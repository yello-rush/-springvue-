package com.mojian.vo.error;

import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ErrorReportVo {

    @ApiModelProperty(value = "提示文案")
    private String alertMessage;

    @ApiModelProperty(value = "错误详情")
    private String errorDetail;

    @ApiModelProperty(value = "异常类型")
    private String errorType;

    @ApiModelProperty(value = "请求路径")
    private String requestPath;

    @ApiModelProperty(value = "发生时间")
    private String occurredAt;
}
