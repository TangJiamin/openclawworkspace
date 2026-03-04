# Agent Workspace 核心文件说明

来源：https://docs.openclaw.ai/concepts/agent-workspace

---

## Agent Workspace 核心文件

每个 Agent 工作区应该包含以下核心文件：

### 必需的核心文件

1. **SOUL.md** ⭐
   - Agent 的灵魂文件
   - 定义 Agent 的个性、原则、行为模式
   - 每次会话时都会被读取
   - 继承自 Main Agent 的 SOUL.md（第一性原理思考）

2. **IDENTITY.md**
   - Agent 的身份定义
   - 包含：Name、Creature、Vibe、Emoji、Avatar
   - 让 Agent 有独特的个性

3. **USER.md**
   - 用户偏好和上下文
   - 帮助 Agent 理解用户
   - 个性化的交互方式

4. **HEARTBEAT.md**
   - 心跳任务配置
   - 定期维护任务
   - 记忆系统维护

5. **AGENTS.md**
   - Agent 矩阵文档
   - 其他 Agents 的说明
   - 协作流程

6. **TOOLS.md**
   - 工具使用指南
   - 可用工具列表
   - 使用示例

7. **README.md**
   - Agent 说明文档
   - 核心能力
   - 工作流程

### 可选文件

8. **MEMORY.md**
   - 长期记忆
   - 压缩的智慧和模式
   - 关键决策历史

9. **config.json**
   - Agent 配置
   - 模型设置
   - 工具配置

10. **models.json**
    - 模型配置
    - LLM 设置
    - Image Model 设置

---

## 标准 Agent 工作区结构

```
~/.openclaw/agents/<agent-name>/
├── SOUL.md              # Agent 灵魂（必需）
├── IDENTITY.md          # Agent 身份（可选）
├── USER.md              # 用户偏好（可选）
├── HEARTBEAT.md         # 心跳配置（可选）
├── AGENTS.md            # Agent 矩阵（可选）
├── TOOLS.md             # 工具指南（可选）
├── README.md            # Agent 说明（必需）
├── MEMORY.md            # 长期记忆（可选）
├── config.json          # Agent 配置（可选）
├── models.json          # 模型配置（可选）
├── scripts/             # 脚本目录
├── sessions/            # 会话历史
└── workspace/           # 工作区
    ├── SOUL.md          # 工作区灵魂
    ├── AGENTS.md        # 其他 Agents
    └── TOOLS.md         # 可用工具
```

---

## 核心原则

所有 Agents 都应该：

1. **继承 Main Agent 的核心原则**
   - 第一性原理思考（SOUL.md）
   - 长期主义（MEMORY.md）
   - Skill/Heartbeat 优先

2. **保持一致性**
   - 相同的核心文件结构
   - 相同的原则和价值观
   - 统一的行为模式

3. **独立的个性**
   - SOUL.md 可以有独特的个性
   - IDENTITY.md 定义独特身份
   - 但必须遵循核心原则

---

## 当前状态检查

### 问题：子 Agents 缺少核心文件

当前子 Agents 只有：
- ✅ README.md（基础说明）
- ✅ workspace/AGENTS.md
- ✅ workspace/TOOLS.md
- ✅ workspace/config.json
- ❌ SOUL.md（缺失！）
- ❌ IDENTITY.md（缺失！）
- ❌ USER.md（缺失！）
- ❌ HEARTBEAT.md（缺失！）

### 解决方案

为每个子 Agent 创建缺失的核心文件，并确保：
1. SOUL.md 包含核心原则引用
2. IDENTITY.md 定义独特身份
3. 保持与 Main Agent 的一致性
