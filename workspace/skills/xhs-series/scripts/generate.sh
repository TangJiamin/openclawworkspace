#!/bin/bash
# XHS Series Generator Script v1.0
# Based on baoyu-xhs-images, simplified for OpenClaw

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# Default values
STYLE="${STYLE:-auto}"
LAYOUT="${LAYOUT:-auto}"
PRESET="${PRESET:-}"
CONTENT=""
OUTPUT_DIR="${BASE_DIR}/output"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --style)
      STYLE="$2"
      shift 2
      ;;
    --layout)
      LAYOUT="$2"
      shift 2
      ;;
    --preset)
      PRESET="$2"
      shift 2
      ;;
    *)
      CONTENT="$1"
      shift
      ;;
  esac
done

# Validate content
if [[ -z "$CONTENT" ]]; then
  echo "❌ Error: No content provided"
  echo "Usage: $0 [--style <style>] [--layout <layout>] [--preset <preset>] <content|file>"
  exit 1
fi

# Read content (file or inline)
if [[ -f "$CONTENT" ]]; then
  CONTENT_TEXT=$(cat "$CONTENT")
else
  CONTENT_TEXT="$CONTENT"
fi

echo "🎨 小红书图文系列生成器"
echo "===================="
echo ""
echo "Content: ${CONTENT_TEXT:0:50}..."
echo ""

# Step 1: Analyze content
echo "📊 Step 1: Analyzing content..."
RECOMMENDED_STYLE=$(detect_content_signal "$CONTENT_TEXT")
RECOMMENDED_LAYOUT=$(detect_content_density "$CONTENT_TEXT")
RECOMMENDED_PRESET=$(get_preset_for_content "$CONTENT_TEXT")

echo "✅ Analysis complete:"
echo "   Style: $RECOMMENDED_STYLE"
echo "   Layout: $RECOMMENDED_LAYOUT"
echo "   Preset: $RECOMMENDED_PRESET"
echo ""

# Apply user overrides
if [[ "$STYLE" == "auto" ]]; then
  STYLE="$RECOMMENDED_STYLE"
fi

if [[ "$LAYOUT" == "auto" ]]; then
  LAYOUT="$RECOMMENDED_LAYOUT"
fi

if [[ -n "$PRESET" ]]; then
  # Parse preset
  PRESET_STYLE=$(get_preset_style "$PRESET")
  PRESET_LAYOUT=$(get_preset_layout "$PRESET")
  
  # User flags override preset
  if [[ "$STYLE" != "auto" && "$STYLE" != "$RECOMMENDED_STYLE" ]]; then
    STYLE="$STYLE"
  else
    STYLE="$PRESET_STYLE"
  fi
  
  if [[ "$LAYOUT" != "auto" && "$LAYOUT" != "$RECOMMENDED_LAYOUT" ]]; then
    LAYOUT="$LAYOUT"
  else
    LAYOUT="$PRESET_LAYOUT"
  fi
fi

echo "🎯 Final configuration:"
echo "   Style: $STYLE"
echo "   Layout: $LAYOUT"
echo ""

# Step 2: Choose strategy
echo "📋 Step 2: Generating outline..."
STRATEGY=$(choose_best_strategy "$CONTENT_TEXT")
OUTLINE=$(generate_outline "$CONTENT_TEXT" "$STRATEGY" "$STYLE" "$LAYOUT")

echo "✅ Outline generated (Strategy: $STRATEGY)"
echo ""

# Step 3: Split into series
echo "🔪 Step 3: Splitting content into series..."
SERIES_LENGTH=$(estimate_series_length "$CONTENT_TEXT" "$LAYOUT")
echo "   Estimated: $SERIES_LENGTH images"

if [[ $SERIES_LENGTH -gt 10 ]]; then
  SERIES_LENGTH=10
  echo "   ⚠️  Limited to 10 images (maximum)"
fi

# Create output directory
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SLUG=$(generate_slug "$CONTENT_TEXT")
OUTPUT_PATH="$OUTPUT_DIR/xhs-$SLUG-$TIMESTAMP"
mkdir -p "$OUTPUT_PATH"

# Save outline
echo "$OUTLINE" > "$OUTPUT_PATH/outline.md"

echo "   Output: $OUTPUT_PATH/"
echo ""

# Step 4: Generate images
echo "🎨 Step 4: Generating images..."
echo ""

# Split content into chunks
mapfile -t CHUNKS < <(split_content_into_chunks "$OUTLINE" "$SERIES_LENGTH")

for i in "${!CHUNKS[@]}"; do
  NUM=$((i + 1))
  CHUNK="${CHUNKS[$i]}"
  
  # Determine position type
  if [[ $NUM -eq 1 ]]; then
    POSITION="cover"
  elif [[ $NUM -eq $SERIES_LENGTH ]]; then
    POSITION="ending"
  else
    POSITION="content"
  fi
  
  # Adjust layout for position
  CURRENT_LAYOUT="$LAYOUT"
  if [[ "$POSITION" == "cover" ]]; then
    CURRENT_LAYOUT="sparse"
  elif [[ "$POSITION" == "ending" ]]; then
    CURRENT_LAYOUT="sparse"
  fi
  
  echo "  [$NUM/$SERIES_LENGTH] Generating ${POSITION} image..."
  echo "    Style: $STYLE"
  echo "    Layout: $CURRENT_LAYOUT"
  echo "    Content: ${CHUNK:0:50}..."
  
  # Generate image using visual-generator
  IMAGE_PATH="$OUTPUT_PATH/$(printf "%02d" $NUM)-${POSITION}.png"
  
  # Call visual-generator
  generate_xhs_image \
    --content "$CHUNK" \
    --style "$STYLE" \
    --layout "$CURRENT_LAYOUT" \
    --position "$POSITION" \
    --output "$IMAGE_PATH"
  
  echo "    ✅ Saved: $IMAGE_PATH"
  echo ""
done

# Step 5: Completion report
echo "✅ Generation complete!"
echo ""
echo "📊 Summary"
echo "========"
echo "Style: $STYLE"
echo "Layout: $LAYOUT"
echo "Series length: $SERIES_LENGTH images"
echo "Output: $OUTPUT_PATH/"
echo ""
echo "📁 Files generated:"
ls -1 "$OUTPUT_PATH/" | while read file; do
  echo "  - $file"
done

# Detect content signal
detect_content_signal() {
  local content="$1"
  
  if echo "$content" | grep -qiE "(美妆|时尚|可爱|粉色|cute|fashion|beauty)"; then
    echo "cute"
  elif echo "$content" | grep -qiE "(健康|自然|清新|health|fresh|nature)"; then
    echo "fresh"
  elif echo "$content" | grep -qiE "(知识|概念|生产力|knowledge|productivity)"; then
    echo "notion"
  elif echo "$content" | grep -qiE "(警告|重要|必须|warning|important)"; then
    echo "bold"
  elif echo "$content" | grep -qiE "(专业|商务|优雅|professional|business)"; then
    echo "minimal"
  else
    echo "notion"
  fi
}

# Detect content density
detect_content_density() {
  local content="$1"
  local word_count=$(echo "$content" | wc -w | awk '{print $1}')
  
  if [[ $word_count -lt 100 ]]; then
    echo "sparse"
  elif [[ $word_count -lt 300 ]]; then
    echo "balanced"
  else
    echo "dense"
  fi
}

# Get preset for content
get_preset_for_content() {
  local content="$1"
  local style=$(detect_content_signal "$content")
  
  case "$style" in
    notion)
      echo "knowledge-card"
      ;;
    cute)
      echo "cute-share"
      ;;
    warm)
      echo "cozy-story"
      ;;
    bold)
      echo "warning"
      ;;
    minimal)
      echo "clean-quote"
      ;;
    *)
      echo "knowledge-card"
      ;;
  esac
}

# Parse preset style
get_preset_style() {
  local preset="$1"
  case "$preset" in
    knowledge-card|checklist|concept-map|swot)
      echo "notion"
      ;;
    tutorial|classroom)
      echo "chalkboard"
      ;;
    study-guide)
      echo "study-notes"
      ;;
    cute-share|girly)
      echo "cute"
      ;;
    cozy-story)
      echo "warm"
      ;;
    product-review|nature-flow)
      echo "fresh"
      ;;
    warning|versus)
      echo "bold"
      ;;
    clean-quote|pro-summary)
      echo "minimal"
      ;;
    retro-ranking|throwback)
      echo "retro"
      ;;
    pop-facts|hype)
      echo "pop"
      ;;
    poster|editorial|cinematic)
      echo "screen-print"
      ;;
    *)
      echo "notion"
      ;;
  esac
}

# Parse preset layout
get_preset_layout() {
  local preset="$1"
  case "$preset" in
    knowledge-card|study-guide)
      echo "dense"
      ;;
    checklist|retro-ranking|pop-facts|warning)
      echo "list"
      ;;
    concept-map)
      echo "mindmap"
      ;;
    swot)
      echo "quadrant"
      ;;
    tutorial|nature-flow)
      echo "flow"
      ;;
    classroom|cozy-story|cute-share|throwback|pro-summary|editorial)
      echo "balanced"
      ;;
    girly|hype|clean-quote|poster)
      echo "sparse"
      ;;
    product-review|versus|cinematic)
      echo "comparison"
      ;;
    *)
      echo "balanced"
      ;;
  esac
}

# Choose best strategy
choose_best_strategy() {
  local content="$1"
  
  if echo "$content" | grep -qiE "(测评|体验|分享|review|experience)"; then
    echo "story-driven"
  elif echo "$content" | grep -qiE "(教程|指南|步骤|tutorial|guide)"; then
    echo "information-dense"
  else
    echo "information-dense"
  fi
}

# Generate outline
generate_outline() {
  local content="$1"
  local strategy="$2"
  local style="$3"
  local layout="$4"
  
  case "$strategy" in
    story-driven)
      echo "# 大纲：故事驱动型

## 1. Hook（吸引点）
- 抓住注意力的开头
- 设置悬念或痛点

## 2. Problem（问题）
- 描述遇到的困难
- 引起共鸣

## 3. Discovery（发现）
- 发现解决方案的过程
- 转折点

## 4. Experience（体验）
- 使用体验
- 变化对比

## 5. Conclusion（结论）
- 总结收获
- 行动召唤"
      ;;
    information-dense)
      echo "# 大纲：信息密集型

## 1. 核心结论
- 最重要的一点
- 直接给出答案

## 2. 信息卡 1
- 关键点 1
- 详细说明

## 3. 信息卡 2
- 关键点 2
- 详细说明

## 4. 信息卡 3
- 关键点 3
- 详细说明

## 5. 优缺点
- 优点列表
- 缺点列表

## 6. 推荐
- 最终建议
- 适用场景"
      ;;
    *)
      echo "# 大纲

## 1. 引入
- 开头介绍

## 2. 主体
- 主要内容

## 3. 总结
- 结论"
      ;;
  esac
}

# Estimate series length
estimate_series_length() {
  local outline="$1"
  local layout="$2"
  
  case "$layout" in
    sparse)
      echo 3
      ;;
    balanced)
      echo 5
      ;;
    dense|list)
      echo 7
      ;;
    *)
      echo 5
      ;;
  esac
}

# Generate slug
generate_slug() {
  local content="$1"
  # Extract first 2-4 meaningful words
  echo "$content" | head -5 | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | head -c 30
}

# Split content into chunks
split_content_into_chunks() {
  local outline="$1"
  local count="$2"
  
  # Split outline into sections
  echo "$outline" | grep "^##" | while read line; do
    echo "$line"
    echo "${line### }"
  done | head -n $((count * 2))
}

# Generate XHS image (placeholder - would call visual-generator)
generate_xhs_image() {
  local content=""
  local style=""
  local layout=""
  local position=""
  local output=""
  
  # Placeholder: would call visual-generator with XHS-specific parameters
  # For now, just create a placeholder image
  
  # TODO: Integrate with visual-generator
  # bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/generate.sh \
  #   "$content" \
  #   --style "$style" \
  #   --layout "$layout" \
  #   --output "$output"
  
  # Create placeholder
  convert -size 1080x1440 xc:white \
    -pointsize 48 -fill black -gravity center \
    -annotate 0 "XHS Image\nStyle: $style\nLayout: $layout\nPosition: $position" \
    "$output" 2>/dev/null || echo "# XHS Image\nStyle: $style\nLayout: $layout" > "$output.txt"
}
