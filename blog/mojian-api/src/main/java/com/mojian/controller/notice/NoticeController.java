package com.mojian.controller.notice;

import com.mojian.common.Result;
import com.mojian.entity.SysNotice;
import com.mojian.service.NoticeService;
import io.swagger.annotations.Api;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/notice")
@Api(tags = "门户-公告管理")
public class NoticeController {

    private final NoticeService noticeService;

    @GetMapping("/list")
    @Operation(description = "公告列表")
    public Result<List<SysNotice>> getNoticeList() {
        return Result.success(noticeService.getNoticeList());
    }
}