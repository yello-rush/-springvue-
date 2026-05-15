package com.mojian.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.mojian.utils.DateUtil;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.io.Serializable;
/**
 * 文章
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("sys_article")
@ApiModel(value = "文章对象 gen_table")
public class SysArticle implements Serializable {

    @TableId(type = IdType.AUTO)
    @ApiModelProperty(value = "主键id")
    private Long id;

    @ApiModelProperty(value = "用户id")
    private Long userId;

    @ApiModelProperty(value = "分类id")
    private Integer categoryId;

    @ApiModelProperty(value = "文章标题")
    private String title;

    @ApiModelProperty(value = "文章封面地址")
    private String cover;

    @ApiModelProperty(value = "文章简介")
    private String summary;

    @ApiModelProperty(value = "文章内容")
    private String content;

    @ApiModelProperty(value = "文章内容md格式")
    private String contentMd;

    @ApiModelProperty(value = "状态 review：审核 publish：上架 offline：下架 draft：草稿")
    private String status;

    @ApiModelProperty(value = "是否首页轮播")
    private Integer isCarousel;

    @ApiModelProperty(value = "文章阅读量")
    private Integer quantity;

    @ApiModelProperty(value = "收藏数量")
    private Integer favoriteNum;

    @ApiModelProperty(value = "关键词")
    private String keywords;

    @ApiModelProperty(value = "Ai生成的简短描述")
    private String aiDescribe;

    @ApiModelProperty(value = "热度")
    private Double heatScore;

    @ApiModelProperty(value = "是否归档 0:否 1:是")
    private Integer isArchive;

    @ApiModelProperty(value = "创建时间")
    @TableField(fill = FieldFill.INSERT)
    @JsonFormat(pattern = DateUtil.YYYY_MM_DD_HH_MM_SS)
    private LocalDateTime createTime;

    @ApiModelProperty(value = "修改时间")
    @TableField(fill = FieldFill.UPDATE)
    @JsonFormat(pattern = DateUtil.YYYY_MM_DD_HH_MM_SS)
    private LocalDateTime updateTime;

    @ApiModelProperty(value = "首次被访问时间")
    @JsonFormat(pattern = DateUtil.YYYY_MM_DD_HH_MM_SS)
    private LocalDateTime firstAccessedTime;

    @ApiModelProperty(value = "最后访问时间")
    @JsonFormat(pattern = DateUtil.YYYY_MM_DD_HH_MM_SS)
    private LocalDateTime lastAccessedTime;
}
