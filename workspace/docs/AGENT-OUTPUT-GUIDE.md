# Agent Output 统一管理指南 v2.0

## 目录结构

```
agents/
├── research-agent/
│   ├── output/
│   │   ├── task-20260312-092307/       # 时间戳格式: YYYYMMDD-HHMMSS
│   │   │   ├── .gitkeep
│   │   │   ├── data.json
│   │   │   └── summary.md
│   │   ├── task-20260312-103000/
│   │   │   └── ...
│   │   └── .archive/                   # 归档目录（可选）
│   │       └── task-xxx_archived_xxx.tar.gz
│   ├── AGENTS.md
│   └── scripts/
├── content-agent/
│   ├── output/
│   │   └── task-20260312-094500/
│   └── ...
└── visual-agent/
    └── ...
```

## 设计理念

✅ **独立管理**: 每个 Agent 管理自己的产出
✅ **归属清晰**: 产出的物理位置反映逻辑归属
✅ **易于迁移**: 整个 Agent 目录可以直接移动
✅ **符合直觉**: Agent 的产出就在 Agent 的目录下

## 使用方法

### 1. 创建产出目录

**自动生成时间戳**（推荐）:
```bash
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create research-agent)
# 输出: /home/node/.openclaw/workspace/agents/research-agent/output/task-20260312-093843
```

**指定任务ID**:
```bash
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create research-agent task-001)
```

### 2. 在 Agent 中使用

```bash
#!/bin/bash
# research-agent 示例

# 创建产出目录
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create research-agent)

# 写入产出文件
cat > "$OUTPUT_DIR/data.json" << 'EOF'
{
  "sources": [...],
  "summary": "..."
}
EOF

cat > "$OUTPUT_DIR/summary.md" << 'EOF'
# 研究总结
EOF

echo "✅ 产出已保存到: $OUTPUT_DIR"
```

### 3. 列出产出

```bash
# 列出所有 Agent
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list

# 列出特定 Agent
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list research-agent
```

**输出示例**:
```
📁 research-agent 的任务产出：

  📦 task-20260312-092307 (2 个文件, 12K)
  📦 task-20260312-103000 (1 个文件, 8K)
```

### 4. 清理旧产出

```bash
# 清理7天前的产出（默认）
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean research-agent

# 清理30天前的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean research-agent 30
```

### 5. 归档任务

```bash
# 归档指定任务到 .archive/ 目录
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh archive research-agent task-20260312-092307
```

## 时间戳格式

- **格式**: `task-YYYYMMDD-HHMMSS`
- **示例**: `task-20260312-093843`
- **时区**: 系统本地时区（Asia/Shanghai）

## 优势

✅ **独立管理**: 每个 Agent 管理自己的产出，不依赖全局目录
✅ **归属清晰**: 产出一目了然是哪个 Agent 的
✅ **易于迁移**: 整个 Agent 目录可以直接移动
✅ **易于维护**: Agent 的所有内容（代码+产出）都在自己的目录下
✅ **符合直觉**: Agent 的产出自然应该在 Agent 的目录下
✅ **任务隔离**: 不同任务的产出完全分离
✅ **追溯性**: 任务ID包含创建时间

## 注意事项

1. **不要手动创建目录**: 始终使用工具脚本创建
2. **不要硬编码路径**: 使用 `$(agent-output-tool.sh create)` 动态获取
3. **定期清理**: 建议每周清理一次旧产出
4. **归档重要任务**: 需要长期保留的任务先归档

## 集成到现有 Agents

### 需要更新的 Agents

- [ ] research-agent
- [ ] content-agent
- [ ] visual-agent
- [ ] video-agent
- [ ] quality-agent
- [ ] requirement-agent

### 更新步骤

1. 找到 Agent 中的产出目录创建代码
2. 替换为 `agent-output-tool.sh`
3. 测试验证

**更新前**:
```bash
OUTPUT_DIR="/home/node/.openclaw/workspace/output/research-$(date +%Y%m%d)"
mkdir -p "$OUTPUT_DIR"
```

**更新后**:
```bash
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create research-agent)
```

## 自动清理任务（可选）

创建定时任务，每周自动清理7天前的产出：

```bash
# 添加到 crontab
0 0 * * 0 bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean research-agent 7
0 0 * * 0 bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean content-agent 7
0 0 * * 0 bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean visual-agent 7
```

## 版本历史

- **v2.0** (2026-03-12): 改为每个 Agent 目录下管理自己的产出
- **v1.0** (2026-03-12): 初始版本（全局 output/ 目录）

## 第一性原理分析

**表象**: 文件组织问题
**本质**: 产出的归属和管理边界
**最优解**: 产出的物理位置应该反映逻辑归属

**关键洞察**:
1. **归属清晰**: Agent 的产出就应该在 Agent 的目录下
2. **边界明确**: 每个 Agent 是独立的单元
3. **更易理解**: 新人一看就知道产出到哪里
