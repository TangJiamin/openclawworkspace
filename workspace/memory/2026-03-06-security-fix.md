# 2026-03-06 安全问题修复

## 🔴 发现的问题

### openclaw.json 包含明文敏感信息

**问题配置**:
```json
{
  "channels": {
    "feishu": {
      "appId": "cli_a92e467bd3f8dcc6",
      "appSecret": "NGzOhxXnRmAlTNzIsPR1ZbljjkcueZhT"  // ❌ 明文
    }
  },
  "models": {
    "providers": {
      "default": {
        "apiKey": "97c45b5ead4dbb33c7d3771f2018c4d7.ZfTUteXnyQ400hT6"  // ❌ 明文
      }
    }
  }
}
```

**违反原则**:
- ❌ MEMORY.md 中的"安全配置最佳实践"
- ❌ 敏感信息应该存储在环境变量中
- ❌ 配置文件应该使用引用而非明文

---

## ✅ 修复方案

### 原则

**环境变量 + 配置引用模式**

### 步骤

#### 1. 设置环境变量

```bash
# 飞书配置
export FEISHU_APP_ID="cli_a92e467bd3f8dcc6"
export FEISHU_APP_SECRET="NGzOhxXnRmAlTNzIsPR1ZbljjkcueZhT"

# 模型 API
export OPENAI_API_KEY="97c45b5ead4dbb33c7d3771f2018c4d7.ZfTUteXnyQ400hT6"
```

#### 2. 修改配置文件使用引用

```json
{
  "channels": {
    "feishu": {
      "appId": "${FEISHU_APP_ID}",
      "appSecret": "${FEISHU_APP_SECRET}"
    }
  },
  "models": {
    "providers": {
      "default": {
        "apiKey": "${OPENAI_API_KEY}"
      }
    }
  }
}
```

#### 3. 系统自动展开

- OpenClaw Gateway 会自动展开 `${VAR_NAME}` 引用
- 无需手动处理环境变量

---

## 🚨 立即行动

### 需要执行的修复

1. **设置环境变量**
   ```bash
   export FEISHU_APP_ID="cli_a92e467bd3f8dcc6"
   export FEISHU_APP_SECRET="NGzOhxXnRmAlTNzIsPR1ZbljjkcueZhT"
   export OPENAI_API_KEY="97c45b5ead4dbb33c7d3771f2018c4d7.ZfTUteXnyQ400hT6"
   ```

2. **修改 openclaw.json**
   - 将明文替换为环境变量引用
   - 重启 Gateway

3. **验证修复**
   - 检查配置文件是否只包含引用
   - 测试飞书通信是否正常

---

## 📋 修复后的优势

1. ✅ **安全性**: 配置文件不包含明文敏感信息
2. ✅ **灵活性**: 不同环境可以使用不同的环境变量
3. ✅ **可维护性**: 敏感信息集中管理
4. ✅ **版本控制**: 配置文件可以安全提交到 Git

---

**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: 🔴 待修复
**日期**: 2026-03-06
**原则**: 安全配置最佳实践（MEMORY.md）
