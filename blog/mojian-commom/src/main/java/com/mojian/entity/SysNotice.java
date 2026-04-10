package com.mojian.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.mojian.utils.DateUtil;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.time.LocalDateTime;
import java.io.Serializable;

@Data
@TableName("sys_notice")
@ApiModel(value = "公告对象")
public class SysNotice implements Serializable {

    @TableId(type = IdType.AUTO)
    @ApiModelProperty(value = "主键")
    private Long id;

    @ApiModelProperty(value = "公告内容")
    private String content;

    @ApiModelProperty(value = "公告标题")
    private String title;

    @ApiModelProperty(value = "跳转链接")
    private String url;

    @ApiModelProperty(value = "排序优先级")
    private Integer sort;

    @ApiModelProperty(value = "显示时长(毫秒)")
    private Long duration;

    @ApiModelProperty(value = "是否展示")
    private Integer isShow;

    @ApiModelProperty(value = "显示位置 （top：顶部，right:右侧）")
    private String position;

    @ApiModelProperty(value = "创建时间")
    @TableField(fill = FieldFill.INSERT)
    @JsonFormat(pattern = DateUtil.YYYY_MM_DD_HH_MM_SS, timezone = "GMT+8")
    private LocalDateTime createTime;
}
