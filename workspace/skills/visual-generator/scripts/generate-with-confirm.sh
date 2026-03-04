#!/bin/bash
# visual-generator - 正确使用 agent-canvas-confirm

set -e

CONTENT="$1"
MODE="${2:-auto}"

echo "🎨 Visual Generator - 使用 agent-canvas-confirm"
echo ""

# 解析内容
TITLE=$(echo "$CONTENT" | jq -r '.title // "未命名"')
DESCRIPTION=$(echo "$CONTENT" | jq -r '.description // ""')
STYLE=$(echo "$CONTENT" | jq -r '.style // "fresh"')
LAYOUT=$(echo "$CONTENT" | jq -r '.layout // "balanced"')

# 构建提示词
PROMPT="$TITLE。$DESCRIPTION"
PROMPT="${PROMPT}。风格：$STYLE。布局：$LAYOUT。"

echo "📋 标题: $TITLE"
echo "🎨 风格: $STYLE"
echo "📐 布局: $LAYOUT"
echo "📝 提示词: ${PROMPT:0:50}..."
echo ""

# ==================== 模式选择 ====================

USE_MODE="refly"  # 强制使用 refly 模式

echo "✅ 使用 Refly Canvas 模式"
echo ""

# ==================== 调用 agent-canvas-confirm Skill ⭐ ====================

echo "📡 调用 agent-canvas-confirm Skill..."
echo ""

CANVAS_SKILL_DIR="/home/node/.openclaw/workspace/skills/agent-canvas-confirm"

if [ ! -d "$CANVAS_SKILL_DIR" ]; then
  echo "❌ agent-canvas-confirm Skill 未找到"
  exit 1
fi

if [ ! -f "$CANVAS_SKILL_DIR/scripts/canvas.sh" ]; then
  echo "❌ agent-canvas-confirm 脚本未找到"
  exit 1
fi

# 构建请求 JSON
CANVAS_REQUEST=$(jq -n \
  --arg action "generate" \
  --arg type "image" \
  --arg prompt "$PROMPT" \
  --arg style "$STYLE" \
  --arg layout "$LAYOUT" \
  '{
    action: $action,
    type: $type,
    prompt: $prompt,
    parameters: {
      style: $style,
      layout: $layout
    }
  }')

echo "📤 发送请求:"
echo "$CANVAS_REQUEST" | jq -c '.'
echo ""

# ⭐ 调用 agent-canvas-confirm（通过 stdin 传递 JSON）
RESULT=$(echo "$CANVAS_REQUEST" | bash "$CANVAS_SKILL_DIR/scripts/canvas.sh" 2>&1)

echo "📥 收到响应（前100字符）:"
echo "${RESULT:0:100}"
echo ""

# 检查结果
if ! echo "$RESULT" | jq -e '.' > /dev/null 2>&1; then
  echo "⚠️  响应不是有效的 JSON"
  echo "完整响应:"
  echo "$RESULT"
  echo ""
  
  # 返回错误结果
  cat << EOF
{
  "success": false,
  "error": "Invalid JSON response from agent-canvas-confirm",
  "raw_response": $(echo "$RESULT" | jq -R -s '.')
}
EOF
  exit 1
fi

# 检查成功标志
SUCCESS=$(echo "$RESULT" | jq -r '.success // false')

if [ "$SUCCESS" != "true" ]; then
  echo "❌ agent-canvas-confirm 返回失败"
  echo "$RESULT" | jq '.'
  exit 1
fi

echo "✅ agent-canvas-confirm 执行成功"
echo ""

# 添加模式信息
RESULT=$(echo "$RESULT" | jq --arg mode "refly" '. + {mode_used: $mode, skill_used: "agent-canvas-confirm"}')

echo "📄 最终结果:"
echo "$RESULT" | jq '.'
echo ""
