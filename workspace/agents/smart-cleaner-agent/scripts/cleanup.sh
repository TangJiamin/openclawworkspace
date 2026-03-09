#!/bin/bash
# Smart Cleaner Agent - 清理脚本
# 基于内容理解的智能清理

set -e

# 配置
SCAN_LIMIT=1000
TIMEOUT_SECONDS=900
WORKSPACE="/home/node/.openclaw"
AGENT_DIR="$WORKSPACE/agents/smart-cleaner-agent"
REPORTS_DIR="$AGENT_DIR/reports"

# 创建报告目录
mkdir -p "$REPORTS_DIR"

# 白名单（绝对路径）
WHITELIST=(
  "$WORKSPACE/workspace/SOUL.md"
  "$WORKSPACE/workspace/IDENTITY.md"
  "$WORKSPACE/workspace/USER.md"
  "$WORKSPACE/workspace/MEMORY.md"
  "$WORKSPACE/workspace/AGENTS.md"
  "$WORKSPACE/workspace/TOOLS.md"
  "$WORKSPACE/workspace/README.md"
  "$WORKSPACE/workspace/HEARTBEAT.md"
)

# 检查文件是否在白名单
is_whitelisted() {
  local file_path="$1"
  for whitelist_path in "${WHITELIST[@]}"; do
    if [[ "$file_path" == "$whitelist_path" ]]; then
      return 0
    fi
  done
  # 检查子 Agents 工作区
  if [[ "$file_path" == "$WORKSPACE/workspace/agents/"* ]]; then
    local filename=$(basename "$file_path")
    if [[ "$filename" =~ ^(AGENTS|SOUL|IDENTITY|USER|TOOLS|README)\.md$ ]]; then
      return 0
    fi
  fi
  return 1
}

# 扫描文件
scan_files() {
  echo "🔍 扫描文件系统..."
  find "$WORKSPACE" -type f \\( -name "*.md" -o -name "*.json" -o -name "*.log" \\) ! -path "*/node_modules/*" ! -path "*/extensions/*" | head -n "$SCAN_LIMIT"
}

# 评估文件价值
assess_value() {
  local file_path="$1"
  local content="$2"

  # 高价值关键词
  local high_value_keywords="设计决策|架构|第一性原理|学习|核心原则"

  # 低价值关键词
  local low_value_keywords="临时|日志|安装|测试|debug"

  if echo "$content" | grep -qE "$high_value_keywords"; then
    echo "high"
  elif echo "$content" | grep -qE "$low_value_keywords"; then
    echo "low"
  else
    echo "medium"
  fi
}

# 评估文件时效
assess_freshness() {
  local file_path="$1"
  local mtime=$(stat -c %Y "$file_path" 2>/dev/null || echo "0")
  local now=$(date +%s)
  local age_days=$(( ($now - $mtime) / 86400 ))

  if [ $age_days -lt 1 ]; then
    echo "new"
  elif [ $age_days -lt 7 ]; then
    echo "recent"
  elif [ $age_days -lt 30 ]; then
    echo "medium"
  else
    echo "old"
  fi
}

# 主清理流程
main() {
  echo "🧹 Smart Cleaner Agent 开始清理..."
  echo "📊 扫描上限: $SCAN_LIMIT 个文件"
  echo "⏱️  超时时间: $TIMEOUT_SECONDS 秒"

  # 扫描文件
  files=$(scan_files)
  total_files=$(echo "$files" | wc -l)
  echo "✅ 找到 $total_files 个文件"

  # 分析文件
  echo "🔎 分析文件价值..."
  whitelisted=0
  candidates=()

  while IFS= read -r file; do
    # 检查白名单
    if is_whitelisted "$file"; then
      ((whitelisted++))
      continue
    fi

    # 读取内容（前 100 行）
    content=$(head -n 100 "$file" 2>/dev/null || echo "")

    # 评估价值
    value=$(assess_value "$file" "$content")
    freshness=$(assess_freshness "$file")

    # 候选删除条件：低价值 + 旧文件
    if [[ "$value" == "low" && "$freshness" == "old" ]]; then
      candidates+=("$file")
    fi
  done <<< "$files"

  # 生成报告
  echo "📋 生成清理报告..."
  report_file="$REPORTS_DIR/cleanup-report-$(date +%Y%m%d-%H%M%S).md"

  cat > "$report_file" << EOF
# 🧹 Smart Cleaner Agent 清理报告

**时间**: $(date)
**扫描文件**: $total_files 个
**白名单保护**: $whitelisted 个
**候选删除**: ${#candidates[@]} 个

---

## 🗑️ 候选删除列表

EOF

  for candidate in "${candidates[@]}"; do
    echo "- \`$candidate\`" >> "$report_file"
  done

  echo "" >> "$report_file"
  echo "## ⚠️ 确认删除？" >> "$report_file"
  echo "" >> "$report_file"
  echo "回复 **确认** 执行删除" >> "$report_file"
  echo "回复 **取消** 中止清理" >> "$report_file"

  echo "✅ 报告已生成: $report_file"

  # 发送飞书通知（通过 Main Agent）
  echo "📤 发送飞书报告..."
  # 这里需要通过 Main Agent 的 message 工具发送
  # 暂时只生成报告

  echo "🎉 清理任务完成！等待用户确认..."
}

# 执行
main "$@"
