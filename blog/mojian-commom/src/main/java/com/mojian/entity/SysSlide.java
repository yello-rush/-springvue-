package com.mojian.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonProperty;

@Data
@TableName("sys_slide")
public class SysSlide {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @JsonProperty("image_url")
    private String imageUrl;
    
    private String title;
    private String link;
    private Integer position;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}