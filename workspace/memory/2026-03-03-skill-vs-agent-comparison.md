# material-collector Skill vs research-agent 对比分析

## 🔴 问题发现

**功能完全一致**！两者都在做资料收集：
- 网络资讯收集
- 技术文档检索
- 飞书文档读取
- 时效性验证（2025-2026）
- 智能筛选（去重、评分、分类）

### 代码对比

#### material-collector Skill (225 行)

**核心功能**:
- 多渠道收集（网络、文档、飞书）
- 时效性验证（2025-2026 优先）
- 智能筛选（去重、评分 60分阈值）
- 结构化输出

#### research-agent (195 行)

**核心功能**:
- 多渠道收集（网络、文档、飞书）
- 时效性验证（2025-2026 优先）
- 智能筛选（去重、评分、过滤）
- 结构化输出

**相似度**: 95%+

### 关键区别

| 维度 | material-collector | research-agent |
|------|------------------|----------------|
| **类型** | Skill（脚本封装） | Agent（独立会话） |
| **复杂度** | 中 | 高 |
| **上下文** | 无独立上下文 | 独立上下文 + 记忆 |
| **执行方式** | 同步执行 | 异步可后台 |
| **超时控制** | 无 | 有（120秒）|

### 架构问题

**重复设计**:
- material-collector Skill = research-agent 的核心功能
- research-agent 应该**调用** material-collector Skill
- 但实际上 research-agent 自己实现了这些功能

## 📊 价值分析

### material-collector Skill 的价值

✅ **存在价值**:
1. 可以被其他 Agent 调用
2. 可以独立使用（直接执行脚本）
3. 可以被 Main Agent 直接调用

❌ **问题**:
1. 与 research-agent 功能重叠
2. research-agent 没有调用 material-collector
3. 存在冗余

### research-agent 的价值

✅ **存在价值**:
1. 独立上下文，可以维护状态
2. 可以并行执行多个收集任务
3. 可以在后台长时间运行

❌ **问题**:
1. 重复实现了 material-collector 的功能
2. 没有复用 material-collector Skill

## 💡 优化方案

### 方案 1: research-agent 调用 material-collector Skill（推荐）

**架构**:
```
research-agent (协调者)
  ↓ 调用
material-collector Skill (执行者)
  ↓ 使用
metaso-search Skill
feishu-doc Skill
```

**优势**:
- ✅ 消除重复代码
- ✅ material-collector 可复用
- ✅ research-agent 专注于协调和整合

### 方案 2: 删除 material-collector Skill（不推荐）

**架构**:
```
research-agent (独立实现所有功能)
  ↓ 直接使用
metaso-search Skill
feishu-doc Skill
```

**优势**:
- ✅ 简单直接

**劣势**:
- ❌ material-collector 无法被其他 Agent 调用
- ❌ 失去复用性

### 方案 3: material-collector 替换 research-agent（不可行）

**问题**:
- ❌ Skill 不能有独立上下文
- ❌ 无法处理复杂任务
- ❌ 不符合架构原则（复杂功能需要 Agent）

## 🎯 建议

**采用方案 1**: research-agent 调用 material-collector Skill

**实施**:
1. 修改 research-agent/AGENTS.md
2. 在工作流程中添加："调用 material-collector Skill"
3. 移除 research-agent 中重复的功能实现
4. 保留 material-collector Skill 的独立性

---

**分析时间**: 2026-03-03 02:11 UTC
**分析人**: Main Agent
