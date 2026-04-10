package com.mojian.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.util.Date;

@Data
@TableName("sys_author")
@ApiModel(value = "SysAuthor对象", description = "作者信息表")
public class SysAuthor {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @ApiModelProperty(value = "作者名称")
    private String name;

    @ApiModelProperty(value = "作者头像")
    private String avatar;

    @ApiModelProperty(value = "个人简介")
    private String description;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;
}