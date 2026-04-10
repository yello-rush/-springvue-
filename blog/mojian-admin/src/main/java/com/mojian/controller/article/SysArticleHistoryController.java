package com.mojian.controller.article;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.mojian.common.Result;
import com.mojian.entity.SysArticleHistory;
import com.mojian.mapper.SysArticleHistoryMapper;
import com.mojian.utils.PageUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/system/article/history")
@RequiredArgsConstructor
@Api(tags = "文章历史版本管理")
public class SysArticleHistoryController {

    private final SysArticleHistoryMapper sysArticleHistoryMapper;

    @GetMapping("/list/{articleId}")
    @ApiOperation("查询文章历史版本列表")
    public Result<IPage<SysArticleHistory>> list(@PathVariable("articleId") Long articleId) {
        LambdaQueryWrapper<SysArticleHistory> wrapper = new LambdaQueryWrapper<SysArticleHistory>()
                .eq(SysArticleHistory::getArticleId, articleId)
                .orderByDesc(SysArticleHistory::getVersion);
        return Result.success(sysArticleHistoryMapper.selectPage(PageUtil.getPage(), wrapper));
    }

    @GetMapping("/{id}")
    @ApiOperation("查询文章历史版本详情")
    public Result<SysArticleHistory> detail(@PathVariable("id") Long id) {
        return Result.success(sysArticleHistoryMapper.selectById(id));
    }

    @DeleteMapping("/{ids}")
    @ApiOperation("删除文章历史版本")
    public Result<Boolean> delete(@PathVariable List<Long> ids) {
        return Result.success(sysArticleHistoryMapper.deleteBatchIds(ids) > 0);
    }
}