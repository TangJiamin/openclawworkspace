# 飞书 Session 清理报告

**清理时间**: 2026-03-10 14:47
**清理原因**: 同一飞书账号创建了多个空 session

---

## 🔍 问题分析

### 发现的问题

针对同一飞书账号 `ou_42097cc9852e3aae3de5893b96a67219`，创建了多个 session：

| Session Key | Tokens | 状态 |
|-------------|--------|------|
| `agent:main:feishu:dm:ou_42097cc9852e3aae3de5893b96a67219` | 159,796 | ✅ 主会话 |
| `agent:main:feishu:dm:ou_42097cc9852e3aae3de81394859ae8be06cf802d` | 0 | ❌ 空会话 |
| `agent:main:feishu:dm:ou_42097cc9852e3aae3de58967219` | 0 | ❌ 空会话 |
| `agent:main:feishu:dm:open_id` | 0 | ❌ 空会话 |

### 根本原因

**配置分析**:
```json
"session": {
  "dmScope": "per-channel-peer"
}
```

**问题**:
- `dmScope: "per-channel-peer"` 会在每次收到不同格式的 open_id 时创建新 session
- 飞书在不同场景下可能使用不同格式的 open_id
- 测试时手动创建了不同的 session

---

## ✅ 清理结果

### 已删除的空会话

1. ✅ `4191f9a0-ad08-44dc-a9d6-9c68608a6393.jsonl`
   - Session: `agent:main:feishu:dm:ou_42097cc9852e3aae3de81394859ae8be06cf802d`
   - Tokens: 0

2. ✅ `9b75906c-f945-41c6-aa68-88680b9dd4bf.jsonl`
   - Session: `agent:main:feishu:dm:ou_42097cc9852e3aae3de58967219`
   - Tokens: 0

3. ✅ `d6c0e37b-683e-4593-b540-66abfa2cf8ef.jsonl`
   - Session: `agent:main:feishu:dm:open_id`
   - Tokens: 0

### 保留的主会话

✅ `19a35bd6-a880-4ab7-98ea-74b4355e03e8.jsonl`
- Session: `agent:main:feishu:dm:ou_42097cc9852e3aae3de5893b96a67219`
- Tokens: 159,796
- 状态: 活跃

---

## 🔒 配置统一

### 当前配置（正确）

**Heartbeat 配置**:
```json
"heartbeat": {
  "every": "12h",
  "session": "agent:main:feishu:dm:ou_42097cc9852e3aae3de5893b96a67219",
  "target": "feishu",
  "to": "user:ou_42097cc9852e3aae3de5893b96a67219",
  "accountId": "default"
}
```

**Session 配置**:
```json
"session": {
  "dmScope": "per-channel-peer",
  "resetTriggers": ["/new", "/reset"]
}
```

**飞书配置**:
```json
"feishu": {
  "enabled": true,
  "sessions": {
    "mode": "peer",
    "defaultAgent": "main"
  }
}
```

### 标准化规则

**统一使用**:
- ✅ 完整 open_id: `ou_42097cc9852e3aae3de5893b96a67219`
- ✅ 带前缀格式: `user:ou_42097cc9852e3aae3de5893b96a67219`
- ✅ Session key: `agent:main:feishu:dm:ou_42097cc9852e3aae3de5893b96a67219`

---

## 🎯 预防措施

### 1. 配置统一

**确保所有配置使用相同的 open_id 格式**:
- Heartbeat 配置 ✅
- 飞书 Webhook 配置 ⚠️ 需要检查
- 测试环境 ⚠️ 避免手动创建 session

### 2. 监控机制

**定期检查**:
- 每周检查是否有新的空 session
- 使用 `sessions_list` 命令查看
- 清理 0 tokens 的空 session

### 3. 测试规范

**避免测试残留**:
- 测试时使用专用测试账号
- 测试完成后清理测试 session
- 不要在生产环境手动创建 session

---

## 📊 清理效果

### 清理前
- Session 总数: 4 个
- 活跃 session: 1 个
- 空 session: 3 个
- 总 Tokens: 159,796

### 清理后
- Session 总数: 1 个
- 活跃 session: 1 个
- 空 session: 0 个 ✅
- 总 Tokens: 159,796

**效果**: 清理了 75% 的空 session，保留了唯一活跃 session

---

## 📝 记录

**清理者**: Main Agent
**清理时间**: 2026-03-10 14:47
**清理原则**: 统一配置，清理空会话
**清理目标**: 确保一个飞书账号只有一个活跃 session

---

**相关配置**: `/home/node/.openclaw/openclaw.json`
**相关学习**: `.learnings/LEARNINGS.md`
