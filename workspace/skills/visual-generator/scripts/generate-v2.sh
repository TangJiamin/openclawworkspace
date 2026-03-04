#!/bin/bash
# visual-generator - 调用 agent-canvas-confirm 生成图片

set -e

CONTENT="$1"

# 参数验证
if [ -z "$CONTENT" ]; then
  echo "❌ 错误: 缺少内容参数"
  exit 1
fi

# 解析内容
TITLE=$(echo "$CONTENT" | jq -r '.title // "未命名"')
DESCRIPTION=$(echo "$CONTENT" | jq -r '.description // ""')
STYLE=$(echo "$CONTENT" | jq -r '.style // "fresh"')
LAYOUT=$(echo "$CONTENT" | jq -r '.layout // "balanced"')

echo "🎨 Visual Generator"
echo "📋 标题: $TITLE"
echo "🎨 风格: $STYLE"
echo "📐 布局: $LAYOUT"
echo ""

# 构建提示词
PROMPT="$TITLE。$DESCRIPTION"
PROMPT="${PROMPT}。风格：$STYLE。布局：$LAYOUT。"

echo "📝 提示词: ${PROMPT:0:100}..."
echo ""

# 调用 agent-canvas-confirm Skill ⭐
CANVAS_SKILL_DIR="/home/node/.openclaw/workspace/skills/agent-canvas-confirm"

if [ ! -d "$CANVAS_SKILL_DIR" ]; then
  echo "❌ agent-canvas-confirm Skill 未找到"
  exit 1
fi

if [ ! -f "$CANVAS_SKILL_DIR/scripts/canvas.sh" ]; then
  echo "❌ agent-canvas-confirm 脚本未找到"
  exit 1
fi

echo "📡 调用 agent-canvas-confirm Skill..."
echo ""

# 调用 canvas.sh
RESULT=$(bash "$CANVAS_SKILL_DIR/scripts/canvas.sh" << EOF
{
  "action": "generate",
  "type": "image",
  "prompt": "$PROMPT",
  "parameters": {
    "style": "$STYLE",
    "layout": "$LAYOUT"
  }
}
EOF
)

# 检查结果
SUCCESS=$(echo "$RESULT" | jq -r '.success // false')

if [ "$SUCCESS" != "true" ]; then
  echo "❌ 生成失败"
  echo "$RESULT" | jq '.'
  exit 1
fi

echo ""
echo "✅ 生成成功"
echo "$RESULT" | jq '.'
