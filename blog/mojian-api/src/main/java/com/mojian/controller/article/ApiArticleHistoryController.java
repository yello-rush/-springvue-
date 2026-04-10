package com.mojian.controller.article;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mojian.common.Result;
import com.mojian.entity.SysArticleHistory;
import com.mojian.mapper.SysArticleHistoryMapper;
import com.mojian.vo.article.SysArticleHistoryVo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/article/history")
@RequiredArgsConstructor
@Api(tags = "前台文章历史版本")
public class ApiArticleHistoryController {

    private final SysArticleHistoryMapper sysArticleHistoryMapper;

    @GetMapping("/list/{articleId}")
    @ApiOperation("查询文章历史版本列表")
    public Result<List<SysArticleHistoryVo>> list(@PathVariable("articleId") Long articleId) {
        LambdaQueryWrapper<SysArticleHistory> wrapper = new LambdaQueryWrapper<SysArticleHistory>()
                .eq(SysArticleHistory::getArticleId, articleId)
                .select(SysArticleHistory::getId, SysArticleHistory::getArticleId, SysArticleHistory::getTitle, SysArticleHistory::getSummary, SysArticleHistory::getVersion, SysArticleHistory::getCreateBy, SysArticleHistory::getCreateTime)
                .orderByDesc(SysArticleHistory::getVersion);
        List<SysArticleHistory> historyList = sysArticleHistoryMapper.selectList(wrapper);
        List<SysArticleHistoryVo> voList = historyList.stream().map(h -> {
            SysArticleHistoryVo vo = new SysArticleHistoryVo();
            BeanUtils.copyProperties(h, vo);
            return vo;
        }).collect(Collectors.toList());
        return Result.success(voList);
    }

    @GetMapping("/{id}")
    @ApiOperation("查询文章历史版本详情")
    public Result<SysArticleHistoryVo> detail(@PathVariable("id") Long id) {
        SysArticleHistory history = sysArticleHistoryMapper.selectById(id);
        if (history == null) {
            return Result.error("历史版本不存在");
        }
        SysArticleHistoryVo vo = new SysArticleHistoryVo();
        BeanUtils.copyProperties(history, vo);
        return Result.success(vo);
    }
}