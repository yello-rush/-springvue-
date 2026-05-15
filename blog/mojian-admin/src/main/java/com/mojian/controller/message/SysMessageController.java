package com.mojian.controller.message;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mojian.common.Result;
import com.mojian.entity.SysMessage;
import com.mojian.service.SysMessageService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author: quequnlong
 * @date: 2025/1/2
 * @description:
 */
@RestController
@Api(tags = "留言管理")
@RequestMapping("/sys/message")
@RequiredArgsConstructor
public class SysMessageController {

    private final SysMessageService sysMessageService;

    @GetMapping("/list")
    @ApiOperation(value = "获取留言列表")
    public Result<Page<SysMessage>> list() {
        return Result.success(sysMessageService.selectList());
    }

    @DeleteMapping("/delete/{ids}")
    @ApiOperation(value = "删除留言")
    @SaCheckPermission("sys:message:delete")
    public Result<Void> delete(@PathVariable List<Integer> ids) {
        sysMessageService.removeBatchByIds(ids);
        return Result.success();
    }

    @PostMapping("/system/send")
    @ApiOperation(value = "群发系统消息")
    @SaCheckPermission("sys:message:send")
    public Result<Void> sendSystemMessage(@RequestBody SendSystemMessageReq req) {
        sysMessageService.sendSystemMessageToAll(req.getTitle(), req.getContent(), req.getLink());
        return Result.success();
    }

    @Data
    public static class SendSystemMessageReq {
        private String title;
        private String content;
        private String link;
    }
}
