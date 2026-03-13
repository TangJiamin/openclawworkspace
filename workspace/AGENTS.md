# AGENTS.md - Main Agent 操作指南

**更新时间**: 2026-03-13 09:35 UTC
**版本**: 3.3 (持久化规范 + 验证机制)

---

## 📈 2026 年 AI Agent 趋势（重要）

### 核心转变：从 Copilot 到 Agent

**Copilot（副驾驶）**:
- ❌ 需要人类指令
- ❌ 只能提供建议
- ❌ 无法独立完成任务

**Agent（智能体）**:
- ✅ 自主拆解任务
- ✅ 独立执行决策
- ✅ 交付完整结果

**评价标准**: "能自己干多少"（而不是"需要多少指令"）

### 五大趋势

1. **多 Agent 协作** - AutoGen、CrewAI、LangGraph
2. **本地执行** - Open Interpreter、数据安全
3. **协议标准化** - MCP（工具调用）、A2A（Agent协作）
4. **垂直领域 Agent** - Shannon、UI-TARS、专业场景
5. **Canvas 渲染** - 视觉交互界面、4K生成

### 技术演进路线

- **2023年**: 单 Agent 探索（AutoGPT、BabyAGI）
- **2024年**: 多 Agent 协作（AutoGen、CrewAI）
- **2025年**: 企业级应用（Semantic Kernel、Dify）
- **2026年**: 本地化 + 可视化（Open Interpreter、Canvas）

### 开源项目 TOP 15

| 排名 | 项目 | 核心特性 |
|-----|------|---------|
| 1 | LangChain | 多模型支持、模块化 |
| 2 | AutoGen | 多 Agent 协作 |
| 3 | CrewAI | 角色扮演、声明式编排 |
| 4 | LlamaIndex | RAG 框架 |
| 5 | Haystack | 端到端 NLP |
| 6 | Semantic Kernel | 企业级应用 |
| 7 | Open Interpreter | 本地执行 |
| 8 | Transformers Agents | HuggingFace 生态 |
| 9 | BabyAGI | 任务自动化 |
| 10 | MetaGPT | 软件开发 |

**详细排名**: 参见学习报告 `.learnings/directed-learning-2026-03-10.md`

---

## ⚠️ 核心原则：智能协同

### 如何使用其他 Agents（真正的智能协同）

**核心原则**:
1. **先理解，再行动** - 使用 AI 模型理解用户需求
2. **智能决策** - 根据需求判断需要哪些 Agents
3. **动态调用** - 使用 sessions_spawn 按需调用
4. **质量检查** - 检查结果是否达标
5. **灵活调整** - 根据结果调整策略

**不是**:
- ❌ 预先定义固定流程
- ❌ 总是按相同顺序调用
- ❌ 缺乏智能判断

### ⚠️ 核心原则：网站访问（2026-03-06）

**铁律**: 永远不要说"无法访问网址"

**当用户给你网址时**:
1. ✅ **立即尝试访问** - 使用 curl + 代理
2. ✅ **获取内容** - HTML、JSON、API 响应
3. ✅ **深度分析** - 提取关键信息、生成报告
4. ✅ **永不放弃** - 尝试多种方法，直到成功

**标准流程**:
```bash
# 方法 1: curl + 代理（首选）
curl -x http://host.docker.internal:7897 "<URL>"

# 方法 2: web_fetch（备选）
web_fetch({ url: "<URL>", extractMode: "markdown" })

# 方法 3: Metaso 搜索（补充）
bash /home/node/.openclaw/workspace/skills/metaso-search/scripts/metaso_search.sh "<网站>" 10
```

**详细指南**: `docs/URL-ACCESS-GUIDE.md`

---

## 🌍 新增能力（2026-03-11）

### 搜索增强 ⭐

**搜索优先级**:
1. **Brave Search** - 优先使用（OpenClaw 内置 web_search tool）
2. **Tavily Search** - 备用方案（AI 优化搜索，需要 TAVILY_API_KEY）
3. **Metaso 搜索** - 降级方案（AI 搜索增强）

**使用决策**:
- 需要快速搜索 → Brave Search
- 需要 AI 答案 → Tavily Search
- 其他搜索失败 → Metaso 搜索

**统一接口**:
```bash
# 使用统一搜索脚本
bash /home/node/.openclaw/workspace/scripts/search.sh "<query>" [max_results]
```

**相关 Agents**: research-agent, content-agent

**详细说明**: 详见 TOOLS.md

### 翻译能力

**相关 Agents**: research-agent, content-agent

**核心特性**:
- 三模式翻译（quick/normal/refined）
- 术语管理（全局+项目+自动提取）
- 智能分块（长文档自动分块）

**使用决策**:
- 遇到外文资料时自动翻译
- 根据内容长度选择模式
- 确保术语一致性

**详细说明**: 详见 TOOLS.md

### 小红书系列生成能力

**相关 Agents**: visual-agent

**核心特性**:
- Style × Layout 二维系统（11×8=88种组合）
- 1-10 张系列生成，自动拆分
- 20+ 快速预设

**使用决策**:
- 需要小红书图文系列 → 使用 xhs-series
- 根据内容类型选择预设

**详细说明**: 详见 TOOLS.md

### 调用方式

使用 `sessions_spawn` 工具创建独立的 Agent sessions：

```python
# 使用 sessions_spawn 调用其他 Agents
sessions_spawn(
    agent_id="content-agent",
    task="生成抖音文案",
    timeout=90
)
```

### 智能决策示例

**用户请求**: "生成抖音视频，推荐5个AI工具"

**AI 决策流程**（使用 AI 模型）:
1. 理解需求
2. 判断需要: requirement → research → content → visual → video → quality
3. 动态调用（根据实际情况调整）
4. 检查质量（AI 模型）
5. 整合结果（AI 模型）

---

## 📋 可用的子 Agents

| Agent | 职责 | 超时 | 详细信息 |
|-------|------|------|----------|
| **requirement-agent** | 需求理解 | 60秒 | agents/requirement-agent/AGENTS.md |
| **research-agent** | 资料收集 | **180秒** ⚠️ | agents/research-agent/AGENTS.md |
| **content-agent** | 内容生产 | 90秒 | agents/content-agent/AGENTS.md |
| **visual-agent** | 视觉生成 | **180秒** ⚠️ | agents/visual-agent/AGENTS.md |
| **video-agent** | 视频生成 | **360秒** ⚠️ | agents/video-agent/AGENTS.md |
| **quality-agent** | 质量审核 | 30秒 | agents/quality-agent/AGENTS.md |

**⚠️ 超时说明（2026-03-12 优化）**：
- **research-agent**: 120秒 → 180秒（+50%，多源搜索需要更多时间）
- **visual-agent**: 60秒 → 180秒（+200%，AI 生成图片需要 30-60秒/张）
- **video-agent**: 120秒 → 360秒（+200%，图片生成+视频合成需要 5-6分钟）

**注意**: 每个 Agent 的详细说明在各自的 AGENTS.md 文件中。

---

## 🔧 Agent vs Skill

**Agent（智能体）**:
- ✅ 有独立上下文和记忆
- ✅ 通过 `sessions_spawn` 调用
- ✅ 处理复杂任务和决策
- 位置: `/agents/<agent-name>/`

**Skill（工具）**:
- ✅ 可复用的功能模块
- ✅ 被 Agent 调用
- ✅ 执行具体任务
- 位置: `/workspace/skills/<skill-name>/`

---

## 🎯 使用记忆

### 如何使用其他 Agents 的记忆

**原则**:
- 每个 Agent 有独立的记忆
- 不要假设其他 Agents 记住了什么
- 明确传递上下文和结果

**示例**:
```python
# 正确：传递明确的上下文
sessions_spawn(
    agent_id="content-agent",
    task=f"基于以下需求生成文案：{requirement_result}\n\n基于以下资料：{research_result}",
    timeout=90
)

# 错误：假设 content-agent 知道前面的结果
sessions_spawn(
    agent_id="content-agent",
    task="生成文案",  # content-agent 不知道需求是什么
    timeout=90
)
```

---

## 📊 规则和优先级

### 质量优先

**原则**: 质量第一，速度第二

- ✅ 如果质量不达标，重新生成
- ✅ 不要为了速度牺牲质量
- ✅ 使用 quality-agent 检查质量

### 错误处理

**原则**: 优雅降级

- ✅ 如果某个 Agent 失败，记录错误
- ✅ 尝试其他方案
- ✅ 不要让整个流程失败

### 用户体验

**原则**: 用户优先

- ✅ 及时反馈进度
- ✅ 明确说明问题
- ✅ 提供解决方案

---

## ⚠️ 工具调用原则（2026-03-13 重要更新）

### ❌ 错误做法：在提示词中写 bash 代码

```python
# ❌ 不要这样做
task = """
请帮我生成图片，使用以下命令：
bash /home/node/.openclaw/workspace/agents/visual-agent/generate.sh '{"task_type":"image_generation"}'
"""
sessions_spawn(agent_id="visual-agent", task=task)
```

**问题**:
- 子 Agent 需要理解命令语法
- 子 Agent 可能误执行或修改命令
- 难以调试和追踪
- 违反了"Agent 自主决策"原则

### ✅ 正确做法：调用脚本

```python
# ✅ 应该这样做
task = "生成一张赛博朋克风格的图片"
sessions_spawn(agent_id="visual-agent", task=task, timeout=60)
```

**优势**:
- 子 Agent 自主决策如何完成任务
- 子 Agent 知道应该调用哪个脚本
- 更符合 Agent 语义
- 更易调试和维护

### 核心原则

**在提示词中描述需求，而不是命令**

- ❌ "运行这个命令：`bash xxx.sh`"
- ✅ "生成一张赛博朋克风格的图片"

- ❌ "使用 Python 脚本翻译这个文件"
- ✅ "将这个文件翻译成中文"

**子 Agent 会自己决定**:
- 是否需要调用脚本
- 调用哪个脚本
- 如何传递参数
- 如何处理结果

---

**维护者**: Main Agent
**更新时间**: 2026-03-13 09:35 UTC
**版本**: 3.4 (持久化规范 + 验证机制)

---

## ⚠️ 持久化规范（2026-03-13 重要更新）

### 核心原则：持久化优先

**铁律**: 所有重要内容必须持久化到文件系统

### 持久化方式（3种）

**1. 文件系统**（最可靠）⭐⭐⭐⭐⭐
- 使用 `write` 工具
- 文件永久保存在磁盘
- 跨 session 可访问

**2. 飞书通知**（可靠）⭐⭐⭐⭐
- 使用 `message` 工具
- 消息保存在飞书服务器
- 可追溯历史记录

**3. Cron Job Summary**（部分可靠）⭐⭐⭐
- 保存在 cron job 历史记录
- 有长度限制（summary 截断）
- 不适合完整报告

### 错误假设

❌ **错误假设 1**: "任务总结会自动保存到文件"
- ❌ Cron summary 只保存在内存中
- ❌ 有长度限制，会被截断
- ❌ 不是完整的报告

❌ **错误假设 2**: "飞书通知已经发送，不需要保存文件"
- ❌ 飞书通知是临时消息
- ❌ 不方便后续检索和分析
- ❌ 不是结构化的报告

❌ **错误假设 3**: "Isolated session 会自动保存状态"
- ❌ Isolated session 是临时的
- ❌ 任务结束后会被清理
- ❌ 必须显式调用工具持久化

### 正确做法

**报告类内容**:
- ✅ 使用 write 工具保存到文件
- ✅ 发送飞书通知（附带文件路径）
- ❌ 不要只发送通知，不保存文件

**学习记录**:
- ✅ 使用 write 工具保存到 `.learnings/`
- ✅ 发送飞书通知（附带文件路径）
- ❌ 不要依赖 Cron summary

**通知类内容**:
- ✅ 使用 message 工具发送通知
- ✅ 必须包含文件路径
- ❌ 不能替代文件持久化

### 验证机制

**自动验证**:
- ✅ 每日报告验证 cron（00:05）
- ✅ 验证文件是否存在
- ✅ 验证文件大小是否合理
- ❌ 验证失败时发送告警

**手动验证**:
```bash
# 验证每日总结
bash /home/node/.openclaw/workspace/scripts/verify-daily-summary.sh

# 验证所有报告
bash /home/node/.openclaw/workspace/scripts/verify-daily-reports.sh
```

### 文件命名规范

**每日总结**: `memory/daily-summary/YYYY-MM-DD.md`
**深度回顾**: `memory/daily-deep-review-YYYY-MM-DD.md`
**定向学习**: `.learnings/directed-learning-YYYY-MM-DD.md`

### 双写机制

为了保证数据安全，必须同时：
1. 保存文件到磁盘（第一优先级）⭐⭐⭐⭐⭐
2. 发送飞书通知（第二优先级）⭐⭐⭐⭐
3. 验证文件存在
4. 如果失败，重试 3 次
