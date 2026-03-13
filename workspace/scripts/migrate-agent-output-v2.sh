#!/bin/bash
# Agent Output 完整迁移脚本 v2
# 更新所有 Agents 使用统一的产出管理工具

set -e

WORKSPACE="/home/node/.openclaw/workspace"
AGENTS_BASE="$WORKSPACE/agents"

echo "🔄 Agent Output 完整迁移工具 v2"
echo "==============================="
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
    # 检查是否已更新
    if grep -q "agent-output-tool.sh" "$XHS_SCRIPT"; then
        echo "  ⏭️  已更新: $XHS_SCRIPT"
    else
        # 备份原文件
        cp "$XHS_SCRIPT" "${XHS_SCRIPT}.backup.$(date +%Y%m%d-%H%M%S)"

        # 替换 OUTPUT_DIR 创建方式
        sed -i 's|OUTPUT_DIR="${SCRIPT_DIR}/output/xhs_9grid_$(date +%Y%m%d_%H%M%S)"|OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create visual-agent)|g' "$XHS_SCRIPT"
        # 删除 mkdir -p 行
        sed -i '/mkdir -p "$OUTPUT_DIR"/d' "$XHS_SCRIPT"

        echo "  ✅ 已更新: $XHS_SCRIPT"
        echo "  📦 备份: ${XHS_SCRIPT}.backup.$(date +%Y%m%d-%H%M%S)"
    fi
else
    echo "  ⚠️  文件不存在: $XHS_SCRIPT"
fi

echo ""

# Step 3: 创建 Agent 使用示例
echo "📄 Step 3: 创建 Agent 使用示例"

cat > "$AGENTS_BASE/research-agent/output-example.sh" << 'EOF'
#!/bin/bash
# research-agent 产出管理示例

# 创建产出目录（自动生成时间戳任务ID）
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create research-agent)

# 写入产出文件
cat > "$OUTPUT_DIR/data.json" << 'DATA'
{
  "sources": [
    {
      "title": "示例标题",
      "url": "https://example.com",
      "published_at": "2026-03-12"
    }
  ],
  "summary": "这是研究总结"
}
DATA

cat > "$OUTPUT_DIR/summary.md" << 'MD'
# 研究总结

## 资料来源

1. [示例标题](https://example.com)

## 核心发现

- 发现1
- 发现2
MD

echo "✅ 产出已保存到: $OUTPUT_DIR"
echo "📊 任务目录: $(basename $OUTPUT_DIR)"
EOF

chmod +x "$AGENTS_BASE/research-agent/output-example.sh"
echo "  ✅ 创建: research-agent/output-example.sh"

echo ""

# Step 4: 更新文档
echo "📝 Step 4: 更新 AGENTS.md 文档提示"

cat > "$WORKSPACE/docs/AGENT-OUTPUT-QUICK-START.md" << 'EOF'
# Agent Output 快速开始

## 使用方法

### 在 Agent 脚本中

```bash
#!/bin/bash

# 创建产出目录（自动生成时间戳任务ID）
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create research-agent)

# 写入产出文件
cat > "$OUTPUT_DIR/result.json" << 'EOF'
{...}
EOF

echo "✅ 产出已保存到: $OUTPUT_DIR"
```

### 列出所有 Agent 产出

```bash
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list
```

### 清理旧产出

```bash
# 清理7天前的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean research-agent 7
```

## 目录结构

```
agents/
├── research-agent/
│   ├── output/
│   │   ├── task-20260312-092307/
│   │   │   ├── data.json
│   │   │   └── summary.md
│   │   └── task-20260312-103000/
│   │       └── ...
│   └── ...
└── content-agent/
    └── ...
```

## 详细文档

- 完整指南: `docs/AGENT-OUTPUT-GUIDE.md`
- 迁移指南: `docs/AGENT-OUTPUT-MIGRATION.md`
EOF

echo "  ✅ 创建: docs/AGENT-OUTPUT-QUICK-START.md"

echo ""

# Step 5: 列出所有 Agent 的产出
echo "📊 Step 5: 列出所有 Agent 的产出"
echo ""

bash "$WORKSPACE/scripts/agent-output-tool.sh" list

echo ""
echo "✅ 迁移完成！"
echo ""
echo "📝 已完成："
echo "  ✅ 创建缺失的 output 目录"
echo "  ✅ 更新 visual-agent 脚本"
echo "  ✅ 创建使用示例脚本"
echo "  ✅ 创建快速开始文档"
echo ""
echo "📝 下一步："
echo "  1. 查看示例: cat agents/research-agent/output-example.sh"
echo "  2. 阅读快速开始: docs/AGENT-OUTPUT-QUICK-START.md"
echo "  3. 更新其他 Agents（参考示例）"
echo "  4. 测试更新后的脚本"
