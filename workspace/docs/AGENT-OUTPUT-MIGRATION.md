# Agent Output 迁移指南

## 目标

将所有 Agents 更新为使用统一的产出管理工具。

## 待更新的 Agents

- [x] research-agent - 已有 output 目录
- [x] content-agent - 已有 output 目录
- [x] visual-agent - 已有 output 目录
- [ ] video-agent - 需要创建
- [ ] quality-agent - 需要创建
- [ ] requirement-agent - 需要创建

## 更新方法

### 方法1: Agent 内部使用（推荐）

在每个 Agent 的任务开始时调用工具创建产出目录：

```bash
#!/bin/bash
# Agent 脚本示例

# 创建产出目录
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create $(basename $(pwd)))

# 写入产出文件
cat > "$OUTPUT_DIR/result.json" << 'EOF'
{...}
EOF

cat > "$OUTPUT_DIR/summary.md" << 'EOF'
# 任务总结
EOF

echo "✅ 产出已保存到: $OUTPUT_DIR"
```

### 方法2: sessions_spawn 传递（备选）

在调用 sessions_spawn 时指定产出目录：

```javascript
// 需要扩展 sessions_spawn 支持
sessions_spawn(
    agent_id="research-agent",
    task="收集资料",
    output_dir="/home/node/.openclaw/workspace/agents/research-agent/output/task-$(date +%Y%m%d-%H%M%S)"
)
```

## 具体更新步骤

### 1. research-agent

**当前状态**: ✅ 已有 `output/` 目录

**需要更新**:
- [ ] 在任务开始时调用 `agent-output-tool.sh create`
- [ ] 将产出写入任务目录而不是直接在 `output/` 下

**示例**:
```bash
# 更新前
OUTPUT_DIR="/home/node/.openclaw/workspace/agents/research-agent/output"
cat > "$OUTPUT_DIR/report.md" << EOF
...
EOF

# 更新后
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create research-agent)
cat > "$OUTPUT_DIR/report.md" << EOF
...
EOF
```

### 2. content-agent

**当前状态**: ✅ 已有 `output/` 目录

**需要更新**: 同 research-agent

### 3. visual-agent

**当前状态**: ✅ 已有 `output/` 目录，但使用旧方式创建目录

**当前代码**（xhs_generate.sh）:
```bash
OUTPUT_DIR="${SCRIPT_DIR}/output/xhs_9grid_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"
```

**需要更新为**:
```bash
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create visual-agent)
```

### 4. video-agent

**当前状态**: ⚠️ 没有 `output/` 目录

**需要更新**:
- [ ] 创建 `agents/video-agent/output/` 目录
- [ ] 在任务开始时调用工具

### 5. quality-agent

**当前状态**: ⚠️ 没有 `output/` 目录

**需要更新**: 同 video-agent

### 6. requirement-agent

**当前状态**: ⚠️ 没有 `output/` 目录

**需要更新**: 同 video-agent

## 优先级

根据使用频率和重要性：

1. **高优先级**（立即更新）:
   - visual-agent（有脚本直接使用）
   - content-agent（频繁使用）

2. **中优先级**（近期更新）:
   - research-agent（频繁使用）
   - quality-agent（质量审核）

3. **低优先级**（按需更新）:
   - video-agent（使用较少）
   - requirement-agent（简单任务）

## 执行计划

```bash
# Step 1: 创建缺失的 output 目录
mkdir -p /home/node/.openclaw/workspace/agents/video-agent/output
mkdir -p /home/node/.openclaw/workspace/agents/quality-agent/output
mkdir -p /home/node/.openclaw/workspace/agents/requirement-agent/output

# Step 2: 更新 visual-agent 脚本
# 编辑 visual-agent/xhs_generate.sh

# Step 3: 更新其他 Agents
# 按优先级逐个更新
```

## 验证

更新后验证：

```bash
# 列出所有 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list

# 应该看到类似输出：
# 🤖 research-agent (2 个任务)
# 🤖 content-agent (1 个任务)
# 🤖 visual-agent (3 个任务)
```

## 注意事项

1. **不要硬编码路径**: 始终使用工具动态创建
2. **保持一致性**: 所有 Agent 使用相同的工具
3. **测试验证**: 更新后测试确保产出正确保存
4. **文档同步**: 更新相关 AGENTS.md 文档

## 版本

v1.0 - 2026-03-12
