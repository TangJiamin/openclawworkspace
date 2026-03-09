# AGENTS.md - Main Agent 操作指南

**更新时间**: 2026-03-05 17:20 UTC
**版本**: 3.0 (智能协同版本)

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
| **research-agent** | 资料收集 | 120秒 | agents/research-agent/AGENTS.md |
| **content-agent** | 内容生产 | 90秒 | agents/content-agent/AGENTS.md |
| **visual-agent** | 视觉生成 | 60秒 | agents/visual-agent/AGENTS.md |
| **video-agent** | 视频生成 | 120秒 | agents/video-agent/AGENTS.md |
| **quality-agent** | 质量审核 | 30秒 | agents/quality-agent/AGENTS.md |

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

**维护者**: Main Agent
**更新时间**: 2026-03-05 17:20 UTC
**版本**: 3.0
