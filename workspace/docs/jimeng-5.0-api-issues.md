# jimeng-5.0 API 调用问题记录

**时间**: 2026-03-10 15:15
**状态**: ❌ 功能不可用

---

## 🔍 问题分析

### 错误信息
```
{"detail":"任务提交失败: 即梦 API 提交失败: 任务提交失败: history_id=None"}
```

### 可能的原因

1. **API Key 问题**
   - API Key 可能已过期
   - API Key 可能权限不足
   - API Key 可能是测试 Key，无法调用生产环境

2. **API 变更**
   - xskill API 可能已更新
   - jimeng-5.0 模型可能需要不同的调用方式
   - 可能需要额外的参数（如 `history_id`）

3. **账户问题**
   - 账户积分不足
   - 账户未激活
   - 账户权限限制

---

## ✅ 已尝试的方法

### 1. REST API 调用（Python 示例代码）
```bash
curl -X POST "https://api.xskill.ai/api/v3/tasks/create" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-xxx" \
  -d '{
    "model": "jimeng-5.0",
    "params": {
      "prompt": "test",
      "ratio": "3:4",
      "resolution": "2k"
    }
  }'
```
**结果**: ❌ 失败，`history_id=None`

### 2. visual-generator 调用
```bash
bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/generate.sh "测试"
```
**结果**: ❌ 失败，参数错误

### 3. MCP 协议调用
**结果**: ❌ 需要 Session ID，初始化失败

---

## 🎯 需要的验证

### 验证 API Key

**请确认**:
1. API Key 是否有效？
2. API Key 是否有 jimeng-5.0 的调用权限？
3. 账户是否有足够的积分？

### 验证方式

**方式 1: 访问 xskill.ai**
1. 登录 https://www.xskill.ai
2. 检查 API Key 状态
3. 检查账户积分
4. 检查 jimeng-5.0 模型是否可用

**方式 2: 使用官方 Python SDK**
```python
import requests

url = "https://api.xskill.ai/api/v3/tasks/create"
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer sk-your-api-key"
}

payload = {
    "model": "jimeng-5.0",
    "params": {
        "prompt": "test",
        "ratio": "3:4",
        "resolution": "2k"
    }
}

response = requests.post(url, json=payload, headers=headers)
result = response.json()

print("任务创建结果:", result)
```

---

## 💡 建议

### 短期解决方案
1. **验证 API Key** - 确认 API Key 是否有效
2. **检查账户状态** - 确认积分和权限
3. **联系 xskill 支持** - 询问 `history_id=None` 错误的原因

### 长期解决方案
1. **使用官方 SDK** - Python/JavaScript SDK 更稳定
2. **使用 MCP 协议** - 如果 REST API 不可用
3. **等待 API 更新** - 如果 xskill 正在更新 API

---

## 📝 诚实的结论

**我不能保证功能可用**，因为：
1. ❌ 所有调用方法都失败了
2. ❌ API 返回 `history_id=None` 错误
3. ❌ 可能是 API Key 或 API 本身的问题

**我需要你的帮助**：
- ✅ 验证 API Key 是否有效
- ✅ 检查 xskill 账户状态
- ✅ 或者提供一个已知可用的 API Key 进行测试

---

**记录者**: Main Agent
**时间**: 2026-03-10 15:15
**状态**: ❌ 功能未验证可用
