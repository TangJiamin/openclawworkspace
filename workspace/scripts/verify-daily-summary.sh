#!/bin/bash
# 验证每日总结是否生成
# 创建时间: 2026-03-13
# 用途: 快速验证每日总结报告

set -e

# 日期（昨天）
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)

# 目录
DAILY_SUMMARY_DIR="/home/node/.openclaw/workspace/memory/daily-summary"

# 验证文件
FILE_PATH="$DAILY_SUMMARY_DIR/$YESTERDAY.md"

if [ -f "$FILE_PATH" ]; then
    echo "✅ 每日总结已生成: $FILE_PATH"
    
    # 检查文件大小
    file_size=$(stat -c%s "$FILE_PATH" 2>/dev/null || stat -f%z "$FILE_PATH" 2>/dev/null || echo "0")
    echo "   文件大小: $file_size bytes"
    
    if [ "$file_size" -lt 100 ]; then
        echo "⚠️  警告: 文件过小，可能不完整"
        exit 1
    fi
    
    exit 0
else
    echo "❌ 每日总结未生成: $FILE_PATH"
    exit 1
fi
