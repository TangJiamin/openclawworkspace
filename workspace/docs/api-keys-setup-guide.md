# API Keys 配置指南

**更新时间**: 2026-03-10 09:30
**目的**: 配置新学习的技能所需的 API Keys

---

## 📍 .env 文件位置

```
/home/node/.openclaw/.env
```

---

## 🔧 需要配置的 API Keys

### 1. Tavily Search ⭐⭐⭐⭐⭐

**用途**: research-agent 首选搜索工具（速度提升 30-50%）

**注册步骤**:
1. 访问: https://tavily.com
2. 注册账号（免费）
3. 获取 API Key
4. 添加到 .env 文件

**配置**:
```bash
# 在 .env 文件中添加：
TAVILY_API_KEY=tvly-your-api-key-here
```

**免费额度**:
- 1,000 次/月
- 适用于大多数场景

**优先级**: 🔥 **高优先级**（推荐配置）

---

### 2. Summarize ⭐⭐⭐⭐⭐

**用途**: 多格式内容总结（PDF/YouTube/图片/音频）

**支持模型**:
- **Gemini**（推荐，免费）
- **OpenAI**（付费）
- **Anthropic**（付费）

#### 配置 Gemini（推荐）

**注册步骤**:
1. 访问: https://makersuite.google.com/app/apikey
2. 创建 API Key（免费）
3. 添加到 .env 文件

**配置**:
```bash
# 在 .env 文件中添加：
GENAI_API_KEY=your-gemini-api-key-here
```

**优势**:
- ✅ 完全免费
- ✅ 支持长文本
- ✅ 多模态支持

#### 配置 OpenAI（可选）

**注册步骤**:
1. 访问: https://platform.openai.com/api-keys
2. 创建 API Key（付费）
3. 添加到 .env 文件

**配置**:
```bash
# 在 .env 文件中添加：
OPENAI_API_KEY=sk-your-openai-key-here
```

**优先级**: 🔥 **高优先级**（推荐配置 Gemini）

---

## 🔄 配置后如何生效

### 方法 1: 重启 Gateway（推荐）

```bash
openclaw gateway restart
```

### 方法 2: 重新加载配置

某些配置可能需要重启才能生效。

---

## ✅ 配置验证

### 验证 Tavily Search

```bash
# 测试搜索
node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "AI工具" -n 5
```

**预期结果**: 返回搜索结果

### 验证 Summarize

```bash
# 测试总结
npx summarize "https://example.com/article" --length medium
```

**预期结果**: 返回文章总结

---

## 📊 配置状态

### 已配置 ✅

- [x] Zhipu AI (GLM-4.7)
- [x] Feishu
- [x] Refly
- [x] Xskill
- [x] GitHub

### 待配置 ⏳

- [ ] Tavily Search（推荐）
- [ ] Summarize - Gemini（推荐）
- [ ] Summarize - OpenAI（可选）

---

## 🎯 配置优先级

### 必须配置（立即）

- [ ] Tavily Search - research-agent 首选搜索工具
- [ ] Gemini API - Summarize 多格式总结

### 可选配置（按需）

- [ ] OpenAI API - Summarize 备选模型
- [ ] Anthropic API - Summarize 备选模型

---

## 💡 快速配置脚本

### 一键配置 Tavily

```bash
# 1. 访问 https://tavily.com 获取 API Key
# 2. 运行以下命令（替换 YOUR_KEY）
echo "TAVILY_API_KEY=tvly-YOUR_KEY" >> /home/node/.openclaw/.env
```

### 一键配置 Gemini

```bash
# 1. 访问 https://makersuite.google.com/app/apikey 获取 API Key
# 2. 运行以下命令（替换 YOUR_KEY）
echo "GENAI_API_KEY=YOUR_KEY" >> /home/node/.openclaw/.env
```

### 重启 Gateway

```bash
openclaw gateway restart
```

---

## 📝 注意事项

1. **安全性**
   - ✅ .env 文件包含敏感信息，不要提交到 Git
   - ✅ 确保 .env 在 .gitignore 中

2. **权限**
   - ✅ 确保 .env 文件权限正确: `chmod 600 .env`

3. **备份**
   - ✅ 修改前建议备份: `cp .env .env.backup`

---

## 🎯 下一步

1. **配置 API Keys**
   - Tavily Search（推荐）
   - Gemini API（推荐）

2. **验证配置**
   - 运行测试命令
   - 确认功能正常

3. **重启 Gateway**
   - 使配置生效

---

**配置指南生成时间**: 2026-03-10 09:30
**下次更新**: 配置完成后
