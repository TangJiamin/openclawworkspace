#!/bin/bash
# Cleanup Configuration

# 清理根目录
CLEANUP_ROOT="/home/node/.openclaw"

# 日志目录
LOG_DIR="/home/node/.openclaw/agents/cleaner-agent/logs"
REPORT_DIR="/home/node/.openclaw/agents/cleaner-agent/reports"

# 保留策略
KEEP_BACKUPS=3
KEEP_DAYS_TEMP=1
KEEP_DAYS_LOGS=7
KEEP_DAYS_AGENT_DATA=7
KEEP_DAYS_SESSIONS=30

# 创建必要的目录
mkdir -p "$LOG_DIR"
mkdir -p "$REPORT_DIR"

# 当前时间戳
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
DATE_TODAY=$(date +"%Y%m%d")

# 日志文件
LOG_FILE="$LOG_DIR/cleanup-$TIMESTAMP.log"
REPORT_FILE="$REPORT_DIR/cleanup-report-$DATE_TODAY.md"
KEEP_DAYS_MEMORY=7
