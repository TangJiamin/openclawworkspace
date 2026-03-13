# Agents 工具调用扫描报告

**生成时间**: 2026-03-13 09:05
**目标**: 扫描所有 Agents 的工具调用情况

---

## 扫描结果

### content-agent

**状态**: ✅ 使用外部工具

**工具调用**:
```markdown
```bash
# 创建产出目录（自动生成时间戳任务ID）
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create $(AGENT_NAME))

# 写入产出文件
cat > "$OUTPUT_DIR/result.json" << 'DATA'
--
```bash
# 列出所有 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list

# 列出当前 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list $(AGENT_NAME)
--
```bash
# 清理7天前的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean $(AGENT_NAME) 7
```

### 详细文档
```

---

### quality-agent

**状态**: ✅ 使用外部工具

**工具调用**:
```markdown
```bash
# 创建产出目录（自动生成时间戳任务ID）
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create $(AGENT_NAME))

# 写入产出文件
cat > "$OUTPUT_DIR/result.json" << 'DATA'
--
```bash
# 列出所有 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list

# 列出当前 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list $(AGENT_NAME)
--
```bash
# 清理7天前的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean $(AGENT_NAME) 7
```

### 详细文档
```

---

### requirement-agent

**状态**: ✅ 使用外部工具

**工具调用**:
```markdown
```bash
# 创建产出目录（自动生成时间戳任务ID）
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create $(AGENT_NAME))

# 写入产出文件
cat > "$OUTPUT_DIR/result.json" << 'DATA'
--
```bash
# 列出所有 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list

# 列出当前 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list $(AGENT_NAME)
--
```bash
# 清理7天前的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean $(AGENT_NAME) 7
```

### 详细文档
```

---

### research-agent

**状态**: ✅ 使用外部工具

**工具调用**:
```markdown
```bash
# 创建产出目录（自动生成时间戳任务ID）
OUTPUT_DIR=$(bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh create $(AGENT_NAME))

# 写入产出文件
cat > "$OUTPUT_DIR/result.json" << 'DATA'
--
```bash
# 列出所有 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list

# 列出当前 Agent 的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh list $(AGENT_NAME)
--
```bash
# 清理7天前的产出
bash /home/node/.openclaw/workspace/scripts/agent-output-tool.sh clean $(AGENT_NAME) 7
```

### 详细文档
```

---

### smart-cleaner-agent

**状态**: ⚠️  未使用外部工具

---

### video-agent

**状态**: ✅ 使用外部工具

**工具调用**:
```markdown
```bash
bash /home/node/.openclaw/workspace/agents/video-agent/generate.sh '{
  "image_url": "https://...",
  "prompt": "cinematic video",
  "duration": 5
}'
--
```bash
# 方式 1: 使用环境变量
TASK_SPEC='{"image_url":"https://...","prompt":"cinematic","duration":5}' \
bash /home/node/.openclaw/workspace/agents/video-agent/generate.sh "$TASK_SPEC"

# 方式 2: 直接传入参数
```

---

### visual-agent

**状态**: ✅ 使用外部工具

**工具调用**:
```markdown
```bash
bash /home/node/.openclaw/workspace/agents/visual-agent/generate.sh "$TASK_SPEC"
```

### 步骤 3: 返回图片 URL

--
```bash
# 方式 1: 使用环境变量
TASK_SPEC='{"task_type":"image_generation","style":"cyberpunk"}' \
bash /home/node/.openclaw/workspace/agents/visual-agent/generate.sh "$TASK_SPEC"

# 方式 2: 直接传入参数
```

---


## 统计结果

- **总计 Agents**: 7
- ✅ **使用外部工具**: 6
- ⚠️  **未使用外部工具**: 1

## 优化建议

1. **优先级高**: 检查使用外部工具的 Agents 是否使用了 uv
2. **优先级中**: 检查是否有重复的工具调用逻辑
3. **优先级低**: 考虑将常用工具调用抽取为共享脚本

---

**下一步**:
1. 逐个检查 Agents 的工具调用
2. 更新 AGENTS.md 的工具调用部分
3. 优化常用工具调用
