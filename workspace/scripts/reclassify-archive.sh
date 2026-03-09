#!/bin/bash
# Archive 重新分类脚本
# 创建时间: 2026-03-05

set -e

WORKSPACE="/home/node/.openclaw/workspace"
ARCHIVE="$WORKSPACE/archive"

echo "📋 重新分类 Archive..."
echo "时间: $(date)"
echo ""

# Step 1: 创建 temp/ 目录
echo "📁 Step 1: 创建 temp/ 目录..."
mkdir -p "$ARCHIVE/temp/bug-fixes"
mkdir -p "$ARCHIVE/temp/test-reports"
echo "✅ temp/ 目录创建完成"
echo ""

# Step 2: 移动短期保留的文件
echo "📦 Step 2: 移动短期保留的文件到 temp/..."
if [ -d "$ARCHIVE/bug-fixes" ]; then
    mv "$ARCHIVE/bug-fixes"/* "$ARCHIVE/temp/bug-fixes/" 2>/dev/null || true
    rmdir "$ARCHIVE/bug-fixes" 2>/dev/null || true
    echo "  ✅ bug-fixes/ 已移动到 temp/bug-fixes/"
fi

if [ -d "$ARCHIVE/test-reports" ]; then
    mv "$ARCHIVE/test-reports"/* "$ARCHIVE/temp/test-reports/" 2>/dev/null || true
    rmdir "$ARCHIVE/test-reports" 2>/dev/null || true
    echo "  ✅ test-reports/ 已移动到 temp/test-reports/"
fi
echo ""

# Step 3: 删除无价值文件
echo "🗑️  Step 3: 删除无价值文件..."
if [ -d "$ARCHIVE/agent-reach-setup" ]; then
    rm -rf "$ARCHIVE/agent-reach-setup"
    echo "  ✅ agent-reach-setup/ 已删除（9 个文件）"
fi

# 删除 GitHub 相关文件（如果在其他目录）
find "$ARCHIVE" -name "GITHUB-*.md" -type f -delete 2>/dev/null || true
echo "  ✅ GitHub 相关文件已删除"
echo ""

# Step 4: 创建 temp/ README
echo "📝 Step 4: 创建 temp/ README..."
cat > "$ARCHIVE/temp/README.md" << 'EOF'
# Temp Archive

本目录包含短期保留的文件，将在 **2026-06-05** 自动删除。

## 目录结构

- `bug-fixes/` - Bug 修复记录（8 个文件）
- `test-reports/` - 测试报告（11 个文件）

## 清理计划

**删除日期**: 2026-06-05
**保留期限**: 3 个月

这些文件短期内可能有参考价值，但超过 3 个月后基本不会再看。

---
创建时间: 2026-03-05
维护者: Main Agent
EOF
echo "✅ temp/ README 已创建"
echo ""

# Step 5: 更新主 README
echo "📝 Step 5: 更新主 README..."
cat > "$ARCHIVE/README.md" << 'EOF'
# Workspace Archive

本目录包含 Workspace 开发过程中的历史文档。

## 📚 长期保留

### agents-history/
Agent 矩阵的设计历史，记录了重要的架构决策（17 个文件）。

### architecture-history/
架构调整历史，记录了重要的设计决策（7 个文件）。

---

## 🗑️ 短期保留（temp/）

这些文件将在 **2026-06-05** 自动删除：

- `temp/bug-fixes/` - Bug 修复记录（8 个文件）
- `temp/test-reports/` - 测试报告（11 个文件）

---
更新时间: 2026-03-05
维护者: Main Agent
EOF
echo "✅ 主 README 已更新"
echo ""

# 完成
echo "✅ Archive 重新分类完成！"
echo ""
echo "📊 统计："
echo "  - 删除文件: 11 个（agent-reach-setup + GitHub 相关）"
echo "  - 短期保留: 19 个（移动到 temp/）"
echo "  - 长期保留: 24 个（agents-history + architecture-history）"
echo ""
echo "🎯 新结构："
echo "  - archive/agents-history/ (长期)"
echo "  - archive/architecture-history/ (长期)"
echo "  - archive/temp/ (2026-06-05 删除)"
echo ""
echo "⚠️  下一步："
echo "  1. 更新清理白名单（只保护长期保留的目录）"
echo "  2. 添加定时清理任务（2026-06-05 删除 temp/）"
