# 取消收藏修复后的监控与验收

## 1. Prometheus 采集配置

- 采集地址：`http://<host>:8800/actuator/prometheus`
- 建议采集间隔：`15s`

示例 `prometheus.yml` 片段：

```yaml
scrape_configs:
  - job_name: mojian-blog
    metrics_path: /actuator/prometheus
    scrape_interval: 15s
    static_configs:
      - targets: ['127.0.0.1:8800']
```

## 2. Grafana 看板关键指标

- QPS（取消收藏接口）：
  - `sum(rate(http_server_requests_seconds_count{uri="/api/article/collect/{id}",method="POST"}[1m]))`
- 4xx 比例：
  - `sum(rate(http_server_requests_seconds_count{status=~"4.."}[5m])) / sum(rate(http_server_requests_seconds_count[5m]))`
- P99 延迟：
  - `histogram_quantile(0.99, sum(rate(http_server_requests_seconds_bucket{uri="/api/article/collect/{id}",method="POST"}[5m])) by (le))`

## 3. 验收标准（连续24小时）

- QPS 稳定，无明显抖动与长时间归零。
- 4xx 比例维持在 `<= 1%`。
- P99 延迟维持在 `< 500ms`。
- 应用日志中不存在批量“请求过于频繁”误报。
- `sys_article_collect_log` 日志记录完整，可按 `user_id + article_id` 追溯收藏/取消收藏行为。
