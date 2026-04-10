package com.mojian.dto.article;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel(value = "文章查询对象")
public class ArticleQueryDto {

    @ApiModelProperty(value = "文章标题")
    private String title;

    @ApiModelProperty(value = "分类id")
    private Integer categoryId;

    @ApiModelProperty(value = "状态 review：审核 publish：上架 offline：下架 draft：草稿")
    private String status;

    @ApiModelProperty(value = "标签id")
    private Integer tagId;
}
