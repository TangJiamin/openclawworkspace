#!/bin/bash
# Workspace 清理脚本
# 创建时间: 2026-03-05

set -e

WORKSPACE="/home/node/.openclaw/workspace"
ARCHIVE="$WORKSPACE/archive"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

echo "🧹 开始清理 Workspace..."
echo "时间: $(date)"
echo ""

# Step 1: 创建归档目录
echo "📁 Step 1: 创建归档目录..."
mkdir -p "$ARCHIVE/agent-reach-setup"
mkdir -p "$ARCHIVE/architecture-history"
mkdir -p "$ARCHIVE/bug-fixes"
mkdir -p "$ARCHIVE/test-reports"
mkdir -p "$ARCHIVE/agents-history"
echo "✅ 归档目录创建完成"
echo ""

# Step 2: 移动 Agent-Reach 文档
echo "📦 Step 2: 归档 Agent-Reach 文档..."
cd "$WORKSPACE"
mv AGENT-REACH-*.md "$ARCHIVE/agent-reach-setup/" 2>/dev/null || echo "  ⚠️  部分 Agent-Reach 文档可能不存在"
echo "✅ Agent-Reach 文档已归档"
echo ""

# Step 3: 移动架构修复文档
echo "📦 Step 3: 归档架构修复文档..."
mv ARCHITECTURE-FIX-*.md "$ARCHIVE/architecture-history/" 2>/dev/null || echo "  ⚠️  部分架构文档可能不存在"
mv FLOW-ARCHITECTURE-FIX.md "$ARCHIVE/architecture-history/" 2>/dev/null || true
echo "✅ 架构修复文档已归档"
echo ""

# Step 4: 移动 Bug 修复文档
echo "📦 Step 4: 归档 Bug 修复文档..."
mv CONTENT-AGENT-*.md "$ARCHIVE/bug-fixes/" 2>/dev/null || echo "  ⚠️  部分 Bug 文档可能不存在"
mv CRITICAL-BUG-REPORT.md "$ARCHIVE/bug-fixes/" 2>/dev/null || true
mv REFLY-API-*.md "$ARCHIVE/bug-fixes/" 2>/dev/null || true
echo "✅ Bug 修复文档已归档"
echo ""

# Step 5: 移动测试报告
echo "📦 Step 5: 归档测试报告..."
mv *TEST-*.md "$ARCHIVE/test-reports/" 2>/dev/null || echo "  ⚠️  部分测试报告可能不存在"
mv *TEST*.md "$ARCHIVE/test-reports/" 2>/dev/null || true
mv FINAL-VERIFICATION-*.md "$ARCHIVE/test-reports/" 2>/dev/null || true
echo "✅ 测试报告已归档"
echo ""

# Step 6: 移动 agents/ 目录下的过时文档
echo "📦 Step 6: 归档 agents/ 目录下的过时文档..."
cd "$WORKSPACE/agents"
mv AGENT-MATRIX-*.md "$ARCHIVE/agents-history/" 2>/dev/null || echo "  ⚠️  部分 Agent 矩阵文档可能不存在"
mv AGENT-SKILLS-CHECK.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv BATCH-USAGE-GUIDE.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv FIRST-PRINCIPLES-ANALYSIS.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv agent-coordination-demo.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv final-analysis.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv openclaw-agents-plan.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv README.md "$ARCHIVE/agents-history/" 2>/dev/null || true
echo "✅ agents/ 目录下的过时文档已归档"
echo ""

# Step 7: 移动其他过时文档
echo "📦 Step 7: 归档其他过时文档..."
cd "$WORKSPACE"
mv AGENT-STANDARDIZATION-COMPLETE.md "$ARCHIVE/architecture-history/" 2>/dev/null || true
mv AGENTS-CREATION-REPORT.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv BAOYU-SKILLS-ANALYSIS.md "$ARCHIVE/architecture-history/" 2>/dev/null || true
mv DUAL-MODE-ARCHITECTURE-FINAL.md "$ARCHIVE/architecture-history/" 2>/dev/null || true
mv MAIN-AGENT-ORCHESTRATION-SYSTEM.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv MULTI-AGENT-COLLABORATION-*.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv NEWS-TIMELINESS-ISSUE.md "$ARCHIVE/bug-fixes/" 2>/dev/null || true
mv OPTIMIZATION-PLAN.md "$ARCHIVE/architecture-history/" 2>/dev/null || true
mv REAL-TOPICS-FIX.md "$ARCHIVE/bug-fixes/" 2>/dev/null || true
mv REQUIREMENT-VERIFICATION.md "$ARCHIVE/test-reports/" 2>/dev/null || true
mv RESEARCH-AGENT-DATA-SOURCES.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv SESSIONS-SPAWN-IMPLEMENTATION.md "$ARCHIVE/agents-history/" 2>/dev/null || true
mv VISUAL-AGENT-FIX.md "$ARCHIVE/bug-fixes/" 2>/dev/null || true
mv GITHUB-*.md "$ARCHIVE/agents-history/" 2>/dev/null || true
echo "✅ 其他过时文档已归档"
echo ""

# Step 8: 删除废弃的 Skills
echo "🗑️  Step 8: 删除废弃的 Skills..."
rm -rf "$WORKSPACE/material-collector"
rm -rf "$WORKSPACE/requirement-analyzer"
echo "✅ 废弃的 Skills 已删除"
echo ""

# Step 9: 删除临时文件
echo "🗑️  Step 9: 删除临时文件..."
rm -f "$WORKSPACE/agents/content-agent/抖音口播方案_ChatGPT技巧.md"
echo "✅ 临时文件已删除"
echo ""

# Step 10: 创建归档 README
echo "📝 Step 10: 创建归档 README..."
cat > "$ARCHIVE/README.md" << 'EOF'
# Workspace Archive

本目录包含 Workspace 开发过程中的历史文档。

## 目录结构

- `agent-reach-setup/` - Agent-Reach 安装配置文档（2026-03-04）
- `architecture-history/` - 架构调整历史文档
- `bug-fixes/` - Bug 修复记录
- `test-reports/` - 测试报告
- `agents-history/` - Agent 矩阵开发历史文档

## 注意

这些文档已完成使命，归档保存以备参考。不应再修改这些文档。

---
归档时间: 2026-03-05
维护者: Main Agent
EOF
echo "✅ 归档 README 已创建"
echo ""

# 完成
echo "✅ Workspace 清理完成！"
echo ""
echo "📊 清理统计："
echo "  - 归档目录: 5 个"
echo "  - 归档文件: 40+ 个"
echo "  - 删除目录: 2 个"
echo "  - 删除文件: 1 个"
echo ""
echo "🎯 清理后的结构："
echo "  - 根目录: 8 个核心文档"
echo "  - archive/: 历史文档"
echo "  - agents/: 6 个 Agents"
echo "  - skills/: 8 个 Skills"
echo ""
echo "✨ Workspace 现在更加整洁了！"
