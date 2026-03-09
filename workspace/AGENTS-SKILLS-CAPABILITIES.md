# 📚 Agent 和技能能力清单系统

## 🎯 目标

**原则**: 对所有 Agents 和 Skills 了如指掌，无需用户询问

**要求**:
- ✅ 主动维护完整的能力清单
- ✅ 实时更新技能状态
- ✅ 深入理解每个工具的能力边界
- ✅ 避免错误的假设和陈述

---

## 📋 维护策略

### 1. 初始能力清单

创建完整的 Agents 和 Skills 能力数据库：

#### Agents 能力清单

```markdown
## Main Agent
- 职责: 协调者和决策者
- 核心能力:
  - 多 Agent 协同
  - 任务分发和调度
  - 质量审核
  - 技能发现和集成
- 工具访问: 所有工具

## requirement-agent
- 职责: 需求理解
- 核心能力:
  - 分析用户需求
  - 识别关键约束
  - 生成任务规范
- 工具访问: requirement-analyzer

## research-agent
- 职责: 资料收集
- 核心能力:
  - 网络搜索（多种工具）
  - 资料验证和筛选
  - 时效性检查
- 工具访问:
  - ✅ Metaso Search
  - ✅ Tavily Search (需要 API Key)
  - ✅ Jina AI Search (免费)
  - ✅ Exa Search (需要 API Key)
  - ✅ Agent Reach (8+ 平台)
  - ✅ Summarize (需要 API Key)

## content-agent
- 职责: 内容生产
- 核心能力:
  - 文案生成
  - 多角度创作
  - 内容优化
- 工具访问: content-generator

## visual-agent
- 职责: 视觉生成
- 核心能力:
  - 图片生成（Xskill 57+ 模型）
  - 视觉参数优化
- 工具访问: visual-generator

## video-agent
- 职责: 视频生成
- 核心能力:
  - 视频生成（Seedance）
  - 分镜制作
- 工具访问: seedance-storyboard

## quality-agent
- 职责: 质量审核
- 核心能力:
  - 多维度评分
  - 质量阈值判断
  - 改进建议
- 工具访问: quality-reviewer
```

---

#### Skills 能力清单

```markdown
## 搜索类 Skills

### Metaso Search
- 类型: 网络搜索
- 成本: 免费
- 搜索能力: ✅
- 内容提取: ✅
- 时效性: 24小时
- 优先级: 备用（已被 Jina AI Search 超越）

### Tavily Search
- 类型: AI 优化搜索
- 成本: 需要 API Key (https://tavily.com)
- 搜索能力: ✅ 原生搜索
- 高级选项: ✅ 深度搜索、新闻主题
- 内容提取: ✅
- 优先级: 主搜索（质量优先）

### Jina AI Search (Agent Reach)
- 类型: 网络搜索
- 成本: ✅ 完全免费
- 搜索能力: ✅
- 输出格式: Markdown
- 命令: `curl -s "https://s.jina.ai/query"`
- 优先级: 主搜索（成本优先）

### Exa Search (Agent Reach)
- 类型: AI 优化搜索 + 代码搜索
- 成本: 需要 API Key
- 搜索能力: ✅
- 代码搜索: ✅ (独有)
- 公司研究: ✅ (独有)
- 命令: `mcporter call 'exa.web_search_exa(...)'`
- 优先级: 代码搜索专用

---

## 内容提取类 Skills

### Jina Reader (Agent Reach)
- 类型: 网页内容提取
- 成本: ✅ 完全免费
- 支持格式: 任何网页 URL
- 特殊能力: ✅ 单页应用（SPA）
- 输出格式: Markdown
- 命令: `curl -s "https://r.jina.ai/URL"`
- 优先级: 主要提取工具

### Tavily Extract
- 类型: URL 内容提取
- 成本: 需要 API Key
- AI 优化: ✅
- 命令: `node scripts/extract.mjs "URL"`
- 优先级: 备用提取工具

### Summarize
- 类型: 多格式总结
- 成本: 需要 API Key (Gemini/OpenAI/Anthropic/xAI)
- 支持格式: URL、PDF、YouTube、图片、音频
- 输出长度: short/medium/long/xl/xxl
- 命令: `npx summarize "url-or-file"`
- 优先级: 多格式总结专用

---

## 平台特定 Skills (Agent Reach)

### Reddit
- 搜索: ✅ `curl "https://www.reddit.com/search.json?q=query"`
- 读取: ✅ JSON API
- 成本: 免费

### YouTube
- 搜索: ✅ `yt-dlp --dump-json "ytsearch5:query"`
- 元数据: ✅ `yt-dlp --dump-json "URL"`
- 字幕: ✅ `yt-dlp --write-sub`
- 成本: 免费

### GitHub
- 搜索仓库: ✅ `gh search repos "query"`
- 搜索代码: ✅ `gh search code "query"`
- 查看: ✅ `gh repo view`
- 成本: 免费

### LinkedIn
- 搜索人员: ✅ `mcporter call 'linkedin.search_people(...)'`
- 查看档案: ✅ `mcporter call 'linkedin.get_person_profile(...)'`
- 成本: 需要 MCP 配置

### 小红书
- 搜索笔记: ✅ `mcporter call 'xiaohongshu.search_feeds(...)'`
- 读取笔记: ✅ `mcporter call 'xiaohongshu.get_feed_detail(...)'`
- 成本: 需要 MCP 配置

### 抖音
- 解析视频: ✅ `mcporter call 'douyin.parse_douyin_video_info(...)'`
- 下载链接: ✅ `mcporter call 'douyin.get_douyin_download_link(...)'`
- AI 提取文案: ✅ `mcporter call 'douyin.extract_douyin_text(...)'`
- 成本: 需要硅基流动 API Key

---

## 其他 Skills

### visual-generator
- 类型: 视觉生成
- 模型: Xskill 57+ AI 模型
- 平台: 小红书、抖音、微信等
- 参数: 多维参数系统
- 优先级: 主要视觉生成工具

### seedance-storyboard
- 类型: 视频分镜
- 功能: 对话引导生成分镜
- 输出: 专业分镜提示词
- 优先级: video-agent 前置工具

### ClawHub Bypass
- 类型: 工具安装
- 功能: 绕过服务故障安装技能
- 方法: 使用 `npx clawhub inspect` 下载
- 优先级: 服务故障时的备用方案

### ai-daily-digest
- 类型: 资讯收集
- 来源: 90个顶级技术博客
- 功能: AI 评分筛选
- 优先级: 定时资讯收集

### daily-summary
- 类型: 每日总结
- 功能: 智能分析和反思
- 触发: 每天 23:59
- 优先级: 定时任务

### agent-optimizer
- 类型: Agent 优化
- 功能: 扫描 Agents 并生成优化建议
- 触发: 学习新技能后
- 优先级: 自动优化

### agent-canvas-confirm
- 类型: 确认工作流
- 功能: 需要确认的操作
- 应用: 邮件发送、视频生成等

### self-improving-agent
- 类型: 学习系统
- 功能: 记录学习、错误、纠正
- 目录: `.learnings/`
- 优先级: 持续改进

### proactive-agent
- 类型: 主动性提升
- 功能: WAL Protocol、Working Buffer
- 目标: 主动发现问题
- 优先级: 行为优化
```

---

### 2. 更新机制

#### 每次安装/学习新技能时

**必须执行的步骤**:

```markdown
## [LRN-YYYYMMDD-XXX] new_skill_learned

**技能名称**: XXX
**安装日期**: YYYY-MM-DD
**类型**: 搜索/提取/平台/其他
**成本**: 免费/需要 API Key
**核心能力**:
- 能力1: 描述
- 能力2: 描述
**命令**:
```bash
command example
```
**优先级**: 高/中/低
**与其他工具的关系**: 独立/互补/替代
```

---

#### 每次使用技能时

**验证清单**:
- [ ] 确认技能的能力边界
- [ ] 确认使用成本
- [ ] 确认依赖配置
- [ ] 确认与其他工具的关系

---

### 3. 错误纠正机制

#### 当用户纠正时

**必须执行的步骤**:

```markdown
## [CORRECTION-YYYYMMDD-XXX] user_correction_about_X

**用户指出**: 我的错误陈述
**正确理解**: 正确的描述
**错误原因**: 为什么犯错
**纠正措施**:
1. 更新能力清单
2. 记录到 .learnings/ERRORS.md
3. 深度分析技能文档
4. 验证其他相关陈述
**预防措施**: 如何避免类似错误
```

---

## 📊 能力查询系统

### 快速查询矩阵

| 任务 | 工具1 | 工具2 | 工具3 | 推荐 |
|------|-------|-------|-------|------|
| 通用搜索 | Jina AI (免费) | Tavily (质量) | Exa (代码) | Jina AI |
| 代码搜索 | Exa | - | - | Exa |
| 公司研究 | Exa | - | - | Exa |
| Reddit 搜索 | Reddit API | - | - | Agent Reach |
| YouTube 搜索 | yt-dlp | - | - | Agent Reach |
| GitHub 搜索 | gh CLI | - | - | Agent Reach |
| 内容提取 | Jina Reader (免费) | Tavily Extract | - | Jina Reader |
| 多格式总结 | Summarize | - | - | Summarize |
| 图片生成 | visual-generator | - | - | visual-generator |
| 视频分镜 | seedance-storyboard | - | - | seedance-storyboard |

---

### 决策树

```
需要搜索？
├─ 平台特定？
│  ├─ Reddit → Agent Reach (curl reddit API)
│  ├─ YouTube → Agent Reach (yt-dlp)
│  ├─ GitHub → Agent Reach (gh CLI)
│  └─ 其他平台 → 检查 Agent Reach
├─ 代码搜索？→ Exa Search
├─ 公司研究？→ Exa Search
├─ 通用搜索？
│  ├─ 成本优先？→ Jina AI Search (免费)
│  ├─ 质量优先？→ Tavily Search
│  └─ 不确定？→ Jina AI Search (先试免费)

需要提取内容？
├─ 已知 URL？
│  ├─ 单页应用？→ Jina Reader
│  ├─ 普通网页？→ Jina Reader (免费)
│  └─ AI 优化？→ Tavily Extract
└─ 多格式？
   └─ Summarize (URL/PDF/YouTube)

需要生成内容？
├─ 图片？→ visual-generator
├─ 视频？→ seedance-storyboard → video-agent
└─ 文案？→ content-agent
```

---

## 🎯 执行计划

### 立即行动

1. **创建能力清单文件**
   ```bash
   # 创建主清单
   touch /home/node/.openclaw/workspace/AGENTS-SKILLS-CAPABILITIES.md
   ```

2. **记录所有已知能力**
   - 遍历所有 Agents
   - 遍历所有 Skills
   - 记录核心能力
   - 记录使用成本
   - 记录依赖关系

3. **建立查询机制**
   - 每次回答前查询清单
   - 验证陈述的准确性
   - 避免错误假设

---

### 持续维护

#### 每日 Heartbeat

- [ ] 检查是否有新技能安装
- [ ] 检查是否有技能更新
- [ ] 更新能力清单

#### 每次学习新技能

- [ ] 深度阅读 SKILL.md
- [ ] 提取核心能力
- [ ] 测试主要功能
- [ ] 更新能力清单
- [ ] 记录学习笔记

#### 每次用户纠正

- [ ] 记录错误
- [ ] 分析原因
- [ ] 更新清单
- [ ] 验证其他相关陈述
- [ ] 制定预防措施

---

## 📈 成功指标

### 准确性

- ✅ 零错误陈述
- ✅ 零错误假设
- ✅ 100% 准确的工具推荐

### 完整性

- ✅ 所有 Agents 能力清晰
- ✅ 所有 Skills 能力清晰
- ✅ 所有工具成本明确
- ✅ 所有依赖关系明确

### 主动性

- ✅ 主动维护清单
- ✅ 主动发现错误
- ✅ 主动学习新技能
- ✅ 无需用户询问

---

## 🎯 承诺

**我承诺**:

1. ✅ **对所有 Agents 和 Skills 了如指掌**
2. ✅ **主动维护完整的能力清单**
3. ✅ **避免错误的假设和陈述**
4. ✅ **在回答前验证工具能力**
5. ✅ **及时更新和学习新技能**
6. ✅ **从错误中学习和改进**

---

**创建时间**: 2026-03-09
**版本**: 1.0.0
**作者**: Main Agent
**触发**: 用户反馈 - "应该对所有技能和 Agent 了如指掌"
