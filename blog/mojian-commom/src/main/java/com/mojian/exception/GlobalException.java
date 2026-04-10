package com.mojian.exception;

import cn.dev33.satoken.exception.NotLoginException;
import cn.dev33.satoken.exception.NotPermissionException;
import com.mojian.common.Result;
import com.mojian.vo.error.ErrorReportVo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import javax.servlet.http.HttpServletRequest;

@Slf4j
@RestControllerAdvice
@RequiredArgsConstructor
public class GlobalException {

    private final ErrorReportManager errorReportManager;

    /**
     * 业务异常
     * @param e
     * @return
     */
    @ExceptionHandler(ServiceException.class)
    public Result<Void> handleServiceException(ServiceException e, HttpServletRequest request) {
        log.error(e.getMessage(), e);
        ErrorReportVo report = errorReportManager.record(e, request.getRequestURI());
        return Result.<Void>error(e.getCode(), e.getMessage())
                .putExtra("alertMessage", report.getAlertMessage())
                .putExtra("errorDetail", report.getErrorDetail())
                .putExtra("errorType", report.getErrorType())
                .putExtra("requestPath", report.getRequestPath())
                .putExtra("occurredAt", report.getOccurredAt());
    }


    /**
     * 权限不足异常
     * @param e
     * @return
     */
    @ExceptionHandler(NotPermissionException.class)
    public Result<Void> handleNotPermissionException(NotPermissionException e, HttpServletRequest request) {
        log.error(e.getMessage(), e);
        ErrorReportVo report = errorReportManager.record(e, request.getRequestURI());
        return Result.<Void>error(HttpStatus.FORBIDDEN.value(),e.getMessage())
                .putExtra("alertMessage", report.getAlertMessage())
                .putExtra("errorDetail", report.getErrorDetail())
                .putExtra("errorType", report.getErrorType())
                .putExtra("requestPath", report.getRequestPath())
                .putExtra("occurredAt", report.getOccurredAt());
    }


    /**
     * 未登录异常
     * @param e
     * @return
     */
    @ExceptionHandler(NotLoginException.class)
    public Result<Void> handleRuntimeException(NotLoginException e, HttpServletRequest request) {
        log.error("未登录异常：", e);
        ErrorReportVo report = errorReportManager.record(e, request.getRequestURI());
        return Result.<Void>error(HttpStatus.UNAUTHORIZED.value(),"当前用户未登录或 登录已过期")
                .putExtra("alertMessage", report.getAlertMessage())
                .putExtra("errorDetail", report.getErrorDetail())
                .putExtra("errorType", report.getErrorType())
                .putExtra("requestPath", report.getRequestPath())
                .putExtra("occurredAt", report.getOccurredAt());
    }

    /**
     * 系统异常
     * @param e
     * @return
     */
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e, HttpServletRequest request) {
        log.error("系统异常：", e);
        ErrorReportVo report = errorReportManager.record(e, request.getRequestURI());
        return Result.<Void>error("系统错误")
                .putExtra("alertMessage", report.getAlertMessage())
                .putExtra("errorDetail", report.getErrorDetail())
                .putExtra("errorType", report.getErrorType())
                .putExtra("requestPath", report.getRequestPath())
                .putExtra("occurredAt", report.getOccurredAt());
    }
}
