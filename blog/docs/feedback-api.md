# 反馈接口字段说明

## 新增字段

- 字段名：`feedbackType`
- 数据库列：`feedback_type`
- 字段类型：`ENUM('function_suggestion','bug_report','performance_issue','ui_optimization','other')`
- 默认值：`function_suggestion`
- 说明：反馈类型，提交反馈时必填，查询反馈列表时可用于筛选。

## 枚举取值

- `function_suggestion`：功能建议
- `bug_report`：Bug反馈
- `performance_issue`：性能问题
- `ui_optimization`：界面优化
- `other`：其他

## 接口使用

- `POST /sys/feedback/add`
  - 请求体新增字段：`feedbackType`（必填）
- `PUT /sys/feedback/update`
  - 请求体可传字段：`feedbackType`（可选，传入时需为合法枚举值）
- `GET /sys/feedback/list`
  - 查询参数支持：`feedbackType`（可选，按类型筛选）

## 请求示例

```json
{
  "feedbackType": "bug_report",
  "content": "在移动端点击提交按钮无响应",
  "email": "test@example.com"
}
```
