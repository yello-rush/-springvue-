package com.mojian.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.mojian.entity.SysMessage;

/**
 * @author: quequnlong
 * @date: 2025/1/2
 * @description:
 */
public interface SysMessageService extends IService<SysMessage> {

    /**
     * 获取消息列表
     * @return
     */
    Page<SysMessage> selectList();

    /**
     * 向全部用户发送系统消息
     *
     * @param title 标题
     * @param content 内容
     * @param link 跳转链接
     */
    void sendSystemMessageToAll(String title, String content, String link);

}
