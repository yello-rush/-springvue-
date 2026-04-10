package com.mojian.controller.article;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mojian.common.Result;
import com.mojian.entity.SysSlide;
import com.mojian.mapper.SysSlideMapper;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/sys/slide")
@RequiredArgsConstructor
@Api(tags = "后台-轮播图管理")
public class SlideAdminController {

    private final SysSlideMapper sysSlideMapper;

    @GetMapping("/list")
    @ApiOperation(value = "分页获取轮播图列表")
    public Result<Page<SysSlide>> getSlides(Integer pageNum, Integer pageSize) {
        Page<SysSlide> page = new Page<>(pageNum == null ? 1 : pageNum, pageSize == null ? 10 : pageSize);
        Page<SysSlide> result = sysSlideMapper.selectPage(page, new LambdaQueryWrapper<SysSlide>()
                .orderByAsc(SysSlide::getPosition)
                .orderByDesc(SysSlide::getCreateTime));
        return Result.success(result);
    }

    @PostMapping("/add")
    @ApiOperation(value = "新增轮播图")
    public Result<Boolean> addSlide(@RequestBody SysSlide sysSlide) {
        return Result.success(sysSlideMapper.insert(sysSlide) > 0);
    }

    @PutMapping("/update")
    @ApiOperation(value = "修改轮播图")
    public Result<Boolean> updateSlide(@RequestBody SysSlide sysSlide) {
        return Result.success(sysSlideMapper.updateById(sysSlide) > 0);
    }

    @DeleteMapping("/delete/{id}")
    @ApiOperation(value = "删除轮播图")
    public Result<Boolean> deleteSlide(@PathVariable Long id) {
        return Result.success(sysSlideMapper.deleteById(id) > 0);
    }
}