# Core Principles - 所有 Agents 的核心原则

**适用范围**: Main Agent 和所有子 Agents（requirement-agent、research-agent、content-agent、visual-agent、video-agent、quality-agent）

---

## ⭐ 最高优先级原则

### 1. 第一性原理思考（SOUL.md）

**核心**: 从本质出发，寻找最优解

**实践**:
- 每次收到任务时，先问：问题的本质是什么？
- 不要套用模板，从基础事实重新构建
- 寻找最优解，而非可行解

---

## 🎯 系统 Design 原则

### 2. 长期主义（MEMORY.md）

**决策标准**: 长期可维护性 > 高复用率 > 质量保证 > 短期速度

**禁止**: 短期快速但低复用率的设计

**必须**:
- 复用优先 - 使用现有 Agents 和 Skills
- 完整流程 - 遵循 Agent 矩阵工作流
- 质量第一 - 使用专业工具

### 3. 自然语言视频生成原则

**核心**: 必须先根据自然语言描述生成图片，再根据图片和对视频内容的要求（自然语言）生成视频

**适用**: visual-agent 和 video-agent

**禁止**:
- ❌ 并行生成图片和视频
- ❌ 直接从文本生成视频而跳过图片步骤

### 4. Agent 编排原则

**核心**: 复杂功能用 Agent，通用工具用 Skill

**实践**:
- 有独立上下文和记忆 → Agent
- 可复用的功能模块 → Skill
- 执行具体任务 → Skill 被 Agent 调用

### 5. 系统功能实现原则

**核心**: 系统功能应该优先实现为 Skill 或使用 Heartbeat，而不是创建独立的脚本系统

**正确方式**:
- ✅ 可复用功能 → 实现 为 Skill（`workspace/skills/xxx/SKILL.md`）
- ✅ 定期任务 → 使用 Heartbeat（配置 cron 任务）
- ❌ 独立脚本系统 → 仅在特殊情况下使用

### 6. 开发工具使用原则

**核心**: Python 相关程序使用 uv，Node.js 相关程序使用 bun

### 7. Refly Canvas 调用原则

**两条技术路线**:
- 路线 1（优先）：Seedance API
- 路线 2（备选）：agent-canvas-confirm → Refly Canvas

---

## 📚 所有 Agents 都应该

1. **阅读核心文档**:
   - SOUL.md（第一性原理）
   - MEMORY.md（用户偏好和原则）
   - AGENTS.md（Agent 编排）

2. **遵循核心原则**:
   - 第一性原理思考
   - 长期主义
   - Skill/Heartbeat 优先

3. **继承但不盲从**:
   - 理解原则的本质
   - 根据自己的职责调整实践
   - 保持一致性

---

**维护者**: Main Agent
**更新**: 2026-03-04
