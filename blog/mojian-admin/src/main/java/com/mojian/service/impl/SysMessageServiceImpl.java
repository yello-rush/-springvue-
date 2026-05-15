package com.mojian.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.mojian.entity.SysMessage;
import com.mojian.entity.SysNotifications;
import com.mojian.entity.SysUser;
import com.mojian.exception.ServiceException;
import com.mojian.mapper.SysMessageMapper;
import com.mojian.mapper.SysNotificationsMapper;
import com.mojian.mapper.SysUserMapper;
import com.mojian.service.SysMessageService;
import com.mojian.utils.PageUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author: quequnlong
 * @date: 2025/1/2
 * @description:
 */
@Service
@RequiredArgsConstructor
public class SysMessageServiceImpl extends ServiceImpl<SysMessageMapper, SysMessage> implements SysMessageService {

    private final SysUserMapper sysUserMapper;
    private final SysNotificationsMapper sysNotificationsMapper;

    @Override
    public Page<SysMessage> selectList() {
        LambdaQueryWrapper<SysMessage> wrapper = new LambdaQueryWrapper<SysMessage>().orderByDesc(SysMessage::getCreateTime);
        return baseMapper.selectPage(PageUtil.getPage(),wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void sendSystemMessageToAll(String title, String content, String link) {
        String safeTitle = title == null ? "" : title.trim();
        String safeContent = content == null ? "" : content.trim();
        String safeLink = link == null ? null : link.trim();
        if (safeTitle.isEmpty()) {
            throw new ServiceException("消息标题不能为空");
        }
        if (safeContent.isEmpty()) {
            throw new ServiceException("消息内容不能为空");
        }

        List<SysUser> users = sysUserMapper.selectList(new LambdaQueryWrapper<SysUser>()
                .select(SysUser::getId)
                .eq(SysUser::getStatus, 1));
        if (users == null || users.isEmpty()) {
            throw new ServiceException("暂无可推送用户");
        }

        for (SysUser user : users) {
            SysNotifications notifications = SysNotifications.builder()
                    .userId(Long.valueOf(user.getId()))
                    .type("system")
                    .title(safeTitle)
                    .message(safeContent)
                    .link((safeLink == null || safeLink.isEmpty()) ? null : safeLink)
                    .isRead(0)
                    .build();
            sysNotificationsMapper.insert(notifications);
        }
    }
}
