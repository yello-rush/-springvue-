package com.mojian.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mojian.service.CacheService;
import com.mojian.utils.RedisUtil;
import com.mojian.vo.cache.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CacheServiceImpl implements CacheService {

    private final RedisUtil redisUtil;

    @Override
    public CacheInfoVo getCacheInfo() {
        CacheInfoVo vo = new CacheInfoVo();
        vo.setVersion("MySQL-Backed-Cache 1.0");
        vo.setMode("standalone");
        vo.setPort("3306");
        vo.setUptime("0");
        vo.setClients("0");
        vo.setUsedMemory("0 B");
        vo.setMaxmemory("Unbounded");
        vo.setAofEnabled("是");
        vo.setRdbLastSaveStatus("成功");
        
        // 获取所有缓存Key数量
        Set<String> keys = redisUtil.keys("*");
        vo.setKeys(String.valueOf(keys.size()));
        
        vo.setInstantaneousInputKbps("0 kbps");
        vo.setInstantaneousOutputKbps("0 kbps");
        return vo;
    }

    @Override
    public CacheMemoryVo getMemoryInfo() {
        CacheMemoryVo vo = new CacheMemoryVo();
        vo.setUsed(Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory());
        vo.setTotal(Runtime.getRuntime().maxMemory());
        return vo;
    }

    @Override
    public IPage<CacheKeyVo> getKeyList(CacheKeyQuery query) {
        Page<CacheKeyVo> page = new Page<>(query.getPageNum(), query.getPageSize());
        String pattern = query.getKey() == null ? "*" : "*" + query.getKey() + "*";
        Set<String> keys = redisUtil.keys(pattern);
        
        if (keys == null || keys.isEmpty()) {
            page.setTotal(0);
            page.setRecords(Collections.emptyList());
            return page;
        }

        List<CacheKeyVo> list = keys.stream().map(key -> {
            CacheKeyVo vo = new CacheKeyVo();
            vo.setKey(key);
            vo.setType("string");
            vo.setSize(redisUtil.size(key));
            vo.setTtl(redisUtil.getExpire(key, TimeUnit.SECONDS));
            return vo;
        }).collect(Collectors.toList());

        // 手动分页
        int start = (int) ((query.getPageNum() - 1) * query.getPageSize());
        int end = Math.min(start + query.getPageSize(), list.size());
        
        if (start > list.size()) {
            page.setRecords(Collections.emptyList());
        } else {
            page.setRecords(list.subList(start, end));
        }
        page.setTotal(list.size());
        return page;
    }

    @Override
    public void clearCache() {
        Set<String> keys = redisUtil.keys("*");
        if (keys != null && !keys.isEmpty()) {
            redisUtil.delete(keys);
        }
    }
}