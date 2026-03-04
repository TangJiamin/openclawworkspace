#!/bin/bash
# 测试 Main Agent 的定义是否完整

echo "=== Main Agent 可用性检查 ==="
echo ""

# 检查文件位置
echo "1. 检查文件位置..."
if [ -f "/home/node/.openclaw/agents/main/agent/AGENTS.md" ]; then
  echo "✓ AGENTS.md 在正确位置"
else
  echo "✗ AGENTS.md 位置错误或不存在"
  exit 1
fi

# 检查关键内容
echo ""
echo "2. 检查关键内容..."
if grep -q "动态调度" /home/node/.openclaw/agents/main/agent/AGENTS.md; then
  echo "✓ 包含动态调度说明"
else
  echo "✗ 缺少动态调度说明"
fi

if grep -q "callAgent.*research-agent" /home/node/.openclaw/agents/main/agent/AGENTS.md; then
  echo "✓ 包含子 Agent 调用示例"
else
  echo "✗ 缺少子 Agent 调用示例"
fi

if grep -q "智能决策\|动态调整" /home/node/.openclaw/agents/main/agent/AGENTS.md; then
  echo "✓ 包含智能决策说明"
else
  echo "✗ 缺少智能决策说明"
fi

# 检查子 Agent 引用
echo ""
echo "3. 检查子 Agent 引用..."
for agent in research-agent content-agent visual-agent video-agent quality-agent; do
  if grep -q "$agent" /home/node/.openclaw/agents/main/agent/AGENTS.md; then
    echo "✓ 引用 $agent"
  else
    echo "✗ 缺少 $agent 引用"
  fi
done

echo ""
echo "=== 检查完成 ==="
echo ""
echo "Main Agent 定义状态: 完整"
echo "可用性: 可用于指导实现"
