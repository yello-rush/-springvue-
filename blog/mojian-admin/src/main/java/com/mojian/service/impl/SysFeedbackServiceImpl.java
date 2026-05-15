package com.mojian.service.impl;


import cn.dev33.satoken.stp.StpUtil;
import com.mojian.common.Constants;
import com.mojian.dto.feedback.SysFeedbackQueryDto;
import com.mojian.enums.FeedbackTypeEnum;
import com.mojian.exception.ServiceException;
import com.mojian.vo.feedback.SysFeedbackVo;
import org.springframework.util.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.jdbc.core.JdbcTemplate;
import com.mojian.mapper.SysFeedbackMapper;
import com.mojian.entity.SysFeedback;
import com.mojian.service.SysFeedbackService;
import com.mojian.utils.PageUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;

import com.mojian.utils.NotificationsUtil;

/**
 * 反馈表 服务实现类
 */
@Service
@RequiredArgsConstructor
public class SysFeedbackServiceImpl extends ServiceImpl<SysFeedbackMapper, SysFeedback> implements SysFeedbackService {

    private final JdbcTemplate jdbcTemplate;
    private final NotificationsUtil notificationsUtil;

    /**
     * 查询反馈表分页列表
     */
    @Override
    public IPage<SysFeedbackVo> selectPage(SysFeedbackQueryDto feedbackQueryDto) {
        ensureFeedbackTypeColumn();
        //如果是门户端的则只能看自己的反馈
        if (!Constants.ADMIN.equals(feedbackQueryDto.getSource())) {
            feedbackQueryDto.setUserId(getCurrentUserId());
        }
        return baseMapper.page(buildPage(), feedbackQueryDto);
    }

    /**
     * 新增反馈表
     */
    @Override
    public boolean insert(SysFeedback sysFeedback) {
        ensureFeedbackTypeColumn();
        String feedbackType = normalizeFeedbackType(sysFeedback.getFeedbackType(), true);
        sysFeedback.setFeedbackType(feedbackType);
        sysFeedback.setUserId(getCurrentUserId());
        return save(sysFeedback);
    }

    /**
     * 修改反馈表
     */
    @Override
    public boolean update(SysFeedback sysFeedback) {
        ensureFeedbackTypeColumn();
        String feedbackType = normalizeFeedbackType(sysFeedback.getFeedbackType(), false);
        if (feedbackType != null) {
            sysFeedback.setFeedbackType(feedbackType);
        }
        boolean updated = updateById(sysFeedback);
        
        // 发送通知
        if (updated && sysFeedback.getStatus() == 1) {
            SysFeedback oldFeedback = getById(sysFeedback.getId());
            if (oldFeedback != null && oldFeedback.getUserId() != null) {
                String feedbackContent = oldFeedback.getContent() != null ? (oldFeedback.getContent().length() > 15 ? oldFeedback.getContent().substring(0, 15) + "..." : oldFeedback.getContent()) : "反馈";
                notificationsUtil.publishFeedbackProcessed(oldFeedback.getUserId(), feedbackContent);
            }
        }
        return updated;
    }

    protected Long getCurrentUserId() {
        return StpUtil.getLoginIdAsLong();
    }

    private String normalizeFeedbackType(String feedbackType, boolean required) {
        if (!StringUtils.hasText(feedbackType)) {
            if (required) {
                throw new ServiceException("反馈类型不能为空");
            }
            return null;
        }
        String normalized = feedbackType.trim();
        if (!FeedbackTypeEnum.contains(normalized)) {
            throw new ServiceException("反馈类型不合法");
        }
        return normalized;
    }

    protected Page<Object> buildPage() {
        return PageUtil.getPage();
    }

    private void ensureFeedbackTypeColumn() {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM information_schema.columns " +
                        "WHERE table_schema = DATABASE() AND table_name = 'sys_feedback' AND column_name = 'feedback_type'",
                Integer.class
        );
        boolean hasFeedbackType = count != null && count > 0;
        if (!hasFeedbackType) {
            jdbcTemplate.execute(
                    "ALTER TABLE `sys_feedback` " +
                            "ADD COLUMN `feedback_type` VARCHAR(32) NOT NULL DEFAULT 'function_suggestion' COMMENT '反馈类型'"
            );
            jdbcTemplate.execute(
                    "UPDATE `sys_feedback` " +
                            "SET `feedback_type` = 'other' " +
                            "WHERE `feedback_type` IS NULL OR `feedback_type` = ''"
            );
        }
        ensureLegacyTypeColumnCompatible();
    }

    private void ensureLegacyTypeColumnCompatible() {
        Integer legacyTypeCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM information_schema.columns " +
                        "WHERE table_schema = DATABASE() AND table_name = 'sys_feedback' AND column_name = 'type'",
                Integer.class
        );
        if (legacyTypeCount == null || legacyTypeCount <= 0) {
            return;
        }
        jdbcTemplate.execute(
                "UPDATE `sys_feedback` SET `type` = '2' " +
                        "WHERE `type` IS NULL OR `type` = ''"
        );
        try {
            jdbcTemplate.execute("ALTER TABLE `sys_feedback` ALTER COLUMN `type` SET DEFAULT '2'");
        } catch (Exception ignored) {
            // 兼容不同 MySQL 方言，不影响主流程
        }
    }
}
