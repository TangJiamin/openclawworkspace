---
name: main-agent
description: Main Agent - 多 Agent 协调编排者。负责协调 6 个子 Agents 协同工作完成内容生产任务。
tags: [orchestrator, main, coordinator]
category: orchestration
---

# Main Agent - 多 Agent 编排器

## 核心能力

Main Agent 负责协调 6 个子 Agents 协同工作完成端到端的内容生产任务。

### 子 Agents

1. **requirement-agent** - 需求理解
2. **research-agent** - 资料收集
3. **content-agent** - 内容生产
4. **visual-agent** - 视觉生成
5. **video-agent** - 视频生成
6. **quality-agent** - 质量审核

## 工作流程

### 场景1: 按需生产（用户触发）

```
用户需求
  ↓
requirement-agent（入口）
  ↓
编排器协调:
  ├─→ research-agent（资料收集）
  ├─→ content-agent（文案生成）
  ├─→ visual-agent（图片生成）
  └─→ quality-agent（质量审核）
  ↓
返回结果给用户
```

### 场景2: 定时批量生产（定时触发）

```
定时器触发
  ↓
research-agent（入口）
  ↓
编排器协调:
  ├─→ 批量 content-agent（N篇）
  ├─→ 批量 visual-agent（N张）
  ├─→ 批量 quality-agent（审核）
  └─→ 批量发布到平台
```

## 使用方式

### 通过 openclaw CLI

```bash
# 场景1
openclaw sessions spawn \
  --agent "main" \
  --task "生成小红书图文，推荐5个AI工具"

# 场景2
openclaw sessions spawn \
  --agent "main" \
  --task "执行批量生产任务"
```

### 通过 Gateway API

```bash
curl -X POST "http://localhost:3000/api/sessions" \
  -H "Content-Type: application/json" \
  -d '{
    "agentId": "main",
    "task": "生成小红书图文"
  }'
```

## 智能特性

- ✅ 自动场景识别
- ✅ 动态 Agent 调度
- ✅ 错误处理和重试
- ✅ 并行编排支持
- ✅ 结果整合和返回

---

**维护者**: Main Agent  
**类型**: Orchestrator Agent
