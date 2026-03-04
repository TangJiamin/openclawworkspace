#!/bin/bash
# 清理执行脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

REPORT_FILE="$REPORT_DIR/cleanup-report-$(date +%Y%m%d).md"

echo "# 🧹 清理执行报告" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "**执行时间**: $(date -u +'%Y-%m-%d %H:%M:%S UTC')" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

DELETED_COUNT=0

# 1. 清理浏览器日志
echo "## 1️⃣ 清理浏览器日志" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
find /home/node/.openclaw/browser -type f -name "*.log" -mtime +7 2>/dev/null | while read file; do
    rm -f "$file"
    echo "- ✅ 删除: \`$file\`" >> "$REPORT_FILE"
    ((DELETED_COUNT++))
done
echo "" >> "$REPORT_FILE"

# 2. 清理备份文件（保留最近3个）
echo "## 2️⃣ 清理备份文件" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
find /home/node/.openclaw/agents/.backup -type f -name "*.tar.gz" 2>/dev/null | sort -r | tail -n +4 | while read file; do
    rm -f "$file"
    echo "- ✅ 删除: \`$file\`" >> "$REPORT_FILE"
    ((DELETED_COUNT++))
done
find /home/node/.openclaw/workspace/skills/.backup -type f -name "*.tar.gz" 2>/dev/null | sort -r | tail -n +4 | while read file; do
    rm -f "$file"
    echo "- ✅ 删除: \`$file\`" >> "$REPORT_FILE"
    ((DELETED_COUNT++))
done
echo "" >> "$REPORT_FILE"

# 3. 清理废弃的 Skills
echo "## 3️⃣ 清理废弃的 Skills" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
for skill in requirement-analyzer content-planner quality-reviewer; do
    skill_path="/home/node/.openclaw/workspace/skills/$skill"
    if [ -d "$skill_path" ]; then
        rm -rf "$skill_path"
        echo "- ✅ 删除: \`$skill_path\`" >> "$REPORT_FILE"
        ((DELETED_COUNT++))
    fi
done
echo "" >> "$REPORT_FILE"

# 4. 清理过时的文档
echo "## 4️⃣ 清理过时的文档" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
find /home/node/.openclaw/workspace/docs -type f -name "*.md" 2>/dev/null | while read file; do
    filename=$(basename "$file")
    case "$filename" in
        SKILL-CREATION-GUIDE.md|AGENT-MATRIX-REPLAN.md|ORCHESTRATION-EXAMPLES.md|AGENT-REACH-STUDY.md)
            # 保留这些文档
            ;;
        *)
            rm -f "$file"
            echo "- ✅ 删除: \`$file\`" >> "$REPORT_FILE"
            ((DELETED_COUNT++))
            ;;
    esac
done
echo "" >> "$REPORT_FILE"

echo "## 📊 清理总计" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "✅ 清理完成！共删除 $DELETED_COUNT 个文件/目录。" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

cat "$REPORT_FILE"
