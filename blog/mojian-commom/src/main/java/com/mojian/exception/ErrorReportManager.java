package com.mojian.exception;

import com.mojian.vo.error.ErrorReportVo;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Component
public class ErrorReportManager {

    private static final String ALERT_MESSAGE = "错误了，请联系管理员";
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private volatile ErrorReportVo latestError = ErrorReportVo.builder()
            .alertMessage(ALERT_MESSAGE)
            .errorDetail("暂无错误")
            .errorType("NONE")
            .requestPath("")
            .occurredAt("")
            .build();

    public ErrorReportVo record(Throwable throwable, String requestPath) {
        String detail = throwable.getMessage();
        if (!StringUtils.hasText(detail)) {
            detail = throwable.getClass().getSimpleName();
        }
        ErrorReportVo report = ErrorReportVo.builder()
                .alertMessage(ALERT_MESSAGE)
                .errorDetail(detail)
                .errorType(throwable.getClass().getSimpleName())
                .requestPath(requestPath)
                .occurredAt(LocalDateTime.now().format(FORMATTER))
                .build();
        latestError = report;
        return report;
    }

    public ErrorReportVo getLatestError() {
        return latestError;
    }
}
