# 基于内容的智能清理

## 核心原则

**通过内容判断，而非文件名** - 识别临时文档和进度报告

## 识别特征

### 临时文档特征

1. **文件名特征**（次要）:
   - `*PROGRESS*.md` - 进度报告
   - `*REPORT*.md` - 各类报告
   - `*CLEANUP*.md` - 清理报告
   - `*MIGRATION*.md` - 迁移进度
   - `*OPTIMIZATION*.md` - 优化报告
   - `*SETUP*.md` - 设置文档
   - `*FINAL*.md` - 最终确认
   - `*CHECKLIST*.md` - 检查清单
   - `*STATUS*.md` - 状态文档
   - `*USABILITY*.md` - 可用性报告

2. **内容特征**（主要）:
   - 包含"进度报告"、"更新时间"、"待处理"
   - 包含任务状态符号（✅ ❌ ⏳）
   - 包含"已完成"、"待处理"、"迁移"
   - 包含时间戳和里程碑标记

3. **位置特征**:
   - `workspace/` 根目录的临时文档
   - `workspace/agents/` 目录中的设置文档
   - `workspace/skills/` 目录中的状态文档
   - `workspace/tools/` 目录中的报告文档

## 清理规则

### workspace 目录

**删除**:
- 所有匹配临时特征的文档（排除核心文档）
- 包括进度报告、设置文档、状态报告等

**保留**:
- `MEMORY.md` - 长期记忆
- `IDENTITY.md` - 用户身份
- `USER.md` - 用户信息
- `SOUL.md` - 核心原则
- `docs/` - 技术文档目录

### memory 目录

**删除**:
- 超过 3 天的历史记忆
- 已压缩到 MEMORY.md 的内容

**保留**:
- 最近 3 天的记忆
- 标记为"高重要性"的记忆

### agents 数据目录

**删除**:
- 超过 7 天的报告文档
- 临时数据文件（`raw-*.md`, `temp-*.json`）

**保留**:
- 最新的配置文件
- 重要的优化报告

## 实施方法

### 方法 1：基于文件名模式（快速）

```bash
find /home/node/.openclaw/workspace -type f -name "*.md" | \
  grep -E "(PROGRESS|REPORT|CLEANUP|MIGRATION|OPTIMIZATION|SETUP|FINAL|CHECKLIST|STATUS|USABILITY)" | \
  grep -vE "(MEMORY|IDENTITY|USER|SOUL|AGENT-MATRIX-REPLAN|SKILL-CREATION-GUIDE|ORCHESTRATION-EXAMPLES|AGENT-REACH-STUDY|docs/)"
```

### 方法 2：基于内容分析（智能）

```bash
# 检查文件内容
grep -l "进度报告\|更新时间\|待处理\|已完成" *.md

# 检查任务状态符号
grep -l "✅\|❌\|⏳" *.md

# 检查迁移相关
grep -l "迁移\|重构\|已删除\|已废弃" *.md
```

## 首次清理结果（2026-03-03 07:30）

### 删除的文件

**临时文档（16 个）**:
- AGENT-DIAGNOSTIC-REPORT.md
- AGENT-SETUP-REPORT.md
- agents/AGENT-CLEANUP-COMPLETE.md
- agents/AGENT-MATRIX-SETUP.md
- agents/CLEANUP-2026-03-02.md
- agents/FINAL-ARCHITECTURE.md
- agents/FINAL-CONFIRMATION.md
- cron/CRON-STATUS.md
- MIGRATION-TRACKER.md
- OPTIMIZATION-COMPLETE.md
- SKILL-CLEANUP-PLAN.md
- skills/SKILLS-STATUS.md
- skills/SKILLS-USABILITY-REPORT.md
- tools/DEPLOYMENT_REPORT.md
- tools/orchestrator/CHECKLIST.md
- tools/orchestrator/TEST-SUCCESS-REPORT.md

**历史记忆（1 个）**:
- memory/2026-02-25.md（>3天）

### 节省空间

约 50KB（文档较小，但数量多）

## 自动化集成

将基于内容的清理集成到 cleanup Skill 中：

```bash
# 添加到每日清理任务
bash /home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-smart-v2.sh
```

## 注意事项

1. **白名单保护**: 重要文档已通过白名单保护
2. **内容优先**: 文件名只是辅助，内容判断更准确
3. **安全删除**: 删除前生成报告，确认后再执行
4. **保留记录**: MEMORY.md 保留所有重要决策和模式

## 总结

通过基于内容的智能识别，我们成功清理了：
- ✅ 16 个临时进度文档
- ✅ 1 个历史记忆
- ✅ 保持工作区干净整洁

这种方法比单纯的文件名匹配更智能，更不容易误删重要文件。
