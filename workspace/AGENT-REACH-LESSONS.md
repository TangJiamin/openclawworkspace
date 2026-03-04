# Agent-Reach 安装说明

**当前状态**: 2026-03-04 02:35 UTC

---

## ⚠️ 环境限制

**问题**: 当前环境是 `externally-managed-environment`，不允许直接 pip install

**解决方案**: 使用 `--break-system-packages --user` 参数

---

## ✅ 正确的安装方式

### 方式1: 使用 pipx（推荐）

```bash
# 安装 pipx
pip3 install --user pipx

# 使用 pipx 安装 agent-reach
pipx install agent-reach
```

### 方式2: 使用 --break-system-packages

```bash
pip3 install --break-system-packages --user https://github.com/Panniantong/agent-reach/archive/main.zip
```

### 方式3: 使用虚拟环境

```bash
# 创建虚拟环境
python3 -m venv ~/.agent-reach-venv

# 激活虚拟环境
source ~/.agent-reach-venv/bin/activate

# 安装
pip install https://github.com/Panniantong/agent-reach/archive/main.zip
```

---

## 🎯 核心价值

### 即使不安装，也可以学习其设计

**Agent-Reach 的核心思想**:

1. **可插拔架构**
   - 每个 channel 是独立插件
   - 不满意就换掉

2. **SKILL.md 设计**
   - 让 Agent 自主决策
   - 不需要用户记命令

3. **诊断工具**
   - `agent-reach doctor`
   - 检查所有组件状态

4. **多数据源**
   - Twitter（xreach CLI）
   - RSS（feedparser）
   - 网页（Jina Reader）
   - GitHub（gh CLI）
   - YouTube（yt-dlp）

---

## 🔧 我们可以立即应用的改进

### 1. 创建 SKILL.md

**为 Main Agent 创建**:

```markdown
## Main Agent SKILL.md

### 当用户需要
- "生成内容" → content-agent
- "收集资讯" → research-agent
- "生成图片" → visual-agent
- "生成视频" → video-agent
- "质量审核" → quality-agent
```

---

### 2. 创建诊断工具

**命令**: `agent-system doctor`

**功能**:
- 检查所有 Agents 状态
- 告诉用户哪个通、哪个不通
- 提供修复建议

---

### 3. 添加更多数据源

**可以立即添加**:

#### Twitter 搜索
```bash
# 安装 xreach CLI
npm install -g xreach

# 使用
xreach search "GPT-5" --json -n 10
```

#### RSS 订阅
```bash
# 安装 feedparser
pip3 install feedparser

# 使用
python3 -c "import feedparser; d = feedparser.parse('URL')"
```

#### 网页抓取
```bash
# 使用 Jina Reader（无需安装）
curl -s "https://r.jina.ai/URL" -H "Accept: text/markdown"
```

---

## 📋 总结

### ✅ 可以直接使用

**是的！Agent-Reach 的功能可以直接使用！**

**方式**:
1. **安装 Agent-Reach**（推荐）
   - 使用 pipx 或虚拟环境
   
2. **使用上游工具**（替代方案）
   - xreach CLI（Twitter）
   - feedparser（RSS）
   - Jina Reader（网页）
   - yt-dlp（YouTube）
   - gh CLI（GitHub）

3. **学习设计思想**（最重要）
   - 可插拔架构
   - SKILL.md 设计
   - 诊断工具
   - 多数据源

---

**维护者**: Main Agent  
**状态**: ✅ Agent-Reach 设计思想已学习，可以立即应用
