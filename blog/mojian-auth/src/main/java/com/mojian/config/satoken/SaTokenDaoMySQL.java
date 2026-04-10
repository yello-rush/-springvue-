package com.mojian.config.satoken;

import cn.dev33.satoken.dao.SaTokenDao;
import com.mojian.utils.RedisUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Sa-Token持久层接口 MySQL实现
 */
@Component
@RequiredArgsConstructor
public class SaTokenDaoMySQL implements SaTokenDao {

    private final RedisUtil redisUtil;

    @Override
    public String get(String key) {
        Object val = redisUtil.get(key);
        return val == null ? null : val.toString();
    }

    @Override
    public void set(String key, String value, long timeout) {
        redisUtil.set(key, value, timeout, TimeUnit.SECONDS);
    }

    @Override
    public void update(String key, String value) {
        long expire = getTimeout(key);
        // -2 means not exist, -1 means never expire
        if (expire == -2) return;
        set(key, value, expire);
    }

    @Override
    public void delete(String key) {
        redisUtil.delete(key);
    }

    @Override
    public long getTimeout(String key) {
        return redisUtil.getExpire(key, TimeUnit.SECONDS);
    }

    @Override
    public void updateTimeout(String key, long timeout) {
        redisUtil.expire(key, timeout, TimeUnit.SECONDS);
    }

    @Override
    public Object getObject(String key) {
        Object obj = redisUtil.get(key);
        if (obj instanceof com.alibaba.fastjson.JSONObject) {
            if (key.contains("session")) {
                return ((com.alibaba.fastjson.JSONObject) obj).toJavaObject(cn.dev33.satoken.session.SaSession.class);
            }
        }
        return obj;
    }

    @Override
    public void setObject(String key, Object object, long timeout) {
        redisUtil.set(key, object, timeout, TimeUnit.SECONDS);
    }

    @Override
    public void updateObject(String key, Object object) {
        long expire = getObjectTimeout(key);
        if (expire == -2) return;
        setObject(key, object, expire);
    }

    @Override
    public void deleteObject(String key) {
        redisUtil.delete(key);
    }

    @Override
    public long getObjectTimeout(String key) {
        return redisUtil.getExpire(key, TimeUnit.SECONDS);
    }

    @Override
    public void updateObjectTimeout(String key, long timeout) {
        redisUtil.expire(key, timeout, TimeUnit.SECONDS);
    }

    @Override
    public List<String> searchData(String prefix, String keyword, int start, int size, boolean sortType) {
        // Simple implementation: fetch all keys matching prefix* and filter
        // Note: RedisUtil keys implementation uses LIKE 'prefix%'
        // Sa-Token expects search.
        // If keyword is present, filter by it.
        return new ArrayList<>(redisUtil.keys(prefix + "*" + keyword + "*"));
    }
}
