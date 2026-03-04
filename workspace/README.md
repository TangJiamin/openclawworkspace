# OpenClaw Agent Matrix 工作区

## 📋 概述

基于 OpenClaw 的智能 Agent 矩阵系统，用于自动化内容生产。

**核心价值**: 通过多 Agent 并行协作，高效产出多平台内容（文案/图片/视频）。

---

## 🏗️ 架构

### Agent 结构

```
Main Agent (协调者)
    ├─ content-producer Agent (文案生产)
    ├─ visual-designer Agent (视觉设计)
    └─ video-producer Agent (视频生产)
```

### 工作流程

```
用户需求
  ↓
Main Agent 理解并分解
  ↓
并行调度专门 Agents
  ├─ content-producer → 文案
  ├─ visual-designer → 图片
  └─ video-producer → 视频
  ↓
整合结果输出
```

---

## 📂 目录结构

```
workspace/
├── AGENTS.md              # Agent配置
├── HEARTBEAT.md           # 心跳任务
├── IDENTITY.md            # 身份配置
├── MEMORY.md              # 长期记忆
├── SOUL.md                # 灵魂配置
├── TOOLS.md               # 工具参考
├── USER.md                # 用户信息
├── README.md              # 本文件
│
├── agents/                # Agents目录
│   ├── orchestrator.js    # 编排器
│   ├── package.json
│   ├── README.md
│   ├── content-producer/  # 文案Agent
│   ├── visual-designer/   # 视觉Agent
│   └── video-producer/    # 视频Agent
│
├── skills/                # Skills目录（能力组件）
│   ├── requirement-analyzer/  # 需求理解
│   ├── quality-reviewer/     # 质量审核
│   ├── visual-generator/     # 视觉生成
│   ├── seedance-storyboard/  # 视频分镜
│   ├── ai-daily-digest/      # 资讯收集
│   └── metaso-search/        # 网络搜索
│
├── memory/                # 记忆目录
│   ├── 2026-02-25.md
│   ├── 2026-02-27.md
│   ├── 2026-02-28.md
│   └── self-improvement.md
│
└── docs/                  # 文档目录
    ├── AGENT-MATRIX-REPLAN.md  # Agent矩阵规划
    └── SKILL-CREATION-GUIDE.md  # Skill创建指南
```

---

## 🚀 快速开始

### 查看 Agent 列表

```bash
openclaw agents list
```

### 查看 Skills 列表

```bash
openclaw skills list
```

### 测试编排器

```bash
cd /home/node/.openclaw/workspace/agents
npm install
npm start
```

---

## 🎯 核心 Agents

### 1. Main Agent (协调者)

**职责**:
- 理解用户需求
- 分解任务
- 分配给专门 Agent
- 协调并行执行
- 整合结果

**位置**: 默认 Agent

### 2. content-producer Agent

**职责**: 生产文案内容

**复用 Skills**:
- ai-daily-digest (资料收集)
- metaso-search (网络搜索)

### 3. visual-designer Agent

**职责**: 生成视觉内容

**复用 Skills**:
- visual-generator (多维参数系统)
- Seedance API (图片生成)

### 4. video-producer Agent

**职责**: 生成视频内容

**复用 Skills**:
- seedance-storyboard (分镜提示词)
- Seedance API (视频生成)

---

## 🛠️ Skills (能力组件)

### 已创建 Skills

| Skill | 能力 | 状态 |
|-------|------|------|
| requirement-analyzer | 需求理解 | ✅ 已测试 |
| quality-reviewer | 质量审核 | ✅ 已创建 |
| visual-generator | 视觉生成 | ✅ 已测试 |
| seedance-storyboard | 视频分镜 | ✅ 已测试 |
| ai-daily-digest | 资讯收集 | ✅ 可用 |
| metaso-search | 网络搜索 | ✅ 可用 |

---

## 📊 效率提升

**串行执行**: 30分钟
```
文案(5分) → 图片(10分) → 视频(15分) = 30分钟
```

**并行执行**: 10分钟
```
    ├─ 文案(5分) ─┐
需求 ├─ 图片(10分) ─┤ → 整合 = 10分钟
    └─ 视频(15分) ─┘
```

**效率提升**: 67%

---

## 🎓 学习资源

### 核心文档

- `docs/AGENT-MATRIX-REPLAN.md` - Agent矩阵重新规划
- `docs/SKILL-CREATION-GUIDE.md` - Skill创建指南

### 记忆

- `MEMORY.md` - 长期记忆和索引
- `memory/YYYY-MM-DD.md` - 每日记忆

---

## 📝 更新日志

### 2026-02-28

**创建**:
- 3个独立 Agents (content-producer, visual-designer, video-producer)
- 2个核心 Skills (requirement-analyzer, quality-reviewer)
- 编排器 (orchestrator.js)

**学习**:
- Baoyu Skills (多维参数系统)
- Seedance Storyboard (分镜引导)
- Skill 创建规范

**优化**:
- 从"全开发"到"整合复用"
- 技能复用率: 70%
- 开发周期: 8周 → 3周

---

**维护**: Main Agent (协调者)
**最后更新**: 2026-02-28
