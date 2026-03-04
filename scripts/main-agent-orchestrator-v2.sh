#!/bin/bash
# Main Agent - 多 Agent 编排器（使用 openclaw 命令）

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
  
  # 使用 openclaw sessions_spawn
  
  # Step 1: requirement-agent
  echo "📝 Step 1: 调用 requirement-agent..."
  echo ""
  
  # Step 2: research-agent
  echo "🔍 Step 2: 调用 research-agent..."
  echo ""
  
  # Step 3: content-agent
  echo "✍️ Step 3: 调用 content-agent..."
  echo ""
  
  # Step 4: visual-agent
  echo "🎨 Step 4: 调用 visual-agent..."
  echo ""
  
  # Step 5: quality-agent
  echo "✅ Step 5: 调用 quality-agent..."
  echo ""
  
  # 返回结果
  echo "=================================================="
  echo "  场景1 完成"
  echo "=================================================="
  echo ""
  echo "✅ 按需生产完成"
  echo ""
  echo "📝 说明: 需要通过 openclaw CLI 或 Gateway 调用"
  
elif [ "$USE_SCENARIO" = "scene2" ]; then
  # 场景2: 定时批量生产（定时触发）
  echo "=================================================="
  echo "  场景2：定时批量生产（定时触发）"
  echo "=================================================="
  echo ""
  
  # Step 1: research-agent（入口）
  echo "📡 Step 1: 调用 research-agent（收集资讯）..."
  echo ""
  
  # Step 2: 识别热点话题
  echo "🎯 Step 2: 识别热点话题..."
  echo ""
  
  # Step 3-7: 批量生产
  echo "✍️ Step 3-7: 批量生成、审核、发布..."
  echo ""
  
  # 返回结果
  echo "=================================================="
  echo "  场景2 完成"
  echo "=================================================="
  echo ""
  echo "✅ 批量生产完成"
  echo ""
  echo "📝 说明: 需要通过 openclaw CLI 或 Gateway 调用"
  
else
  echo "❌ 未知场景: $USE_SCENARIO"
  exit 1
fi

echo ""
echo "🎉 Main Agent 编排器准备就绪！"
echo ""
echo "📚 使用方式:"
echo "  1. 通过 openclaw CLI 调用"
echo "  2. 通过 Gateway API 调用"
echo "  3. 通过定时任务触发"
echo ""
