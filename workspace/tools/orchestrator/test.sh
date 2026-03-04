#!/bin/bash

# Orchestrator 测试脚本
# 测试 sessions_spawn 创建真正的独立 Agent sessions

echo "=== Orchestrator 多 Agent 协同测试 ==="
echo ""
echo "方案 C: 使用 sessions_spawn 创建独立 Agent sessions"
echo ""

# 测试场景
SCENARIO="生成小红书内容，推荐5个提升效率的AI工具"

echo "📝 测试场景: $SCENARIO"
echo ""

echo "🔄 执行流程:"
echo "  1. requirement-agent (需求理解)"
echo "     ↓ 传递结果"
echo "  2. research-agent (资料收集)"
echo "     ↓ 传递结果"
echo "  3. content-agent (内容生产)"
echo "     ↓ 传递结果"
echo "  4. visual-agent (视觉生成)"
echo "     ↓ 传递结果"
echo "  5. quality-agent (质量审核)"
echo ""

echo "🤖 每个 Agent 都是独立的 session:"
echo "  ✅ 有自己的上下文"
echo "  ✅ 有自己的记忆"
echo "  ✅ 独立的超时控制"
echo "  ✅ 真正的并行能力"
echo ""

echo "📝 关键代码:"
echo ""
echo "  // 创建 requirement-agent session"
echo "  const reqSession = await sessions_spawn({"
echo "    task: '你是 requirement-agent。分析需求...',"
echo "    label: 'requirement-agent',"
echo "    agentId: 'main',"
echo "    timeout: 60,"
echo "    thinking: 'low',"
echo "    cleanup: 'keep'"
echo "  });"
echo ""
echo "  // reqSession 是真正的独立 session！"
echo ""

echo "🚀 下一步:"
echo "  1. 在 main Agent 中注册 orchestrate 工具"
echo "  2. 测试 sessions_spawn 功能"
echo "  3. 验证结果传递机制"
echo "  4. 集成真实 API"
echo ""

echo "✅ 架构设计完成！"
echo ""
echo "📍 相关文件:"
echo "  - /home/node/.openclaw/workspace/tools/orchestrator/orchestrator.js"
echo "  - /home/node/.openclaw/workspace/tools/orchestrator/README.md"
echo "  - /home/node/.openclaw/workspace/tools/orchestrator/IMPLEMENTATION.md"
echo ""
echo "🎯 准备开始测试！"
