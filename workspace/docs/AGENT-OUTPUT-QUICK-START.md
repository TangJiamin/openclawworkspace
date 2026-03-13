# Agent Output 快速开始

## 使用方法

### 在 Agent 脚本中

```bash
#!/bin/bash

# 创建产出目录（自动生成时间戳任务ID）
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create research-agent)

# 写入产出文件
echo "{...}" > "$OUTPUT_DIR/result.json"

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
