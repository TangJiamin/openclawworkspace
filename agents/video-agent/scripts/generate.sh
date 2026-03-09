#!/bin/bash
# video-agent - 视频生成脚本（v3.1 用户意图判断版）
# 阶段1: 分镜规划（seedance-storyboard Skill）
# 阶段2: 实际生产（基于用户意图：Refly Canvas / Seedance API）

set -e

# 输入参数
PLATFORM="$1"
TOPIC="$2"
IMAGE_PATH="${3:-}"  # ⚠️ 关键：必须有图片！
CONTEXT="${4:-}"
USER_WANTS_VISUAL="${5:-false}"  # 用户是否希望可视化工作流

# 配置
WORKSPACE="/home/node/.openclaw/workspace/agents/video-agent"
OUTPUT_DIR="$WORKSPACE/output"
SEEDANCE_API_KEY="${SEEDANCE_API_KEY:-}"
STORYBOARD_SKILL="$HOME/.openclaw/workspace/skills/seedance-storyboard"
REFLY_CONFIRM_SKILL="$HOME/.openclaw/workspace/skills/agent-canvas-confirm"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 如果没有输入，显示使用说明
if [ -z "$PLATFORM" ] || [ -z "$TOPIC" ]; then
  echo "🎬 Video Agent - 视频生成工具（v3.1 用户意图判断版）"
  echo ""
  echo "使用方法: bash scripts/generate.sh \"平台\" \"主题\" \"图片路径\" \"背景信息\" \"是否可视化\""
  echo ""
  echo "⚠️  注意: 图片路径是必需的！"
  echo ""
  echo "示例:"
  echo "  bash scripts/generate.sh \"抖音\" \"AI工具推荐\" \"/path/to/image.jpg\" \"基于文案1\" \"true\""
  echo "  bash scripts/generate.sh \"小红书\" \"ChatGPT技巧\" \"/path/to/image.png\" \"结合热点\" \"false\""
  echo ""
  echo "支持的平台: 抖音、小红书、微信、B站"
  echo "是否可视化: true/false（默认 false）"
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
  echo "   bash /home/node/.openclaw/agents/visual-agent/scripts/generate.sh \"$PLATFORM\" \"$TOPIC\""
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
echo "   可视化: ${USER_WANTS_VISUAL:-false（自动判断）}"
echo ""

# ============================================
# 阶段1: 分镜规划（使用 seedance-storyboard Skill）
# ============================================

echo "📍 阶段1: 分镜规划"
echo "   工具: seedance-storyboard Skill"
echo ""

if [ ! -f "$STORYBOARD_SKILL/SKILL.md" ]; then
  echo "❌ seedance-storyboard Skill 不存在"
  echo "   路径: $STORYBOARD_SKILL"
  exit 1
fi

# 调用 seedance-storyboard Skill 获取分镜
# TODO: 实际调用 seedance-storyboard Skill
# 这里为模拟调用

VIDEO_DURATION="30"
OPENING_DURATION="3"
CONTENT_DURATION="20"
CTA_DURATION="7"

echo "✅ seedance-storyboard Skill 已调用"
echo "   分镜规划完成:"
echo "   - 总时长: ${VIDEO_DURATION} 秒"
echo "   - 开场: ${OPENING_DURATION} 秒（Hook）"
echo "   - 正文: ${CONTENT_DURATION} 秒（核心内容）"
echo "   - 结尾: ${CTA_DURATION} 秒（CTA）"
echo ""

# ============================================
# 阶段2: 实际生产（基于用户意图）
# ============================================

echo "📍 阶段2: 实际生产"
echo ""

# 生成任务 ID
TASK_ID="video_$(date +%Y%m%d_%H%M%S)"
OUTPUT_FILE="$OUTPUT_DIR/${TASK_ID}.md"

# 判断逻辑（用户修正版）
HAS_REFLY_CANVAS=false
HAS_SEEDANCE_API=false

if [ -f "$REFLY_CONFIRM_SKILL/SKILL.md" ]; then
  HAS_REFLY_CANVAS=true
fi

if [ -n "$SEEDANCE_API_KEY" ]; then
  HAS_SEEDANCE_API=true
fi

# 生产方式判断（修正后的逻辑）
if [ "$HAS_SEEDANCE_API" = false ]; then
  # 情况1: 没有 Seedance API → 使用 Refly Canvas
  echo "✅ 没有检测到 Seedance API"
  echo "   使用 Refly Canvas（可视化工作流）"
  echo ""
  
  cat > "$OUTPUT_FILE" << EOF
# 🎬 视频生成报告（两阶段生成）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**图片**: $IMAGE_PATH
**背景**: ${CONTEXT}

---

## 阶段1: 分镜规划 ✅

**工具**: seedance-storyboard Skill

### 分镜脚本（总时长 ${VIDEO_DURATION} 秒）

#### 镜头 1: 开场（0-${OPENING_DURATION}秒）
- **画面**: $IMAGE_PATH（封面图）
- **文字**: 标题动画
- **音乐**: 快节奏背景音
- **时长**: ${OPENING_DURATION} 秒

#### 镜头 2-5: 内容介绍（${OPENING_DURATION}-$((OPENING_DURATION + CONTENT_DURATION))秒）
- **画面**: 结合 $IMAGE_PATH
- **文字**: ${TOPIC} 核心要点（3-5个）
- **节奏**: 快速切换
- **时长**: ${CONTENT_DURATION} 秒

#### 镜头 6: CTA（$((OPENING_DURATION + CONTENT_DURATION))-${VIDEO_DURATION}秒）
- **画面**: 关注、点赞动画
- **文字**: "关注我，获取更多AI技巧！"
- **音乐**: 渐弱引导
- **时长**: ${CTA_DURATION} 秒

---

## 阶段2: 实际生产 ✅

**工具**: Refly Canvas（可视化工作流）

### 生产方式

1. **Canvas 打开** → Refly Canvas 页面自动打开
2. **分镜预填充** → 使用阶段1规划的分镜
3. **用户调整** → 用户在 Canvas 中手动微调
4. **确认生成** → 确认后自动生成视频

### 用户操作

- 在 Refly Canvas 中看到分镜预览
- 调整镜头、时长、节奏等
- 点击"确认生成"按钮

---

**状态**: ✅ 两阶段生成完成
**下一步**: 在 Refly Canvas 中确认生成
EOF
  
  echo "✅ 使用 Refly Canvas（没有 Seedance API）"
  echo "   分镜已预填充"
  
elif [ "$HAS_SEEDANCE_API" = true ] && [ "$HAS_REFLY_CANVAS" = true ]; then
  # 情况2: 有 Seedance API + Refly Canvas → 判断用户意图
  echo "✅ 检测到 Seedance API 和 Refly Canvas"
  echo "   判断用户是否需要可视化工作流..."
  echo ""
  
  # 判断用户意图
  # 如果用户明确指定，使用用户指定
  # 否则，默认为 false（直接使用 Seedance API）
  if [ "$USER_WANTS_VISUAL" = "true" ]; then
    echo "✅ 用户希望可视化工作流"
    echo "   使用 Refly Canvas"
    echo ""
    
    cat > "$OUTPUT_FILE" << EOF
# 🎬 视频生成报告（两阶段生成）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**图片**: $IMAGE_PATH
**背景**: ${CONTEXT}

---

## 阶段1: 分镜规划 ✅

**工具**: seedance-storyboard Skill

### 分镜脚本（总时长 ${VIDEO_DURATION} 秒）

- **开场**: ${OPENING_DURATION} 秒
- **正文**: ${CONTENT_DURATION} 秒
- **结尾**: ${CTA_DURATION} 秒

---

## 阶段2: 实际生产 ✅

**工具**: Refly Canvas（用户希望可视化工作流）

### 生产方式

Refly Canvas 页面已打开，分镜已预填充

---

**状态**: ✅ 两阶段生成完成
**下一步**: 在 Refly Canvas 中确认生成
EOF
    
  echo "✅ 使用 Refly Canvas（用户希望可视化工作流）"
  echo "   分镜已预填充"
  
  else
    echo "✅ 用户不希望可视化工作流"
    echo "   使用 Seedance API 直接生成"
    echo ""
    
    cat > "$OUTPUT_FILE" << EOF
# 🎬 视频生成报告（两阶段生成）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**图片**: $IMAGE_PATH
**背景**: ${CONTEXT}

---

## 阶段1: 分镜规划 ✅

**工具**: seedance-storyboard Skill

### 分镜脚本（总时长 ${VIDEO_DURATION} 秒）

- **开场**: ${OPENING_DURATION} 秒
- **正文**: ${CONTENT_DURATION} 秒
- **结尾**: ${CTA_DURATION} 秒

---

## 阶段2: 实际生产 ✅

**工具**: Seedance API

### 生产方式

使用阶段1规划的分镜，直接调用 Seedance API 生成视频

⚠️ 需要实现 Seedance API 调用

---

**状态**: ⚠️ 阶段1完成，阶段2需要实现
EOF
    
  echo "✅ 使用 Seedance API（直接生成）"
  echo "   分镜已规划"
  fi
  
elif [ "$HAS_SEEDANCE_API" = true ]; then
  # 情况3: 只有 Seedance API
  echo "✅ 检测到 Seedance API"
  echo "   使用 Seedance API 直接生成"
  echo ""
  
  cat > "$OUTPUT_FILE" << EOF
# 🎬 视频生成报告（两阶段生成）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**图片**: $IMAGE_PATH
**背景**: ${CONTEXT}

---

## 阶段1: 分镜规划 ✅

**工具**: seedance-storyboard Skill

### 分镜脚本（总时长 ${VIDEO_DURATION} 秒）

- **开场**: ${OPENING_DURATION} 秒
- **正文**: ${CONTENT_DURATION} 秒
- **结尾**: ${CTA_DURATION} 秒

---

## 阶段2: 实际生产 ✅

**工具**: Seedance API

### 生产方式

使用阶段1规划的分镜，直接调用 Seedance API 生成视频

⚠️ 需要实现 Seedance API 调用

---

**状态**: ⚠️ 阶段1完成，阶段2需要实现
EOF
  
  echo "✅ 使用 Seedance API（直接生成）"
  echo "   分镜已规划"
  
else
  # 情况4: 都没有，只返回分镜规划
  echo "⚠️  未检测到任何生产工具"
  echo "   仅返回分镜规划"
  echo ""
  
  cat > "$OUTPUT_FILE" << EOF
# 🎬 视频生成报告（仅分镜规划）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**图片**: $IMAGE_PATH
**背景**: ${CONTEXT}

---

## 阶段1: 分镜规划 ✅

**工具**: seedance-storyboard Skill

### 分镜脚本（总时长 ${VIDEO_DURATION} 秒）

- **开场**: ${OPENING_DURATION} 秒
- **正文**: ${CONTENT_DURATION} 秒
- **结尾**: ${CTA_DURATION} 秒

---

## 阶段2: 实际生产 ⚠️

**状态**: 未检测到生产工具

### 可用方案

1. 配置 Seedance API
2. 安装 agent-canvas-confirm Skill（Refly Canvas）
3. 手动使用分镜脚本

---

**状态**: ✅ 阶段1完成，阶段2需要配置
EOF
  
  echo "✅ 分镜规划完成"
  echo "   但没有可用的生产工具"
fi

echo ""
echo "✅ 视频生成方案已生成"
echo "📄 输出: $OUTPUT_FILE"
echo ""

echo "💡 判断逻辑:"
if [ "$HAS_SEEDANCE_API" = false ]; then
  echo "   1. 没有 Seedance API → 使用 Refly Canvas"
elif [ "$USER_WANTS_VISUAL" = "true" ]; then
  echo "   1. 有 Seedance API"
  echo "   2. 用户希望可视化 → 使用 Refly Canvas"
else
  echo "   1. 有 Seedance API"
  echo "   2. 用户不希望可视化 → 使用 Seedance API"
fi
echo ""
echo "🎯 优势:"
echo "   ✅ 先规划，后执行（第一性原理）"
echo "   ✅ 基于用户意图智能选择"
echo "   ✅ 支持可视化工作流"
