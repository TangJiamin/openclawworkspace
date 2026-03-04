#!/bin/bash
# 简化版智能内容识别清理

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_FILE="/home/node/.openclaw/agents/cleaner-agent/reports/cleanup-smart-$(date +%Y%m%d).md"

echo "# 🧠 智能内容识别清理报告" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "**扫描时间**: $(date -u +'%Y-%m-%d %H:%M:%S UTC')" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 临时文档特征
TEMP_PATTERNS=(
    "进度报告"
    "更新时间"
    "迁移进度"
    "已完成"
    "待处理"
    "AGENT-.*-REPORT"
    "CLEANUP-"
    "MIGRATION-"
    "OPTIMIZATION-"
    "SETUP-"
    "FINAL-"
    "CHECKLIST"
)

# 扫描 workspace 目录
echo "## 📂 workspace 目录中的临时文档" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 查找包含临时特征的文档
find /home/node/.openclaw/workspace -type f -name "*.md" | grep -E "(PROGRESS|REPORT|CLEANUP|MIGRATION|OPTIMIZATION|SETUP|FINAL|CHECKLIST|STATUS|USABILITY)" | while read file; do
    # 排除重要文档
    if echo "$file" | grep -qE "(MEMORY|IDENTITY|USER|SOUL|AGENT-MATRIX-REPLAN|SKILL-CREATION-GUIDE|ORCHESTRATION-EXAMPLES|AGENT-REACH-STUDY)"; then
        continue
    fi
    
    local size=$(du -h "$file" | cut -f1)
    echo "- 🗑️  \`$file\` ($size)" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"

# 扫描 memory 目录
echo "## 📂 memory 目录中的历史记录" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

find /home/node/.openclaw/workspace/memory -type f -name "*.md" -mtime +7 | while read file; do
    local filename=$(basename "$file")
    local size=$(du -h "$file" | cut -f1)
    local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
    echo "- 📋 \`$file\` ($size, ${file_age}天前) - 历史记忆" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"

# 扫描 agents 数据目录
echo "## 📂 agents 数据目录中的报告" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

find /home/node/.openclaw/agents -type f -path "*/data/*.md" | while read file; do
    local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
    local size=$(du -h "$file" | cut -f1)
    echo "- 📊 \`$file\` ($size, ${file_age}天前)" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"

# 统计
TEMP_COUNT=$(find /home/node/.openclaw/workspace -type f -name "*.md" | grep -E "(PROGRESS|REPORT|CLEANUP|MIGRATION|OPTIMIZATION|SETUP|FINAL|CHECKLIST|STATUS|USABILITY)" | wc -l)
MEMORY_COUNT=$(find /home/node/.openclaw/workspace/memory -type f -name "*.md" | wc -l)
DATA_COUNT=$(find /home/node/.openclaw/agents -type f -path "*/data/*.md" | wc -l)

echo "## 📊 统计" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "- 🗑️  临时文档: $TEMP_COUNT 个" >> "$REPORT_FILE"
echo "- 📋 历史记忆: $MEMORY_COUNT 个" >> "$REPORT_FILE"
echo "- 📊 数据报告: $DATA_COUNT 个" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "## 💡 清理建议" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "1. **临时文档**: 删除所有 workspace/ 中的临时进度文档" >> "$REPORT_FILE"
echo "2. **历史记忆**: 保留最近 3 天的记忆，删除更早的" >> "$REPORT_FILE"
echo "3. **数据报告**: 删除超过 7 天的报告" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "✅ 扫描完成！" >> "$REPORT_FILE"

cat "$REPORT_FILE"
