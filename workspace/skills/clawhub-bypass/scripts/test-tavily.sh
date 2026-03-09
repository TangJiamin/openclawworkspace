#!/bin/bash
# 测试 Tavily Search 技能

echo "🔍 测试 Tavily Search"
echo "=================="
echo ""

# 检查 API Key
if [ -z "$TAVILY_API_KEY" ]; then
  echo "❌ 错误: TAVILY_API_KEY 环境变量未设置"
  echo ""
  echo "请先配置 API Key:"
  echo "  export TAVILY_API_KEY=\"your-key\""
  echo ""
  echo "详细说明: /home/node/.openclaw/workspace/skills/clawhub-bypass/API-KEYS-CONFIG.md"
  exit 1
fi

echo "✅ API Key 已配置"
echo ""

# 测试搜索
echo "📊 测试 1: 基础搜索"
echo "查询: AI agents"
echo ""

node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "AI agents" 2>&1

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ 基础搜索测试通过"
else
  echo ""
  echo "❌ 基础搜索测试失败"
  exit 1
fi

echo ""
echo "=================="
echo "📊 测试 2: 深度搜索"
echo "查询: artificial intelligence latest developments"
echo ""

node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "artificial intelligence latest developments" --deep -n 3 2>&1

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ 深度搜索测试通过"
else
  echo ""
  echo "❌ 深度搜索测试失败"
  exit 1
fi

echo ""
echo "=================="
echo "✅ 所有测试通过！"
echo ""
echo "Tavily Search 技能可用"
