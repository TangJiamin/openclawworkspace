#!/bin/bash
# ClawHub Bypass - 安装多个技能
# 使用: bash install-multiple.sh skill1 skill2 skill3

set -e

SKILLS_DIR="/home/node/.openclaw/workspace/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SINGLE="$SCRIPT_DIR/install-single.sh"

if [ $# -eq 0 ]; then
  echo "❌ 错误: 请提供至少一个技能名称"
  echo "使用: bash $0 <skill1> <skill2> <skill3> ..."
  echo "示例: bash $0 tavily-search summarize find-skills"
  exit 1
fi

echo "📦 批量安装技能"
echo "技能数量: $#"
echo "技能列表:"
for slug in "$@"; do
  echo "  - $slug"
done
echo ""
echo "----------------------------------------"
echo ""

# 统计
SUCCESS=0
FAILED=0
TOTAL=$#

# 安装每个技能
for slug in "$@"; do
  echo "📦 [$((SUCCESS + FAILED + 1))/$TOTAL] 安装 $slug..."
  echo ""

  if bash "$INSTALL_SINGLE" "$slug"; then
    SUCCESS=$((SUCCESS + 1))
    echo "✅ $slug 安装成功"
  else
    FAILED=$((FAILED + 1))
    echo "❌ $slug 安装失败"
  fi

  echo ""
  echo "----------------------------------------"
  echo ""
done

# 总结
echo "📊 安装总结"
echo "成功: $SUCCESS/$TOTAL"
echo "失败: $FAILED/$TOTAL"
echo ""

if [ $FAILED -eq 0 ]; then
  echo "🎉 所有技能安装成功！"
  exit 0
else
  echo "⚠️  部分技能安装失败"
  exit 1
fi
