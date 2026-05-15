package com.mojian.enums;

import java.util.Arrays;

/**
 * 反馈类型枚举
 */
public enum FeedbackTypeEnum {
    FUNCTION_SUGGESTION("function_suggestion", "功能建议"),
    BUG_REPORT("bug_report", "Bug反馈"),
    PERFORMANCE_ISSUE("performance_issue", "性能问题"),
    UI_OPTIMIZATION("ui_optimization", "界面优化"),
    OTHER("other", "其他");

    private final String code;
    private final String desc;

    FeedbackTypeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    public static boolean contains(String code) {
        if (code == null) {
            return false;
        }
        return Arrays.stream(values()).anyMatch(item -> item.code.equals(code));
    }
}
