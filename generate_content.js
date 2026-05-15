const fs = require('fs');
const mysql = require('mysql2/promise');

async function run() {
  const conn = await mysql.createConnection({
    host: 'localhost', user: 'root', password: '1234', database: 'blog'
  });
  
  const [articles] = await conn.execute('SELECT id, title FROM sys_article');
  
  for (const article of articles) {
    const title = article.title;
    const contentMd = `## 引言\n\n关于 **${title}** 的探讨，在现代软件开发中正变得越来越重要。很多开发者在实际项目中都会遇到类似的问题。本文将深入探讨相关的原理与最佳实践。\n\n## 核心原理解析\n\n### 1. 基础架构\n\n首先，我们需要理解其底层架构。通过合理的模块划分，我们可以实现高内聚、低耦合的设计目标。\n这不仅有助于代码的维护，还能大幅提升系统的可扩展性。\n\n### 2. 关键技术点\n\n在实现 **${title}** 的过程中，有几个关键的技术点需要特别注意：\n\n* **性能优化**：通过缓存和异步处理提升响应速度。\n* **数据一致性**：确保在并发场景下的数据安全。\n* **异常处理**：建立完善的错误捕获与日志监控机制。\n\n\`\`\`java\n// 核心实现示例代码\npublic class CoreService {\n    public void processData() {\n        try {\n            // 业务逻辑处理\n            log.info("Processing data started...");\n            performOptimization();\n        } catch (Exception e) {\n            log.error("Error occurred", e);\n            throw new CustomException(e);\n        }\n    }\n}\n\`\`\`\n\n## 实践案例与经验总结\n\n在我们的实际项目中，通过引入这套方案，系统的吞吐量提升了将近40%，同时线上的错误率也显著下降。\n最重要的是，开发团队的维护成本大大降低。\n\n## 结语\n\n技术的演进永无止境，希望这篇关于 **${title}** 的分享能为大家在实际开发中提供一些参考和思路。欢迎在评论区交流讨论！`;
    
    const content = `<h2 id="引言">引言</h2><p>关于 <strong>${title}</strong> 的探讨，在现代软件开发中正变得越来越重要。很多开发者在实际项目中都会遇到类似的问题。本文将深入探讨相关的原理与最佳实践。</p><h2 id="核心原理解析">核心原理解析</h2><h3 id="1-基础架构">1. 基础架构</h3><p>首先，我们需要理解其底层架构。通过合理的模块划分，我们可以实现高内聚、低耦合的设计目标。<br>这不仅有助于代码的维护，还能大幅提升系统的可扩展性。</p><h3 id="2-关键技术点">2. 关键技术点</h3><p>在实现 <strong>${title}</strong> 的过程中，有几个关键的技术点需要特别注意：</p><ul><li><strong>性能优化</strong>：通过缓存和异步处理提升响应速度。</li><li><strong>数据一致性</strong>：确保在并发场景下的数据安全。</li><li><strong>异常处理</strong>：建立完善的错误捕获与日志监控机制。</li></ul><pre><code class="language-java">// 核心实现示例代码\npublic class CoreService {\n    public void processData() {\n        try {\n            // 业务逻辑处理\n            log.info(&quot;Processing data started...&quot;);\n            performOptimization();\n        } catch (Exception e) {\n            log.error(&quot;Error occurred&quot;, e);\n            throw new CustomException(e);\n        }\n    }\n}\n</code></pre><h2 id="实践案例与经验总结">实践案例与经验总结</h2><p>在我们的实际项目中，通过引入这套方案，系统的吞吐量提升了将近40%，同时线上的错误率也显著下降。<br>最重要的是，开发团队的维护成本大大降低。</p><h2 id="结语">结语</h2><p>技术的演进永无止境，希望这篇关于 <strong>${title}</strong> 的分享能为大家在实际开发中提供一些参考和思路。欢迎在评论区交流讨论！</p>`;
    
    await conn.execute('UPDATE sys_article SET content_md = ?, content = ? WHERE id = ?', [contentMd, content, article.id]);
    console.log(`Updated article ${article.id}`);
  }
  
  await conn.end();
}
run();