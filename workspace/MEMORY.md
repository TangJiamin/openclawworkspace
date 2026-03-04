# MEMORY.md

## 📋 快速索引

### 当前项目
- **Agent 矩阵** (2026-02-28 - ) - 多 Agent 并行协作系统
- **每日学习系统** (2026-03-04 - ) - 每日总结反思 + 定向学习

### 技术文档
- **Skill 创建指南** - `docs/SKILL-CREATION-GUIDE.md`
- **Agent 矩阵规划** - `docs/AGENT-MATRIX-REPLAN.md`
- **快速参考** - `TOOLS.md`

---

## 🎯 项目历程

### 每日学习系统项目 (2026-03-04 - )

**核心创新**: 先总结，后学习（而非学习 → 总结）

**时间安排**:
- 21:00: 每日总结 + 自我反思
- 21:30: 定向学习（基于总结）
- 23:59: 深度回顾

**工作流程**:
```
17:00-21:00: 工作时间 → 记录到记忆
  ↓
21:00: 每日总结 + 自我反思
  ↓
识别可进化的能力
  ↓
生成学习计划
  ↓
21:30: 定向学习（基于总结）
  ↓
针对性学习和实践
  ↓
23:59: 深度回顾
  ↓
评估完成情况，规划明天
```

**核心原则**: 总结（自我反思）→ 学习计划 → 定向学习 → 深度回顾

**创建的文件**:
- `workspace/skills/daily-summary/SKILL.md`: 每日总结 Skill 规范
- `workspace/skills/daily-summary/scripts/generate-v2.sh`: 智能分析脚本（v2.0）
- `workspace/memory/DAILY-LEARNING-SCHEDULE.md`: 完整时间设计文档

**智能分析脚本功能**:
- 自动扫描今日记忆
- 智能提取能力增长
- 自动识别错误和偏差
- 生成针对性学习计划
- 自动计算评分

---

### Agent 矩阵项目 (2026-02-28 - )

**架构**: 多 Agent 并行协作
```
Main Agent (协调者)
  ├─ content-producer Agent (文案)
  ├─ visual-designer Agent (视觉)
  └─ video-producer Agent (视频)
```

**核心 Agents**（智能体）:
- requirement-agent ✅ - 需求理解
- research-agent ✅ - 资料收集（24小时时效性 + AI热点筛选）
- content-agent ✅ - 内容生产
- visual-agent ✅ - 视觉生成
- video-agent ✅ - 视频生成
- quality-agent ✅ - 质量审核

**核心 Skills**（工具）:
- requirement-analyzer ✅ - 需求分析工具
- quality-reviewer ✅ - 质量审核工具
- visual-generator ✅ - 视觉生成工具（多维参数系统）
- seedance-storyboard ✅ - 视频分镜工具（对话引导）
- ai-daily-digest ✅ - 资讯收集工具（90个顶级技术博客）
- metaso-search ✅ - 网络搜索工具（时效性强化）
- daily-summary ✅ - 每日总结工具（智能分析）

### 学习的技能

1. **visual-generator** (来自 Baoyu Skills)
   - 核心思想: Style × Layout 二维系统
   - 9种风格 (cute, fresh, warm, bold, minimal...)
   - 6种布局 (sparse, balanced, dense, list, comparison, flow)

2. **seedance-storyboard** (来自 elementsix/elementsix-skills)
   - 核心思想: 对话引导分镜
   - 5个维度引导 (内容/风格/镜头/动作/声音)
   - 时间轴 + 镜头序列

3. **agent-reach** (Agent-to-Agent 通信)
   - 安装工具: `uv`
   - 支持: YouTube, Reddit, Bilibili, RSS, Web

### 技术规范

**Skill 创建** (2026-02-28):
- Workspace Skill: SKILL.md + scripts/ (简单工具)
- Extension Skill: package.json + src/handler.ts (复杂系统)

**关键转变**: 从"全开发"到"整合复用"，技能复用率 70%

---

---

## ⚠️ 历史项目归档 (2026-02-28)

### AI Media Pipeline 项目

**状态**: 已删除，干扰新思路

该项目曾规划 9 个 Agent 的智能体矩阵，后被删除以支持重新规划。

---

## 🎯 用户偏好和开发模式 (2026-03-02)

### ⚠️ 核心原则：长期主义（最高优先级）

**决策标准**: 长期可维护性 > 高复用率 > 质量保证 > 短期速度

**禁止**: 短期快速但低复用率的设计（如绕过 Agents 直接调用 API）

**必须**:
- 复用优先 - 使用现有 Agents 和 Skills
- 完整流程 - 遵循 Agent 矩阵工作流
- 质量第一 - 使用专业工具

---

### ⚠️ 关键要求：自然语言视频生成原则（最高优先级）

**核心原则**: 在进行自然语言视频生成任务时，**必须先根据自然语言描述生成图片，再根据图片和对视频内容的要求（自然语言）生成视频**。

**适用范围**: 无论采用技术路线1（Seedance API）还是技术路线2（Refly Canvas），都必须坚持这个原则。

**执行流程**:
1. Step 1: 根据自然语言描述生成图片（必需完成）
2. Step 2: 使用生成的图片作为输入，结合视频描述生成视频

**禁止**:
- ❌ 并行生成图片和视频
- ❌ 直接从文本生成视频而跳过图片步骤

---

### ⚠️ 关键要求：三层记忆机制

**用户明确要求**: 使用三层记忆机制管理记忆

1. **短期记忆**: Session context（系统提供）
2. **中期记忆**: `memory/YYYY-MM-DD.md` - 结构化日志（决策、偏好、解决方案）
3. **长期记忆**: `MEMORY.md` - 压缩的智慧和模式

**行为规则**: 当用户说"请记住..."时，必须立即存储到适当的记忆层

---

### ⚠️ 关键要求：系统功能实现原则（2026-03-04 15:53）

**优先使用 Skill 和 Heartbeat，避免创建独立脚本系统**

**核心原则**: 系统功能应该优先实现为 Skill 或使用 Heartbeat，而不是创建独立的脚本系统。

**正确方式**:
- ✅ 可复用功能 → 实现 为 Skill（`workspace/skills/xxx/SKILL.md`）
- ✅ 定期任务 → 使用 Heartbeat（配置 cron 任务）
- ❌ 独立脚本系统 → 仅在特殊情况下使用

**原因**:
1. 符合架构原则："通用工具用 Skill"
2. 更好的集成：与现有 Agent 系统无缝集成
3. 更简单的维护：统一的工作流程
4. 统一的调用方式：Agent 可以调用，Heartbeat 定期执行

**示例**:
- ❌ 错误：`/scripts/auto-update-agents.sh`（独立脚本）
- ✅ 正确：`/workspace/skills/capability-updater/SKILL.md`（Skill）

---

### 开发模式
**默认实现方式**: 创建 Skill

规则：
1. 除非有更好的实现方式（需说明理由）
2. 除非用户明确指定其他方式
3. **根据实际需求和规范创建**，不是套用模板

### Skill 创建原则
- **需求驱动**: 根据具体需求设计功能
- **遵循规范**: 按照 Skill 创建规范（见 SKILL-CREATION-GUIDE.md）
- **灵活适配**: 不套用固定模板，根据实际需要调整结构
- **配置优先**: 使用配置文件，方便后续修改和优化

**重要**: "创建 Skill" ≠ 套用模板，而是根据需求 + 遵循规范 + 灵活设计

---

## 🎯 Research Agent 规范 (2026-03-03)

### 核心原则

**三大核心原则**:
1. **时效性控制** ⏰ - 所有信息必须满足 24 小时时效性要求
2. **AI 领域聚焦** 🤖 - 重点筛选 AI 领域的高价值内容
3. **智能筛选** 🎯 - 评估、分析、筛选高关注度热点，而非简单罗列

### 评分系统

**综合评分** = 时效性(30%) + 热度(30%) + 价值(25%) + AI相关性(15%)

**筛选阈值**: 总分 ≥ 7.0

### 时效性要求

- ✅ **24小时内**: 标记为"最新资讯"或"今日热点"
- ⚠️ **超过24小时**: 标记为"背景资料"或"历史参考"
- ⚠️ **无时间信息**: 标注"时间未知"，优先级降低

### 质量标准

1. **时效性**: 90% 以上内容为 24 小时内
2. **相关性**: 95% 以上内容与 AI 相关
3. **价值密度**: 平均综合评分 ≥ 7.5
4. **覆盖面**: 至少 3 个 AI 子领域

### 相关文件

**Agent 位置**:
- Agent: `/home/node/.openclaw/agents/research-agent/`
- 规范: `/home/node/.openclaw/agents/research-agent/SKILL.md`
- 脚本: `/home/node/.openclaw/agents/research-agent/scripts/collect.sh`
- 数据: `/home/node/.openclaw/agents/research-agent/data/`

**使用的工具 Skills**:
- Metaso Search: `/home/node/.openclaw/workspace/skills/metaso-search/`
- AI Daily Digest: `/home/node/.openclaw/workspace/skills/ai-daily-digest/`

---

## Cleaner Agent - 自动清理系统 (2026-03-03)

### 职责

每天凌晨 3:00 自动清理 `.openclaw` 目录中的无用文件，保持容器干净整洁。

### 清理规则

**A 类：自动清理**
- 临时文件: *.tmp, *.temp, temp-*.json (>1天)
- 浏览器日志: browser/*/user-data/*/*.log (>7天)
- Agent 数据: agents/research-agent/data/*.md (>7天)
- 会话历史: agents/*/sessions/* (>30天)

**B 类：确认清理**
- 备份文件: 保留最近 3 个，删除更早的
- 废弃 Skills: requirement-analyzer, content-planner, quality-reviewer（已迁移）
- 过时文档: 删除 docs/ 中已完成的项目文档

**白名单（永不删除）**
- 用户数据: MEMORY.md, IDENTITY.md, USER.md, SOUL.md
- Agent 核心: README.md, models.json
- Skill 定义: SKILL.md
- 活跃扩展: feishu, dingtalk
- 所有 extensions/
- 核心文档: SKILL-CREATION-GUIDE.md, AGENT-MATRIX-REPLAN.md, ORCHESTRATION-EXAMPLES.md, AGENT-REACH-STUDY.md

### 文件结构

```
/home/node/.openclaw/agents/cleaner-agent/
├── README.md              # Agent 说明
├── USAGE.md               # 使用说明
├── agent/config.json      # Agent 配置
├── scripts/
│   ├── run.sh             # 主脚本
│   └── test.sh            # 测试脚本
├── logs/                  # 日志目录
└── reports/               # 报告目录

/home/node/.openclaw/workspace/skills/cleanup/
├── SKILL.md               # Skill 规范
└── scripts/
    ├── config.sh          # 配置文件
    ├── whitelist.sh       # 白名单
    ├── cleanup-simple.sh  # 扫描脚本
    └── cleanup-exec.sh    # 清理脚本
```

### 定时任务

```yaml
schedule: "0 3 * * *"  # 每天凌晨 3:00 UTC
payload: "执行每日清理任务"
delivery:
  mode: "announce"
  channel: "feishu"
```

### 使用方式

```bash
# 扫描文件系统
bash /home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-simple.sh

# 执行清理
bash /home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-exec.sh

# 查看报告
cat /home/node/.openclaw/agents/cleaner-agent/reports/cleanup-report-$(date +%Y%m%d).md
```

### 首次运行结果 (2026-03-03 07:19)

- ✅ 删除 6 个浏览器日志文件
- ✅ 删除 4 个过时文档
- ✅ 保留核心文档（4个）
- ✅ 保留所有 extensions（白名单）

### 维护者

Main Agent
