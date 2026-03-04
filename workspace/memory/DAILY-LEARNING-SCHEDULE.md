# 每日学习和总结 Cron 配置

## 🎯 核心原则

**先总结，后学习**：总结（自我反思）→ 识别能力进化方向 → 定向学习

## 时间安排

### 1. 每日总结 + 自我反思（晚上 21:00）
```yaml
schedule: "0 21 * * *"  # 每天 21:00
sessionTarget: "isolated"
payload: |
  执行每日总结和自我反思
  - 扫描今日记忆 (17:00-21:00)
  - 自我反思：识别可进化的能力和方向
  - 生成针对性学习计划
  - 保存到 memory/daily-summary/YYYY-MM-DD.md
delivery:
  mode: "announce"
  channel: "feishu"
```

**目的**: 自我反思，识别能力进化方向

### 2. 定向学习（晚上 21:30）
```yaml
schedule: "30 21 * * *"  # 每天 21:30
sessionTarget: "isolated"
payload: |
  执行定向学习（基于 21:00 的总结）
  - 读取每日总结中的学习计划
  - 识别需要加强的能力
  - 提取需要避免的错误
  - 针对性学习和实践
  - 记录学习成果
  - 保存到 memory/daily-learning/YYYY-MM-DD.md
delivery:
  mode: "announce"
  channel: "feishu"
```

**目的**: 基于总结的定向提升

### 3. 深度回顾（晚上 23:59）
```yaml
schedule: "59 23 * * *"  # 每天 23:59
sessionTarget: "isolated"
payload: |
  深度回顾今天
  - 总结完成情况
  - 学习完成情况
  - 评估整体表现
  - 规划明天重点
  - 更新明日目标
delivery:
  mode: "announce"
  channel: "feishu"
```

**目的**: 一天结束的深度反思和规划

## 工作流程

```
17:00 - 21:00 工作时间，记录到今日记忆
  ↓
21:00 - 每日总结 + 自我反思
  ↓
自我反思：识别可进化的能力
  ↓
生成针对性学习计划
  ↓
保存: memory/daily-summary/2026-03-04.md
  ↓
（30分钟准备时间）
  ↓
21:30 - 定向学习
  ↓
读取学习计划
  ↓
针对性学习和实践
  ↓
记录学习成果
  ↓
保存: memory/daily-learning/2026-03-04.md
  ↓
（2.5小时学习和实践）
  ↓
23:59 - 深度回顾
  ↓
评估总结完成情况
  ↓
评估学习完成情况
  ↓
规划明天重点
  ↓
更新明日目标
```

## 文件结构

```
memory/
├── YYYY-MM-DD.md           # 今日记忆（17:00-21:00 工作时间）
├── daily-summary/
│   └── YYYY-MM-DD.md       # 每日总结（21:00）+ 学习计划
└── daily-learning/
    └── YYYY-MM-DD.md       # 学习成果（21:30）+ 完成情况
```

## 优势

1. **闭环设计**: 反思 → 计划 → 学习 → 回顾
2. **连续性强**: 总结后 30 分钟立即学习
3. **针对性强**: 学习基于自我反思识别的方向
4. **时间合理**: 学习有 2.5 小时，充分消化
