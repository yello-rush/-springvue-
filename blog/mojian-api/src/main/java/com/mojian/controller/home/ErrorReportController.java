package com.mojian.controller.home;

import com.mojian.common.Result;
import com.mojian.exception.ErrorReportManager;
import com.mojian.vo.error.ErrorReportVo;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/error")
@RequiredArgsConstructor
public class ErrorReportController {

    private final ErrorReportManager errorReportManager;

    @GetMapping("/latest")
    @ApiOperation(value = "获取最近一次错误信息")
    public Result<ErrorReportVo> latest() {
        return Result.success(errorReportManager.getLatestError());
    }
}
