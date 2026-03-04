#!/bin/bash
# visual-generator - 修复版（正确使用 agent-canvas-confirm）

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
echo ""

# ==================== 模式选择 ====================

USE_MODE=""

if [ "$MODE" = "auto" ]; then
  if [ -n "$SEEDANCE_API_KEY" ]; then
    USE_MODE="seedance"
    echo "✅ 使用 Seedance API 模式"
  else
    USE_MODE="refly"
    echo "⚠️  Seedance API Key 未配置，使用 Refly Canvas 模式"
  fi
else
  USE_MODE="$MODE"
  echo "✅ 使用指定模式: $MODE"
fi

echo ""

# ==================== 执行生成 ====================

if [ "$USE_MODE" = "seedance" ]; then
  # TODO: Seedance API
  echo "📡 Seedance API 未实现"
  exit 1
  
elif [ "$USE_MODE" = "refly" ]; then
  # ⭐ 正确做法：调用 agent-canvas-confirm Skill
  echo "📡 调用 agent-canvas-confirm Skill（Refly Canvas）..."
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
  
  echo "📤 发送请求到 agent-canvas-confirm:"
  echo "$CANVAS_REQUEST" | jq -c '.'
  echo ""
  
  # ⭐ 通过 stdin 调用 canvas.sh
  RESULT=$(echo "$CANVAS_REQUEST" | bash "$CANVAS_SKILL_DIR/scripts/canvas.sh" 2>&1)
  
  # 检查结果
  if ! echo "$RESULT" | jq -e '.' > /dev/null 2>&1; then
    echo "⚠️  agent-canvas-confirm 返回非 JSON 响应"
    echo "原始输出（前200字符）:"
    echo "${RESULT:0:200}"
    echo ""
    
    # 尝试提取关键信息
    if echo "$RESULT" | grep -q "executionId"; then
      EXEC_ID=$(echo "$RESULT" | grep -o 'executionId[^, }]*' | head -1 | cut -d'"' -f2)
      echo "✅ 提取到执行 ID: $EXEC_ID"
      
      RESULT=$(jq -n \
        --arg mode "refly" \
        --arg eid "$EXEC_ID" \
        '{success: true, mode_used: $mode, execution_id: $eid, note: "非JSON响应，已提取executionId"}')
    else
      echo "❌ 无法解析响应"
      RESULT=$(jq -n '{success: false, error: "Failed to parse response"}')
    fi
  fi
  
  # 检查成功标志
  SUCCESS=$(echo "$RESULT" | jq -r '.success // false')
  
  if [ "$SUCCESS" != "true" ]; then
    echo "❌ agent-canvas-confirm 返回失败"
    echo "$RESULT" | jq '.'
    exit 1
  fi
  
  # 添加模式信息
  RESULT=$(echo "$RESULT" | jq --arg mode "refly" '. + {mode_used: $mode, skill_used: "agent-canvas-confirm"}')
  
  echo "✅ agent-canvas-confirm 执行成功"
  echo ""
  
fi

# ==================== 返回结果 ====================

echo "📄 生成结果:"
echo "$RESULT" | jq '.'
echo ""

echo "✅ 完成"
echo ""
