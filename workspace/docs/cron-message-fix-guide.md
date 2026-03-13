# Cron Job 通知修复指南

**问题**: Cron Jobs 中的 message 调用缺少 `target` 参数
**修复时间**: 2026-03-10 09:15
**优先级**: 🔥 高

---

## 🔍 问题分析

### 当前状态

**Cron Job 配置**（正确）:
```json
{
  "delivery": {
    "mode": "announce",
    "channel": "feishu",
    "to": "ou_42097cc9852e3aae3de5893b96a67219"
  }
}
```

**Agent 执行时的 message 调用**（错误）:
```javascript
message({
  action: "send",
  channel: "feishu",
  // ❌ 缺少 target 参数
  message: "..."
})
```

### 根本原因

Cron Job 配置有 `delivery.to`，但：
1. **Agent 不知道 delivery 配置** - 配置在 Cron Job 层级，Agent 看不到
2. **Agent 需要显式传递 target** - message tool 要求必须提供 target
3. **没有自动填充机制** - 不会自动从 delivery.to 填充到 message.target

---

## ✅ 解决方案

### 方案 1: 修改 Agent 代码（推荐）

在所有 Cron Jobs 的任务描述中添加明确的 target 说明。

#### 修复示例

**修复前**（智能清理任务）:
```
## 🔄 工作流程

1. 扫描 .openclaw 目录
2. 检查白名单
3. 删除低价值文件
4. 生成清理报告
5. 记录到今日记忆
```

**修复后**:
```
## 🔄 工作流程

1. 扫描 .openclaw 目录
2. 检查白名单
3. 删除低价值文件
4. 生成清理报告
5. 记录到今日记忆

## 📢 通知发送

**重要**: 发送飞书通知时必须包含 target 参数

```javascript
message({
  action: "send",
  channel: "feishu",
  target: "ou_42097cc9852e3aae3de5893b96a67219",  // ✅ 必须包含
  message: "清理报告..."
})
```
```

### 方案 2: 在 Cron Job payload 中添加 target

修改 Cron Job 的 message 字段，在末尾添加通知说明。

#### 修复示例

**修复前**:
```json
{
  "message": "执行智能清理任务\n\n## 🎯 任务目标\n..."
}
```

**修复后**:
```json
{
  "message": "执行智能清理任务\n\n## 🎯 任务目标\n...\n\n## 📢 通知发送\n\n发送飞书通知时必须包含:\n- channel: \"feishu\"\n- target: \"ou_42097cc9852e3aae3de5893b96a67219\"\n\n示例:\nmessage({ action: \"send\", channel: \"feishu\", target: \"ou_42097cc9852e3aae3de5893b96a67219\", message: \"...\" })"
}
```

---

## 📋 需要修复的 Cron Jobs

### 1. daily-summary-reflection（每日总结反思）

**修复位置**: Cron Job payload

**添加内容**:
```markdown
## 📢 通知发送

发送飞书通知时必须包含:
- channel: "feishu"
- target: "ou_42097cc9852e3aae3de5893b96a67219"

示例:
message({
  action: "send",
  channel: "feishu",
  target: "ou_42097cc9852e3aae3de5893b96a67219",
  message: "每日总结报告..."
})
```

### 2. daily-directed-learning（定向学习）

**修复位置**: Cron Job payload

**添加内容**: 同上

### 3. daily-deep-review（深度回顾）

**修复位置**: Cron Job payload

**添加内容**: 同上

### 4. smart-cleanup-daily（智能清理任务）

**修复位置**: Cron Job payload

**添加内容**: 同上

### 5. git-auto-backup（Git 自动备份）

**修复位置**: Cron Job payload

**添加内容**: 同上

---

## 🛠️ 修复步骤

### Step 1: 备份当前配置

```bash
cp /home/node/.openclaw/cron/jobs.json /home/node/.openclaw/cron/jobs.json.backup
```

### Step 2: 修改每个 Cron Job

对于每个 Cron Job，在 payload.message 的末尾添加通知说明。

### Step 3: 重启 Gateway

```bash
openclaw gateway restart
```

### Step 4: 测试验证

等待下一次 Cron Job 执行，检查通知是否成功。

---

## 🎯 预期效果

**修复前**:
- ❌ 07:00 智能清理通知失败

**修复后**:
- ✅ 21:00 每日总结通知成功
- ✅ 21:30 定向学习通知成功
- ✅ 23:59 深度回顾通知成功
- ✅ 07:00 智能清理通知成功
- ✅ 00:30 Git 备份通知成功

---

## 📊 验证清单

- [ ] 备份当前配置
- [ ] 修改 daily-summary-reflection
- [ ] 修改 daily-directed-learning
- [ ] 修改 daily-deep-review
- [ ] 修改 smart-cleanup-daily
- [ ] 修改 git-auto-backup
- [ ] 重启 Gateway
- [ ] 测试验证

---

**修复人**: Main Agent
**修复时间**: 2026-03-10 09:15
**状态**: ⏳ 待执行
