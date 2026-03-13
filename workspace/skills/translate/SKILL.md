---
name: translate
description: 多语言翻译工具（基于 baoyu-translate 简化版）。支持三模式翻译（quick/normal/refined）、术语管理、智能分块。
version: 1.0.0
tags: [translate, translation, multilingual]
category: utility
---

# 多语言翻译工具 v1.0

基于 baoyu-translate 核心逻辑，专为 OpenClaw Agent 矩阵优化的翻译工具。

## 🎯 核心特性

### 1. 三模式翻译系统

| 模式 | 步骤 | 适用场景 | 质量 |
|------|------|----------|------|
| **quick** | 直接翻译 | 短文本、非正式内容、快速任务 | ⭐⭐ |
| **normal** | 分析→翻译 | 文章、博客、通用内容 | ⭐⭐⭐⭐ |
| **refined** | 分析→翻译→审核→润色 | 出版级质量、重要文档 | ⭐⭐⭐⭐⭐ |

### 2. 术语管理系统

- ✅ 全局术语表（Glossary）
- ✅ 项目级术语表（EXTEND.md）
- ✅ 自动术语提取
- ✅ 术语一致性保证

### 3. 智能分块

- ✅ 自动识别长文档
- ✅ 按 Markdown 结构分块
- ✅ 保证术语一致性

---

## 🚀 快速开始

### 基础使用

```bash
# 自动模式（推荐）
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  "Hello, world!" \
  --from en \
  --to zh-CN

# 快速模式（短文本）
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  "This is a test." \
  --mode quick

# 正常模式（文章）
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  /path/to/article.md \
  --mode normal

# 精细模式（出版级）
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  /path/to/important.md \
  --mode refined
```

---

## 📋 模式详解

### Quick 模式（快速翻译）

**特点**:
- ✅ 直接翻译
- ✅ 无分析步骤
- ✅ 适合短文本

**适用场景**:
- 社交媒体帖子
- 聊天消息
- 快速查询
- 非正式内容

**限制**:
- ⚠️ 不分块
- ⚠️ 无术语表
- ⚠️ 质量较低

---

### Normal 模式（标准翻译）

**特点**:
- ✅ 分析内容
- ✅ 生成翻译提示词
- ✅ 应用术语表
- ✅ 智能分块

**步骤**:
1. **分析** → 识别领域、语气、术语
2. **组装提示词** → 整合术语表和上下文
3. **翻译** → 按提示词翻译
4. **合并** → 合并分块（如有）

**适用场景**:
- 文章
- 博客
- 技术文档
- 通用内容

---

### Refined 模式（精细翻译）

**特点**:
- ✅ 完整工作流
- ✅ 质量审核
- ✅ 多轮润色
- ✅ 出版级质量

**步骤**:
1. **分析** → 深度内容分析
2. **组装提示词** → 详细翻译指令
3. **草稿** → 初始翻译
4. **审核** → 诊断问题
5. **修订** → 修正问题
6. **润色** → 最终润色

**适用场景**:
- 出版物
- 重要文档
- 官方公告
- 品牌内容

---

## 🎨 翻译风格

| 风格 | 描述 | 效果 |
|------|------|------|
| `storytelling` | 引人入胜的叙事（默认） | 吸引读者，流畅过渡 |
| `formal` | 专业、结构化 | 中立语气，清晰组织 |
| `technical` | 精确、文档风格 | 简洁，术语密集 |
| `literal` | 接近原文结构 | 最小化重组 |
| `academic` | 学术、严谨 | 正式语域，复杂句式 |
| `business` | 简洁、结果导向 | 行动导向，高管友好 |
| `conversational` | 口语化 | 友好、平易近人 |
| `elegant` | 文学、优雅 | 审美精炼，节奏感 |

---

## 🎯 受众类型

| 受众 | 描述 | 效果 |
|------|------|------|
| `general` | 普通读者（默认） | 平实语言，更多注释 |
| `technical` | 开发者/工程师 | 减少常见技术术语注释 |
| `academic` | 研究者/学者 | 正式语域，精确术语 |
| `business` | 商务人士 | 商务友好，解释技术概念 |

---

## 📖 术语管理

### 术语表优先级

1. **全局术语表**: `~/.translate/glossary-global.md`
2. **项目术语表**: `.translate/EXTEND.md`
3. **自动提取**: 从文档中提取

### 术语表格式

```markdown
# Glossary

| 原文 | 译文 | 说明 |
|------|------|------|
| AI | 人工智能 | Artificial Intelligence |
| LLM | 大语言模型 | Large Language Model |
| Agent | 智能体 | 自主决策的AI系统 |
```

---

## 🔧 配置文件

### EXTEND.md 格式

```yaml
# 默认设置
target_language: zh-CN
default_mode: normal
audience: general
style: storytelling

# 术语表
glossary:
  AI: 人工智能
  LLM: 大语言模型
  Agent: 智能体

# 分块设置
chunk_threshold: 4000
chunk_max_words: 5000
```

---

## 📂 输出结构

```
article-zh-CN/
├── translation.md          # 最终翻译（始终存在）
├── 01-analysis.md          # 内容分析（normal/refined）
├── 02-prompt.md            # 翻译提示词（normal/refined）
├── 03-draft.md             # 初始草稿（refined）
├── 04-critique.md          # 审核诊断（refined）
├── 05-revision.md          # 修订版本（refined）
└── chunks/                 # 分块（如有）
    ├── chunk-01.md
    ├── chunk-01-draft.md
    └── ...
```

---

## 🎯 翻译原则

### 核心原则

1. **准确性优先**: 事实、数据、逻辑必须完全匹配
2. **意译优先**: 翻译作者的意思，而不仅仅是字面意思
3. **自然流畅**: 使用地道的目标语言表达
4. **术语一致**: 使用标准翻译，首次出现加注释
5. **保持格式**: 保留所有 Markdown 格式
6. **情感保真**: 保留词语的情感内涵

### 具体技巧

#### 比喻和习语
- ❌ 不要逐字翻译
- ✅ 按意图翻译
- ✅ 替换为自然表达

#### 情感词汇
- ❌ 只翻译字面意思
- ✅ 保留情感内涵
- ✅ 引发相同反应

#### 句子结构
- ❌ 僵化保留原文结构
- ✅ 自由重组
- ✅ 符合目标语言习惯

#### 译者注释
```
译文（English original，通俗解释）
```

---

## 🚀 集成到 Agent 矩阵

### research-agent

**用途**: 翻译外文资料

```bash
# 示例：翻译英文技术文章
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  /path/to/english-article.md \
  --mode normal \
  --style technical \
  --audience technical
```

### content-agent

**用途**: 多语言内容生产

```bash
# 示例：将中文内容翻译成英文
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  /path/to/chinese-content.md \
  --from zh-CN \
  --to en \
  --mode refined \
  --style storytelling
```

---

## 📚 参考文档

- [baoyu-translate 原始文档](https://github.com/JimLiu/baoyu-skills#baoyu-translate)
- [翻译最佳实践](https://github.com/JimLiu/baoyu-skills/blob/main/skills/baoyu-translate/references/translation-best-practices.md)
- [精细工作流](https://github.com/JimLiu/baoyu-skills/blob/main/skills/baoyu-translate/references/refined-workflow.md)

---

**基于**: baoyu-translate v1.56.1
**简化者**: Main Agent
**日期**: 2026-03-11
**状态**: ✅ 学习完成，已简化适配
