# 系统架构原则

**更新时间**: 2026-03-04 15:53 UTC

---

## ⭐ 最高优先级原则

### 1. 第一性原理思考（SOUL.md）

**从本质出发，寻找最优解**

---

## 🎯 系统设计原则

### 2. 长期主义（MEMORY.md）

**决策标准**: 长期可维护性 > 高复用率 > 质量保证 > 短期速度

---

### 3. 自然语言视频生成原则（MEMORY.md）

**必须先根据自然语言描述生成图片，再根据图片和对视频内容的要求（自然语言）生成视频**

---

### 4. Agent 编排原则（AGENTS.md）

**复杂功能用 Agent，通用工具用 Skill**

---

### 5. 开发工具使用原则（memory/2026-03-04-dev-tools.md）

**Python 相关程序使用 uv，Node.js 相关程序使用 bun**

---

### 6. Refly Canvas 调用原则（visual-agent/video-agent）

**两条技术路线**：
- 路线 1（优先）：Seedance API
- 路线 2（备选）：agent-canvas-confirm → Refly Canvas
- agent-canvas-confirm 仅在没有 Seedance API 或用户指定 refly 时使用

---

### 7. 系统功能实现原则（NEW - 2026-03-04）

**优先使用 Skill 和 Heartbeat，避免创建独立脚本系统**

**说明**：
- ✅ 系统功能应该优先实现为 Skill（可复用工具）
- ✅ 定期任务应该使用 Heartbeat（cron 任务）
- ❌ 避免创建独立的脚本系统（除非有特殊原因）

**为什么**：
1. **符合架构原则**：Skill 是可复用工具，符合"通用工具用 Skill"
2. **更好的集成**：与现有 Agent 系统无缝集成
3. **更简单的维护**：不需要维护独立的脚本和调度
4. **统一的调用方式**：Agent 可以调用 Skill，Heartbeat 定期执行

**示例**：

**❌ 错误方式**：
```bash
# 创建独立的脚本系统
/scripts/auto-update-agents.sh
/scripts/monitor-system.sh
/scripts/backup-data.sh
```

**✅ 正确方式**：
```bash
# 实现为 Skill
/workspace/skills/capability-updater/SKILL.md
/workspace/skills/system-monitor/SKILL.md
/workspace/skills/data-backup/SKILL.md

# 定期任务使用 Heartbeat
# HEARTBEAT.md 中配置 cron 任务
```

**使用场景**：
- 自动更新检查 → Skill + Heartbeat
- 系统监控 → Skill + Heartbeat
- 数据备份 → Skill + Heartbeat
- 清理任务 → Skill + Heartbeat
- 通知提醒 → Skill + Heartbeat

**例外情况**：
- 一次性手动脚本可以放在 `scripts/` 目录
- 但如果是可复用功能，应该实现为 Skill

---

## 🔄 原则更新历史

### 2026-03-04 15:53 UTC
- **新增原则 #7**：系统功能实现原则
- **原因**：Agent 能力自动更新系统的设计讨论
- **决策**：优先使用 Skill 和 Heartbeat，避免独立脚本系统

---

**维护者**: Main Agent
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: 用户明确要求，必须遵守
