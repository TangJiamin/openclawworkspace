# Main Agent Tools

## 编排工具

### orchestrate

多 Agent 编排工具 - 协调 6 个子 Agents 协同工作完成内容生产任务。

**描述**: 通过智能编排，协调 requirement-agent, research-agent, content-agent, visual-agent, video-agent, quality-agent 协同工作。

**参数**:
- `userInput` (string, required): 用户需求描述

**返回**: 
- 格式化的生成结果，包含：
  - 任务规范
  - 收集的资料
  - 生成的内容
  - 质量审核报告

**使用示例**:

```
# 生成小红书图文
orchestrate("生成小红书内容，推荐5个提升效率的AI工具")

# 执行批量生产
orchestrate("执行批量生产任务")
```

**工作流程**:

```
用户需求
  ↓
场景识别
  ↓
┌─────────────────────┐
│ 场景1: 按需生产       │
│ requirement-agent    │
│   → research-agent  │
│   → content-agent   │
│   → visual-agent    │
│   → quality-agent   │
└─────────────────────┘
  ↓
┌─────────────────────┐
│ 场景2: 定时批量生产   │
│ research-agent      │
│   → content × N     │
│   → visual × N      │
│   → quality × N     │
└─────────────────────┘
  ↓
整合结果 → 返回用户
```

---

## 配置工具

### recognize_scenario

场景识别工具 - 自动识别用户需求属于哪个场景。

**参数**:
- `userInput` (string): 用户需求

**返回**:
- `scenario`: "scene1" 或 "scene2"

---

**维护者**: Main Agent  
**版本**: 1.0
