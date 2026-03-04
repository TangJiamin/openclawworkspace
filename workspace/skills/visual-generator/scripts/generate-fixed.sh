#!/bin/bash
# visual-generator - 修复版（正确调用 agent-canvas-confirm）

set -e

CONTENT="$1"
MODE="${2:-auto}"

echo "🎨 Visual Generator - 双模式生成"
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
  # 自动选择
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

RESULT=""

if [ "$USE_MODE" = "seedance" ]; then
  # 方式1: Seedance API
  echo "📡 调用 Seedance API..."
  echo ""
  
  # TODO: 实现 Seedance API 调用
  RESULT=$(jq -n \
    --arg mode "seedance" \
    '{success: false, error: "Seedance API not implemented yet", mode_used: $mode}')
  
elif [ "$USE_MODE" = "refly" ]; then
  # 方式2: Refly Canvas（调用 agent-canvas-confirm）
  echo "📡 调用 agent-canvas-confirm Skill（Refly Canvas）..."
  echo ""
  
  CANVAS_SKILL_DIR="/home/node/.openclaw/workspace/skills/agent-canvas-confirm"
  
  if [ ! -d "$CANVAS_SKILL_DIR" ]; then
    echo "❌ agent-canvas-confirm Skill 未找到"
    RESULT=$(jq -n '{success: false, error: "agent-canvas-confirm skill not found"}')
  elif [ ! -f "$CANVAS_SKILL_DIR/scripts/canvas.sh" ]; then
    echo "❌ agent-canvas-confirm 脚本未找到"
    RESULT=$(jq -n '{success: false, error: "canvas.sh script not found"}')
  else
    # 正确调用方式：通过 stdin 传递 JSON
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
    
    echo "📤 发送请求到 agent-canvas-confirm..."
    echo "$CANVAS_REQUEST" | jq -c '.'
    echo ""
    
    # 调用 canvas.sh
    RESULT=$(echo "$CANVAS_REQUEST" | bash "$CANVAS_SKILL_DIR/scripts/canvas.sh" 2>&1)
    
    echo "📥 收到响应"
  fi
  
else
  echo "❌ 未知模式: $USE_MODE"
  RESULT=$(jq -n --arg mode "$USE_MODE" '{success: false, error: "Unknown mode", mode_used: $mode}')
fi

echo ""

# ==================== 结果处理 ====================

echo "📊 处理结果..."
echo ""

# 检查是否是 JSON
if ! echo "$RESULT" | jq -e '.' > /dev/null 2>&1; then
  echo "⚠️  结果不是有效的 JSON，可能包含错误信息"
  echo "原始输出:"
  echo "$RESULT" | head -20
  echo ""
  
  # 创建错误结果
  RESULT=$(jq -n \
    --arg mode "$USE_MODE" \
    --arg output "$RESULT" \
    '{success: false, error: "Invalid JSON output", mode_used: $mode, raw_output: $output}')
fi

# 检查成功标志
SUCCESS=$(echo "$RESULT" | jq -r '.success // false')

if [ "$SUCCESS" != "true" ]; then
  echo "❌ 生成失败"
  echo "$RESULT" | jq '.'
  exit 1
fi

# 添加模式信息
RESULT=$(echo "$RESULT" | jq --arg mode "$USE_MODE" '. + {mode_used: $mode}')

echo "✅ 生成成功（模式: $USE_MODE）"
echo ""
echo "📄 结果:"
echo "$RESULT" | jq '.'
echo ""
