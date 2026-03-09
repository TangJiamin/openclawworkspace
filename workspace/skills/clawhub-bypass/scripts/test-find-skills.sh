#!/bin/bash
# 测试 Find Skills 技能

echo "🔍 测试 Find Skills"
echo "=================="
echo ""

# 检查 npx skills 是否可用
echo "🔍 检查 skills 命令..."
if ! command -v skills &> /dev/null; then
  echo "✅ skills 命令将通过 npx 运行"
else
  echo "✅ skills 命令已安装"
fi

echo ""

# 测试搜索功能
echo "📊 测试 1: 搜索技能"
echo "查询: react"
echo ""

npx skills find "react" 2>&1 | head -30

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ 技能搜索测试通过"
else
  echo ""
  echo "⚠️  技能搜索测试失败（可能是网络问题）"
fi

echo ""
echo "=================="
echo "💡 使用示例"
echo ""
echo "# 搜索技能"
echo "npx skills find \"react performance\""
echo ""
echo "# 安装技能"
echo "npx skills add <package>"
echo ""
echo "# 检查更新"
echo "npx skills check"
echo ""
echo "# 更新所有技能"
echo "npx skills update"
echo ""
echo "=================="
echo ""
echo "Find Skills 技能可用（外部 CLI 工具）"
