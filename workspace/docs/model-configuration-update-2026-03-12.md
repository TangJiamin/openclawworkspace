# 模型配置更新建议

**时间**: 2026-03-12 16:20

---

## 🎯 发现的问题

### GLM-4.7 不适合复杂工具调用

**证据**：
- 简单任务：✅ 成功（文件读取）
- 复杂任务：❌ 失败（Token = 0）

**根本原因**：
- GLM-4.7 可能不支持复杂的多步骤工具调用
- Token 消耗异常（0 说明没有实际输出）
- 可能在"思考"但没有输出

---

## 💡 解决方案：更换为 MiniMax 模型

### 可用的模型

```json
{
  "default/glm-4.7": {},
  "minimax/MiniMax-M2.5": {"alias": "mm-pro"},
  "minimax/MiniMax-VL-01": {"alias": "mm-vl"},
  "minimax/miniM ax-M2.5-Lightning": {"alias": "mm-fast"}
}
```

### 推荐配置

**visual-agent 使用 MiniMax-M2.5**：

```json
{
  "agents": {
    "list": [
      {
        "id": "visual-agent",
        "model": "minimax/MiniMax-M2.5"
      }
    ]
  }
}
```

**原因**：
- MiniMax 更适合工具调用
- MiniMax 支持多步骤任务
- MiniMax 性能更好

---

## 🔧 更新方法

### 方法 1: 手动更新

```bash
# 编辑配置文件
nano /home/node/.openclaw/openclaw.json

# 找到 visual-agent 配置
# 将 "model": "default/glm-4.7" 改为 "model": "minimax/MiniMax-M2.5"

# 保存并重启
```

### 方法 2: 使用 jq 更新

```bash
cd /home/node/.openclaw

# 备份
cp openclaw.json openclaw.json.bak

# 更新
jq '(.agents.list[] | select(.id == "visual-agent") | .model) |= "minimax/MiniMax-M2.5"' openclaw.json > openclaw-new.json

# 替换
mv openclaw-new.json openclaw.json
```

---

## 🎯 测试计划

1. ✅ 更新 visual-agent 模型为 MiniMax-M2.5
2. ✅ 重启 OpenClaw Gateway
3. ✅ 测试 visual-agent 是否成功
4. ✅ 如果成功，更新 video-agent 也使用 MiniMax

---

**文档版本**: v1.0
**最后更新**: 2026-03-12 16:20
**状态**: 待手动更新配置
