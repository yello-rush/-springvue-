package com.mojian.vo.article;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@ApiModel(value = "文章版本历史视图对象")
public class SysArticleHistoryVo {
    @ApiModelProperty(value = "主键id")
    private Long id;

    @ApiModelProperty(value = "文章id")
    private Long articleId;

    @ApiModelProperty(value = "文章标题")
    private String title;

    @ApiModelProperty(value = "文章内容")
    private String content;

    @ApiModelProperty(value = "文章内容md格式")
    private String contentMd;

    @ApiModelProperty(value = "修改摘要")
    private String summary;

    @ApiModelProperty(value = "版本号")
    private Integer version;

    @ApiModelProperty(value = "修改人")
    private String createBy;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @ApiModelProperty(value = "修改时间")
    private LocalDateTime createTime;
}