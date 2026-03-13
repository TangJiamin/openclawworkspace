#!/bin/bash
# Learning Integration Trigger
# 学习新技能后自动触发 Agent 优化

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"

echo "🧠 Learning Integration Trigger"
echo "==============================="
echo ""

# 检查是否刚刚学习了新技能
# 通过检查最近修改的 Skills 目录

LEARNING_TRIGGER_FILE="${WORKSPACE_DIR}/.last-learning"

# 检查是否有新的学习
check_new_learning() {
  local skills_dir="${WORKSPACE_DIR}/skills"
  
  # 检查最近 5 分钟内修改的 Skills
  local recent_skills=$(find "$skills_dir" -maxdepth 1 -type d -mmin -5 ! -name "skills" 2>/dev/null)
  
  if [[ -n "$recent_skills" ]]; then
    return 0
  else
    return 1
  fi
}

# 触发优化
trigger_optimization() {
  echo "🎯 检测到新学习的技能！"
  echo ""
  echo "📋 最近学习的 Skills:"
  find "${WORKSPACE_DIR}/skills" -maxdepth 1 -type d -mmin -5 ! -name "skills" -exec basename {} \; 2>/dev/null | while read skill; do
    echo "  - $skill"
  done
  echo ""
  
  echo "🚀 触发自动优化流程..."
  echo ""
  
  # 执行自动优化脚本
  if [[ -f "${SCRIPT_DIR}/auto-optimize.sh" ]]; then
    bash "${SCRIPT_DIR}/auto-optimize.sh"
  else
    echo "❌ 自动优化脚本不存在"
    return 1
  fi
}

# 主流程
main() {
  if check_new_learning; then
    trigger_optimization
  else
    echo "✅ 未检测到新学习的技能"
  fi
}

main
