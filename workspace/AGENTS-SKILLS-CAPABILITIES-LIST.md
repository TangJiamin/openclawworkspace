# 📊 Agents 和 Skills 完整能力清单

**最后更新**: 2026-03-09
**维护者**: Main Agent
**目的**: 对所有 Agents 和 Skills 了如指掌，无需用户询问

---

## 🤖 Agents 能力清单

### Main Agent
- **职责**: 协调者和决策者
- **核心能力**:
  - 多 Agent 协同和编排
  - 任务分发和调度
  - 质量审核和验收
  - 技能发现和集成
- **工具访问**: 所有工具
- **文档**: `/home/node/.openclaw/workspace/AGENTS.md`

### requirement-agent
- **职责**: 需求理解和分析
- **核心能力**:
  - 分析用户需求
  - 识别关键约束
  - 生成任务规范
- **工具访问**: requirement-analyzer
- **超时**: 60秒

### research-agent
- **职责**: 资料收集和研究
- **核心能力**:
  - 网络搜索（多种工具）
  - 资料验证和筛选
  - 时效性检查（24小时）
- **工具访问**:
  - ✅ Metaso Search (免费)
  - ✅ Tavily Search (需要 API Key)
  - ✅ Jina AI Search (免费)
  - ✅ Exa Search (需要 API Key)
  - ✅ Agent Reach (8+ 平台)
  - ✅ Summarize (需要 API Key)
- **超时**: 120秒

### content-agent
- **职责**: 内容生产
- **核心能力**:
  - 文案生成
  - 多角度创作
  - 内容优化
- **工具访问**: content-generator
- **超时**: 90秒

### visual-agent
- **职责**: 视觉生成
- **核心能力**:
  - 图片生成（Xskill 57+ 模型）
  - 视觉参数优化
- **工具访问**: visual-generator
- **超时**: 60秒

### video-agent
- **职责**: 视频生成
- **核心能力**:
  - 视频生成（Seedance）
  - 分镜制作
- **工具访问**: seedance-storyboard
- **超时**: 120秒

### quality-agent
- **职责**: 质量审核
- **核心能力**:
  - 多维度评分
  - 质量阈值判断
  - 改进建议
- **工具访问**: quality-reviewer
- **超时**: 30秒

---

## 🛠️ Skills 能力清单

### 搜索类 Skills

#### Metaso Search
- **类型**: 网络搜索
- **成本**: ✅ 免费
- **搜索能力**: ✅
- **内容提取**: ✅
- **时效性**: 24小时
- **命令**: `bash /home/node/.openclaw/workspace/skills/metaso-search/scripts/metaso_search.sh "query" 10`
- **优先级**: 备用（已被 Jina AI Search 超越）
- **状态**: ✅ 已安装

#### Tavily Search
- **类型**: AI 优化搜索
- **成本**: 需要 API Key (https://tavily.com)
- **搜索能力**: ✅ 原生搜索
- **高级选项**: ✅ 深度搜索 (--deep)、新闻主题 (--topic news)
- **内容提取**: ✅
- **命令**: `node /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.mjs "query" -n 10`
- **优先级**: 主搜索（质量优先）
- **状态**: ✅ 已安装（2026-03-09）

#### Jina AI Search (Agent Reach)
- **类型**: 网络搜索
- **成本**: ✅ 完全免费
- **搜索能力**: ✅
- **输出格式**: Markdown
- **命令**: `curl -s "https://s.jina.ai/[query]" -H "Accept: text/markdown"`
- **优先级**: ⭐⭐⭐⭐⭐ 主搜索（成本优先）
- **状态**: ✅ 已安装（Agent Reach）

#### Exa Search (Agent Reach)
- **类型**: AI 优化搜索 + 代码搜索
- **成本**: 需要 API Key
- **搜索能力**: ✅
- **代码搜索**: ✅ (独有能力)
- **公司研究**: ✅ (独有能力)
- **命令**: 
  - 搜索: `mcporter call 'exa.web_search_exa(query: "query", numResults: 5)'`
  - 代码: `mcporter call 'exa.get_code_context_exa(query: "...", tokensNum: 3000)'`
  - 公司: `mcporter call 'exa.company_research_exa(companyName: "...")'`
- **优先级**: 代码搜索专用
- **状态**: ⚠️ 需要配置 Exa API Key

---

### 内容提取类 Skills

#### Jina Reader (Agent Reach)
- **类型**: 网页内容提取
- **成本**: ✅ 完全免费
- **支持格式**: 任何网页 URL
- **特殊能力**: ✅ 单页应用（SPA）
- **输出格式**: Markdown
- **命令**: `curl -s "https://r.jina.ai/[URL]"`
- **优先级**: ⭐⭐⭐⭐⭐ 主要提取工具
- **状态**: ✅ 已安装（Agent Reach）

#### Tavily Extract
- **类型**: URL 内容提取
- **成本**: 需要 API Key
- **AI 优化**: ✅
- **命令**: `node /home/node/.openclaw/workspace/skills/tavily-search/scripts/extract.mjs "URL"`
- **优先级**: 备用提取工具
- **状态**: ✅ 已安装（2026-03-09）

#### Summarize
- **类型**: 多格式总结
- **成本**: 需要 API Key (Gemini/OpenAI/Anthropic/xAI)
- **支持格式**: URL、PDF、YouTube、图片、音频
- **输出长度**: short/medium/long/xl/xxl
- **命令**: `npx summarize "url-or-file" --length medium`
- **优先级**: 多格式总结专用
- **状态**: ✅ 已安装（2026-03-09）

---

### 平台特定 Skills (Agent Reach)

#### Reddit
- **搜索**: ✅ `curl -s "https://www.reddit.com/search.json?q=query&limit=10" -H "User-Agent: agent-reach/1.0"`
- **读取**: ✅ `curl -s "https://www.reddit.com/r/python/hot.json?limit=10"`
- **成本**: ✅ 免费
- **状态**: ✅ 已安装（Agent Reach）

#### YouTube
- **搜索**: ✅ `yt-dlp --dump-json "ytsearch5:query"`
- **元数据**: ✅ `yt-dlp --dump-json "URL"`
- **字幕**: ✅ `yt-dlp --write-sub --write-auto-sub --sub-lang "zh-Hans,zh,en" --skip-download`
- **成本**: ✅ 免费
- **状态**: ✅ 已安装（Agent Reach）

#### GitHub
- **搜索仓库**: ✅ `gh search repos "query" --sort stars --limit 10`
- **搜索代码**: ✅ `gh search code "query" --language python`
- **查看**: ✅ `gh repo view owner/repo`
- **成本**: ✅ 免费
- **状态**: ✅ 已安装（Agent Reach）

#### LinkedIn
- **搜索人员**: ✅ `mcporter call 'linkedin.search_people(keyword: "AI engineer", limit: 10)'`
- **查看档案**: ✅ `mcporter call 'linkedin.get_person_profile(linkedin_url: "...")'`
- **成本**: ⚠️ 需要 MCP 配置
- **状态**: ⚠️ 需要配置

#### 小红书
- **搜索笔记**: ✅ `mcporter call 'xiaohongshu.search_feeds(keyword: "query")'`
- **读取笔记**: ✅ `mcporter call 'xiaohongshu.get_feed_detail(feed_id: "...")'`
- **成本**: ⚠️ 需要 MCP 配置
- **状态**: ⚠️ 需要配置

#### 抖音
- **解析视频**: ✅ `mcporter call 'douyin.parse_douyin_video_info(share_link: "...")'`
- **下载链接**: ✅ `mcporter call 'douyin.get_douyin_download_link(share_link: "...")'`
- **AI 提取文案**: ✅ `mcporter call 'douyin.extract_douyin_text(share_link: "...")'`
- **成本**: 需要硅基流动 API Key
- **状态**: ⚠️ 需要配置

---

### 内容生成类 Skills

#### visual-generator
- **类型**: 视觉生成
- **模型**: Xskill 57+ AI 模型
- **平台**: 小红书、抖音、微信等
- **功能**:
  - 图片生成
  - 参数优化
  - 多维参数系统
- **命令**: 通过 content-agent 调用
- **优先级**: 主要视觉生成工具
- **状态**: ✅ 已安装

#### seedance-storyboard
- **类型**: 视频分镜
- **功能**: 对话引导生成分镜
- **输出**: 专业分镜提示词
- **命令**: 对话式使用
- **优先级**: video-agent 前置工具
- **状态**: ✅ 已安装

---

### 工具类 Skills

#### ClawHub Bypass
- **类型**: 工具安装
- **功能**: 绕过服务故障安装技能
- **方法**: 使用 `npx clawhub inspect` 下载
- **命令**: `bash /home/node/.openclaw/workspace/skills/clawhub-bypass/scripts/install-simple.sh <skill-name>`
- **优先级**: 服务故障时的备用方案
- **状态**: ✅ 已创建（2026-03-09）

#### ai-daily-digest
- **类型**: 资讯收集
- **来源**: 90个顶级技术博客
- **功能**: AI 评分筛选
- **触发**: 定时任务
- **优先级**: 定时资讯收集
- **状态**: ✅ 已安装

#### daily-summary
- **类型**: 每日总结
- **功能**: 智能分析和反思
- **触发**: 每天 23:59
- **优先级**: 定时任务
- **状态**: ✅ 已安装

#### agent-optimizer
- **类型**: Agent 优化
- **功能**: 扫描 Agents 并生成优化建议
- **触发**: 学习新技能后
- **命令**: `bash /home/node/.openclaw/workspace/skills/agent-optimizer/scripts/check.sh`
- **优先级**: 自动优化
- **状态**: ✅ 已安装

#### agent-canvas-confirm
- **类型**: 确认工作流
- **功能**: 需要确认的操作
- **应用**: 邮件发送、视频生成等
- **优先级**: 确认机制
- **状态**: ✅ 已安装

---

### 学习和优化类 Skills

#### self-improving-agent
- **类型**: 学习系统
- **功能**: 记录学习、错误、纠正
- **目录**: `.learnings/`
- **文件**:
  - LEARNINGS.md
  - ERRORS.md
  - FEATURE_REQUESTS.md
- **优先级**: 持续改进
- **状态**: ✅ 已安装（2026-03-07）

#### proactive-agent
- **类型**: 主动性提升
- **功能**: 
  - WAL Protocol（先记录后响应）
  - Working Buffer（危险区日志）
  - Relentless Resourcefulness（尝试10种方法）
- **目标**: 主动发现问题
- **优先级**: 行为优化
- **状态**: ✅ 已安装（2026-03-07）

#### find-skills
- **类型**: 技能发现
- **功能**: 自动发现和安装相关技能
- **命令**: `npx skills find "query"`
- **优先级**: 技能发现
- **状态**: ✅ 已安装（2026-03-09）

---

## 🎯 快速决策矩阵

### 搜索工具选择

| 场景 | 推荐工具 | 备选工具 | 原因 |
|------|---------|---------|------|
| **通用搜索** | Jina AI Search (免费) | Tavily Search | 成本优先 |
| **深度搜索** | Tavily Search (--deep) | - | 质量优先 |
| **新闻搜索** | Tavily Search (--topic news) | - | 日期过滤 |
| **代码搜索** | Exa Search | - | 独有能力 |
| **公司研究** | Exa Search | - | 独有能力 |
| **Reddit** | Agent Reach (Reddit API) | - | 平台专用 |
| **YouTube** | Agent Reach (yt-dlp) | - | 平台专用 |
| **GitHub** | Agent Reach (gh CLI) | - | 平台专用 |

### 内容提取选择

| 场景 | 推荐工具 | 备选工具 | 原因 |
|------|---------|---------|------|
| **普通网页** | Jina Reader (免费) | Tavily Extract | 成本优先 |
| **单页应用** | Jina Reader | - | SPA 支持 |
| **PDF** | Summarize | - | 多格式支持 |
| **YouTube** | Summarize | Agent Reach (yt-dlp) | 总结专用 |

### 内容生成选择

| 场景 | 推荐工具 | 原因 |
|------|---------|------|
| **文案** | content-agent | 专用 Agent |
| **图片** | visual-agent | Xskill 57+ 模型 |
| **视频** | video-agent | Seedance 生成 |

---

## ⚠️ 配置状态

### 需要配置 API Keys

- [ ] **Tavily Search** - https://tavily.com
- [ ] **Summarize** - Gemini/OpenAI/Anthropic/xAI
- [ ] **Exa Search** - Exa API Key
- [ ] **LinkedIn MCP** - MCP 配置
- [ ] **小红书 MCP** - MCP 配置
- [ ] **抖音** - 硅基流动 API Key

### 已配置（免费）

- [x] **Jina AI Search** - 完全免费
- [x] **Jina Reader** - 完全免费
- [x] **Reddit** - 完全免费
- [x] **YouTube** - 完全免费
- [x] **GitHub** - 完全免费
- [x] **Metaso Search** - 完全免费

---

## 📚 相关文档

- **主文档**: `/home/node/.openclaw/workspace/AGENTS-SKILLS-CAPABILITIES.md`
- **对比分析**: `/tmp/tavily-vs-agent-reach-comparison.md`
- **更正分析**: `/tmp/search-capability-correction.md`
- **Agent 矩阵**: `/home/node/.openclaw/workspace/docs/AGENT-MATRIX-REPLAN.md`

---

## 🎯 维护承诺

**我承诺**:

1. ✅ **对所有 Agents 和 Skills 了如指掌**
2. ✅ **主动维护完整的能力清单**
3. ✅ **避免错误的假设和陈述**
4. ✅ **在回答前验证工具能力**
5. ✅ **及时更新和学习新技能**
6. ✅ **从错误中学习和改进**

---

**最后更新**: 2026-03-09
**下次审查**: 每次安装新技能后
**维护者**: Main Agent
