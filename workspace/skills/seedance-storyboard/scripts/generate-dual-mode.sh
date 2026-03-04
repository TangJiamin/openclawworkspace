#!/bin/bash
# seedance-storyboard - 支持双模式生成

set -e

IMAGE_PATH="$1"
CONTENT="$2"
MODE="${3:-auto}"

echo "🎬 Seedance Storyboard - 双模式生成"
echo ""
echo "🖼️  图片: $IMAGE_PATH"
echo ""

# 参数验证
if [ -z "$IMAGE_PATH" ] || [ ! -f "$IMAGE_PATH" ]; then
  echo "❌ 错误: 图片文件不存在"
  exit 1
fi

# 解析内容
TITLE=$(echo "$CONTENT" | jq -r '.title // "未命名"')
DESCRIPTION=$(echo "$CONTENT" | jq -r '.description // ""')
STYLE=$(echo "$CONTENT" | jq -r '.style // "professional"')
DURATION=$(echo "$CONTENT" | jq -r '.duration // "30"')

# 构建提示词
PROMPT="$TITLE。$DESCRIPTION"
PROMPT="${PROMPT}。风格：$STYLE。时长：${DURATION}秒。"

# ==================== 模式选择 ====================

USE_MODE=""

if [ "$MODE" = "auto" ]; then
  # 自动选择
  
  # 检查 Seedance API Key
  if [ -n "$SEEDANCE_API_KEY" ]; then
    USE_MODE="seedance"
    echo "✅ 使用 Seedance API 模式"
  else
    # 降级到 Refly Canvas
    USE_MODE="refly"
    echo "⚠️  Seedance API Key 未配置，降级到 Refly Canvas 模式"
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
  echo "📡 调用 Seedance Video API..."
  echo ""
  
  # TODO: 实现 Seedance Video API 调用
  RESULT='{
    "success": false,
    "error": "Seedance Video API not implemented yet"
  }'
  
elif [ "$USE_MODE" = "refly" ]; then
  # 方式2: Refly Canvas
  echo "📡 调用 agent-canvas-confirm Skill（Refly Canvas）..."
  echo ""
  
  CANVAS_SKILL_DIR="/home/node/.openclaw/workspace/skills/agent-canvas-confirm"
  
  if [ ! -d "$CANVAS_SKILL_DIR" ]; then
    echo "❌ agent-canvas-confirm Skill 未找到"
    exit 1
  fi
  
  # 调用 agent-canvas-confirm
  RESULT=$(bash "$CANVAS_SKILL_DIR/scripts/canvas.sh" << EOF
{
  "action": "generate",
  "type": "video",
  "image": "$IMAGE_PATH",
  "prompt": "$PROMPT",
  "parameters": {
    "style": "$STYLE",
    "duration": $DURATION
  }
}
EOF
)
  
else
  echo "❌ 未知模式: $USE_MODE"
  exit 1
fi

# ==================== 结果处理 ====================

SUCCESS=$(echo "$RESULT" | jq -r '.success // false')

if [ "$SUCCESS" != "true" ]; then
  echo "❌ 生成失败"
  echo "$RESULT" | jq '.'
  exit 1
fi

# 添加模式信息
RESULT=$(echo "$RESULT" | jq --arg mode "$USE_MODE" '. + {mode_used: $mode}')

echo ""
echo "✅ 生成成功（模式: $USE_MODE）"
echo "$RESULT" | jq '.'
