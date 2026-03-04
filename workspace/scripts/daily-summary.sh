#!/bin/bash
# 每日总结脚本 - 在学习之前先总结今日工作

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# 获取今天的日期
TODAY=$(TZ='Asia/Shanghai' date +%Y-%m-%d)
MEMORY_FILE="/home/node/.openclaw/workspace/memory/$TODAY.md"

log_info "每日总结 - $TODAY"
echo ""

# 检查今天的记忆文件是否存在
if [ ! -f "$MEMORY_FILE" ]; then
  log_warn "今天的记忆文件不存在: $MEMORY_FILE"
  log_info "创建新的记忆文件..."
  touch "$MEMORY_FILE"
fi

# 提取今日关键决策
log_info "1. 提取今日关键决策..."
echo "## 🎯 今日关键决策" >> /tmp/daily_summary.md
grep -E "^##.*决策|^-\s+**.*决策|决定:|选择:" "$MEMORY_FILE" | head -10 >> /tmp/daily_summary.md 2>/dev/null || echo "无关键决策" >> /tmp/daily_summary.md
echo "" >> /tmp/daily_summary.md

# 提取今日学到的新能力
log_info "2. 提取今日学到的新能力..."
echo "## 📚 今日学到的新能力" >> /tmp/daily_summary.md
grep -E "学到|发现|新能力|新技能|技能.*可用" "$MEMORY_FILE" | head -10 >> /tmp/daily_summary.md 2>/dev/null || echo "无新能力记录" >> /tmp/daily_summary.md
echo "" >> /tmp/daily_summary.md

# 提取今日遇到的问题
log_info "3. 提取今日遇到的问题..."
echo "## ⚠️ 今日遇到的问题" >> /tmp/daily_summary.md
grep -E "问题|错误|失败|挑战|困难" "$MEMORY_FILE" | head -10 >> /tmp/daily_summary.md 2>/dev/null || echo "无问题记录" >> /tmp/daily_summary.md
echo "" >> /tmp/daily_summary.md

# 提取今日的改进
log_info "4. 提取今日的改进..."
echo "## ✅ 今日的改进" >> /tmp/daily_summary.md
grep -E "修复|优化|改进|更新|创建" "$MEMORY_FILE" | head -10 >> /tmp/daily_summary.md 2>/dev/null || echo "无改进记录" >> /tmp/daily_summary.md
echo "" >> /tmp/daily_summary.md

# 生成学习方向建议
log_info "5. 生成学习方向建议..."
echo "## 🎯 明日学习方向建议" >> /tmp/daily_summary.md

# 基于今日问题生成学习方向
if grep -q "架构" "$MEMORY_FILE"; then
  echo "- 深入学习 Agent 架构设计" >> /tmp/daily_summary.md
fi

if grep -q "技能" "$MEMORY_FILE"; then
  echo "- 研究 Workspace Skills 的最佳实践" >> /tmp/daily_summary.md
fi

if grep -q "错误" "$MEMORY_FILE"; then
  echo "- 总结错误模式，避免重复" >> /tmp/daily_summary.md
fi

if grep -q "复用" "$MEMORY_FILE"; then
  echo "- 学习如何提高代码和技能复用率" >> /tmp/daily_summary.md
fi

echo "" >> /tmp/daily_summary.md

# 输出总结
cat /tmp/daily_summary.md

# 保存总结
SUMMARY_FILE="/home/node/.openclaw/workspace/memory/daily-summary/${TODAY}-summary.md"
mkdir -p "$(dirname "$SUMMARY_FILE")"
cp /tmp/daily_summary.md "$SUMMARY_FILE"

log_info "每日总结已保存: $SUMMARY_FILE"
echo ""

# 输出学习建议
log_info "💡 基于总结，明日学习建议："
cat /tmp/daily_summary.md | grep -A 10 "明日学习方向建议"

echo ""
log_info "每日总结完成！"
