#!/bin/bash
# ClawHub Bypass - 批量安装（从文件）
# 使用: bash install-batch.sh <skills-list-file>

set -e

SKILLS_DIR="/home/node/.openclaw/workspace/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SINGLE="$SCRIPT_DIR/install-single.sh"

LIST_FILE="$1"

if [ -z "$LIST_FILE" ]; then
  echo "❌ 错误: 请提供技能列表文件"
  echo "使用: bash $0 <skills-list-file>"
  echo "示例: bash $0 /tmp/skills-list.txt"
  exit 1
fi

if [ ! -f "$LIST_FILE" ]; then
  echo "❌ 错误: 文件不存在: $LIST_FILE"
  exit 1
fi

echo "📦 批量安装技能（从文件）"
echo "文件: $LIST_FILE"
echo ""

# 读取技能列表
SKILLS=$(cat "$LIST_FILE" | grep -v "^#" | grep -v "^[[:space:]]*$" | tr '\n' ' ')
SKILL_COUNT=$(echo "$SKILLS" | wc -w)

if [ $SKILL_COUNT -eq 0 ]; then
  echo "❌ 错误: 文件中没有技能（空文件或只有注释）"
  exit 1
fi

echo "技能数量: $SKILL_COUNT"
echo "技能列表:"
for slug in $SKILLS; do
  echo "  - $slug"
done
echo ""
echo "----------------------------------------"
echo ""

# 调用多技能安装脚本
bash "$SCRIPT_DIR/install-multiple.sh" $SKILLS
