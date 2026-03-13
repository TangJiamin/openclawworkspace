#!/bin/bash
# 扫描 agents/ 目录并生成工具调用报告
# 2026-03-13

set -e

AGENTS_DIR="$HOME/.openclaw/workspace/agents"
REPORT="$HOME/.openclaw/workspace/tmp/agents-scan-report.md"

# 创建报告目录
mkdir -p "$(dirname "$REPORT")"

# 初始化报告
cat > "$REPORT" << 'EOF'
# Agents 工具调用扫描报告

**生成时间**: 2026-03-13 09:05
**目标**: 扫描所有 Agents 的工具调用情况

---

## 扫描结果

EOF

# 统计变量
total_agents=0
agents_with_tools=0
agents_without_tools=0

echo "================================"
echo "🔍 扫描 Agents 目录"
echo "================================"
echo ""

# 遍历所有 Agents
for agent_dir in "$AGENTS_DIR"/*; do
  if [ ! -d "$agent_dir" ]; then
    continue
  fi

  agent_name=$(basename "$agent_dir")
  agents_file="$agent_dir/AGENTS.md"

  # 跳过没有 AGENTS.md 的目录
  if [ ! -f "$agents_file" ]; then
    continue
  fi

  total_agents=$((total_agents + 1))
  echo "扫描: $agent_name"

  # 添加到报告
  echo "### $agent_name" >> "$REPORT"
  echo "" >> "$REPORT"

  # 检查是否使用了外部工具（bash、python、node、scripts/）
  if grep -qE "bash |python |node |scripts/" "$agents_file" 2>/dev/null; then
    agents_with_tools=$((agents_with_tools + 1))
    echo "  ✅ 使用外部工具"

    echo "**状态**: ✅ 使用外部工具" >> "$REPORT"
    echo "" >> "$REPORT"

    # 提取工具调用
    echo "**工具调用**:" >> "$REPORT"
    echo "\`\`\`markdown" >> "$REPORT"

    # 提取 bash 代码块
    grep -A 5 '```bash' "$agents_file" 2>/dev/null | head -20 >> "$REPORT" || echo "(无 bash 代码块)" >> "$REPORT"

    echo "\`\`\`" >> "$REPORT"
    echo "" >> "$REPORT"
  else
    agents_without_tools=$((agents_without_tools + 1))
    echo "  ⚠️  未使用外部工具"

    echo "**状态**: ⚠️  未使用外部工具" >> "$REPORT"
    echo "" >> "$REPORT"
  fi

  echo "---" >> "$REPORT"
  echo "" >> "$REPORT"
done

# 添加统计
cat >> "$REPORT" << EOF

## 统计结果

- **总计 Agents**: $total_agents
- ✅ **使用外部工具**: $agents_with_tools
- ⚠️  **未使用外部工具**: $agents_without_tools

## 优化建议

1. **优先级高**: 检查使用外部工具的 Agents 是否使用了 uv
2. **优先级中**: 检查是否有重复的工具调用逻辑
3. **优先级低**: 考虑将常用工具调用抽取为共享脚本

---

**下一步**:
1. 逐个检查 Agents 的工具调用
2. 更新 AGENTS.md 的工具调用部分
3. 优化常用工具调用
EOF

# 输出结果
echo ""
echo "================================"
echo "✅ 扫描完成！"
echo "================================"
echo "总计: $total_agents | 使用工具: $agents_with_tools | 未使用工具: $agents_without_tools"
echo ""
echo "📄 详细报告: $REPORT"
echo ""

# 显示报告
cat "$REPORT"
