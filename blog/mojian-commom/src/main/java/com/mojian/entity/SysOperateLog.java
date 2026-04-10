package com.mojian.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.mojian.utils.DateUtil;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;

import java.time.LocalDateTime;
import java.io.Serializable;

@Data
@Builder
@TableName("sys_operate_log")
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "对象 gen_table")
public class SysOperateLog implements Serializable {

    @TableId(type = IdType.AUTO)
    @ApiModelProperty(value = "主键ID")
    @ExcelProperty("主键ID")
    private Long id;

    @ApiModelProperty(value = "操作用户")
    @ExcelProperty("操作用户")
    private String username;

    @ApiModelProperty(value = "请求接口")
    @ExcelProperty("请求接口")
    @ColumnWidth(30)
    private String requestUrl;

    @ApiModelProperty("User-Agent")
    @ExcelProperty("User-Agent")
    @ColumnWidth(50)
    private String ua;

    @ApiModelProperty(value = "请求方式")
    @ExcelProperty("请求方式")
    private String type;

    @ApiModelProperty(value = "操作名称")
    @ExcelProperty("操作名称")
    private String operationName;

    @ApiModelProperty(value = "ip")
    @ExcelProperty("IP")
    private String ip;

    @ApiModelProperty(value = "ip来源")
    @ExcelProperty("IP来源")
    private String source;

    @ApiModelProperty(value = "请求接口耗时")
    @ExcelProperty("请求接口耗时(ms)")
    private Long spendTime;

    @ApiModelProperty(value = "创建时间")
    @JsonFormat(pattern = DateUtil.YYYY_MM_DD_HH_MM_SS, timezone = "GMT+8")
    @ExcelProperty("创建时间")
    @ColumnWidth(20)
    private LocalDateTime createTime;

    @ApiModelProperty(value = "请求参数")
    @ExcelProperty("请求参数")
    @ColumnWidth(30)
    private String paramsJson;

    @ApiModelProperty(value = "类地址")
    @ExcelProperty("类地址")
    @ColumnWidth(30)
    private String classPath;

    @ApiModelProperty(value = "方法名")
    @ExcelProperty("方法名")
    private String methodName;

}