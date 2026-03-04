#!/bin/bash
# Cleaner Agent 主脚本

set -e

AGENT_DIR="/home/node/.openclaw/agents/cleaner-agent"
CLEANUP_SKILL_DIR="/home/node/.openclaw/workspace/skills/cleanup"
REPORT_DIR="$AGENT_DIR/reports"
REPORT_FILE="$REPORT_DIR/cleanup-report-$(date +%Y%m%d).md"

# 创建必要目录
mkdir -p "$REPORT_DIR"

echo "🧹 Cleaner Agent 启动"
echo "===================="
echo ""

# 1. 扫描文件系统
echo "1️⃣ 扫描文件系统..."
bash "$CLEANUP_SKILL_DIR/scripts/cleanup-simple.sh" > /tmp/cleanup-scan.txt 2>&1
cat /tmp/cleanup-scan.txt

# 2. 读取扫描结果
SCAN_RESULT=$(cat /tmp/cleanup-scan.txt)

# 3. 发送飞书通知
echo ""
echo "2️⃣ 发送飞书通知..."

# 提取关键信息
TEMP_FILES=$(echo "$SCAN_RESULT" | grep -A 100 "## 1️⃣ 临时文件" | grep -B 100 "## 2️⃣" | grep "^-" | wc -l)
BROWSER_LOGS=$(echo "$SCAN_RESULT" | grep -A 100 "## 2️⃣ 浏览器日志" | grep -B 100 "## 3️⃣" | grep "^-" | wc -l)
BACKUPS=$(echo "$SCAN_RESULT" | grep -A 100 "## 3️⃣ 备份文件" | grep -B 100 "## 4️⃣" | grep "^-" | wc -l)
DEPRECATED_SKILLS=$(echo "$SCAN_RESULT" | grep -A 100 "## 4️⃣ 废弃的 Skills" | grep -B 100 "## 5️⃣" | grep "^-" | wc -l)
OUTDATED_DOCS=$(echo "$SCAN_RESULT" | grep -A 100 "## 5️⃣ 过时的文档" | grep -B 100 "✅" | grep "^-" | wc -l)

# 生成通知消息
NOTIFICATION="🧹 **清理扫描报告**

📅 时间: $(date -u +'%Y-%m-%d %H:%M:%S UTC')

📊 扫描结果:
- 📁 临时文件: $TEMP_FILES 个
- 🌐 浏览器日志: $BROWSER_LOGS 个
- 💾 备份文件: $BACKUPS 个
- 🗑️  废弃 Skills: $DEPRECATED_SKILLS 个
- 📄 过时文档: $OUTDATED_DOCS 个

✅ 扫描完成！确认后将自动执行清理。

📄 详细报告: \`$REPORT_FILE\`"

# 这里应该调用 message 工具发送飞书通知
# 但由于我们在 Agent 中，不能直接调用
# 所以输出到 stdout，让主 Agent 处理
echo ""
echo "📬 通知内容:"
echo "$NOTIFICATION"

# 4. 执行清理
echo ""
echo "3️⃣ 执行清理..."
bash "$CLEANUP_SKILL_DIR/scripts/cleanup-exec.sh"

echo ""
echo "✅ Cleaner Agent 完成！"
