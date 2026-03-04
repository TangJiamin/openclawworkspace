---
name: ai-daily-digest
description: AI Daily Digest - 从 90 个顶级技术博客抓取最新文章，AI 评分筛选，生成每日精选摘要。用于获取 AI/技术领域的最新高质量资讯。
tags: [ai, digest, tech-news, blog, rss, research]
category: content-research
---

# AI Daily Digest

## 简介

AI Daily Digest 从 90 个顶级技术博客（包括 OpenAI、Anthropic、Google DeepMind、Meta AI 等）抓取最新文章，使用 AI 多维评分筛选，生成结构化每日摘要。

**能力：**
- 从 90 个顶级技术博客抓取 RSS
- AI 多维评分筛选
- 生成结构化摘要
- 中英双语支持
- 6 大分类体系
- 趋势分析

## 快速使用

### 生成每日摘要

```bash
cd /home/node/.openclaw/workspace/skills/ai-daily-digest
npx tsx scripts/digest.ts
```

### 指定天数

```bash
npx tsx scripts/digest.ts 3  # 生成过去 3 天的摘要
```

### 指定分类

```bash
npx tsx scripts/digest.ts --category llm  # 仅 LLM 分类
npx tsx tsx scripts/digest.ts --category vision  # 仅视觉分类
```

### 保存到文件

```bash
npx tsx scripts/digest.ts > ~/digest-$(date +%Y%m%d).md
```

## 数据存储

生成的摘要保存在：
- `/home/node/.openclaw/workspace/skills/ai-daily-digest/data/digests/`

## 分类体系

1. **LLM/大模型** - GPT、Claude、Gemini 等
2. **视觉/多模态** - 图像生成、视频理解
3. **AI 工具** - 开发工具、框架
4. **研究论文** - arXiv、学术进展
5. **行业动态** - 公司新闻、产品发布
6. **最佳实践** - 工程、部署、优化

## API 依赖

需要配置：
- **ZHIPU_API_KEY**: 智谱 AI API key（用于评分和摘要）
- **GLM_MODEL**: 默认 `glm-4-plus`

## 集成方式

### 作为 Agent 触发

当用户说"获取今日 AI 资讯"、"生成技术摘要"时，自动运行 digest 脚本。

### 定时任务

使用 cron 定时生成：

```bash
# 每天早上 8 点生成
0 8 * * * cd /home/node/.openclaw/workspace/skills/ai-daily-digest && npx tsx scripts/digest.ts
```

## 输出格式

```markdown
# AI Daily Digest - 2026-02-28

## 📊 今日概览
- 新文章: 156 篇
- 高分文章: 23 篇
- 主要分类: LLM (8), 视觉 (6), 工具 (5)

## 🎯 重点推荐

### [9.2分] GPT-5 技术报告泄露
来源: OpenAI Blog | 分类: LLM
摘要: ...
