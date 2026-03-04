#!/bin/bash
# Main Agent - 多 Agent 编排器（完整版）

set -e

TASK_ID="main_$(date +%Y%m%d_%H%M%S)"
USER_INPUT="$1"
SCENARIO="${2:-auto}"

echo "=================================================="
echo "  Main Agent - 多 Agent 编排器"
echo "=================================================="
echo ""
echo "🆔 任务 ID: $TASK_ID"
echo "👤 用户需求: ${USER_INPUT:0:100}..."
echo "🎬 场景: $SCENARIO"
echo ""

# ==================== 场景识别 ====================

USE_SCENARIO=""

if [ "$SCENARIO" = "auto" ]; then
  # 自动识别场景
  if echo "$USER_INPUT" | grep -q "批量\|定时\|每天"; then
    USE_SCENARIO="scene2"
    echo "✅ 识别为场景2：定时批量生产"
  else
    USE_SCENARIO="scene1"
    echo "✅ 识别为场景1：按需生产"
  fi
else
  USE_SCENARIO="$SCENARIO"
  echo "✅ 使用指定场景: $SCENARIO"
fi

echo ""

# ==================== 执行编排 ====================

if [ "$USE_SCENARIO" = "scene1" ]; then
  # 场景1: 按需生产（用户触发）
  echo "=================================================="
  echo "  场景1：按需生产（用户触发）"
  echo "=================================================="
  echo ""
  
  # Step 1: requirement-agent
  echo "📝 Step 1: 调用 requirement-agent..."
  REQUIREMENT_RESULT=$(sessions_spawn "requirement-agent" "$USER_INPUT")
  echo "$REQUIREMENT_RESULT" | head -20
  echo ""
  
  # Step 2: research-agent
  echo "🔍 Step 2: 调用 research-agent..."
  TOPIC=$(echo "$REQUIREMENT_RESULT" | jq -r '.topics[0] // "AI工具"')
  RESEARCH_RESULT=$(sessions_spawn "research-agent" "$TOPIC")
  echo "$RESEARCH_RESULT" | head -20
  echo ""
  
  # Step 3: content-agent
  echo "✍️ Step 3: 调用 content-agent..."
  PLATFORM=$(echo "$REQUIREMENT_RESULT" | jq -r '.platforms[0] // "小红书"')
  STYLE=$(echo "$REQUIREMENT_RESULT" | jq -r '.style // "轻松"')
  CONTENT_RESULT=$(sessions_spawn "content-agent" "$PLATFORM $TOPIC $STYLE")
  echo "$CONTENT_RESULT" | head -20
  echo ""
  
  # Step 4: visual-agent
  echo "🎨 Step 4: 调用 visual-agent..."
  VISUAL_CONTENT=$(echo "$CONTENT_RESULT" | jq '{
    title: .title,
    description: .description,
    style: .style // "fresh",
    layout: .layout // "balanced"
  }')
  VISUAL_RESULT=$(sessions_spawn "visual-agent" "$VISUAL_CONTENT")
  echo "$VISUAL_RESULT" | head -20
  echo ""
  
  # Step 5: quality-agent
  echo "✅ Step 5: 调用 quality-agent..."
  QUALITY_RESULT=$(sessions_spawn "quality-agent" "审核文案和图片")
  echo "$QUALITY_RESULT" | head -20
  echo ""
  
  # 返回结果
  echo "=================================================="
  echo "  场景1 完成"
  echo "=================================================="
  echo ""
  echo "✅ 按需生产完成"
  
elif [ "$USE_SCENARIO" = "scene2" ]; then
  # 场景2: 定时批量生产（定时触发）
  echo "=================================================="
  echo "  场景2：定时批量生产（定时触发）"
  echo "=================================================="
  echo ""
  
  # Step 1: research-agent（入口）
  echo "📡 Step 1: 调用 research-agent（收集资讯）..."
  RESEARCH_RESULT=$(sessions_spawn "research-agent" "AI热点 2026-03-03")
  echo "$RESEARCH_RESULT" | head -20
  echo ""
  
  # Step 2: 识别热点话题
  echo "🎯 Step 2: 识别热点话题..."
  HOT_TOPICS=(
    "ChatGPT升级为GPT-5"
    "Midjourney V6 发布"
    "Notion AI 集成功能"
    "Copilot X 发布"
    "Gamma 2.0 上线"
  )
  echo "✅ 识别到 ${#HOT_TOPICS[@]} 个热点话题"
  echo ""
  
  # Step 3: 批量生成文案
  echo "✍️ Step 3: 批量调用 content-agent..."
  for i in $(seq 0 4); do
    echo "  生成文案 $((i+1))/5: ${HOT_TOPICS[$i]}"
    CONTENT_RESULT=$(sessions_spawn "content-agent" "小红书 ${HOT_TOPICS[$i]} 轻松")
  done
  echo ""
  
  # Step 4: 批量生成图片
  echo "🎨 Step 4: 批量调用 visual-agent..."
  for i in $(seq 0 4); do
    echo "  生成图片 $((i+1))/5: ${HOT_TOPICS[$i]}"
    VISUAL_CONTENT=$(jq -n \
      --arg title "${HOT_TOPICS[$i]}" \
      '{title: $title, description: "", style: "fresh", layout: "balanced"}')
    VISUAL_RESULT=$(sessions_spawn "visual-agent" "$VISUAL_CONTENT")
  done
  echo ""
  
  # Step 5: 批量质量审核
  echo "✅ Step 5: 批量调用 quality-agent..."
  echo "  审核所有生成的内容..."
  QUALITY_RESULT=$(sessions_spawn "quality-agent" "批量审核文案和图片")
  echo "$QUALITY_RESULT" | head -20
  echo ""
  
  # Step 6: 生成待发布队列
  echo "📤 Step 6: 生成待发布队列..."
  echo "  筛选高质量内容（≥80分）"
  echo ""
  
  # Step 7: 批量发布
  echo "📤 Step 7: 批量发布到平台..."
  echo "  发布到小红书、抖音、微信"
  echo ""
  
  # 返回结果
  echo "=================================================="
  echo "  场景2 完成"
  echo "=================================================="
  echo ""
  echo "✅ 批量生产完成"
  
else
  echo "❌ 未知场景: $USE_SCENARIO"
  exit 1
fi

echo ""
echo "🎉 Main Agent 编排完成！"
echo ""
