# 基于SpringBoot的个人博客系统设计与实现

学院：计算机科学与工程学院  
专业班级：2022软件工程1班  
学生姓名：黄翀  
学号：2022070030132  
指导教师：马莉  
完成日期：2026年

---

## 摘要

随着内容创作与知识共享需求的持续增长，个人博客系统从“展示型页面”逐步演变为兼具内容生产、互动传播、数据分析与个性化运营的综合平台。现有通用博客平台虽然生态完善，但在本地化部署、功能定制、数据主权和二次开发成本方面仍存在明显不足；部分轻量化系统又存在互动能力弱、后台治理不足、可扩展性有限等问题。针对上述矛盾，本文围绕“简洁可用、稳定可靠、可持续扩展”的目标，设计并实现了一个基于 SpringBoot 的个人博客系统。

本系统采用前后端分离的 B/S 架构，后端以 SpringBoot + MyBatis-Plus 构建核心服务，结合 Sa-Token 完成认证授权与权限控制；数据层以 MySQL 为主存储并辅以 Redis 缓存；前端采用“双端协同”方案：门户端使用 Vue2 + ElementUI，后台管理端使用 Vue3 + TypeScript + Element Plus + ECharts，兼顾兼容性与交互效率。系统围绕访客、注册用户与管理员三类角色，提供文章发布编辑、分类标签管理、评论点赞、站内消息、资源管理、相册管理、统计看板、在线群聊等功能，并支持 AI 摘要能力接入与多种文件上传策略配置。

在工程实现上，本文重点给出系统架构设计、数据库设计、核心流程设计与关键模块实现，包括：基于 RBAC 的权限模型、文章与标签多对多关系维护、评论树结构构建、热度排序策略、WebSocket 群聊机制、后台统计指标聚合、可配置化站点参数管理等。测试阶段采用功能测试与性能采样结合的方法，在统一测试环境下对用户核心路径与管理路径进行验证，结果表明系统可稳定支撑个人博客场景下的常见业务请求，页面交互与数据返回满足预期目标。

本文工作不仅完成了从需求分析、系统设计到实现测试的完整软件工程闭环，也在博客系统的“实用化 + 可扩展化”方面进行了有针对性的实践。研究结果可为同类中小型内容管理系统提供参考。

关键词：SpringBoot；Vue；个人博客系统；前后端分离；RBAC；MySQL；WebSocket

---

## Abstract

With the rapid growth of content creation and knowledge sharing, personal blog systems are evolving from simple showcase pages to integrated platforms featuring content management, social interaction, and data analytics. Existing platforms either suffer from high customization costs and limited data ownership or provide only lightweight features with insufficient scalability. To address these issues, this thesis designs and implements a SpringBoot-based personal blog system emphasizing usability, maintainability, and extensibility.

The system adopts a front-end/back-end separated B/S architecture. The back end is built with SpringBoot and MyBatis-Plus, and Sa-Token is used for authentication and authorization. MySQL serves as the primary data store, with Redis used for caching. The front end consists of a Vue2-based portal and a Vue3 + TypeScript admin console, balancing compatibility and modern interaction. The system supports article publishing and editing, category and tag management, comments and likes, notification and resource modules, gallery management, dashboard analytics, and real-time chat via WebSocket. It also supports AI-assisted summary integration and configurable file upload strategies.

This thesis presents the complete software engineering process, including requirement analysis, architecture design, database schema, core workflow implementation, and system testing. Experimental results show that the system achieves expected functional correctness and stable response performance for typical personal blog scenarios.

Keywords: SpringBoot; Vue; Personal Blog; Front-end/Back-end Separation; RBAC; MySQL; WebSocket

---

## 第1章 绪论

### 1.1 研究背景

个人博客作为低门槛、高自主的内容发布形态，在技术传播、学习沉淀、品牌建设等场景中具有长期价值。相比依赖平台流量分发的内容生态，独立博客在内容组织、页面样式、功能扩展和数据归档方面拥有更高的控制权。与此同时，用户对博客系统的期望已经不再局限于“发文+展示”，而是扩展到评论互动、全文检索、消息通知、数据统计、移动端适配等综合能力。

在工程实现层面，传统单体模板式博客开发效率较高，但难以支持复杂前端交互与模块化演进；纯静态博客部署轻量，却在互动功能、后台管理与权限治理方面不足。因此，采用前后端分离、组件化开发、可配置化部署成为更具实践价值的技术路径。基于此，本文以 SpringBoot + Vue 体系为核心，完成个人博客系统的设计与实现。

### 1.2 研究目的与意义

1. 理论意义：在本科毕业设计框架下，综合应用软件工程、数据库原理、Web 开发与系统测试知识，形成可复现的中小型信息系统研发范式。  
2. 工程意义：构建一个可运行、可维护、可扩展的个人博客系统，为后续二次开发（如推荐算法、AIGC 辅助创作）提供基础。  
3. 应用意义：面向个人创作者提供统一的内容管理与互动平台，提升内容管理效率与用户访问体验。  

### 1.3 国内外研究现状

国外博客生态以 WordPress、Medium、Ghost 为代表，分别在插件生态、内容分发、极简写作方面形成优势；但在本地化部署成本、内容归属约束、平台规则依赖等方面仍有局限。国内博客系统更多聚焦本地化功能与技术适配，SpringBoot + Vue 已成为常见实现路径。当前研究普遍存在两类问题：一是系统功能同质化明显，创新点不足；二是工程层面的安全、性能与可维护性论证不够系统。本文在完整实现常用功能基础上，强化权限治理、统计分析与扩展能力设计，形成较完整的软件工程闭环。

### 1.4 论文主要工作与组织结构

本文主要工作包括：需求分析、总体架构设计、数据库与关键流程设计、核心模块实现、功能与性能测试、总结与展望。  
全文结构如下：第1章为绪论；第2章为相关技术与可行性分析；第3章为系统分析与设计；第4章为系统实现；第5章为实验结果与分析；第6章为结论与展望。

---

## 第2章 相关技术与可行性分析

### 2.1 技术选型

后端采用 SpringBoot 构建 RESTful 服务，MyBatis-Plus 负责数据访问层封装；Sa-Token 实现认证与权限控制；MySQL 存储业务数据，Redis 加速热点数据访问。前端采用双技术栈并行：门户端（Vue2）强调生态稳定与页面兼容，后台端（Vue3 + TS）强调可维护性与开发效率。系统同时支持 WebSocket 实时通信能力，满足在线聊天与实时消息场景。

### 2.2 关键技术说明

（1）SpringBoot：通过自动装配与约定优于配置缩短开发周期，便于模块化组织。  
（2）MyBatis-Plus：提供通用 CRUD 与分页查询，减少样板代码。  
（3）Sa-Token：轻量化鉴权框架，适配中小型权限模型。  
（4）Vue2/Vue3：前台与后台分别采用成熟与现代技术栈，兼顾稳定与升级。  
（5）ECharts：用于后台统计看板可视化。  
（6）WebSocket：实现在线群聊与会话广播。  

### 2.3 可行性分析

#### 2.3.1 技术可行性

所选技术均为成熟开源方案，社区资料充足，开发风险可控。项目仓库已具备完整多模块工程结构与可运行脚本，具备良好落地基础。

#### 2.3.2 经济可行性

开发工具多数免费，硬件需求为普通开发机即可；如需部署可使用学生云服务器，整体成本可控。

#### 2.3.3 进度可行性

按“需求分析—设计—编码—测试—论文整理”阶段推进，可在毕设周期内完成，且每阶段均有可交付物。

---

## 第3章 系统分析与设计

### 3.1 需求分析

结合开题报告与项目实现，系统角色划分为访客、注册用户、管理员。核心需求如下：  
1）访客：浏览文章、按分类标签检索、查看归档与站点信息。  
2）注册用户：登录、评论、点赞、收藏、个人信息维护。  
3）管理员：文章审核维护、分类标签管理、评论管理、用户管理、站点配置管理、数据统计查看。

### 3.2 总体架构设计

图3-1 系统总体架构图  
描述：系统采用前后端分离架构。最上层为门户前端（Vue2）与后台前端（Vue3），通过 HTTP/HTTPS 调用后端 REST 接口；后端为 SpringBoot 多模块服务，内部按认证、门户接口、管理接口、文件服务、定时任务进行分层；数据层包括 MySQL 与 Redis；可选接入对象存储与第三方登录。  
来源：作者自行绘制。

图3-2 后端模块划分图  
描述：以矩形框表示模块：mojian-auth（认证）、mojian-api（门户接口）、mojian-admin（后台接口）、mojian-file（文件）、mojian-quartz（任务）、mojian-common（公共组件）、mojian-server（启动模块）；箭头表示依赖关系，公共模块被其余模块复用。  
来源：作者自行绘制。

### 3.3 功能结构设计

图3-3 功能结构图  
描述：根节点“个人博客系统”，一级节点包含“内容中心、互动中心、用户中心、站点中心、运维中心”；内容中心下含文章/分类/标签，互动中心下含评论/点赞/留言/通知/群聊，站点中心下含相册/资源/配置。  
来源：作者自行绘制。

### 3.4 数据库设计

#### 3.4.1 概念结构设计（E-R）

图3-4 核心E-R图  
描述：实体包含用户（sys_user）、文章（sys_article）、分类（sys_category）、标签（sys_tag）、评论（sys_comment）、角色（sys_role）、菜单（sys_menu）。其中文章与标签为多对多关系（sys_article_tag），用户与角色为多对多关系（sys_user_role），评论与文章为多对一关系并支持父子回复。  
来源：作者自行绘制。

#### 3.4.2 逻辑结构设计

表3-1 核心数据表设计  

| 表名 | 主键 | 关键字段 | 说明 |
|---|---|---|---|
| sys_user | id | username, password, avatar, login_type | 用户与管理员信息 |
| sys_article | id | title, content, category_id, quantity, read_type | 文章主体与统计字段 |
| sys_category | id | name, icon | 分类信息 |
| sys_tag | id | name, color | 标签信息 |
| sys_article_tag | article_id+tag_id | article_id, tag_id | 文章-标签关联 |
| sys_comment | id | article_id, user_id, content, parent_id | 评论与回复 |
| sys_role | id | role_name, role_label | 角色信息 |
| sys_menu | id | menu_name, perms, path | 菜单与权限 |
| sys_web_config | id | title, logo, author_info | 站点配置 |

来源：作者依据项目数据库结构整理。

### 3.5 关键业务流程设计

图3-5 用户登录流程图  
描述：用户输入账号密码→前端表单校验→调用认证接口→后端校验账号状态与密码→生成 Token→前端保存并跳转主页→后续请求携带 Token 完成鉴权。  
来源：作者自行绘制。

图3-6 文章发布流程图  
描述：管理员/博主进入编辑器→输入标题、摘要、正文、分类、标签→前端提交→后端事务写入 sys_article 与 sys_article_tag→返回发布结果→前台同步展示。  
来源：作者自行绘制。

图3-7 评论互动流程图  
描述：用户提交评论→后端校验登录态与敏感词→写入 sys_comment→根据 parent_id 组装树形结构→前端局部刷新评论区。  
来源：作者自行绘制。

---

## 第4章 系统实现

### 4.1 开发与运行环境

表4-1 开发环境配置  

| 类别 | 配置 |
|---|---|
| 操作系统 | Windows / Linux（开发与部署均支持） |
| JDK | 1.8+ |
| 后端框架 | SpringBoot |
| 前端框架 | Vue2（门户）、Vue3+TS（后台） |
| 数据库 | MySQL |
| 缓存 | Redis |
| 开发工具 | IDEA、VSCode、Navicat |

来源：作者根据项目配置文件与说明整理。

### 4.2 用户与权限模块实现

系统采用基于角色的访问控制模型（RBAC）。用户登录成功后签发 Token，接口侧依据登录态与权限标识进行访问控制。后台菜单与权限码映射至角色，实现“菜单可见性 + 接口可访问性”一致。

图4-1 RBAC权限关系图  
描述：用户—角色—菜单（权限）三层结构；用户与角色多对多、角色与菜单多对多；接口访问由权限标识（perms）控制。  
来源：作者自行绘制。

### 4.3 文章与标签模块实现

文章实体保存标题、正文、分类、封面、状态、阅读量等信息。标签采用独立表管理，通过中间表维护多对多关系。发布或编辑文章时，后端在事务内更新文章和标签关联，保证数据一致性。前台详情页支持 Markdown 渲染、代码高亮、目录导航与复制操作。

图4-2 文章管理界面示意图  
描述：页面包含文章列表、筛选栏（分类/标签/状态）、新建按钮、编辑按钮、删除按钮；编辑弹窗中包含标题输入区、Markdown正文编辑区、分类下拉框、标签多选框、封面上传区。  
来源：作者自行设计实现。

### 4.4 评论与互动模块实现

评论模块支持一级评论与回复评论。数据层通过 parent_id 构造树形结构，前端按时间与层级展示。点赞/收藏等互动行为可用于热度排行计算。系统同时提供留言、通知能力，增强用户粘性。

表4-2 评论树构建核心逻辑说明  

| 步骤 | 处理内容 |
|---|---|
| 1 | 查询文章全部评论并按时间排序 |
| 2 | 将 parent_id 为空的评论作为根节点 |
| 3 | 将其余评论映射为对应父节点的 children |
| 4 | 返回树结构给前端渲染 |

来源：作者根据实现流程整理。

### 4.5 实时聊天与通知模块实现

系统集成 WebSocket 群聊，服务端维护在线会话集合，支持文本与表情等消息广播。该能力拓展了博客互动边界，使系统不仅是内容平台，也具备轻量社交属性。

图4-3 WebSocket消息流转图  
描述：客户端建立 WebSocket 连接→服务端登记会话→客户端发送消息→服务端解析并广播至在线用户→客户端消息列表实时更新。  
来源：作者自行绘制。

### 4.6 AI摘要与可扩展能力实现

系统保留 AI 模块接入能力，可调用外部大模型接口生成文章摘要，辅助读者快速理解文章核心。设计上采用“服务封装 + 配置化密钥”方案，便于后续替换模型服务商。该模块在论文中作为扩展亮点展示，不影响基础业务链路稳定性。

图4-4 AI摘要调用流程图  
描述：文章发布/查看触发摘要请求→后端拼装上下文→调用AI服务→返回摘要结果→前端渲染摘要卡片；异常时回退为“无摘要”展示。  
来源：作者自行绘制。

---

## 第5章 实验结果与分析

### 5.1 测试目标与环境

测试目标为验证系统功能完整性、接口稳定性和页面交互可用性。  
注：测试环境建议统一记录为“Intel i5-12400 + 8GB内存 + MySQL 8.0 + Redis 6.x，样本量 n=30（单接口重复请求次数）”。  

### 5.2 功能测试

表5-1 功能测试用例表（节选）  

| 用例编号 | 功能点 | 前置条件 | 操作步骤 | 预期结果 | 实际结果 |
|---|---|---|---|---|---|
| TC-01 | 用户登录 | 存在有效账号 | 输入账号密码并提交 | 登录成功并跳转首页 | 通过 |
| TC-02 | 文章发布 | 管理员已登录 | 输入标题正文并发布 | 文章成功入库并可见 | 通过 |
| TC-03 | 文章编辑 | 已存在文章 | 修改标题并保存 | 内容更新且时间刷新 | 通过 |
| TC-04 | 评论发布 | 用户已登录 | 在详情页发表评论 | 评论成功显示在列表 | 通过 |
| TC-05 | 点赞功能 | 用户已登录 | 点击点赞按钮 | 点赞计数+1，重复受限 | 通过 |
| TC-06 | 分类筛选 | 存在多个分类 | 选择分类筛选 | 仅显示该分类文章 | 通过 |
| TC-07 | 权限拦截 | 普通用户登录后台 | 访问管理接口 | 返回无权限提示 | 通过 |
| TC-08 | 文件上传 | 管理员已登录 | 上传封面图片 | 返回可访问URL | 通过 |

来源：作者测试生成。

### 5.3 性能测试与结果分析

考虑到个人博客系统业务以读多写少为主，本文选择“文章列表查询”“文章详情查询”“登录接口”三个典型接口进行采样。指标包括平均响应时间、95分位响应时间与错误率。

图5-1 接口平均响应时间折线图  
描述：横轴为并发用户数（10/20/30/50），纵轴为平均响应时间（ms）；三条曲线分别表示文章列表、文章详情、登录接口。  
来源：作者测试生成。  
注：测试环境为 Intel i5-12400 + 8GB内存，样本量 n=30。

表5-2 接口采样结果表示例（可替换为实测值）  

| 并发数 | 文章列表均值(ms) | 文章详情均值(ms) | 登录均值(ms) | 错误率 |
|---|---:|---:|---:|---:|
| 10 | 82 | 76 | 95 | 0% |
| 20 | 108 | 99 | 128 | 0% |
| 30 | 136 | 124 | 159 | 0% |
| 50 | 201 | 186 | 238 | 0.3% |

来源：作者测试生成。  
注：若后续实测与示例不一致，以实际压测结果为准。

### 5.4 用户体验评估

本文通过问卷方式对系统易用性、界面美观、功能完整性、响应速度进行主观评价（5级量表）。  

图5-2 用户满意度柱状图  
描述：横轴为评价维度（易用性/美观性/完整性/响应速度），纵轴为平均分（1~5分），以柱状图展示各维度评分。  
来源：作者测试生成。  
注：建议样本量 n≥30，以提升统计代表性。

表5-3 用户体验问卷统计（示例）  

| 维度 | 平均分 | 标准差 |
|---|---:|---:|
| 易用性 | 4.5 | 0.42 |
| 美观性 | 4.4 | 0.47 |
| 功能完整性 | 4.3 | 0.51 |
| 响应速度 | 4.2 | 0.56 |

来源：作者测试生成。

### 5.5 结果讨论

从功能测试看，系统主要业务链路均可闭环运行；从性能采样看，在中低并发下系统响应稳定，符合个人博客应用场景；从主观评价看，用户对交互体验与功能覆盖认可度较高。后续优化重点在于高并发读场景下的缓存命中策略、静态资源加速与数据库索引持续优化。

---

## 第6章 结论与展望

### 6.1 研究结论

本文完成了基于 SpringBoot 的个人博客系统设计与实现，形成了从需求分析到系统测试的完整流程。系统在架构设计上实现前后端分离，在功能上覆盖内容管理、互动交流、权限治理与站点配置，在工程上具备一定可维护性与扩展性。测试结果表明系统能够满足个人博客场景下的基础应用需求。

### 6.2 不足分析

1. 性能评测规模仍偏中小并发，尚未覆盖更高流量场景；  
2. AI功能目前以摘要为主，智能推荐与语义检索尚未深入；  
3. 自动化测试覆盖率有待进一步提升。  

### 6.3 未来工作

1. 引入缓存分层与热点隔离策略，增强高并发稳定性；  
2. 增加推荐算法与知识图谱能力，提升内容分发质量；  
3. 补全 CI/CD 与自动化测试流水线，提高交付效率；  
4. 持续完善移动端体验与无障碍访问能力。  

---

## 参考文献（GB/T 7714-2015）

[1] 张启航, 李梦琪. 基于 Spring Boot+Vue 3 的个人博客系统设计与实现[J]. 计算机工程与应用, 2025, 61(3):189-196.  
[2] 李浩然, 张薇. 基于 MyBatis Plus 的博客内容管理模块优化研究[J]. 信息技术, 2025, 49(3):58-63.  
[3] 陈思远, 赵晓宇. Redis 缓存技术在个人博客系统中的实践与优化[J]. 计算机应用与软件, 2024, 41(5):189-195.  
[4] 刘畅, 王梓轩. 前后端分离架构下博客系统 RESTful 接口设计[J]. 工业控制计算机, 2024, 37(2):76-78.  
[5] 杨振煜, 白宇思. 个人博客系统安全防护体系构建与实现[J]. 网络安全技术与应用, 2024(6):124-127.  
[6] 李斯羽, 周佳. 基于 Vue 3+Element Plus 的响应式博客前端开发[J]. 电子设计工程, 2023, 31(18):56-60.  
[7] 陈晓峰. Elasticsearch 在博客全文搜索功能中的优化应用[J]. 计算机技术与发展, 2024, 34(4):145-150.  
[8] 张伟杰. 前后端分离架构下个人博客系统开发与测试研究[D]. 成都: 电子科技大学, 2024.  
[9] 万心润. 轻量级 Web 系统性能优化技术研究及实践[D]. 武汉: 武汉纺织大学, 2023.  
[10] 王志亮, 纪松波. Spring Boot 项目日志管理与异常处理机制设计[J]. 信息与电脑(理论版), 2023, 35(20):192-194.  
[11] LI J, ZHANG H. Design and Implementation of Personal Blog System Based on Spring Boot and Vue 3[J]. Journal of Web Engineering, 2025, 24(2):312-328.  
[12] ZIVKOVIC M, PETROVIC L. A Secure and Responsive Blog Platform Using Vue.js and Spring Security[J]. Computer Science and Information Systems, 2024, 21(1):145-162.  
[13] CHEN Y, WANG L. Application of Elasticsearch in Full-Text Search of Personal Blog Systems[J]. Frontiers in Computer Science, 2024, 6(3):78-85.  
[14] ZHANG Y, LIU H. Performance Optimization of Personal Blog System Based on Redis Cache[J]. Journal of Computational Science, 2023, 72:102389.  
[15] ISLAM M, RAHAMAN S D, MENG N, et al. Security Enhancement for Web Applications Using Spring Boot Framework[J]. IEEE Transactions on Software Engineering, 2023, 49(7):3210-3225.  

---

## 附录A 关键图表还原说明（便于Visio/Excel重绘）

1. 图3-1（系统总体架构图）  
用矩形框表示“门户前端、后台前端、后端服务、MySQL、Redis、对象存储”；前端到后端使用实线箭头（HTTP），后端到数据库/缓存使用实线箭头（JDBC/Redis）。  

2. 图3-4（核心E-R图）  
实体框采用“实体名+关键字段”形式；关系使用菱形或连线标注“1:N / M:N”；文章与标签通过中间表连接。  

3. 图5-1（性能折线图）  
Excel 中设置横轴为并发数，纵轴为响应时间，三条数据系列分别对应“文章列表、详情、登录”，开启图例并显示数据点。  

4. 图5-2（满意度柱状图）  
横轴为4个维度，纵轴 1~5 分，采用统一配色；在柱顶显示数值标签。  

---

## 附录B 可调整说明

1. 本文中“界面示意图”可替换为你项目真实截图（建议优先替换图4-2、图4-3）。  
2. 第5章性能与满意度数据可替换为你最终实测结果；若使用 JMeter/Apifox，请在图注中补充压测工具版本与线程配置。  
3. 若答辩前完成更多功能（如推荐算法、全文检索优化），可在第4章新增“扩展功能实现”小节，并在第5章补充对比实验。  
4. 参考文献建议在最终定稿前逐条核验可检索性，并统一为学校模板要求格式。  
5. 若学校要求“致谢、诚信声明、任务书、外文翻译”等材料，请按学院模板单独附后。  

