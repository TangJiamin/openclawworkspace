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
