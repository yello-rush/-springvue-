package com.mojian.controller.article;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mojian.common.Result;
import com.mojian.entity.SysSlide;
import com.mojian.mapper.SysSlideMapper;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/slides")
@RequiredArgsConstructor
@Api(tags = "门户-轮播图")
public class SlideController {

    private final SysSlideMapper sysSlideMapper;

    @GetMapping
    @ApiOperation(value = "获取轮播图列表")
    public Result<List<SysSlide>> getSlides() {
        List<SysSlide> list = sysSlideMapper.selectList(new LambdaQueryWrapper<SysSlide>()
                .eq(SysSlide::getStatus, 1)
                .orderByAsc(SysSlide::getPosition)
                .orderByDesc(SysSlide::getCreateTime));
        return Result.success(list);
    }
}