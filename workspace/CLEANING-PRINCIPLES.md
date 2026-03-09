# 清理原则 (CLEANING-PRINCIPLES.md)

**创建时间**: 2026-03-05 01:31:00 UTC
**更新时间**: 2026-03-05 02:54:00 UTC
**维护者**: Main Agent
**执行者**: Main Agent
**状态**: 活跃 - 每日清理时持续更新

---

## 🎯 核心原则

### 架构说明

**执行者**: Main Agent（我）
**触发方式**: Cron 任务（每天 07:00 GMT+8）
**通知方式**: 飞书消息
**确认机制**: 删除前必须用户确认

---

### 铁律 #0: 白名单保护模式（最高优先级）

**开启白名单模式**：任何在白名单中的文件/目录，绝对不删除。

**白名单文件**：
```bash
# ===== Main Agent 核心文档 =====
SOUL.md
IDENTITY.md
USER.md
MEMORY.md
AGENTS.md
TOOLS.md
README.md
HEARTBEAT.md

# ===== 子 Agents 核心文档 =====
# 根据 OpenClaw 官方规范：
# workspace: Agent 的唯一工作目录，包含所有核心文档
# agentDir: 配置和运行时目录，包含 config, scripts, sessions

# 子 Agents 工作区（/home/node/.openclaw/workspace/agents/*/）
- AGENTS.md - 协作文档
- SOUL.md - 本质文档
- IDENTITY.md - 身份文档
- USER.md - 用户文档
- TOOLS.md - 工具参考
- README.md - 说明文档
- HEARTBEAT.md - Heartbeat 配置（如果有）
- config.json - 配置文件（在 workspace 也有）

# 子 Agents agentDir（/home/node/.openclaw/agents/*/）
- config.json - 配置文件（主配置）
- models.json - 模型配置
- README.md - 说明文档（可选）
- scripts/ - 脚本（如果有的话）
- sessions/ - 会话历史
- agent/ - 工作目录

**保护原则**: 只保护 workspace 中的核心文档，agentDir 的文件可重新生成

# ===== 技术文档 =====
docs/*.md

# ===== 记忆文档 =====
memory/YYYY-MM-DD.md

# ===== 设计历史 =====
archive/agents-history/
archive/architecture-history/
```

**白名单检查流程**：
```
1. 遇到文件
   ↓
2. 检查白名单
   ├─ 文件名匹配 → 绝对保护，跳过
   ├─ 路径匹配 → 绝对保护，跳过
   └─ 不匹配 ↓
3. 继续内容分析
```

---

### 铁律 #1: 我的核心文档绝对不删除

这些文档定义了我"是谁"、"如何工作"、"拥有什么记忆"，删除它们会破坏我的完整性。

#### 本质文档（我是谁）
- `/home/node/.openclaw/workspace/SOUL.md` - 我的本质和行为准则
- `/home/node/.openclaw/workspace/IDENTITY.md` - 我的身份信息
- `/home/node/.openclaw/workspace/USER.md` - 我的用户信息

#### 记忆文档（我的记忆）
- `/home/node/.openclaw/workspace/MEMORY.md` - 长期记忆和智慧
- `/home/node/.openclaw/workspace/memory/YYYY-MM-DD.md` - 日常记忆日志

#### 架构文档（如何工作）
- `/home/node/.openclaw/workspace/AGENTS.md` - Agent 矩阵
- `/home/node/.openclaw/workspace/TOOLS.md` - 工具参考
- `/home/node/.openclaw/workspace/README.md` - 工作区说明
- `/home/node/.openclaw/workspace/HEARTBEAT.md` - Heartbeat 配置

#### 技术文档（开发指南）
- `/home/node/.openclaw/workspace/docs/SKILL-CREATION-GUIDE.md`
- `/home/node/.openclaw/workspace/docs/AGENT-MATRIX-REPLAN.md`
- `/home/node/.openclaw/workspace/docs/ORCHESTRATION-EXAMPLES.md`
- `/home/node/.openclaw/workspace/docs/AGENT-REACH-STUDY.md`

#### 设计历史（重要架构决策）
- `/home/node/.openclaw/workspace/archive/agents-history/` (整个目录)
- `/home/node/.openclaw/workspace/archive/architecture-history/` (整个目录)

**删除以上任何文件 = 自我破坏，绝对禁止。**

---

## 🧠 智能决策原则

### 原则 #1: 内容理解优先

在删除任何文件前，必须：
1. **读取文件内容**（使用 read 工具）
2. **理解文件价值**（这个文件的用途是什么？）
3. **评估删除影响**（删除后会有什么后果？）
4. **征求用户意见**（如果不确定）

### 原则 #2: 价值分类

根据内容理解，将文件分为：

#### 💎 高价值（保留）
- 包含设计决策、架构思考
- 包含"为什么"、"原理"、"本质"等深度内容
- 记录了重要的经验和教训
- 未来可能需要参考

**示例**：
- Agent 矩阵设计文档
- Bug 修复的根本原因分析
- 架构调整的决策记录

#### 📦 中价值（短期保留）
- 包含具体实现细节
- 测试报告、调试记录
- 3-6 个月内可能有参考价值

**示例**：
- Bug 修复记录（短期）
- 测试报告
- 临时数据分析

#### 🗑️ 低价值（可删除）
- 纯粹的临时文件
- 已完成任务的进度记录
- 安装/配置日志
- 可以重新生成的文件
- **冗余的索引文件**（NEW）

**示例**：
- 临时日志文件（*.log）
- 临时数据文件（temp-*.json）
- 安装记录（*INSTALLATION*.md）
- 重复的备份文件
- **SYSTEM-PRINCIPLES.md, CORE-PRINCIPLES.md**（与 SOUL.md/MEMORY.md 重复）

### 原则 #2.5: 避免冗余索引文件 ⭐ NEW

**问题**: 创建"中心化原则"文件会导致内容重复和维护困难

**错误示例**：
- ❌ SYSTEM-PRINCIPLES.md - 冗余的原则索引
- ❌ CORE-PRINCIPLES.md - 重复的核心原则文件
- ❌ PRINCIPLES-INDEX.md - 原则的索引文件

**正确方式**：
- ✅ SOUL.md - "我是谁"（本质、行为准则）
- ✅ MEMORY.md - "我知道什么"（长期记忆）
- ✅ 单一数据源 - 每个信息只在一个地方

**判断标准**：
- 如果文件内容是"引用其他文档" → 索引文件，可删除
- 如果文件内容是"重复 SOUL.md/MEMORY.md" → 冗余文件，可删除
- 如果文件内容是"全新的原则" → 保留并合并到 SOUL.md 或 MEMORY.md

### 原则 #3: 时间因素

只有在明确判断为"低价值"后，才考虑时间：
- **低价值文件**: 创建 > 1 天 → 可删除
- **中价值文件**: 创建 > 90 天 → 重新评估
- **高价值文件**: 永不删除

### 原则 #4: 目录特殊性

某些目录有特殊规则：
- `archive/temp/` - 已标记为临时，90 天后删除
- `agents/*/sessions/` - 会话历史，30 天后删除
- `browser/*/user-data/` - 浏览器数据，90 天后删除
- `browser/*/user-data/*/*.log` - 浏览器日志，7 天后删除
- `agents/*/logs/` - 日志文件，7 天后删除
- `agents/research-agent/data/*.json` - 临时搜索数据，7 天后删除

---

## 📋 决策流程

```
1. 遇到文件
   ↓
2. 是否为核心文档？
   ├─ 是 → 绝对保留（铁律 #1）
   └─ 否 ↓
3. 读取文件内容
   ↓
4. 理解文件价值
   ├─ 高价值 → 保留
   ├─ 中价值 → 保留，标记时间
   └─ 低价值 ↓
5. 检查创建时间
   ├─ < 1 天 → 保留（太新）
   └─ > 1 天 ↓
6. 征求用户意见
   ├─ 同意 → 删除
   └─ 拒绝 → 保留，记录原因
```

---

## 🔄 持续改进

### 每次清理后更新这个文档

1. **记录新的发现**
   - 哪些文件类型有特殊价值？
   - 哪些规则需要调整？

2. **记录错误决策**
   - 删除了不该删除的？→ 恢复并调整规则
   - 保留了不该保留的？→ 记录原因，下次改进

3. **记录用户偏好**
   - 用户希望保留什么？
   - 用户认为什么是重要的？

---

## 📊 历史记录

### 2026-03-05 10:43 (第一次智能清理)
- ✅ 创建初始原则
- ✅ 确定核心文档列表
- ✅ 发现 SYSTEM-PRINCIPLES.md 冗余问题
- ✅ 识别 16 个可删除文件
- ✅ 新增原则 #2.5: 避免冗余索引文件
- ✅ 更新目录特殊性规则（浏览器日志、搜索数据）
- ⏰ 等待用户确认后执行清理

**关键发现**:
1. SYSTEM-PRINCIPLES.md 与 SOUL.md + MEMORY.md 重复
2. 旧 Cleaner Agent 文档需要清理
3. 浏览器日志超过 7 天未清理
4. Research Agent 临时数据需要定期清理

**清理候选**: 16 个文件（等待用户确认）

---

## 🎯 目标

建立一套**真正智能**的清理系统：
- ✅ 基于内容理解，而非机械规则
- ✅ 保护核心文档，绝对安全
- ✅ 持续学习，不断改进
- ✅ 像人一样思考，而非脚本执行
