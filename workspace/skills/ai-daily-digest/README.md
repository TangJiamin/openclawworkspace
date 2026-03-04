# 🤖 AI Daily Digest - OpenClaw Skill

## 📋 概述

AI Daily Digest 是从 90 个顶级技术博客（Karpathy 推荐）抓取最新文章，通过 AI 评分筛选，生成每日精选摘要的 OpenClaw Skill。

**原项目：** https://github.com/vigorX777/ai-daily-digest

---

## 🎯 核心功能

### 1. 信息源

- ✅ 90 个顶级技术博客（Karpathy 推荐）
- ✅ RSS 抓取（并发 10 路，15s 超时）
- ✅ 兼容 RSS 2.0 和 Atom 格式

### 2. AI 处理

- ✅ 多维评分（相关性、质量、时效性）
- ✅ 自动分类（6 大分类体系）
- ✅ 结构化摘要（4-6 句）
- ✅ 中英双语标题
- ✅ 推荐理由生成
- ✅ 趋势分析

### 3. 输出格式

- 📝 今日看点（宏观趋势）
- 🏆 今日必读 Top 3
- 📊 数据概览（统计 + 图表）
- 分类文章列表（6 大分类）

---

## 🚀 快速开始

### 步骤 1: 安装原始 Skill

**在 Claude Code 中:**

```bash
/plugin marketplace add vigorX777/ai-daily-digest
/plugin install ai-daily-digest
```

**或手动克隆:**

```bash
git clone https://github.com/vigorX777/ai-daily-digest.git ~/ai-daily-digest
cd ~/ai-daily-digest
```

### 步骤 2: 配置 API Key

```bash
# 设置 Gemini API Key（推荐，免费）
export GEMINI_API_KEY="your-gemini-api-key"

# 或设置 OpenAI API Key（可选兜底）
export OPENAI_API_KEY="your-openai-api-key"
export OPENAI_API_BASE="https://api.deepseek.com/v1"
export OPENAI_MODEL="deepseek-chat"
```

**获取 Gemini API Key:**
1. 访问：https://aistudio.google.com/apikey
2. 创建新的 API Key
3. 复制 API Key

### 步骤 3: 复制脚本

```bash
# 创建 scripts 目录
mkdir -p /home/node/.openclaw/workspace/skills/ai-daily-digest/scripts

# 复制原始脚本
cp ~/ai-daily-digest/scripts/digest.ts \
   /home/node/.openclaw/workspace/skills/ai-daily-digest/scripts/
```

### 步骤 4: 配置环境变量

```bash
# 编辑 Gateway 配置
nano ~/.openclaw/gateway.env

# 添加以下内容
AI_DIGEST_ENABLED=true
AI_DIGEST_HOURS=48
AI_DIGEST_TOP_N=15
AI_DIGEST_LANG=zh

GEMINI_API_KEY=your-gemini-api-key
OPENAI_API_KEY=your-openai-api-key  # 可选
```

### 步骤 5: 测试

```bash
cd /home/node/.openclaw/workspace/skills/ai-daily-digest
node handler.ts
```

---

## 📝 使用方式

### 在 OpenClaw 中使用

```
/digest

或直接对话：

生成最近 48 小时的技术文章摘要

生成最近 24 小时的 10 篇精选文章

Generate digest for last 72 hours, top 20 articles
```

### 参数说明

| 参数 | 选项 | 默认值 |
|------|------|--------|
| **时间范围** | 24h / 48h / 72h / 7天 | 48h |
| **精选数量** | 10 / 15 / 20 | 15 |
| **输出语言** | 中文 / English | 中文 |

---

## 📊 输出示例

```markdown
# 📝 今日看点

AI 领域迎来重大突破，多篇文章讨论了大语言模型的最新进展...

# 🏆 今日必读 Top 3

## 1. 大语言模型的推理优化技术
**原题:** Techniques for Optimizing LLM Inference
**来源:** Simon Willison's Blog
**评分:** ⭐ 9.2/10
**关键词:** LLM, 推理优化, 性能
**推荐理由:** 这篇文章深入探讨了 LLM 推理的各种优化技术...
**摘要:** 4-6 句结构化摘要...

# 📊 数据概览

| 指标 | 数值 |
|------|------|
| 扫描源数 | 90 |
| 抓取文章数 | 245 |
| 精选文章数 | 15 |

# 分类文章

## 🤖 AI / ML
...

## 🔒 安全
...

## ⚙️ 工程
...

## 🛠 工具 / 开源
...

## 💡 观点 / 杂谈
...

## 📝 其他
...
```

---

## 🔄 与热点猎手集成

### 工作流配置

```yaml
# Cron Job 1: AI Daily Digest
name: "AI Daily Digest"
schedule:
  type: cron
  expr: "0 9 * * *"

payload:
  kind: agentTurn
  message: |
    运行 AI Daily Digest
    - 时间范围：48 小时
    - 精选数量：15 篇
    - 输出语言：中文

---

# Cron Job 2: 内容策划师
name: "内容策划师"
schedule:
  type: cron
  expr: "0 10 * * *"

payload:
  kind: agentTurn
  message: |
    综合以下两个来源进行内容策划：

    1. 热点猎手输出：data/hotspots/$(date +%Y-%m-%d).json
    2. AI Daily Digest 输出：data/digests/$(date +%Y-%m-%d).md

    请智能融合：
    - 热点权重：40%
    - 深度权重：60%
    - 生成今日内容计划
```

### 智能融合

```javascript
// 内容策划师融合逻辑

function fuseInsights(hotspots, digest) {
  return {
    hot_topics: hotspots.topics,  // 来自热点猎手
    deep_insights: digest.top3,    // 来自 AI Daily Digest
    trending_technical: digest.byCategory['AI/ML'],
    recommendations: generateRecommendations(hotspots, digest)
  };
}
```

---

## ⚙️ 配置文件

### 自动保存配置

配置文件路径：`~/.hn-daily-digest/config.json`

```json
{
  "geminiApiKey": "your-api-key",
  "timeRange": 48,
  "topN": 15,
  "language": "zh",
  "lastUsed": "2026-02-27T10:00:00Z"
}
```

### 环境变量

```bash
# ~/.openclaw/gateway.env

AI_DIGEST_ENABLED=true
AI_DIGEST_HOURS=48
AI_DIGEST_TOP_N=15
AI_DIGEST_LANG=zh

GEMINI_API_KEY=your-gemini-api-key
OPENAI_API_KEY=your-openai-api-key  # 可选
```

---

## 🎯 6 大分类体系

| 分类 | 覆盖范围 |
|------|----------|
| **🤖 AI / ML** | AI、机器学习、LLM、深度学习 |
| **🔒 安全** | 安全、隐私、漏洞、加密 |
| **⚙️ 工程** | 软件工程、架构、编程语言、系统设计 |
| **🛠 工具 / 开源** | 开发工具、开源项目、新发布的库/框架 |
| **💡 观点 / 杂谈** | 行业观点、个人思考、职业发展 |
| **📝 其他** | 不属于以上分类的内容 |

---

## 💡 使用技巧

### 1. 最佳时间

- **08:00 - 热点猎手**（实时热点）
- **09:00 - AI Daily Digest**（深度洞察）
- **10:00 - 内容策划师**（智能融合）

### 2. 参数选择

- **快速浏览:** 24h + 10 篇
- **标准推荐:** 48h + 15 篇
- **深度研究:** 72h + 20 篇

### 3. 语言选择

- **中文团队:** 中文（默认）
- **国际团队:** English

---

## 📚 相关文档

- **原项目:** https://github.com/vigorX777/ai-daily-digest
- **详细分析:** `docs/AI-DAILY-DIGEST-ANALYSIS.md`
- **集成指南:** `docs/AI-DAILY-DIGEST-INTEGRATION.md`
- **策略分析:** `docs/AI-DAILY-DIGEST-STRATEGY.md`

---

## 🎊 总结

**核心价值:**
- ✅ 深度技术洞察
- ✅ 顶级专家观点
- ✅ AI 质量评分
- ✅ 结构化摘要
- ✅ 中英双语

**与热点猎手互补:**
- 热点猎手 = 广度 + 实时
- AI Daily Digest = 深度 + 权威

**立即开始:**
1. 配置 API Key
2. 运行 `/digest`
3. 获取深度技术洞察

---

**🤖 开始你的深度技术洞察之旅！**
