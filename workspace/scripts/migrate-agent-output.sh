#!/bin/bash
# Agent Output 迁移脚本
# 自动更新所有 Agents 使用统一的产出管理工具

set -e

WORKSPACE="/home/node/.openclaw/workspace"
AGENTS_BASE="$WORKSPACE/agents"

echo "🔄 Agent Output 迁移工具"
echo "========================"
echo ""

# Step 1: 创建缺失的 output 目录
echo "📁 Step 1: 创建缺失的 output 目录"

for agent in video-agent quality-agent requirement-agent; do
    agent_dir="$AGENTS_BASE/$agent"
    output_dir="$agent_dir/output"

    if [ ! -d "$output_dir" ]; then
        mkdir -p "$output_dir"
        echo "  ✅ 创建: $output_dir"
    else
        echo "  ⏭️  已存在: $output_dir"
    fi
done

echo ""

# Step 2: 更新 visual-agent 脚本
echo "📝 Step 2: 更新 visual-agent 脚本"

XHS_SCRIPT="$AGENTS_BASE/visual-agent/xhs_generate.sh"

if [ -f "$XHS_SCRIPT" ]; then
    # 备份原文件
    cp "$XHS_SCRIPT" "${XHS_SCRIPT}.backup.$(date +%Y%m%d-%H%M%S)"

    # 替换 OUTPUT_DIR 创建方式
    sed -i 's|OUTPUT_DIR="${SCRIPT_DIR}/output/xhs_9grid_$(date +%Y%m%d_%H%M%S)"|OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create visual-agent)|g' "$XHS_SCRIPT"
    sed -i '/mkdir -p "$OUTPUT_DIR"/d' "$XHS_SCRIPT"

    echo "  ✅ 已更新: $XHS_SCRIPT"
    echo "  📦 备份: ${XHS_SCRIPT}.backup.$(date +%Y%m%d-%H%M%S)"
else
    echo "  ⏭️  文件不存在: $XHS_SCRIPT"
fi

echo ""

# Step 3: 列出所有 Agent 的产出
echo "📊 Step 3: 列出所有 Agent 的产出"
echo ""

bash "$WORKSPACE/scripts/agent-output-tool.sh" list

echo ""
echo "✅ 迁移完成！"
echo ""
echo "📝 下一步："
echo "  1. 检查更新后的脚本是否正常工作"
echo "  2. 更新其他 Agents（content-agent, research-agent 等）"
echo "  3. 验证产出目录结构"
