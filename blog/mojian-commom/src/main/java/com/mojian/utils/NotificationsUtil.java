package com.mojian.utils;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mojian.entity.SysArticle;
import com.mojian.entity.SysNotifications;
import com.mojian.entity.SysUser;
import com.mojian.mapper.SysArticleMapper;
import com.mojian.mapper.SysNotificationsMapper;
import com.mojian.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author: quequnlong
 * @date: 2025/3/24
 * @description:
 */
@Component
@RequiredArgsConstructor
public class NotificationsUtil {

    private final SysArticleMapper sysArticleMapper;
    private final SysNotificationsMapper baseMapper;
    private final SysUserMapper sysUserMapper;

    public void publish(SysNotifications sysNotifications) {
        SysArticle sysArticle = new SysArticle();
        switch (sysNotifications.getType()) {
            case "comment":
                if (sysNotifications.getUserId() == null) {
                    sysArticle = sysArticleMapper.selectById(sysNotifications.getArticleId());
                    sysNotifications.setUserId(sysArticle.getUserId());
                }
                break;
            case "like":
                if (sysNotifications.getArticleId() != null) {
                    sysArticle = sysArticleMapper.selectById(sysNotifications.getArticleId());
                    sysNotifications.setUserId(sysArticle.getUserId());
                }
                sysNotifications.setMessage("点赞了文章：" + sysArticle.getTitle());
                break;
            case "unLike":
                break;
            default:
                break;
        }
        if (sysNotifications.getUserId() != null) {
            baseMapper.insert(sysNotifications);
        }
    }

    /**
     * 发送新文章发布通知给所有用户
     */
    public void publishNewArticle(SysArticle article) {
        List<SysUser> users = sysUserMapper.selectList(new LambdaQueryWrapper<SysUser>().eq(SysUser::getStatus, 1));
        for (SysUser user : users) {
            SysNotifications notification = SysNotifications.builder()
                    .userId(user.getId() != null ? user.getId().longValue() : null)
                    .type("system")
                    .title("新文章发布")
                    .message("站长发布了新文章：" + article.getTitle())
                    .articleId(article.getId())
                    .link("/article/" + article.getId())
                    .isRead(0)
                    .build();
            baseMapper.insert(notification);
        }
    }

    /**
     * 发送收藏文章更新通知给收藏了该文章的用户
     */
    public void publishArticleUpdate(SysArticle article) {
        List<Integer> userIds = sysArticleMapper.getUsersByArticleCollect(article.getId());
        if (userIds != null && !userIds.isEmpty()) {
            for (Integer userId : userIds) {
                if (userId != null) {
                    SysNotifications notification = SysNotifications.builder()
                            .userId(userId.longValue())
                            .type("system")
                            .title("收藏文章更新")
                            .message("你收藏的文章【" + article.getTitle() + "】已更新内容")
                            .articleId(article.getId())
                            .link("/article/" + article.getId())
                            .isRead(0)
                            .build();
                    baseMapper.insert(notification);
                }
            }
        }
    }

    /**
     * 反馈已处理通知
     */
    public void publishFeedbackProcessed(Long userId, String feedbackTitle) {
        SysNotifications notification = SysNotifications.builder()
                .userId(userId)
                .type("system")
                .title("反馈处理结果")
                .message("你提交的反馈【" + feedbackTitle + "】已被管理员处理")
                .isRead(0)
                .build();
        baseMapper.insert(notification);
    }
}
