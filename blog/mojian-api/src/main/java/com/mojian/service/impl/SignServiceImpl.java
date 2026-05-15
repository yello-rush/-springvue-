package com.mojian.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import com.mojian.common.RedisConstants;
import com.mojian.service.SignService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;

/**
 * @author: quequnlong
 * @date: 2025/2/8
 * @description:
 */
@Service
@RequiredArgsConstructor
public class SignServiceImpl implements SignService {

    private final JdbcTemplate jdbcTemplate;


    @Override
    public Boolean sign(){
        String userId = StpUtil.getLoginIdAsString();
        String sql = "INSERT IGNORE INTO sys_user_sign (user_id, sign_date) VALUES (?, CURDATE())";
        jdbcTemplate.update(sql, userId);
        return Boolean.TRUE;
    }

    @Override
    public Boolean isSignedToday(){
        String userId = StpUtil.getLoginIdAsString();
        String sql = "SELECT count(*) FROM sys_user_sign WHERE user_id = ? AND sign_date = CURDATE()";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId);
        return count != null && count > 0;
    }

    @Override
    public Long getCumulativeSignDays(){
        String userId = StpUtil.getLoginIdAsString();
        String sql = "SELECT count(*) FROM sys_user_sign WHERE user_id = ?";
        return jdbcTemplate.queryForObject(sql, Long.class, userId);
    }

    @Override
    public int getConsecutiveSignDays(){
        String userId = StpUtil.getLoginIdAsString();
        // 获取用户最近的签到记录，按日期倒序
        String sql = "SELECT sign_date FROM sys_user_sign WHERE user_id = ? ORDER BY sign_date DESC";
        List<LocalDate> dates = jdbcTemplate.query(sql, (rs, rowNum) -> rs.getDate("sign_date").toLocalDate(), userId);

        if (dates.isEmpty()) {
            return 0;
        }

        int consecutiveDays = 0;
        LocalDate expectedDate = LocalDate.now();
        
        // 如果今天没签到，从昨天开始算（如果只要连续签到，今天没签也可能算断了，看业务定义。通常如果今天没签，看昨天是否签了）
        // 这里逻辑：如果最新一条是今天，consecutiveDays=1，然后看昨天。如果最新是昨天，consecutiveDays=0? 
        // 原Redis逻辑是从offset倒推。
        // 我们简单点：从最近一天开始，如果是今天或昨天，就连续。
        
        boolean isTodaySigned = dates.get(0).equals(LocalDate.now());
        if (!isTodaySigned) {
             // 如果今天没签，但昨天签了，那目前的连续天数是截至到昨天的。
             // 检查最新日期是否是昨天
             if (!dates.get(0).equals(LocalDate.now().minusDays(1))) {
                 return 0; 
             }
             expectedDate = LocalDate.now().minusDays(1);
        }

        for (LocalDate date : dates) {
            if (date.equals(expectedDate)) {
                consecutiveDays++;
                expectedDate = expectedDate.minusDays(1);
            } else {
                break;
            }
        }

        return consecutiveDays;
    }

    @Override
    public List<String> getSignDaysList() {
        String userId = StpUtil.getLoginIdAsString();
        String sql = "SELECT sign_date FROM sys_user_sign WHERE user_id = ? ORDER BY sign_date DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> rs.getString("sign_date"), userId);
    }

    private static long getOffset() {
        return 0; // No longer needed
    }
}
