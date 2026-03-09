# API Keys 配置指南

## 需要配置的 API Keys

### 1. Tavily API Key（必需）

**用途**: Tavily Search - AI 优化搜索

**注册地址**: https://tavily.com

**步骤**:
1. 访问 https://tavily.com
2. 注册账号（免费套餐可用）
3. 获取 API Key
4. 配置环境变量：

```bash
export TAVILY_API_KEY="tvly-your-api-key-here"
```

**验证**:
```bash
echo $TAVILY_API_KEY
# 应该显示你的 API Key
```

---

### 2. Gemini API Key（推荐）

**用途**: Summarize - 多格式总结

**注册地址**: https://ai.google.dev

**步骤**:
1. 访问 https://ai.google.dev
2. 创建项目或使用现有项目
3. 启用 Gemini API
4. 创建 API Key
5. 配置环境变量：

```bash
export GEMINI_API_KEY="your-gemini-api-key-here"
```

**别名**（也支持）:
```bash
export GOOGLE_GENERATIVE_AI_API_KEY="your-api-key"
# 或
export GOOGLE_API_KEY="your-api-key"
```

**验证**:
```bash
echo $GEMINI_API_KEY
# 应该显示你的 API Key
```

---

### 3. 其他选项（可选）

#### OpenAI API Key

**用途**: Summarize 备选方案

```bash
export OPENAI_API_KEY="sk-your-openai-key"
```

#### Anthropic API Key

**用途**: Summarize 备选方案

```bash
export ANTHROPIC_API_KEY="sk-ant-your-key"
```

#### xAI API Key

**用途**: Summarize 备选方案

```bash
export XAI_API_KEY="your-xai-key"
```

---

## 持久化配置

### 方法 1: 临时配置（当前会话）

```bash
export TAVILY_API_KEY="your-key"
export GEMINI_API_KEY="your-key"
```

**注意**: 终端关闭后失效

---

### 方法 2: 永久配置（推荐）

#### 在宿主机上配置

```bash
# 编辑 ~/.bashrc 或 ~/.zshrc
nano ~/.bashrc

# 添加以下行
export TAVILY_API_KEY="your-key"
export GEMINI_API_KEY="your-key"

# 重新加载配置
source ~/.bashrc
```

#### 在容器内配置

```bash
# 编辑 ~/.bashrc
nano ~/.bashrc

# 添加以下行
export TAVILY_API_KEY="your-key"
export GEMINI_API_KEY="your-key"

# 重新加载配置
source ~/.bashrc
```

---

### 方法 3: 使用 .env 文件（推荐用于容器）

```bash
# 创建 .env 文件
cat > ~/.openclaw-env << EOF
TAVILY_API_KEY=your-key
GEMINI_API_KEY=your-key
EOF

# 加载环境变量
source ~/.openclaw-env
```

**添加到 ~/.bashrc**:
```bash
echo 'source ~/.openclaw-env' >> ~/.bashrc
source ~/.bashrc
```

---

## 测试配置

### 测试 Tavily API Key

```bash
bash /home/node/.openclaw/workspace/skills/clawhub-bypass/scripts/test-tavily.sh
```

### 测试 Gemini API Key

```bash
bash /home/node/.openclaw/workspace/skills/clawhub-bypass/scripts/test-gemini.sh
```

---

## 安全建议

1. **不要提交到 Git** - 确保 `.env` 文件在 `.gitignore` 中
2. **使用环境变量** - 而不是硬编码在脚本中
3. **最小权限原则** - 使用具有最小权限的 API Key
4. **定期轮换** - 定期更换 API Key

---

## 故障排查

### 问题 1: API Key 无效

**错误**: `Invalid API key`

**解决方案**:
1. 检查 API Key 是否正确复制（无多余空格）
2. 确认 API Key 是否已激活
3. 检查 API Key 是否已过期

---

### 问题 2: 配额不足

**错误**: `Quota exceeded`

**解决方案**:
1. 检查账户配额
2. 升级套餐或等待配额重置
3. 优化调用频率

---

### 问题 3: 环境变量未生效

**错误**: `API_KEY not found`

**解决方案**:
1. 确认环境变量已设置: `echo $TAVILY_API_KEY`
2. 重新加载配置: `source ~/.bashrc`
3. 检查文件路径是否正确

---

## 当前状态

**已配置**: 无

**需要配置**:
- [ ] TAVILY_API_KEY
- [ ] GEMINI_API_KEY（或 OPENAI_API_KEY, ANTHROPIC_API_KEY, XAI_API_KEY）

---

**下一步**: 配置 API Keys 后，运行测试脚本验证
