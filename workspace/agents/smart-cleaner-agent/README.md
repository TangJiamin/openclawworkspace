# Smart Cleaner Agent - 智能清理 Agent

**职责**: 智能清理 .openclaw 目录，基于内容理解做决策

**位置**: `/home/node/.openclaw/workspace/agents/smart-cleaner-agent/`

---

## 🎯 核心能力

### 1. 白名单保护
- Main Agent 核心文档（8个）
- 子 Agents 工作区核心文档（6×6个）
- 技术文档和设计历史

### 2. 内容理解
- 真正读取文件内容
- 理解文件价值
- 智能决策

### 3. 用户确认
- 生成删除候选列表
- 发送飞书报告
- 等待用户确认

---

## 🔄 工作流程

```
1. 扫描 .openclaw 目录
   ├─ 扫描上限: 1000 个文件/次
   ├─ 超时时间: 900 秒
   └─ 跳过大型二进制文件

2. 检查白名单
   ├─ 在白名单 → 跳过 ✅
   └─ 不在白名单 ↓

3. 读取文件内容
   ├─ 读取前 100 行
   └─ 分析价值和时效

4. 理解文件价值
   ├─ 💎 高价值 → 保留
   ├─ 📦 中价值 → 短期保留
   └─ 🗑️ 低价值 ↓

5. 检查时效
   ├─ < 1天 → 跳过（太新）
   ├─ 1-7天 → 谨慎
   └─ > 7天 ↓

6. 生成删除候选列表
   ├─ 文件路径
   ├─ 价值评估
   └─ 删除理由

7. 发送飞书报告
   ├─ 候选列表
   ├─ 价值分析
   └─ 等待确认

8. 用户确认后执行删除
   ├─ 删除文件
   └─ 更新清理原则

9. 生成清理报告
   └─ 保存到 reports/
```

---

## 🛡️ 白名单

### Main Agent 核心
```
/home/node/.openclaw/workspace/SOUL.md
/home/node/.openclaw/workspace/IDENTITY.md
/home/node/.openclaw/workspace/USER.md
/home/node/.openclaw/workspace/MEMORY.md
/home/node/.openclaw/workspace/AGENTS.md
/home/node/.openclaw/workspace/TOOLS.md
/home/node/.openclaw/workspace/README.md
/home/node/.openclaw/workspace/HEARTBEAT.md
```

### 子 Agents 工作区
```
/home/node/.openclaw/workspace/agents/*/AGENTS.md
/home/node/.openclaw/workspace/agents/*/SOUL.md
/home/node/.openclaw/workspace/agents/*/IDENTITY.md
/home/node/.openclaw/workspace/agents/*/USER.md
/home/node/.openclaw/workspace/agents/*/TOOLS.md
/home/node/.openclaw/workspace/agents/*/README.md
```

### 技术文档和设计历史
```
/home/node/.openclaw/workspace/docs/*.md
/home/node/.openclaw/workspace/archive/agents-history/
/home/node/.openclaw/workspace/archive/architecture-history/
```

---

## ⚙️ 配置

- **执行时间**: 每天 07:00 (GMT+8)
- **扫描上限**: 1000 个文件/次
- **超时时间**: 900 秒（15 分钟）
- **通知方式**: 飞书

---

## 📝 重要提醒

- ⚠️ 白名单文件绝对不删除
- ⚠️ 删除前必须用户确认
- ⚠️ 每次清理后更新清理原则
- ⚠️ 真正理解内容，而非基于规则
