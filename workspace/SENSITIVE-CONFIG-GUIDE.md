# 敏感信息配置标准流程

## ⚠️ 核心原则

**永远不在配置文件中硬编码敏感信息**

---

## ✅ 标准流程

### 步骤 1: 提示用户配置

当需要新的 API Key 或敏感信息时，提示用户：

```bash
# 请在 .env 文件中添加以下配置：
NEW_API_KEY=sk-xxx
```

**位置**: `/home/node/.openclaw/.env`

### 步骤 2: 从 .env 文件加载

**脚本中加载环境变量**：

```bash
# 方法1: source（推荐）
source /home/node/.openclaw/.env

# 方法2: export
export $(cat /home/node/.openclaw/.env | grep -v '^#' | xargs)
```

### 步骤 3: 配置文件使用引用

**openclaw.json 或其他配置文件**：

```json
{
  "apiKey": "${NEW_API_KEY}"
}
```

---

## ❌ 错误做法

### 1. 在配置文件中硬编码

```json
{
  "apiKey": "sk-xxx"  // ❌ 错误
}
```

### 2. 在脚本中硬编码

```bash
export API_KEY="sk-xxx"  # ❌ 错误
```

### 3. 直接写入配置文件

```bash
jq '.apiKey = "sk-xxx"' config.json  # ❌ 错误
```

---

## ✅ 正确做法

### 1. 提示用户

```bash
echo "请在 /home/node/.openclaw/.env 中添加："
echo "NEW_API_KEY=sk-xxx"
```

### 2. 使用环境变量

```bash
# 配置文件
{
  "apiKey": "${NEW_API_KEY}"  # ✅ 正确
}

# 脚本中
source /home/node/.openclaw/.env
curl -H "Authorization: Bearer $NEW_API_KEY"  # ✅ 正确
```

---

## 📋 .env 文件位置

**主文件**: `/home/node/.openclaw/.env`

**包含的当前环境变量**:
- `ZHIPU_API_KEY`
- `FEISHU_APP_ID`
- `FEISHU_APP_SECRET`
- `XSKILL_API_KEY`
- `REFLY_API_KEY`
- `GATEWAY_TOKEN`

---

## 🎯 实际示例

### 场景：需要添加新的 API Key

**用户**: "配置新的天气 API"

**我的响应**:
```
请在 /home/node/.openclaw/.env 文件中添加以下配置：

WEATHER_API_KEY=your-api-key-here

然后重启 Gateway 使配置生效。
```

**不在配置文件中硬编码** ✅

---

## 📌 重要提醒

1. ✅ **永远不在配置文件中写入明文敏感信息**
2. ✅ **永远不在脚本中硬编码 API Key**
3. ✅ **永远提示用户在 .env 中配置**
4. ✅ **使用环境变量引用 ${VAR_NAME}**

---

**维护者**: Main Agent
**更新时间**: 2026-03-06
**重要性**: ⭐⭐⭐⭐⭐
