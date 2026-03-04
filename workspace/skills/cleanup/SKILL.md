# Cleanup Skill - 清理工具

## 描述

提供文件清理功能，支持基于规则的自动清理和手动清理。

## 功能

### 1. 扫描文件系统
识别可清理的文件，分类展示

### 2. 生成清理预览
显示将要删除的文件列表，支持干跑（dry-run）

### 3. 执行清理操作
安全删除文件，支持白名单保护

### 4. 生成清理报告
统计清理结果，生成详细报告

## 使用方式

### 作为 Skill 调用

```bash
# 扫描文件系统
cleanup scan

# 生成清理预览（干跑）
cleanup preview

# 执行清理
cleanup clean

# 生成报告
cleanup report
```

### 作为脚本调用

```bash
# 扫描
./scripts/cleanup.sh scan

# 清理
./scripts/cleanup.sh clean
```

## 清理规则

### A 类：自动清理
- **临时文件**: *.tmp, *.temp, temp-*.json
  - 位置: agents/*/data/
  - 规则: 删除超过 1 天的文件

- **浏览器日志**: *.log
  - 位置: browser/*/user-data/*/
  - 规则: 删除超过 7 天的文件

- **Agent 数据**: *.md
  - 位置: agents/research-agent/data/
  - 规则: 删除超过 7 天的报告

- **会话历史**: 所有文件
  - 位置: agents/*/sessions/
  - 规则: 删除超过 30 天的会话

### B 类：确认清理
- **备份文件**: *.tar.gz
  - 位置: agents/.backup/, workspace/skills/.backup/
  - 规则: 保留最近 3 个，删除更早的

- **废弃 Skills**: 整个目录
  - 位置: workspace/skills/requirement-analyzer
  - 位置: workspace/skills/content-planner
  - 位置: workspace/skills/quality-reviewer
  - 规则: 删除整个目录（已迁移到 Agents）

- **过时文档**: *.md
  - 位置: workspace/docs/
  - 规则: 保留核心文档，删除过时的项目文档

## 白名单（永不删除）

### 用户数据
- workspace/MEMORY.md
- workspace/IDENTITY.md
- workspace/USER.md
- workspace/SOUL.md

### Agent 核心
- agents/*/README.md
- agents/*/models.json
- agents/main/*

### Skill 定义
- workspace/skills/*/SKILL.md

### 扩展
- extensions/**/*（暂时全部保护）

### 核心文档
- workspace/docs/SKILL-CREATION-GUIDE.md
- workspace/docs/AGENT-MATRIX-REPLAN.md
- workspace/docs/ORCHESTRATION-EXAMPLES.md
- workspace/docs/AGENT-REACH-STUDY.md

## 输出格式

### 扫描结果

```json
{
  "scan_time": "2026-03-03T07:00:00Z",
  "categories": {
    "temp_files": {
      "count": 5,
      "total_size": "1.2M",
      "files": [
        "/home/node/.openclaw/agents/research-agent/data/temp-123.json",
        "/home/node/.openclaw/agents/research-agent/data/temp-456.json"
      ]
    },
    "browser_logs": {
      "count": 10,
      "total_size": "500K",
      "files": [...]
    }
  },
  "total_cleanup_potential": "50M"
}
```

### 清理报告

```json
{
  "cleanup_time": "2026-03-03T07:05:00Z",
  "summary": {
    "total_files_deleted": 25,
    "total_space_freed": "45M",
    "categories": {
      "temp_files": 5,
      "browser_logs": 10,
      "agent_data": 8,
      "backups": 2
    }
  },
  "details": {
    "deleted_files": [...],
    "protected_files": [...],
    "errors": []
  }
}
```

## 安全机制

### 1. 白名单保护
匹配白名单的文件永远不会被删除

### 2. 干跑模式
首次运行自动启用干跑模式，预览清理结果

### 3. 日志记录
所有删除操作记录到日志文件

### 4. 错误处理
删除失败时记录错误，继续处理其他文件

## 配置

配置文件位置: `scripts/config.sh`

```bash
# 清理根目录
CLEANUP_ROOT="/home/node/.openclaw"

# 白名单文件
WHITELIST_FILE="scripts/whitelist.txt"

# 日志目录
LOG_DIR="/home/node/.openclaw/agents/cleaner-agent/logs"

# 保留策略
KEEP_BACKUPS=3
KEEP_DAYS_TEMP=1
KEEP_DAYS_LOGS=7
KEEP_DAYS_SESSIONS=30
```

### C 类：临时进度文档
- **迁移进度**: *MIGRATION-*.md, *PROGRESS-*.md
- **位置**: workspace/
- **规则**: 删除所有临时进度文档（已完成任务）
