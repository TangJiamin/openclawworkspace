#!/bin/bash
# Agent Output 批量更新脚本
# 为所有 Agents 添加产出管理说明

set -e

WORKSPACE="/home/node/.openclaw/workspace"
AGENTS_BASE="$WORKSPACE/agents"

echo "🔄 更新所有 Agents 的产出管理"
echo "================================"
echo ""

# Agent 列表
AGENTS=("research-agent" "content-agent" "visual-agent" "video-agent" "quality-agent" "requirement-agent")

# 为每个 Agent 的 AGENTS.md 添加产出管理说明
for agent in "${AGENTS[@]}"; do
    agents_file="$AGENTS_BASE/$agent/AGENTS.md"

    if [ -f "$agents_file" ]; then
        echo "📝 更新: $agent/AGENTS.md"

        # 检查是否已有产出管理说明
        if grep -q "## 📁 产出管理" "$agents_file"; then
            echo "  ⏭️  已有产出管理说明，跳过"
        else
            # 添加产出管理说明
            cat >> "$agents_file" << 'EOF'

---

## 📁 产出管理

### 目录结构

```
agents/$(AGENT_NAME)/
└── output/
    └── task-YYYYMMDD-HHMMSS/
        ├── data.json
        ├── summary.md
        └── ...
```

### 使用方法

```bash
# 创建产出目录（自动生成时间戳任务ID）
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create $(AGENT_NAME))

# 写入产出文件
cat > "$OUTPUT_DIR/result.json" << 'DATA'
{
  "status": "success",
  "data": {...}
}
DATA

echo "✅ 产出已保存到: $OUTPUT_DIR"
```

### 列出产出

```bash
# 列出所有 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list

# 列出当前 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list $(AGENT_NAME)
```

### 清理旧产出

```bash
# 清理7天前的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean $(AGENT_NAME) 7
```

### 详细文档

- 快速开始: `docs/AGENT-OUTPUT-QUICK-START.md`
- 完整指南: `docs/AGENT-OUTPUT-GUIDE.md`
EOF

            echo "  ✅ 已添加产出管理说明"
        fi
    else
        echo "⚠️  文件不存在: $agents_file"
    fi

    echo ""
done

echo "✅ 更新完成！"
echo ""
echo "📝 已为以下 Agents 添加产出管理说明："
for agent in "${AGENTS[@]}"; do
    echo "  - $agent"
done
echo ""
echo "📚 查看快速开始: docs/AGENT-OUTPUT-QUICK-START.md"
