package com.mojian.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mojian.common.RedisConstants;
import com.mojian.entity.SysComment;
import com.mojian.entity.SysNotifications;
import com.mojian.entity.SysUser;
import com.mojian.vo.dashboard.ContributionData;
import com.mojian.vo.dashboard.IndexVo;
import com.mojian.mapper.SysArticleMapper;
import com.mojian.mapper.SysCommentMapper;
import com.mojian.mapper.SysMessageMapper;
import com.mojian.mapper.SysNotificationsMapper;
import com.mojian.mapper.SysUserMapper;
import com.mojian.service.IndexService;
import com.mojian.utils.RedisUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class IndexServiceImpl implements IndexService {

    private final SysUserMapper sysUserMapper;

    private final SysArticleMapper sysArticleMapper;

    private final SysMessageMapper sysMessageMapper;

    private final SysCommentMapper sysCommentMapper;

    private final SysNotificationsMapper sysNotificationsMapper;

    private final RedisUtil redisUtil;

    @Override
    public IndexVo index() {
        Long userCount = sysUserMapper.selectCount(null);
        Long articleCount = sysArticleMapper.selectCount(null);
        Long messageCount = sysMessageMapper.selectCount(null);

        int visitCount = 0;
        Object e = redisUtil.get(RedisConstants.BLOG_VIEWS_COUNT);
        if (e != null) {
            visitCount = Integer.parseInt(e.toString());
        }

        List<ContributionData> list = sysArticleMapper.getThisYearContributionData();

        return IndexVo.builder()
                .articleCount(articleCount)
                .userCount(userCount)
                .messageCount(messageCount)
                .visitCount(visitCount)
                .contributionData(list)
                .build();
    }

    @Override
    public List<Map<String, Integer>> getCategories() {
        List<Map<String, Integer>> list = sysArticleMapper.selectCountByCategory();
        return list;
    }

    @Override
    public Map<String, Object> getNotifications() {
        Map<String, Object> result = new HashMap<>();
        
        // 1. 获取当前登录用户的 lastLoginTime
        long userId = StpUtil.getLoginIdAsLong();
        SysUser user = sysUserMapper.selectById(userId);
        LocalDateTime lastLoginTime = user != null && user.getLastLoginTime() != null ? user.getLastLoginTime() : LocalDateTime.now().minusDays(1);
        
        // 2. 今日新增用户
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        Long todayNewUsers = sysUserMapper.selectCount(new LambdaQueryWrapper<SysUser>()
                .ge(SysUser::getCreateTime, todayStart));
        result.put("todayNewUsers", todayNewUsers);
        
        // 3. 近7日注册趋势小图数据
        List<Map<String, Object>> weeklyUserTrend = new ArrayList<>();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MM-dd");
        for (int i = 6; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusDays(i);
            LocalDateTime start = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime end = LocalDateTime.of(date, LocalTime.MAX);
            Long count = sysUserMapper.selectCount(new LambdaQueryWrapper<SysUser>()
                    .ge(SysUser::getCreateTime, start)
                    .le(SysUser::getCreateTime, end));
            Map<String, Object> map = new HashMap<>();
            map.put("date", date.format(dtf));
            map.put("count", count);
            weeklyUserTrend.add(map);
        }
        result.put("weeklyUserTrend", weeklyUserTrend);
        
        // 4. 互动数据 (根据评论时间来，和后台登录时间来取差值)
        Long newComments = sysCommentMapper.selectCount(new LambdaQueryWrapper<SysComment>()
                .gt(SysComment::getCreateTime, lastLoginTime));
        result.put("newComments", newComments);
        
        Long newLikes = sysNotificationsMapper.selectCount(new LambdaQueryWrapper<SysNotifications>()
                .eq(SysNotifications::getType, "like")
                .gt(SysNotifications::getCreateTime, lastLoginTime));
        result.put("newLikes", newLikes);
        
        Long newFavorites = sysNotificationsMapper.selectCount(new LambdaQueryWrapper<SysNotifications>()
                .eq(SysNotifications::getType, "favorite")
                .gt(SysNotifications::getCreateTime, lastLoginTime));
        result.put("newFavorites", newFavorites);
        
        return result;
    }
}
