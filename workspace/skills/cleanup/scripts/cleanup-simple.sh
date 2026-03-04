#!/bin/bash
# 简化版清理脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

REPORT_FILE="$REPORT_DIR/cleanup-report-$(date +%Y%m%d).md"

echo "# 📊 清理扫描报告" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "**扫描时间**: $(date -u +'%Y-%m-%d %H:%M:%S UTC')" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 1. 扫描临时文件
echo "## 1️⃣ 临时文件" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
find /home/node/.openclaw -type f \( -name "*.tmp" -o -name "*.temp" -o -name "temp-*.json" \) 2>/dev/null | while read file; do
    echo "- \`$file\`" >> "$REPORT_FILE"
done
echo "" >> "$REPORT_FILE"

# 2. 扫描浏览器日志
echo "## 2️⃣ 浏览器日志" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
find /home/node/.openclaw/browser -type f -name "*.log" 2>/dev/null | while read file; do
    echo "- \`$file\`" >> "$REPORT_FILE"
done
echo "" >> "$REPORT_FILE"

# 3. 扫描备份文件
echo "## 3️⃣ 备份文件" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
find /home/node/.openclaw/agents/.backup -type f -name "*.tar.gz" 2>/dev/null | sort -r | tail -n +4 | while read file; do
    echo "- \`$file\`" >> "$REPORT_FILE"
done
echo "" >> "$REPORT_FILE"

# 4. 扫描废弃的 Skills
echo "## 4️⃣ 废弃的 Skills" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
for skill in requirement-analyzer content-planner quality-reviewer; do
    skill_path="/home/node/.openclaw/workspace/skills/$skill"
    if [ -d "$skill_path" ]; then
        echo "- \`$skill_path\`" >> "$REPORT_FILE"
    fi
done
echo "" >> "$REPORT_FILE"

# 5. 扫描过时的文档
echo "## 5️⃣ 过时的文档" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
find /home/node/.openclaw/workspace/docs -type f -name "*.md" 2>/dev/null | while read file; do
    filename=$(basename "$file")
    case "$filename" in
        SKILL-CREATION-GUIDE.md|AGENT-MATRIX-REPLAN.md|ORCHESTRATION-EXAMPLES.md|AGENT-REACH-STUDY.md)
            # 保留这些文档
            ;;
        *)
            echo "- \`$file\`" >> "$REPORT_FILE"
            ;;
    esac
done
echo "" >> "$REPORT_FILE"

echo "✅ 扫描完成！" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "📄 报告已保存到: $REPORT_FILE" >> "$REPORT_FILE"

cat "$REPORT_FILE"
