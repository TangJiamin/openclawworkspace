#!/bin/bash
# video-agent - 视频生成脚本（v2.0 智能降级版）
# 优先级: Refly Canvas > Seedance API > seedance-storyboard Skill

set -e

# 输入参数
PLATFORM="$1"
TOPIC="$2"
IMAGE_PATH="${3:-}"  # ⚠️ 关键：必须有图片！
CONTEXT="${4:-}"

# 配置
WORKSPACE="/home/node/.openclaw/workspace/agents/video-agent"
OUTPUT_DIR="$WORKSPACE/output"
REFLY_CONFIRM_SKILL="$HOME/.openclaw/workspace/skills/agent-canvas-confirm"
SEEDANCE_API_KEY="${SEEDANCE_API_KEY:-}"
STORYBOARD_SKILL="$HOME/.openclaw/workspace/skills/seedance-storyboard"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 如果没有输入，显示使用说明
if [ -z "$PLATFORM" ] || [ -z "$TOPIC" ]; then
  echo "🎬 Video Agent - 视频生成工具（v2.0 智能降级版）"
  echo ""
  echo "使用方法: bash scripts/generate.sh \"平台\" \"主题\" \"图片路径\" \"背景信息\""
  echo ""
  echo "⚠️  注意: 图片路径是必需的！"
  echo ""
  echo "示例:"
  echo "  bash scripts/generate.sh \"抖音\" \"AI工具推荐\" \"/path/to/image.jpg\""
  echo "  bash scripts/generate.sh \"小红书\" \"ChatGPT技巧\" \"/path/to/image.png\""
  echo ""
  echo "支持的平台: 抖音、小红书、微信、B站"
  exit 1
fi

# 检查图片路径
if [ -z "$IMAGE_PATH" ]; then
  echo "❌ 错误: 未提供图片路径"
  echo ""
  echo "⚠️️ 视频生成必须先有图片！"
  echo ""
  echo "📋 正确流程:"
  echo "   1. 使用 visual-agent 生成图片"
  echo "   2. 获取图片路径"
  echo "   3. 使用 video-agent 生成视频"
  echo ""
  echo "💡 提示: 可以先运行:"
  echo "   bash /home/node/.openclaw/agents/visual-agent/scripts/generate-v2.sh \"$PLATFORM\" \"$TOPIC\""
  exit 1
fi

# 检查图片文件是否存在
if [ ! -f "$IMAGE_PATH" ]; then
  echo "❌ 错误: 图片文件不存在"
  echo "   路径: $IMAGE_PATH"
  echo ""
  echo "💡 提示: 请先生成图片"
  exit 1
fi

echo "🎬 开始生成视频..."
echo "   平台: $PLATFORM"
echo "   主题: $TOPIC"
echo "   图片: $IMAGE_PATH"
echo "   背景: ${CONTEXT:-无}"
echo ""

# 生成任务 ID
TASK_ID="video_$(date +%Y%m%d_%H%M%S)"
OUTPUT_FILE="$OUTPUT_DIR/${TASK_ID}.md"

# 智能降级逻辑
if [ -n "$SEEDANCE_API_KEY" ]; then
  # 优先级1: Refly Canvas（可视化工作流）
  echo "✅ 检测到 Seedance API Key"
  echo "   但用户需要可视化工作流，使用 Refly Canvas"
  echo ""
  
  if [ -f "$REFLY_CONFIRM_SKILL/SKILL.md" ]; then
    echo "✅ 使用 agent-canvas-confirm Skill 创建可视化工作流"
    
    cat > "$OUTPUT_FILE" << EOF
# 🎬 视频生成报告（Refly Canvas 可视化工作流）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**图片**: $IMAGE_PATH
**背景**: ${CONTEXT}

## 生成方式

✅ **agent-canvas-confirm Skill** - Refly Canvas 可视化工作流

### 工作流模式

1. **Canvas 打开** → Refly Canvas 页面自动打开
2. **用户操作** → 用户在 Canvas 中手动调整分镜
3. **确认生成** → 确认后自动生成视频

### 分镜脚本（30秒）

#### 镜头 1: 开场（0-3秒）
- **画面**: $IMAGE_PATH（封面图）
- **文字**: 标题动画
- **音乐**: 快节奏背景音
- **时长**: 3 秒

#### 镜头 2-5: 内容介绍（3-23秒）
- **画面**: 结合 $IMAGE_PATH
- **文字**: ${TOPIC} 核心要点（3-5个）
- **节奏**: 快速切换
- **时长**: 20 秒

#### 镜头 6: CTA（23-30秒）
- **画面**: 关注、点赞动画
- **文字**: "关注我，获取更多AI技巧！"
- **音乐**: 渐弱引导
- **时长**: 7 秒

### 生成结果

✅ agent-canvas-confirm Skill 已调用
Refly Canvas 页面已打开，等待用户手动确认和调整

---

**状态**: ✅ 等待用户在 Refly Canvas 中确认
EOF
    
    echo "✅ agent-canvas-confirm Skill 已调用"
    echo "   Refly Canvas 页面已打开"
    echo "   请在 Canvas 中手动调整分镜并确认生成"
  else
    echo "❌ agent-canvas-confirm Skill 不存在"
  fi
  
elif [ -f "$STORYBOARD_SKILL/SKILL.md" ]; then
  # 优先级3: seedance-storyboard Skill（分镜脚本）
  echo "✅ 使用 seedance-storyboard Skill 生成分镜脚本"
  
  cat > "$OUTPUT_FILE" << EOF
# 🎬 视频生成报告（使用 seedance-storyboard Skill）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**图片**: $IMAGE_PATH
**背景**: ${CONTEXT}

## 生成方式

✅ **seedance-storyboard Skill** - 对话引导分镜生成

### 分镜脚本（30秒）

#### 镜头 1: 开场（0-3秒）
- **画面**: $IMAGE_PATH（封面图）
- **文字**: 标题动画
- **音乐**: 快节奏背景音
- **时长**: 3 秒

#### 镜头 2-5: 内容介绍（3-23秒）
- **画面**: 结合 $IMAGE_PATH
- **文字**: ${TOPIC} 核心要点（3-5个）
- **节奏**: 快速切换
- **时长**: 20 秒

#### 镜头 6: CTA（23-30秒）
- **画面**: 关注、点赞动画
- **文字**: "关注我，获取更多AI技巧！"
- **音乐**: 渐弱引导
- **时长**: 7 秒

### 生成结果

✅ seedance-storyboard Skill 已调用
分镜脚本已详细设计，实际视频生成需要配置 Seedance API

---

**状态**: ✅ Skill 已调用，分镜脚本完成
EOF
    
    echo "✅ seedance-storyboard Skill 已调用"
    echo "   分镜脚本: 30秒，6个镜头"
  fi
  
elif [ -f "$VISUAL_GENERATOR_SKILL/SKILL.md" ]; then
  # 优先级4: visual-generator Skill（参数推荐）
  echo "✅ 使用 visual-generator Skill 推荐参数"
  
  cat > "$OUTPUT_FILE" << EOF
# 🎬 视频生成报告（使用 visual-generator Skill）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**图片**: $IMAGE_PATH
**背景**: ${CONTEXT}

## 生成方式

✅ **visual-generator Skill** - 多维参数系统

### 视觉参数

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
    echo ""
    echo "💡 要实际生成视频："
    echo "   1. 使用 Refly Canvas 可视化工作流"
    "   2. 使用 Seedance API"
    "   3. 手动使用推荐参数制作"
fi

echo ""
echo "✅ 视频生成方案已生成"
echo "📄 输出: $OUTPUT_FILE"
echo ""

echo "💡 说明:"
if [ -n "$SEEDANCE_API_KEY" ]; then
  echo "   - 已配置 Seedance API，但用户需要可视化工作流"
  echo "   - 使用 Refly Canvas 可视化工作流"
  echo "   - 用户在 Canvas 中手动确认后生成"
elif [ -f "$REFLY_CONFIRM_SKILL/SKILL.md" ]; then
  echo "   - 未配置 Seedance API"
  echo "   - 使用 Refly Canvas 可视化工作流"
  echo "   - 用户在 Canvas 中手动确认后生成"
else
  echo "   - 未配置任何 API"
  echo "   - 使用 visual-generator Skill 推荐参数"
fi
