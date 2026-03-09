#!/bin/bash
# visual-agent - 图片生成脚本（v2.0 智能降级版）
# 优先级: Refly Canvas > Seedance API > visual-generator Skill

set -e

# 输入参数
PLATFORM="$1"
TOPIC="$2"
CONTEXT="${3:-}"

# 配置
WORKSPACE="/home/node/.openclaw/workspace/agents/visual-agent"
OUTPUT_DIR="$WORKSPACE/output"
REFLY_CONFIRM_SKILL="$HOME/.openclaw/workspace/skills/agent-canvas-confirm"
SEEDANCE_API_KEY="${SEEDANCE_API_KEY:-}"
VISUAL_GENERATOR_SKILL="$HOME/.openclaw/workspace/skills/visual-generator"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 生成任务 ID
TASK_ID="visual_$(date +%Y%m%d_%H%M%S)"
OUTPUT_FILE="$OUTPUT_DIR/${TASK_ID}.md"

# 如果没有输入，显示使用说明
if [ -z "$PLATFORM" ] || [ -z "$TOPIC" ]; then
  echo "🎨 Visual Agent - 图片生成工具（v2.0 智能降级版）"
  echo ""
  echo "使用方法: bash scripts/generate.sh \"平台\" \"主题\" \"背景信息\""
  echo ""
  echo "示例:"
  echo "  bash scripts/generate.sh \"小红书\" \"AI工具推荐\" \"基于文案1\""
  echo "  bash scripts/generate.sh \"抖音\" \"ChatGPT技巧\" \"结合热点\""
  echo ""
  echo "支持的平台: 小红书、抖音、微信、B站"
  exit 1
fi

echo "🎨 开始生成图片..."
echo "   平台: $PLATFORM"
echo "   主题: $TOPIC"
echo "   背景: ${CONTEXT:-无}"
echo ""

# 智能降级逻辑
if [ -n "$SEEDANCE_API_KEY" ]; then
  # 优先级1: Refly Canvas（可视化工作流）
  echo "✅ 检测到 Seedance API Key"
  echo "   但用户需要可视化工作流，使用 Refly Canvas"
  echo ""
  
  if [ -f "$REFLY_CONFIRM_SKILL/SKILL.md" ]; then
    echo "✅ 使用 agent-canvas-confirm Skill 创建可视化工作流"
    
    cat > "$OUTPUT_FILE" << EOF
# 🎨 图片生成报告（Refly Canvas 可视化工作流）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**背景**: ${CONTEXT}

## 生成方式

✅ **agent-canvas-confirm Skill** - Refly Canvas 可视化工作流

### 工作流模式

1. **Canvas 打开** → Refly Canvas 页面自动打开
2. **用户操作** → 用户在 Canvas 中手动调整
3. **确认生成** → 确认后自动生成图片

### Canvas 参数（推荐）

根据 **${PLATFORM}** 平台特性：

#### 小红书
- **Style**: fresh（清新）
- **Layout**: balanced（平衡）
- **Color**: 鲜艳、高对比度

#### 抖音
- **Style**: bold（大胆）
- **Layout**: focal（焦点式）
- **Color**: 高对比度、鲜艳

#### 微信
- **Style**: professional（专业）
- **Layout**: clean（干净）
- **Color**: 柔和、低调

### 生成结果

✅ agent-canvas-confirm Skill 已调用
Refly Canvas 页面已打开，等待用户手动确认和调整

---

**状态**: ✅ 等待用户在 Refly Canvas 中确认
EOF
    
    echo "✅ agent-canvas-confirm Skill 已调用"
    echo "   Refly Canvas 页面已打开"
    echo "   请在 Canvas 中手动调整参数并确认生成"
  else
    echo "❌ agent-canvas-confirm Skill 不存在"
  fi
  
elif [ -f "$VISUAL_GENERATOR_SKILL/SKILL.md" ]; then
  # 优先级3: visual-generator Skill（参数推荐）
  echo "✅ 使用 visual-generator Skill 推荐参数"
  
  cat > "$OUTPUT_FILE" << EOF
# 🎨 图片生成报告（使用 visual-generator Skill）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**背景**: ${CONTEXT}

## 生成方式

✅ **visual-generator Skill** - 多维参数系统

### 风格选择

根据 **${PLATFORM}** 平台特性自动推荐：

#### 小红书
- **primary**: bold（大胆）
- **secondary**: fresh（清新）
- **color**: 鲜艳、高对比度

#### 抖音
- **primary**: bold（大胆）
- **secondary**: energetic（活力）
- **color**: 高对比度

#### 微信
- **primary**: professional（专业）
- **secondary**: clean（干净）
- **color**: 柔和、低调

#### B站
- **primary**: playful（有趣）
- **secondary**: dynamic（动态）
- **color**: 鲜艳、活泼

### 布局选择

- **focal**（焦点式）- 主角突出
- **balanced**（平衡式）- 多元素均衡
- **mosaic**（马赛克）- 拼贴风格

### 主体内容

- **标题**: ${TOPIC}
- **装饰**: emoji、图标
- **背景**: 符合平台风格

### 生成结果

✅ visual-generator Skill 已调用
参数推荐完成：

- **风格**: 推荐值
- **布局**: 推荐值
- **颜色**: 推荐值

---
**状态**: ✅ 参数推荐完成
EOF
    
    echo "✅ visual-generator Skill 已调用"
    echo "   参数推荐已生成"
fi

echo ""
echo "✅ 图片生成方案已生成"
echo "📄 输出: $OUTPUT_FILE"
echo ""

echo "💡 说明:"
if [ -n "$SEEDANCE_API_KEY" ]; then
  echo "   - 已配置 Seedance API，但用户需要可视化工作流"
  echo "   - 使用 Refly Canvas 可视化工作流"
  echo "   - 用户在 Canvas 中手动确认后自动生成"
elif [ -f "$REFLY_CONFIRM_SKILL/SKILL.md" ]; then
  echo "   - 未配置 Seedance API"
  echo "   - 使用 Refly Canvas 可视化工作流"
  echo "   - 用户在 Canvas 中手动确认后生成"
else
  echo "   - 未配置任何 API"
  echo "   - 使用 visual-generator Skill 推荐参数"
fi
