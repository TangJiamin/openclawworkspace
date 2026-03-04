#!/bin/bash
# visual-generator v2.0 - 智能推荐脚本

set -e

# 引入分析函数
source /home/node/.openclaw/workspace/skills/visual-generator/scripts/analyze.sh

# 主函数
main() {
  local content="$1"
  auto_mode="${2:-true}"
  
  if [ -z "$content" ]; then
    echo "使用方法: bash scripts/recommend.sh \"内容\" [auto]"
    exit 1
  fi
  
  echo "# 🎨 Visual Generator v2.0 - 智能推荐"
  echo ""
  echo "**输入**: $content"
  echo "**模式**: $auto_mode"
  echo ""
  
  # 分析内容
  analyze_content "$content"
  
  # 推荐参数
  if [ "$auto_mode" = "true" ]; then
    # 自动模式：直接生成推荐
    recommend_params "$CONTENT_TYPE" "$TONE" "$COMPLEXITY"
  else
    # 交互模式：询问用户
    echo ""
    "是否接受推荐？（y/n/r 输入自定义参数）"
    read -r response < /dev/tty
    
    if [ "$response" = "y" ]; then
      echo "✅ 使用推荐参数生成..."
      # 调用生成
    elif [ "$response" = "r" ]; then
      echo "📝 请输入自定义参数"
      echo "风格: (cute/fresh/warm/bold/minimal/tech/nature/elegant/dark)"
      read -r style
      echo "布局: (sparse/balanced/dense/list/comparison/flow/pyramid)"
      read -r layout
      echo ""
      echo "✅ 使用自定义参数: style=$style, layout=$layout"
    else
      echo "⏭  退出"
      exit 0
    fi
  fi
}

main "$@"
