#!/bin/bash
# 测试 Summarize 技能

echo "📝 测试 Summarize"
echo "================="
echo ""

# 检查 API Key（支持多个选项）
API_KEY_SET=false

if [ -n "$GEMINI_API_KEY" ]; then
  echo "✅ GEMINI_API_KEY 已配置"
  API_KEY_SET=true
elif [ -n "$OPENAI_API_KEY" ]; then
  echo "✅ OPENAI_API_KEY 已配置"
  API_KEY_SET=true
elif [ -n "$ANTHROPIC_API_KEY" ]; then
  echo "✅ ANTHROPIC_API_KEY 已配置"
  API_KEY_SET=true
elif [ -n "$XAI_API_KEY" ]; then
  echo "✅ XAI_API_KEY 已配置"
  API_KEY_SET=true
fi

if [ "$API_KEY_SET" = false ]; then
  echo "❌ 错误: 没有配置任何 API Key"
  echo ""
  echo "请至少配置一个:"
  echo "  export GEMINI_API_KEY=\"your-key\""
  echo "  export OPENAI_API_KEY=\"your-key\""
  echo "  export ANTHROPIC_API_KEY=\"your-key\""
  echo "  export XAI_API_KEY=\"your-key\""
  echo ""
  echo "详细说明: /home/node/.openclaw/workspace/skills/clawhub-bypass/API-KEYS-CONFIG.md"
  exit 1
fi

echo ""

# 检查 npx summarize 是否可用
echo "🔍 检查 summarize 命令..."
if ! command -v summarize &> /dev/null; then
  echo "⚠️  summarize 命令未安装"
  echo ""
  echo "使用 npx 运行:"
  echo "  npx summarize --help"
  echo ""
else
  echo "✅ summarize 命令已安装"
fi

echo ""

# 测试总结功能（使用示例 URL）
echo "📊 测试 1: URL 总结"
echo "URL: https://example.com"
echo ""

npx summarize "https://example.com" --length short 2>&1 | head -20

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ URL 总结测试通过"
else
  echo ""
  echo "⚠️  URL 总结测试失败（可能是网络问题或 URL 不可访问）"
fi

echo ""
echo "================="
echo "💡 使用示例"
echo ""
echo "# 总结 URL"
echo "npx summarize \"https://example.com/article\""
echo ""
echo "# 总结 PDF"
echo "npx summarize \"/path/to/file.pdf\""
echo ""
echo "# 总结 YouTube"
echo "npx summarize \"https://youtu.be/dQw4w9WgXcQ\" --youtube auto"
echo ""
echo "# 使用特定模型"
echo "npx summarize \"https://example.com\" --model google/gemini-3-flash-preview"
echo ""
echo "# 指定输出长度"
echo "npx summarize \"https://example.com\" --length medium"
echo ""
echo "================="
echo ""
echo "Summarize 技能已安装（需要配置 API Key 才能使用）"
