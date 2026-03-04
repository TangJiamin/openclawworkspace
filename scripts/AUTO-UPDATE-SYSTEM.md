# 自动 Agent 更新系统

**目的**: 当学习新能力时，自动识别需要更新的 Agents，并发送更新建议给你确认

---

## 🔄 工作流程

```
1. 学习新能力
   ↓
2. 记录到 capabilities.json
   命令: auto-update-agents.sh register <name> <type> <desc> <agents>
   ↓
3. 生成更新建议
   命令: auto-update-agents.sh suggest
   ↓
4. 发送消息给你（需要手动）
   内容: 哪些 Agents 可以更新，为什么更新
   ↓
5. 等待你的确认
   回复 "确认更新" 或 "查看详情"
   ↓
6. 应用更新
   命令: auto-update-agents.sh apply <suggestions-file>
   ↓
7. Git commit（自动记录）
```

---

## 📋 当前已记录的能力

**agent-reach** (2026-03-04)
- **类型**: data-source
- **描述**: 多平台数据源（YouTube、Reddit、B站、RSS、网页）
- **相关 Agents**: research-agent

---

## 🎯 实际案例：刚才的更新

### 1. 学习新能力
- 学习到 agent-reach 工具
- 支持从 YouTube、Reddit、B站等平台收集数据

### 2. 记录能力
```bash
auto-update-agents.sh register \
  "agent-reach" \
  "data-source" \
  "多平台数据源" \
  '["research-agent"]'
```

### 3. 识别更新机会
- 扫描所有 Agents 配置
- 发现 research-agent 可以受益
- 生成更新建议

### 4. 发送建议消息（下一步）
消息内容：
```
🔔 Agent 更新建议

1 个 Agent 可以更新：

📦 research-agent
   新能力: agent-reach
   建议: 添加 agent-reach 作为数据源
   原因: agent-reach 可以从 YouTube、Reddit、B站等多平台收集资讯

---
回复 '确认更新' 应用这些更新
回复 '查看详情' 查看完整配置差异
```

### 5. 等待确认
- 你回复 "确认更新"
- 或回复 "查看详情"

### 6. 应用更新
```bash
auto-update-agents.sh apply <suggestions-file>
```

### 7. Git 记录
- 自动 commit: "Auto-update: Apply agent capability updates"

---

## 🔧 使用命令

### 初始化系统
```bash
auto-update-agents.sh init
```

### 记录新能力
```bash
auto-update-agents.sh register \
  "能力名称" \
  "能力类型" \
  "能力描述" \
  '["agent1", "agent2"]'
```

### 扫描 Agents
```bash
auto-update-agents.sh scan
```

### 生成建议
```bash
auto-update-agents.sh suggest
```

### 应用更新
```bash
auto-update-agents.sh apply <suggestions-file>
```

---

## 💡 下一步优化

### 自动化消息发送
需要集成消息发送功能：
- Feishu 机器人
- 其他消息渠道

### 更智能的匹配
- 分析 Agent 的 README.md
- 检查 Agent 的依赖关系
- 智能推断哪些 Agent 需要更新

### 版本兼容性检查
- 检查更新是否破坏现有功能
- 建议测试步骤
- 提供回滚方案

---

**维护者**: Main Agent
**状态**: ✅ 核心功能已实现
**下一步**: 集成消息自动发送
