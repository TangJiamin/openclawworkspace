# 学习记录

本文档记录从 ClawHub、官方文档、开源项目中学到的技能和知识。

---

## [LRN-20260308-001] Tavily Web Search Skill

**Logged**: 2026-03-08T21:30:00Z
**Priority**: high
**Status**: pending
**Area**: infra

### 技能描述

AI-optimized web search via Tavily API. Returns concise, relevant results for AI agents.

### 核心价值

- **AI 优化**: 专为 AI Agent 设计的搜索 API
- **简洁结果**: 返回简洁、相关的结果（不需要进一步处理）
- **与现有搜索对比**: 
  - metaso-search: 需要调用外部脚本，结果格式化
  - tavily-search: 原生 AI 优化，结果更直接

### 应用场景

1. **research-agent 增强**
   - 替代或补充 metaso-search
   - 提供更快速的搜索结果
   - 减少结果处理时间

2. **实时资讯收集**
   - AI Daily Digest 可以使用
   - 更快的搜索速度

### 安装方式

```bash
npx clawhub@latest install tavily-search
```

### 学习笔记

- 需要配置 Tavily API Key
- 可能需要环境变量配置
- 需要测试与 metaso-search 的效果对比

### 下一步行动

- [ ] 安装 tavily-search
- [ ] 配置 API Key
- [ ] 对比测试（tavily vs metaso）
- [ ] 评估是否替换 research-agent 中的搜索工具

---

## [LRN-20260308-002] Summarize Skill

**Logged**: 2026-03-08T21:35:00Z
**Priority**: high
**Status**: pending
**Area**: backend

### 技能描述

Summarize URLs or files with the summarize CLI (web, PDFs, images, audio, YouTube).

### 核心价值

- **多格式支持**: Web、PDFs、图片、音频、YouTube
- **统一接口**: 一个命令处理所有格式
- **增强 research-agent**: 可以快速总结多种来源的资料

### 应用场景

1. **research-agent 增强**
   - 快速总结 YouTube 视频（AI 行业动态）
   - 总结 PDF 研究报告
   - 总结长文章

2. **内容生产**
   - content-agent 可以使用
   - 快速理解参考资料

3. **学习效率**
   - 总结技术文档
   - 总结 GitHub README

### 安装方式

```bash
npx clawhub@latest install summarize
```

### 学习笔记

- 需要测试 YouTube 总结效果
- 需要测试 PDF 总结效果
- 可能需要配置 API Key

### 下一步行动

- [ ] 安装 summarize
- [ ] 测试 YouTube 总结
- [ ] 测试 PDF 总结
- [ ] 集成到 research-agent

---

## [LRN-20260308-003] Find Skills Skill

**Logged**: 2026-03-08T21:40:00Z
**Priority**: medium
**Status**: pending
**Area**: infra

### 技能描述

Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities.

### 核心价值

- **自动发现**: 当用户询问功能时，自动搜索相关技能
- **自然语言**: 理解用户的意图（"怎么做 X"、"有技能能做 X 吗"）
- **持续学习**: 自动发现 ClawHub 上的新技能

### 应用场景

1. **Main Agent 增强**
   - 用户询问"能否总结 PDF"时，自动发现 summarize skill
   - 用户询问"能否搜索 GitHub"时，自动发现 github skill

2. **主动性提升**
   - 当发现现有能力不足时，主动搜索相关技能
   - 符合 Proactive Agent 的理念

### 安装方式

```bash
npx clawhub@latest install find-skills
```

### 学习笔记

- 这个技能是"技能的技能"
- 可以大大降低发现新技能的成本
- 符合持续改进的理念

### 下一步行动

- [ ] 安装 find-skills
- [ ] 测试自然语言查询
- [ ] 集成到 Main Agent

---

## [LRN-20260308-004] 其他观察到的技能

**Logged**: 2026-03-08T21:45:00Z
**Priority**: low
**Status**: pending
**Area**: infra

### Gog - Google Workspace CLI

- 功能: Gmail, Calendar, Drive, Contacts, Sheets, Docs
- 应用: 可能用于自动化文档管理、日历同步
- 优先级: 中等（如果需要 Google Workspace 集成）

### Github - GitHub CLI

- 功能: gh issue, gh pr, gh run, gh api
- 应用: 可能用于 GitHub 项目管理、CI 监控
- 优先级: 低（当前不涉及 GitHub 操作）

### Notion - Notion API

- 功能: 创建和管理页面、数据库、块
- 应用: 可能用于知识管理、笔记同步
- 优先级: 低（已有 Feishu 集成）

### Nano Pdf - PDF 编辑

- 功能: 用自然语言编辑 PDF
- 应用: PDF 处理
- 优先级: 中等（如果需要 PDF 编辑）

### Obsidian - Obsidian vaults

- 功能: 管理 Obsidian vaults（Markdown 笔记）
- 应用: 可能用于笔记管理
- 优先级: 低（当前使用 MEMORY.md 系统）

---

## 优先级排序

基于当前 Agent 矩阵项目需求：

### 高优先级（立即安装）

1. **tavily-search** - 增强搜索能力（research-agent）
2. **summarize** - 多格式总结（research-agent, content-agent）

### 中优先级（近期安装）

3. **find-skills** - 技能自动发现（Main Agent）
4. **nano-pdf** - PDF 处理（如果需要）

### 低优先级（按需安装）

5. **github** - GitHub 管理（如果需要）
6. **notion** - Notion 集成（如果需要）
7. **gog** - Google Workspace（如果需要）
8. **obsidian** - Obsidian 管理（如果需要）

---

## 学习总结

### 关键洞察

**第一性原理分析**:
- 本质: 从"手动发现技能"到"自动发现技能"
- 拆解:
  1. ClawHub 是技能生态的核心
  2. find-skills 是"技能的技能"（元技能）
  3. tavily-search 和 summarize 直接增强 Agent 矩阵能力
- 构建: 优先安装高优先级技能，测试后集成
- 验证: 安装后运行 Agent 优化检查器

### 能力提升路径

```
当前能力（metaso-search）
  ↓
安装 tavily-search
  ↓
对比测试（速度、质量、成本）
  ↓
选择最优方案
  ↓
更新 research-agent
```

### 与 Agent 矩阵的关联

**research-agent 增强**:
- ✅ tavily-search（AI 优化搜索）
- ✅ summarize（多格式总结）

**content-agent 增强**:
- ✅ summarize（快速理解参考资料）

**Main Agent 增强**:
- ✅ find-skills（自动发现技能）

---

**维护者**: Main Agent
**更新时间**: 2026-03-08 21:45
**版本**: 1.0
