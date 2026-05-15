package com.mojian.controller.message;

import com.mojian.common.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/sys/dictData")
@Api(tags = "门户-字典数据")
public class DictDataController {

    @GetMapping("/selectDataByDictTypeCache/{dictType}")
    @ApiOperation(value = "获取字典数据（兼容接口）")
    public Result<List<Map<String, Object>>> selectDataByDictTypeCache(@PathVariable String dictType) {
        if ("feedback_type".equals(dictType)) {
            return Result.success(buildFeedbackTypeOptions());
        }
        if ("feedback_status".equals(dictType)) {
            return Result.success(buildFeedbackStatusOptions());
        }
        return Result.success(Collections.emptyList());
    }

    private List<Map<String, Object>> buildFeedbackTypeOptions() {
        return Arrays.asList(
                item("功能建议", "function_suggestion", "primary"),
                item("Bug反馈", "bug_report", "danger"),
                item("性能问题", "performance_issue", "warning"),
                item("界面优化", "ui_optimization", "success"),
                item("其他", "other", "info")
        );
    }

    private List<Map<String, Object>> buildFeedbackStatusOptions() {
        return Arrays.asList(
                item("待处理", "0", "warning"),
                item("处理中", "1", "primary"),
                item("已处理", "2", "success")
        );
    }

    private Map<String, Object> item(String label, String value, String style) {
        Map<String, Object> option = new LinkedHashMap<>(4);
        option.put("label", label);
        option.put("value", value);
        option.put("style", style);
        return option;
    }
}
