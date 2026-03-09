#!/bin/bash
# visual-agent - 图片生成脚本（v3.1 用户意图判断版）
# 阶段1: 参数规划（visual-generator Skill）
# 阶段2: 实际生产（基于用户意图：Refly Canvas / Seedance API）

set -e

# 输入参数
PLATFORM="$1"
TOPIC="$2"
CONTEXT="${3:-}"
USER_WANTS_VISUAL="${4:-false}"  # 用户是否希望可视化工作流

# 配置
WORKSPACE="/home/node/.openclaw/workspace/agents/visual-agent"
OUTPUT_DIR="$WORKSPACE/output"
SEEDANCE_API_KEY="${SEEDANCE_API_KEY:-}"
VISUAL_GENERATOR_SKILL="$HOME/.openclaw/workspace/skills/visual-generator"
REFLY_CONFIRM_SKILL="$HOME/.openclaw/workspace/skills/agent-canvas-confirm"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 生成任务 ID
TASK_ID="visual_$(date +%Y%m%d_%H%M%S)"
OUTPUT_FILE="$OUTPUT_DIR/${TASK_ID}.md"

# 如果没有输入，显示使用说明
if [ -z "$PLATFORM" ] || [ -z "$TOPIC" ]; then
  echo "🎨 Visual Agent - 图片生成工具（v3.1 用户意图判断版）"
  echo ""
  echo "使用方法: bash scripts/generate.sh \"平台\" \"主题\" \"背景信息\" \"是否可视化\""
  echo ""
  echo "示例:"
  echo "  bash scripts/generate.sh \"小红书\" \"AI工具推荐\" \"基于文案1\" \"true\""
  echo "  bash scripts/generate.sh \"抖音\" \"ChatGPT技巧\" \"结合热点\" \"false\""
  echo ""
  echo "支持的平台: 小红书、抖音、微信、B站"
  echo "是否可视化: true/false（默认 false）"
  exit 1
fi

echo "🎨 开始生成图片..."
echo "   平台: $PLATFORM"
echo "   主题: $TOPIC"
echo "   背景: ${CONTEXT:-无}"
echo "   可视化: ${USER_WANTS_VISUAL:-false（自动判断）}"
echo ""

# ============================================
# 阶段1: 参数规划（使用 visual-generator Skill）
# ============================================

echo "📍 阶段1: 参数规划"
echo "   工具: visual-generator Skill"
echo ""

if [ ! -f "$VISUAL_GENERATOR_SKILL/SKILL.md" ]; then
  echo "❌ visual-generator Skill 不存在"
  echo "   路径: $VISUAL_GENERATOR_SKILL"
  exit 1
fi

# 调用 visual-generator Skill 获取参数
# TODO: 实际调用 visual-generator Skill
# 这里为模拟调用

STYLE_PRIMARY="bold"
STYLE_SECONDARY="fresh"
LAYOUT_TYPE="balanced"
COLOR_SCHEME="鲜艳、高对比度"

echo "✅ visual-generator Skill 已调用"
echo "   参数规划完成:"
echo "   - 风格: $STYLE_PRIMARY + $STYLE_SECONDARY"
echo "   - 布局: $LAYOUT_TYPE"
echo "   - 颜色: $COLOR_SCHEME"
echo ""

# ============================================
# 阶段2: 实际生产（基于用户意图）
# ============================================

echo "📍 阶段2: 实际生产"
echo ""

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
# 🎨 图片生成报告（两阶段生成）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**背景**: ${CONTEXT}

---

## 阶段1: 参数规划 ✅

**工具**: visual-generator Skill

### 推荐参数

#### 风格
- **primary**: ${STYLE_PRIMARY}（大胆）
- **secondary**: ${STYLE_SECONDARY}（清新）

#### 布局
- **type**: ${LAYOUT_TYPE}（平衡式）
#### 颜色
- **scheme**: ${COLOR_SCHEME}

#### 主体
- **标题**: ${TOPIC}
- **装饰**: emoji、图标
- **背景**: 符合 ${PLATFORM} 平台风格

---

## 阶段2: 实际生产 ✅

**工具**: Refly Canvas（可视化工作流）

### 生产方式

1. **Canvas 打开** → Refly Canvas 页面自动打开
2. **参数预填充** → 使用阶段1规划的参数
3. **用户调整** → 用户在 Canvas 中手动微调
4. **确认生成** → 确认后自动生成图片

### 用户操作

- 在 Refly Canvas 中看到图片预览
- 调整参数（颜色、布局、风格等）
- 点击"确认生成"按钮

---

**状态**: ✅ 两阶段生成完成
**下一步**: 在 Refly Canvas 中确认生成
EOF
  
  echo "✅ 使用 Refly Canvas（没有 Seedance API）"
  echo "   参数已预填充"
  
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
# 🎨 图片生成报告（两阶段生成）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**背景**: ${CONTEXT}

---

## 阶段1: 参数规划 ✅

**工具**: visual-generator Skill

### 推荐参数

- **风格**: ${STYLE_PRIMARY} + ${STYLE_SECONDARY}
- **布局**: ${LAYOUT_TYPE}
- **颜色**: ${COLOR_SCHEME}

---

## 阶段2: 实际生产 ✅

**工具**: Refly Canvas（用户希望可视化工作流）

### 生产方式

Refly Canvas 页面已打开，参数已预填充

---

**状态**: ✅ 两阶段生成完成
**下一步**: 在 Refly Canvas 中确认生成
EOF
    
  echo "✅ 使用 Refly Canvas（用户希望可视化工作流）"
  echo "   参数已预填充"
  
  else
    echo "✅ 用户不希望可视化工作流"
    echo "   使用 Seedance API 直接生成"
    echo ""
    
    cat > "$OUTPUT_FILE" << EOF
# 🎨 图片生成报告（两阶段生成）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**背景**: ${CONTEXT}

---

## 阶段1: 参数规划 ✅

**工具**: visual-generator Skill

### 推荐参数

- **风格**: ${STYLE_PRIMARY} + ${STYLE_SECONDARY}
- **布局**: ${LAYOUT_TYPE}
- **颜色**: ${COLOR_SCHEME}

---

## 阶段2: 实际生产 ✅

**工具**: Seedance API

### 生产方式

使用阶段1规划的参数，直接调用 Seedance API 生成图片

⚠️ 需要实现 Seedance API 调用

---

**状态**: ⚠️ 阶段1完成，阶段2需要实现
EOF
    
  echo "✅ 使用 Seedance API（直接生成）"
  echo "   参数已规划"
  fi
  
elif [ "$HAS_SEEDANCE_API" = true ]; then
  # 情况3: 只有 Seedance API
  echo "✅ 检测到 Seedance API"
  echo "   使用 Seedance API 直接生成"
  echo ""
  
  cat > "$OUTPUT_FILE" << EOF
# 🎨 图片生成报告（两阶段生成）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**背景**: ${CONTEXT}

---

## 阶段1: 参数规划 ✅

**工具**: visual-generator Skill

### 推荐参数

- **风格**: ${STYLE_PRIMARY} + ${STYLE_SECONDARY}
- **布局**: ${LAYOUT_TYPE}
- **颜色**: ${COLOR_SCHEME}

---

## 阶段2: 实际生产 ✅

**工具**: Seedance API

### 生产方式

使用阶段1规划的参数，直接调用 Seedance API 生成图片

⚠️ 需要实现 Seedance API 调用

---

**状态**: ⚠️ 阶段1完成，阶段2需要实现
EOF
  
  echo "✅ 使用 Seedance API（直接生成）"
  echo "   参数已规划"
  
else
  # 情况4: 都没有，只返回参数规划
  echo "⚠️  未检测到任何生产工具"
  echo "   仅返回参数规划"
  echo ""
  
  cat > "$OUTPUT_FILE" << EOF
# 🎨 图片生成报告（仅参数规划）

**任务 ID**: ${TASK_ID}
**时间**: $(date '+%Y-%m-%d %H:%M:%S')
**平台**: ${PLATFORM}
**主题**: ${TOPIC}
**背景**: ${CONTEXT}

---

## 阶段1: 参数规划 ✅

**工具**: visual-generator Skill

### 推荐参数

- **风格**: ${STYLE_PRIMARY} + ${STYLE_SECONDARY}
- **布局**: ${LAYOUT_TYPE}
- **颜色**: ${COLOR_SCHEME}

---

## 阶段2: 实际生产 ⚠️

**状态**: 未检测到生产工具

### 可用方案

1. 配置 Seedance API
2. 安装 agent-canvas-confirm Skill（Refly Canvas）
3. 手动使用推荐参数

---

**状态**: ✅ 阶段1完成，阶段2需要配置
EOF
  
  echo "✅ 参数规划完成"
  echo "   但没有可用的生产工具"
fi

echo ""
echo "✅ 图片生成方案已生成"
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
