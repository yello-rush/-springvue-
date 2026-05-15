package com.mojian.utils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * Redis替换工具类 (基于MySQL实现)
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class RedisUtil {

    private final JdbcTemplate jdbcTemplate;
    
    // 本地一级缓存，减少数据库压力
    private final Map<String, Object> localCache = new ConcurrentHashMap<>();
    // 记录本地缓存过期时间，-1 表示永不过期
    private final Map<String, Long> localExpireCache = new ConcurrentHashMap<>();

    private static final String TABLE = "sys_cache";

    static {
        com.alibaba.fastjson.parser.ParserConfig.getGlobalInstance().setAutoTypeSupport(true);
    }

    /**
     * 设置缓存
     */
    public void set(String key, Object value) {
        set(key, value, -1, TimeUnit.SECONDS);
    }

    /**
     * 设置缓存并设置过期时间
     */
    public void set(String key, Object value, long timeout, TimeUnit unit) {
        String jsonValue = JSON.toJSONString(value, com.alibaba.fastjson.serializer.SerializerFeature.WriteClassName);
        long expireTime = timeout > 0 ? System.currentTimeMillis() + unit.toMillis(timeout) : -1;
        
        String sql = "INSERT INTO " + TABLE + " (cache_key, cache_value, expire_time) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE cache_value = ?, expire_time = ?";
        jdbcTemplate.update(sql, key, jsonValue, expireTime, jsonValue, expireTime);
        localCache.put(key, value);
        localExpireCache.put(key, expireTime);
    }

    /**
     * 获取缓存
     */
    public Object get(String key) {
        if (localCache.containsKey(key)) {
            Long localExpireTime = localExpireCache.getOrDefault(key, -1L);
            if (localExpireTime == -1 || System.currentTimeMillis() <= localExpireTime) {
                return localCache.get(key);
            }
            // 本地缓存已过期，清理后继续查库，避免返回脏数据
            localCache.remove(key);
            localExpireCache.remove(key);
        }
        try {
            String sql = "SELECT cache_value, expire_time FROM " + TABLE + " WHERE cache_key = ?";
            Map<String, Object> result = jdbcTemplate.queryForMap(sql, key);
            
            long expireTime = (long) result.get("expire_time");
            if (expireTime != -1 && System.currentTimeMillis() > expireTime) {
                delete(key);
                return null;
            }
            
            String jsonValue = (String) result.get("cache_value");
            Object value = JSON.parse(jsonValue, com.alibaba.fastjson.parser.Feature.SupportAutoType); 
            if (value != null) {
                localCache.put(key, value);
                localExpireCache.put(key, expireTime);
            }
            return value;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    /**
     * 删除缓存
     */
    public Boolean delete(String key) {
        localCache.remove(key);
        localExpireCache.remove(key);
        String sql = "DELETE FROM " + TABLE + " WHERE cache_key = ?";
        return jdbcTemplate.update(sql, key) > 0;
    }

    public Boolean del(String key) {
        return delete(key);
    }

    /**
     * 批量删除缓存
     */
    public Long delete(Collection<String> keys) {
        if (keys == null || keys.isEmpty()) return 0L;
        keys.forEach(localCache::remove);
        keys.forEach(localExpireCache::remove);
        
        String inSql = String.join(",", Collections.nCopies(keys.size(), "?"));
        String sql = "DELETE FROM " + TABLE + " WHERE cache_key IN (" + inSql + ")";
        return (long) jdbcTemplate.update(sql, keys.toArray());
    }

    /**
     * 设置过期时间
     */
    public void expire(String key, long timeout, TimeUnit unit) {
        long expireTime = System.currentTimeMillis() + unit.toMillis(timeout);
        String sql = "UPDATE " + TABLE + " SET expire_time = ? WHERE cache_key = ?";
        jdbcTemplate.update(sql, expireTime, key);
        if (localCache.containsKey(key)) {
            localExpireCache.put(key, expireTime);
        }
    }

    /**
     * 获取过期时间
     */
    public Long getExpire(String key, TimeUnit unit) {
        try {
            String sql = "SELECT expire_time FROM " + TABLE + " WHERE cache_key = ?";
            Long expireTime = jdbcTemplate.queryForObject(sql, Long.class, key);
            if (expireTime == null || expireTime == -1) return -1L;
            return unit.convert(expireTime - System.currentTimeMillis(), TimeUnit.MILLISECONDS);
        } catch (EmptyResultDataAccessException e) {
            return -2L; // 不存在
        }
    }

    /**
     * 判断key是否存在
     */
    public Boolean hasKey(String key) {
        return get(key) != null;
    }

    /**
     * 按delta递增
     */
    public void increment(String key, long delta) {
        Object val = get(key);
        long current = val == null ? 0 : Long.parseLong(val.toString());
        set(key, current + delta);
    }

    /**
     * 按delta递减
     */
    public Long decrement(String key, long delta) {
        Object val = get(key);
        long current = val == null ? 0 : Long.parseLong(val.toString());
        long newVal = current - delta;
        set(key, newVal);
        return newVal;
    }

    // --- Hash Operations (Simulated) ---

    public Object hGet(String key, String hashKey) {
        Map<String, Object> map = getMap(key);
        return map.get(hashKey);
    }

    public void hSet(String key, String hashKey, Object value) {
        Map<String, Object> map = getMap(key);
        map.put(hashKey, value);
        set(key, map);
    }

    public void hSet(String key, String hashKey, Object value, long timeout, TimeUnit unit) {
        hSet(key, hashKey, value);
        expire(key, timeout, unit);
    }

    public Map<Object, Object> hGetAll(String key) {
        return new HashMap<>(getMap(key));
    }

    public void hSetAll(String key, Map<Object, Object> map) {
        set(key, map);
    }

    public void hDel(String key, Object... hashKeys) {
        Map<String, Object> map = getMap(key);
        for (Object hashKey : hashKeys) {
            map.remove(hashKey.toString());
        }
        set(key, map);
    }

    public void hDelete(String key, Object... hashKeys) {
        hDel(key, hashKeys);
    }

    public Boolean hHasKey(String key, String hashKey) {
        return getMap(key).containsKey(hashKey);
    }

    public void hIncr(String key, String hashKey, Long delta) {
        Map<String, Object> map = getMap(key);
        Object val = map.get(hashKey);
        long current = val == null ? 0 : Long.parseLong(val.toString());
        map.put(hashKey, current + delta);
        set(key, map);
    }

    public void hDecr(String key, String hashKey, Long delta) {
        hIncr(key, hashKey, -delta);
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> getMap(String key) {
        Object val = get(key);
        if (val instanceof Map) {
            return (Map<String, Object>) val;
        }
        if (val instanceof JSONObject) {
            return ((JSONObject) val).getInnerMap();
        }
        return new HashMap<>();
    }

    // --- List Operations (Simulated) ---

    public Long lPush(String key, Object value) {
        List<Object> list = getList(key);
        list.add(value); // right push actually for simplicity, list is ordered
        set(key, list);
        return (long) list.size();
    }

    public Long lPushAll(String key, Object... values) {
        List<Object> list = getList(key);
        Collections.addAll(list, values);
        set(key, list);
        return (long) list.size();
    }

    public List<Object> lRange(String key, long start, long end) {
        List<Object> list = getList(key);
        if (list.isEmpty()) return list;
        int size = list.size();
        int fromIndex = (int) start;
        int toIndex = (int) end;
        if (fromIndex < 0) fromIndex = 0;
        if (toIndex == -1 || toIndex >= size) toIndex = size - 1;
        if (fromIndex > toIndex) return new ArrayList<>();
        return list.subList(fromIndex, toIndex + 1);
    }

    @SuppressWarnings("unchecked")
    private List<Object> getList(String key) {
        Object val = get(key);
        if (val instanceof List) return (List<Object>) val;
        if (val instanceof JSONArray) return new ArrayList<>((JSONArray) val);
        return new ArrayList<>();
    }

    // --- Set Operations (Simulated) ---

    public void sAdd(String key, Object... values) {
        Set<Object> set = getSet(key);
        Collections.addAll(set, values);
        set(key, set);
    }

    public Boolean sIsMember(String key, Object value) {
        return getSet(key).contains(value);
    }

    public Set<Object> sMembers(String key) {
        return getSet(key);
    }

    public void sRemove(String key, Object... values) {
        Set<Object> set = getSet(key);
        for (Object val : values) set.remove(val);
        set(key, set);
    }

    @SuppressWarnings("unchecked")
    private Set<Object> getSet(String key) {
        Object val = get(key);
        if (val instanceof Collection) return new HashSet<>((Collection<?>) val);
        return new HashSet<>();
    }

    // --- ZSet Operations (Simulated) ---

    public Boolean zAdd(String key, Object value, double score) {
        // ZSet is complex to simulate with JSON, storing as List of objects with score
        // For simplicity, just ignore or store as Set
        log.warn("ZSet zAdd not fully implemented in MySQL RedisUtil: {}", key);
        return false;
    }

    public Set<Object> zRangeByScore(String key, double min, double max) {
        log.warn("ZSet zRangeByScore not implemented: {}", key);
        return new HashSet<>();
    }

    // --- Other ---

    public Set<String> keys(String pattern) {
        String sqlPattern = pattern.replace("*", "%");
        String sql = "SELECT cache_key FROM " + TABLE + " WHERE cache_key LIKE ?";
        return new HashSet<>(jdbcTemplate.queryForList(sql, String.class, sqlPattern));
    }

    public String type(String key) {
        return "string"; // Dummy
    }

    public Long size(String key) {
        return 1L;
    }

    // --- Bitmap (Deprecated, SignService rewritten) ---

    public void setBit(String key, long offset, boolean value) {
        log.warn("setBit is deprecated and not supported in MySQL RedisUtil. Please refactor.");
    }

    public Boolean getBit(String key, long offset) {
        return false;
    }

    public Long bitCount(String key, long start, long end) {
        return 0L;
    }
}
