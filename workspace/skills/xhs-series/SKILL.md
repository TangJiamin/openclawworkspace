---
name: xhs-series
description: 小红书图文系列生成器（基于 baoyu-xhs-images 简化版）。自动将内容拆分为 1-10 张小红书风格的信息图，支持 11 种风格 × 8 种布局 = 88 种组合。
version: 1.0.0
tags: [xhs, xiaohongshu, series, infographic, social-media]
category: content-production
---

# 小红书图文系列生成器 v1.0

基于 baoyu-xhs-images 核心逻辑，专为 OpenClaw Agent 矩阵优化的小红书图文系列生成工具。

## 🎯 核心特性

### 1. Style × Layout 二维系统

**11 种风格** × **8 种布局** = **88 种组合**

| 风格类型 | 风格 | 适用场景 |
|----------|------|----------|
| 甜美系 | cute, fresh, warm | 美妆、生活、日常 |
| 强力系 | bold, pop, retro | 警告、对比、盘点 |
| 知识系 | notion, chalkboard, study-notes | 知识科普、教程 |
| 极简系 | minimal, screen-print | 专业、商务、影评 |

### 2. 智能内容拆分

- ✅ 自动分析内容结构
- ✅ 智能拆分为 1-10 张图
- ✅ 保证逻辑连贯性
- ✅ 优化小红书"种草"场景

### 3. 快速预设

- ✅ 20+ 预设组合
- ✅ 一键应用
- ✅ 场景化推荐

---

## 🚀 快速开始

### 基础使用

```bash
# 自动模式（推荐）
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  "5个提高效率的AI工具"

# 指定风格
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --style notion

# 指定布局
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --layout dense

# 使用预设
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --preset knowledge-card
```

---

## 🎨 风格系统

### 知识系风格

| 风格 | 描述 | 最佳布局 |
|------|------|----------|
| **notion** | 极简手绘线稿，知识感 | dense, list, mindmap |
| **chalkboard** | 黑板粉笔风，教育感 | flow, balanced, dense |
| **study-notes** | 真实手写笔记风 | dense, list |

### 甜美系风格

| 风格 | 描述 | 最佳布局 |
|------|------|----------|
| **cute** | 甜美可爱，经典小红书风 | sparse, balanced |
| **fresh** | 清新自然 | balanced, flow |
| **warm** | 温暖亲切 | balanced |

### 强力系风格

| 风格 | 描述 | 最佳布局 |
|------|------|----------|
| **bold** | 强烈冲击 | list, comparison |
| **pop** | 活力炸裂 | sparse, list |
| **retro** | 复古怀旧 | list, balanced |

### 极简系风格

| 风格 | 描述 | 最佳布局 |
|------|------|----------|
| **minimal** | 超级干净 | sparse, balanced |
| **screen-print** | 海报艺术风 | sparse, comparison |

---

## 📐 布局系统

### 密度布局

| 布局 | 信息密度 | 留白 | 点数/图 |
|------|----------|------|---------|
| **sparse** | 低 | 60-70% | 1-2 |
| **balanced** | 中 | 40-50% | 3-4 |
| **dense** | 高 | 20-30% | 5-8 |

### 结构布局

| 布局 | 结构 | 项目数 | 适用场景 |
|------|------|--------|----------|
| **list** | 垂直枚举 | 4-7 | 排行榜、清单 |
| **comparison** | 左右对比 | 2 部分 | 前后对比、优缺点 |
| **flow** | 流程图 | 3-6 步 | 过程、时间线 |
| **mindmap** | 中心辐射 | 4-8 分支 | 概念图、脑图 |
| **quadrant** | 四象限 | 4 部分 | SWOT、分类 |

---

## 🎯 快速预设

### 知识学习类

| 预设 | 风格 | 布局 | 最佳用途 |
|------|------|------|----------|
| `knowledge-card` | notion | dense | 干货知识卡 |
| `checklist` | notion | list | 清单、排行 |
| `concept-map` | notion | mindmap | 概念图 |
| `swot` | notion | quadrant | SWOT 分析 |
| `tutorial` | chalkboard | flow | 教程步骤 |
| `classroom` | chalkboard | balanced | 课堂笔记 |
| `study-guide` | study-notes | dense | 学习笔记 |

### 生活分享类

| 预设 | 风格 | 布局 | 最佳用途 |
|------|------|------|----------|
| `cute-share` | cute | balanced | 少女风分享 |
| `girly` | cute | sparse | 甜美封面 |
| `cozy-story` | warm | balanced | 生活故事 |
| `product-review` | fresh | comparison | 产品对比 |

### 强力观点类

| 预设 | 风格 | 布局 | 最佳用途 |
|------|------|------|----------|
| `warning` | bold | list | 避坑指南 |
| `versus` | bold | comparison | 正反对比 |
| `clean-quote` | minimal | sparse | 金句封面 |
| `hype` | pop | sparse | 炸裂封面 |

### 复古娱乐类

| 预设 | 风格 | 布局 | 最佳用途 |
|------|------|------|----------|
| `retro-ranking` | retro | list | 复古排行 |
| `throwback` | retro | balanced | 怀旧分享 |
| `pop-facts` | pop | list | 趣味冷知识 |

### 海报编辑类

| 预设 | 风格 | 布局 | 最佳用途 |
|------|------|------|----------|
| `poster` | screen-print | sparse | 海报风封面 |
| `editorial` | screen-print | balanced | 观点文章 |
| `cinematic` | screen-print | comparison | 电影对比 |

---

## 📊 内容拆分策略

### Strategy A: 故事驱动型

**特点**:
- 个人体验为主线
- 情感共鸣优先
- 真实性强

**结构**: Hook → 问题 → 发现 → 体验 → 结论

**适用**: 测评、个人分享、转变故事

---

### Strategy B: 信息密集型

**特点**:
- 价值优先
- 高效信息传递
- 结构清晰

**结构**: 核心结论 → 信息卡 → 优缺点 → 推荐

**适用**: 教程、对比、产品测评、清单

---

### Strategy C: 视觉优先型

**特点**:
- 视觉冲击为核心
- 极简文字
- 即刻吸引力

**结构**: 主图 → 细节图 → 生活场景 → CTA

**适用**: 高颜值产品、生活方式、氛围内容

---

## 🎯 智能选择

### 内容信号识别

| 内容信号 | 推荐风格 | 推荐布局 | 推荐预设 |
|----------|----------|----------|----------|
| 美妆、时尚、可爱、粉色 | cute | sparse/balanced | cute-share, girly |
| 健康、自然、清新 | fresh | balanced/flow | product-review |
| 生活、故事、情感 | warm | balanced | cozy-story |
| 警告、重要、必须 | bold | list/comparison | warning, versus |
| 专业、商务、优雅 | minimal | sparse/balanced | clean-quote |
| 知识、概念、生产力 | notion | dense/list | knowledge-card |
| 教育、教程、学习 | chalkboard | balanced/dense | tutorial |
| 笔记、手写、学习 | study-notes | dense/list | study-guide |
| 电影、海报、观点 | screen-print | sparse/comparison | poster |

---

## 📐 画布规范

### 尺寸比例

| 名称 | 比例 | 像素 | 说明 |
|------|------|------|------|
| **portrait-3-4** | 3:4 | 1242×1660 | 最高流量（推荐） |
| **square** | 1:1 | 1242×1242 | 次推荐 |
| **portrait-2-3** | 2:3 | 1242×1863 | 更高格式 |

**默认**: portrait-3-4（最大互动）

### 安全区

避免在这些区域放置关键内容：

| 区域 | 位置 | 原因 |
|------|------|------|
| bottom-overlay | 底部 10% | 标题栏覆盖 |
| top-right | 右上角 | 点赞/分享按钮 |
| bottom-right | 右下角 | 水印位置 |

---

## 🔄 工作流程

### 生成流程

```
内容输入
  ↓
分析内容（识别信号）
  ↓
智能推荐（风格 + 布局）
  ↓
生成大纲（3 种策略）
  ↓
用户确认（快速/自定义/详细）
  ↓
拆分内容（1-10 张图）
  ↓
生成图片（逐张）
  ↓
完成报告
```

---

## 🎨 与 visual-generator 的关系

### visual-generator

- ✅ 单张图片生成
- ✅ 通用场景
- ✅ 快速生成

### xhs-series

- ✅ 系列 1-10 张图
- ✅ 小红书专用
- ✅ Style × Layout 系统
- ✅ 智能拆分

### 互补关系

- 单图需求 → visual-generator
- 系列图需求 → xhs-series
- xhs-series 可以调用 visual-generator 生成单张图片

---

## 📚 参考文档

- [baoyu-xhs-images 原始文档](https://github.com/JimLiu/baoyu-skills#baoyu-xhs-images)
- [风格定义](references/presets/)
- [布局定义](references/elements/canvas.md)

---

**基于**: baoyu-xhs-images v1.56.1
**简化者**: Main Agent
**日期**: 2026-03-11
**状态**: ✅ 学习完成，已简化适配
