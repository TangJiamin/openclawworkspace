# Cleaner Agent 使用说明

## 概述

Cleaner Agent 是一个自动清理系统，每天凌晨 3:00 自动清理 `.openclaw` 目录中的无用文件，保持容器干净整洁。

## 清理规则

### 自动清理（A 类）

1. **临时文件** - `*.tmp`, `*.temp`, `temp-*.json` (>1天)
2. **浏览器日志** - `browser/*/user-data/*/*.log` (>7天)
3. **Agent 数据** - `agents/research-agent/data/*.md` (>7天)
4. **会话历史** - `agents/*/sessions/*` (>30天)

### 确认清理（B 类）

5. **备份文件** - 保留最近 3 个，删除更早的
6. **废弃 Skills** - 删除 requirement-analyzer, content-planner, quality-reviewer
7. **过时文档** - 删除 docs/ 中已完成的项目文档

## 白名单（永不删除）

- 用户数据: MEMORY.md, IDENTITY.md, USER.md, SOUL.md
- Agent 核心: README.md, models.json
- Skill 定义: SKILL.md
- 活跃扩展: feishu, dingtalk
- 所有 extensions/
- 核心文档: SKILL-CREATION-GUIDE.md, AGENT-MATRIX-REPLAN.md, ORCHESTRATION-EXAMPLES.md, AGENT-REACH-STUDY.md

## 定时任务

- **执行时间**: 每天凌晨 3:00 UTC
- **通知方式**: 飞书 DM
- **超时时间**: 60 秒

## 手动执行

### 扫描文件系统

```bash
bash /home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-simple.sh
```

### 执行清理

```bash
bash /home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-exec.sh
```

### 运行完整流程

```bash
bash /home/node/.openclaw/agents/cleaner-agent/scripts/run.sh
```

## 查看报告

```bash
cat /home/node/.openclaw/agents/cleaner-agent/reports/cleanup-report-$(date +%Y%m%d).md
```

## Cron Job 管理

### 查看所有 Cron Jobs

```bash
openclaw cron list
```

### 查看清理任务详情

```bash
openclaw cron list | grep "每日清理任务"
```

### 手动触发清理任务

```bash
openclaw cron run <job-id>
```

### 禁用/启用清理任务

```bash
# 禁用
openclaw cron update <job-id> '{"enabled": false}'

# 启用
openclaw cron update <job-id> '{"enabled": true}'
```

### 删除清理任务

```bash
openclaw cron remove <job-id>
```

## 文件结构

```
/home/node/.openclaw/agents/cleaner-agent/
├── README.md              # Agent 说明
├── USAGE.md               # 使用说明（本文件）
├── agent/
│   └── config.json        # Agent 配置
├── scripts/
│   ├── run.sh             # 主脚本
│   └── test.sh            # 测试脚本
├── logs/                  # 日志目录
│   └── cleanup-*.log
└── reports/               # 报告目录
    └── cleanup-report-*.md

/home/node/.openclaw/workspace/skills/cleanup/
├── SKILL.md               # Skill 规范
└── scripts/
    ├── config.sh          # 配置文件
    ├── whitelist.sh       # 白名单
    ├── cleanup-simple.sh  # 简化版扫描脚本
    └── cleanup-exec.sh    # 清理执行脚本
```

## 测试

首次运行后，可以测试清理系统：

```bash
# 1. 扫描文件系统
bash /home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-simple.sh

# 2. 查看扫描报告
cat /home/node/.openclaw/agents/cleaner-agent/reports/cleanup-report-$(date +%Y%m%d).md

# 3. 确认无误后，执行清理
bash /home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-exec.sh
```

## 注意事项

1. **首次运行**: 建议先手动运行扫描，确认无误后再启用自动清理
2. **白名单保护**: 重要文件已在白名单中，不会被误删
3. **日志记录**: 所有清理操作都会记录到日志文件
4. **报告通知**: 每次清理后会生成报告并发送飞书通知
5. **备份恢复**: 删除前建议先备份重要数据（虽然已有白名单保护）

## 更新记录

- 2026-03-03: 创建 Cleaner Agent，配置每日凌晨 3:00 自动清理
- 2026-03-03: 首次运行，成功删除 6 个浏览器日志和 4 个过时文档
