#!/bin/bash
# 测试所有已安装的技能

echo "🧪 技能测试套件"
echo "================"
echo ""

# 测试计数
PASS=0
FAIL=0

# 测试 Tavily Search
echo "📦 [1/3] 测试 Tavily Search"
echo "-----------------------------------"
bash /home/node/.openclaw/workspace/skills/clawhub-bypass/scripts/test-tavily.sh
if [ $? -eq 0 ]; then
  PASS=$((PASS + 1))
  echo "✅ Tavily Search: 通过"
else
  FAIL=$((FAIL + 1))
  echo "❌ Tavily Search: 失败"
fi
echo ""
echo ""

# 测试 Summarize
echo "📦 [2/3] 测试 Summarize"
echo "-----------------------------------"
bash /home/node/.openclaw/workspace/skills/clawhub-bypass/scripts/test-summarize.sh
if [ $? -eq 0 ]; then
  PASS=$((PASS + 1))
  echo "✅ Summarize: 通过"
else
  FAIL=$((FAIL + 1))
  echo "❌ Summarize: 失败"
fi
echo ""
echo ""

# 测试 Find Skills
echo "📦 [3/3] 测试 Find Skills"
echo "-----------------------------------"
bash /home/node/.openclaw/workspace/skills/clawhub-bypass/scripts/test-find-skills.sh
if [ $? -eq 0 ]; then
  PASS=$((PASS + 1))
  echo "✅ Find Skills: 通过"
else
  FAIL=$((FAIL + 1))
  echo "❌ Find Skills: 失败"
fi
echo ""
echo ""

# 总结
echo "================"
echo "📊 测试总结"
echo "通过: $PASS/3"
echo "失败: $FAIL/3"
echo ""

if [ $FAIL -eq 0 ]; then
  echo "🎉 所有技能测试通过！"
  echo ""
  echo "下一步: 集成到 Agent 矩阵"
  exit 0
else
  echo "⚠️  部分技能测试失败"
  echo ""
  echo "请检查:"
  echo "  1. API Keys 是否正确配置"
  echo "  2. 网络连接是否正常"
  echo "  3. 技能文件是否完整"
  exit 1
fi
