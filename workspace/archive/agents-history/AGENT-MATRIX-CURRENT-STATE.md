# Agent 矩阵当前状态 (2026-03-02)

## 架构概览

```
Main Agent (动态协调者)
  ├─ research-agent (资料收集)
  ├─ content-agent (文案生产)
  ├─ visual-agent (图片生成)
  ├─ video-agent (视频生成)
  └─ quality-agent (质量审核)
```

## Agent 列表

### 1. Main Agent - 动态协调者

**路径**: `/home/node/.openclaw/agents/main/agent/AGENTS.md`

**职责**:
- 理解用户需求
- 动态调度子 Agent
- 整合结果
- 处理异常

**调用**:
- 调用所有子 Agent
- 直接使用 requirement-analyzer、quality-reviewer 技能

**不调用**: 具体生成技能（由子 Agent 调用）

---

### 2. research-agent - 资料收集

**路径**: `/home/node/.openclaw/agents/research-agent/agent/AGENTS.md`

**职责**:
- 收集网络资讯
- 搜索技术文档
- 验证时效性
- 智能筛选

**调用技能**:
- metaso-search
- ai-daily-digest
- material-collector

**超时**: 120秒

---

### 3. content-agent - 文案生产

**路径**: `/home/node/.openclaw/agents/content-agent/agent/AGENTS.md`

**职责**:
- 生成各类文案（小红书、抖音、公众号等）
- 基于资料创作
- 遵循平台规范

**调用技能**:
- content-planner（策略规划）
- metaso-search（补充资料）

**超时**: 90秒

---

### 4. visual-agent - 图片生成

**路径**: `/home/node/.openclaw/agents/visual-agent/agent/AGENTS.md`

**职责**:
- 生成图片
- 设计信息图
- 制作封面

**调用技能**:
- visual-generator（多维参数系统）

**超时**: 60秒

---

### 5. video-agent - 视频生成

**路径**: `/home/node/.openclaw/agents/video-agent/agent/AGENTS.md`

**职责**:
- 生成视频分镜
- 制作视频内容

**调用技能**:
- seedance-storyboard（对话引导分镜）

**⚠️ 重要约束**:
- 必须先生成图片，再生成视频
- 禁止并行生成图片和视频
- 禁止直接从文本生成视频

**超时**: 120秒

---

### 6. quality-agent - 质量审核

**路径**: `/home/node/.openclaw/agents/quality-agent/agent/AGENTS.md`

**职责**:
- 审核文案质量
- 审核图片合规性
- 审核视频质量
- 输出质量报告

**调用技能**:
- quality-reviewer

**超时**: 30秒

---

## 已删除的 Agent

### requirement-agent

**删除原因**: 与 requirement-analyzer 技能完全重复

**删除时间**: 2026-03-02

**替代方案**: Main Agent 直接调用 requirement-analyzer 技能

---

## 技能列表

### 核心技能（已集成）

1. **requirement-analyzer** ✅ - 需求理解
2. **quality-reviewer** ✅ - 质量审核
3. **visual-generator** ✅ - 视觉生成
4. **seedance-storyboard** ✅ - 视频分镜
5. **ai-daily-digest** ✅ - 资讯收集
6. **metaso-search** ✅ - 网络搜索
7. **material-collector** ✅ - 资料收集
8. **content-planner** ✅ - 内容策略

### 支持技能

9. **feishu-doc** - 飞书文档操作
10. **feishu-drive** - 飞书云存储
11. **feishu-wiki** - 飞书知识库
12. **weather** - 天气查询

---

## 工作流程

### 完整流程（图文）

```
用户需求
  ↓
Main Agent 分析任务
  ↓
research-agent (收集资料)
  ↓
content-agent (生成文案)
  ↓
visual-agent (生成图片)
  ↓
quality-agent (质量审核)
  ↓
Main Agent 整合结果
  ↓
返回用户
```

### 完整流程（视频）

```
用户需求
  ↓
Main Agent 分析任务
  ↓
research-agent (收集资料)
  ↓
content-agent (生成文案)
  ↓
visual-agent (生成图片) ← 必需步骤
  ↓
video-agent (生成视频) ← 等图片完成后
  ↓
quality-agent (质量审核)
  ↓
Main Agent 整合结果
  ↓
返回用户
```

### 简化流程（仅文案）

```
用户需求
  ↓
Main Agent 分析任务
  ↓
content-agent (生成文案)
  ↓
quality-agent (质量审核)
  ↓
返回用户
```

---

## 设计原则

### 1. 第一性原理 ⭐️

从本质出发，寻找最优解：
- 问题的本质是什么？
- 用户的真正需求是什么？
- 什么是最优解决方案？

### 2. 分层架构

```
决策层（Main Agent）
  └─ 动态调度，不调用技能

执行层（子 Agents）
  └─ 调用对应技能

工具层（Skills）
  └─ 被调用
```

### 3. 避免重复

- 先检查是否已有技能
- 优先复用而非新建
- requirement-agent → requirement-analyzer 技能

### 4. 自然语言视频生成原则 ⚠️

**必须**:
1. 先生成图片
2. 再生成视频（使用图片）

**禁止**:
- ❌ 并行生成图片和视频
- ❌ 直接从文本生成视频

### 5. 单一文件原则

- Agent 只需要 AGENTS.md
- 角色定位 + 能力 + 调用关系统一
- 不需要额外的配置文件

---

## 当前状态

| Agent | 状态 | AGENTS.md | 技能集成 |
|-------|------|----------|---------|
| Main Agent | ✅ 完成 | ✅ | N/A（协调者） |
| research-agent | ✅ 完成 | ✅ | ✅ |
| content-agent | ✅ 完成 | ✅ | ✅ |
| visual-agent | ✅ 完成 | ✅ | ✅ |
| video-agent | ✅ 完成 | ✅ | ✅ |
| quality-agent | ✅ 完成 | ✅ | ✅ |
| requirement-agent | ❌ 已删除 | - | - |

---

## 使用示例

### 生成小红书图文

```javascript
orchestrate("生成小红书图文，推荐5个提升效率的AI工具")
```

**执行流程**:
1. Main Agent 分析任务
2. research-agent 收集资料
3. content-agent 生成文案
4. visual-agent 生成图片
5. quality-agent 质量审核
6. 整合结果返回

### 生成抖音视频

```javascript
orchestrate("生成抖音视频，介绍ChatGPT使用技巧")
```

**执行流程**:
1. Main Agent 分析任务
2. research-agent 收集资料
3. content-agent 生成文案
4. visual-agent 生成图片（必需）
5. video-agent 生成视频
6. quality-agent 质量审核
7. 整合结果返回

---

**更新时间**: 2026-03-02 11:15 UTC
**状态**: Agent 矩阵已完成，可投入使用
