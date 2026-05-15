package com.mojian.controller.user;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.mojian.common.Result;
import com.mojian.dto.feedback.SysFeedbackQueryDto;
import com.mojian.entity.SysArticle;
import com.mojian.entity.SysFeedback;
import com.mojian.entity.SysUser;
import com.mojian.enums.FeedbackTypeEnum;
import com.mojian.exception.ServiceException;
import com.mojian.mapper.SysFeedbackMapper;
import com.mojian.service.UserService;
import com.mojian.utils.PageUtil;
import com.mojian.vo.article.ArticleListVo;
import com.mojian.vo.comment.CommentListVo;
import com.mojian.vo.feedback.SysFeedbackVo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;
import com.mojian.common.PageQuery;
import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;

/**
 * @author: quequnlong
 * @date: 2025/1/11
 * @description:
 */
@RestController
@RequestMapping("/protal/user")
@RequiredArgsConstructor
@Api(tags = "门户-个人中心")
public class UserController {

    private final UserService userService;
    private final SysFeedbackMapper sysFeedbackMapper;
    private final JdbcTemplate jdbcTemplate;

    @PutMapping("/updateProfile")
    @ApiOperation(value = "修改我的资料")
    public Result<Void> updateProfile(@RequestBody SysUser user){
        userService.updateProfile(user);
        return Result.success();
    }

    @GetMapping("/comment")
    @ApiOperation(value = "获取我的评论")
    public Result<IPage<CommentListVo>> selectMyComment(){
        return Result.success(userService.selectMyComment());
    }

    @DeleteMapping("/delMyComment/{ids}")
    @ApiOperation(value = "删除我的评论")
    public Result<Void> delMyComment(@PathVariable List<Long> ids){
        return Result.success(userService.delMyComment(ids));
    }

    @GetMapping("/myLike")
    @ApiOperation(value = "获取我的点赞")
    public Result<IPage<ArticleListVo>> selectMyLike(){
        return Result.success(userService.selectMyLike());
    }

    @GetMapping("/myArticle")
    @ApiOperation(value = "获取我的文章")
    public Result<IPage<ArticleListVo>> selectMyArticle(SysArticle article){
        return Result.success(userService.selectMyArticle(article));
    }

    @GetMapping("/history")
    @SaCheckLogin
    @ApiOperation(value = "浏览历史")
    public Result<IPage<ArticleListVo>> getMyHistory(PageQuery pageQuery) {
        return Result.success(userService.getMyHistory(pageQuery));
    }

    @GetMapping("/favorites")
    @SaCheckLogin
    @ApiOperation(value = "我的收藏")
    public Result<IPage<ArticleListVo>> getMyFavorites(PageQuery pageQuery) {
        return Result.success(userService.getMyFavorites(pageQuery));
    }

    @GetMapping("/feedback/list")
    @SaCheckLogin
    @ApiOperation(value = "获取我的反馈")
    public Result<IPage<SysFeedbackVo>> getMyFeedbacks(SysFeedbackQueryDto feedbackQueryDto) {
        ensureFeedbackTypeColumn();
        feedbackQueryDto.setUserId(StpUtil.getLoginIdAsLong());
        return Result.success(sysFeedbackMapper.page(PageUtil.getPage(), feedbackQueryDto));
    }

    @PostMapping("/feedback/add")
    @SaCheckLogin
    @ApiOperation(value = "提交反馈")
    public Result<Object> addFeedback(@RequestBody SysFeedback sysFeedback) {
        ensureFeedbackTypeColumn();
        String feedbackType = normalizeFeedbackType(sysFeedback.getFeedbackType());
        sysFeedback.setFeedbackType(feedbackType);
        sysFeedback.setUserId(StpUtil.getLoginIdAsLong());
        return Result.success(sysFeedbackMapper.insert(sysFeedback) > 0);
    }

    private String normalizeFeedbackType(String feedbackType) {
        if (!StringUtils.hasText(feedbackType)) {
            throw new ServiceException("反馈类型不能为空");
        }
        String normalized = feedbackType.trim();
        if (!FeedbackTypeEnum.contains(normalized)) {
            throw new ServiceException("反馈类型不合法");
        }
        return normalized;
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
