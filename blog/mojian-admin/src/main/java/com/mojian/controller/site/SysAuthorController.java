package com.mojian.controller.site;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mojian.common.Result;
import com.mojian.entity.SysAuthor;
import com.mojian.service.SysAuthorService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.util.StringUtils;
import java.util.List;

@RestController
@RequestMapping("/sys/author")
@RequiredArgsConstructor
@Api(tags = "作者信息管理")
public class SysAuthorController {

    private final SysAuthorService sysAuthorService;

    @GetMapping("/list")
    @ApiOperation("列表查询")
    @SaCheckPermission("sys:author:list")
    public Result<Page<SysAuthor>> list(Integer pageNum, Integer pageSize, String name) {
        Page<SysAuthor> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<SysAuthor> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(name)) {
            wrapper.like(SysAuthor::getName, name);
        }
        return Result.success(sysAuthorService.page(page, wrapper));
    }

    @PostMapping("/add")
    @ApiOperation("新增")
    @SaCheckPermission("sys:author:add")
    public Result<Boolean> add(@RequestBody SysAuthor sysAuthor) {
        return Result.success(sysAuthorService.save(sysAuthor));
    }

    @PutMapping("/update")
    @ApiOperation("修改")
    @SaCheckPermission("sys:author:update")
    public Result<Boolean> update(@RequestBody SysAuthor sysAuthor) {
        return Result.success(sysAuthorService.updateById(sysAuthor));
    }

    @DeleteMapping("/delete/{ids}")
    @ApiOperation("删除")
    @SaCheckPermission("sys:author:delete")
    public Result<Boolean> delete(@PathVariable List<Long> ids) {
        return Result.success(sysAuthorService.removeByIds(ids));
    }
}