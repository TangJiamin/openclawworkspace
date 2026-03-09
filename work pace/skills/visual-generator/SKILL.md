---
name: visual-generator
description: 智能视觉内容生成器（v3.0）。自动分析内容、智能选择模型、生成高质量图片。支持小红书、抖音、微信等平台。
tags: [visual, image, generation, xhs, infographic, ai]
category: content-production
version: 3.0
---

# 🎨 Visual Generator v3.0 - 智能视觉生成器

基于内容分析自动推荐视觉风格、智能选择模型、生成高质量图片的智能生成工具（v3.0）。

## 🎯 v3.0 核心能力

### 1. 智能模型选择

**根据场景自动选择最优模型**:

| 场景 | 推荐模型 | 理由 |
|------|---------|------|
| 小红书封面 | jimeng-5.0 | 性价比高，2K/4K |
| 商业广告 | flux-realism | 照片级写实 |
| 抖音视频封面 | jimeng-5.0 | 性价比高，快速 |
| 人物肖像 | flux-realism | 写实风格 |
| 快速测试 | jimeng-5.0 | 速度快 |

### 2. 多层备用方案

```
jimeng-5.0（优先）
  ↓ 失败
flux-realism（备用）
  ↓ 失败
本地生成（最后）
```

### 3. 统一 API 接口

- 支持 57+ 个 Xskill 模型
- 统一的调用方式
- 自动轮询任务状态

---

## 🚀 快速开始

### 基础使用

```bash
# 自动模式（推荐）
bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/generate.sh \
  "5个提高效率的AI工具"

# 系统会自动：
# 1. 分析内容（列表型工具推荐）
# 2. 推荐参数（style=fresh, layout=list）
# 3. 选择模型（jimeng-5.0）
# 4. 生成图片
```

### 高级使用

```bash
# 指定模型
bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/generate.sh \
  "商业产品广告" \
  --model "flux-realism"

# 指定参数
bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/generate.sh \
  "产品渲染图" \
  --style "technical" \
  --ratio "3:4" \
  --resolution "2k"
```

---

## 🎓 决策指南（AI 模型决策）

### 场景匹配

当用户请求生成图片时，AI 模型应该根据以下标准判断：

#### 小红书封面
- **特征**: 3:4 比例、高饱和度、可爱风格
- **推荐**: jimeng-5.0
- **理由**: 性价比高（2 积分），质量稳定

#### 商业广告
- **特征**: 照片级写实、专业感、高端
- **推荐**: flux-realism
- **理由**: 商业级质量，写实效果

#### 人物肖像
- **特征**: 真实感、细节丰富、皮肤质感
- **推荐**: flux-realism
- **理由**: 写实风格顶级

#### 抖音/视频封面
- **特征**: 快速生成、成本敏感
- **推荐**: jimeng-5.0
- **理由**: 速度快，性价比高

#### 快速测试
- **特征**: 速度优先、批量生成
- **推荐**: jimeng-5.0
- **理由**: 速度快

---

## 🎨 参数推荐

### 风格 (Style)

- `fresh` - 清新（自然、明亮）- 小红书教程
- `bold` - 大胆（高对比、强烈）- 抖音封面
- `minimal` - 极简（干净、简洁）- 微信封面
- `technical` - 技术（蓝图、工程）- 产品渲染
- `warm` - 温暖（柔和、亲和）- 情感内容
- `elegant` - 优雅（高级、质感）- 奢侈品

### 布局 (Layout)

- `sparse` - 稀疏（1-2 点）- 封面
- `balanced` - 平衡（3-4 点）- 标准内容
- `dense` - 密集（5-8 点）- 知识卡片
- `list` - 列表（4-7 项）- 排名、清单

### 色彩 (Palette)

- `vivid` - 鲜艳（高饱和度）- 多巴胺配色
- `pastel` - 柔和（粉彩色）- 治愈系
- `monochrome` - 单色（统一色调）- 极简风

---

## 🔄 工作流程

```
用户输入内容
    ↓
1. 内容分析
    ├─ 识别内容类型
    ├─ 识别情感基调
    └─ 识别目标平台
    ↓
2. 参数推荐
    ├─ 匹配风格（fresh/bold/warm/etc）
    ├─ 匹配布局（sparse/balanced/dense/list）
    └─ 匹配色彩（vivid/pastel/monochrome）
    ↓
3. 模型选择
    ├─ AI 智能判断场景
    ├─ 根据场景选择模型
    └─ 考虑成本和质量
    ↓
4. 生成提示词
    ├─ 风格 → 描述
    ├─ 布局 → 描述
    └─ 色彩 → 描述
    ↓
5. 调用 API
    ├─ 主模型（jimeng-5.0/flux-realism）
    ├─ 备用模型（失败时）
    └─ 返回图片 URL
```

---

## 💡 使用示例

### 示例1：小红书封面

```bash
# 输入
generate "小红书封面，5个AI工具推荐"

# AI 模型决策
# 1. 识别：小红书 + 教程类
# 2. 推荐：style=fresh, layout=list, palette=vivid
# 3. 选择：jimeng-5.0
# 4. 生成提示词
# 5. 调用 API

# 输出
✅ 图片生成成功
🔗 图片URL: https://...
📊 模型: jimeng-5.0
💰 消耗积分: 2
```

### 示例2：商业广告

```bash
# 输入
generate "商业产品广告，luxury perfume"

# AI 模型决策
# 1. 识别：商业 + 产品
# 2. 推荐：professional, studio lighting
# 3. 选择：flux-realism
# 4. 生成提示词
# 5. 调用 API

# 输出
✅ 图片生成成功
🔗 图片URL: https://...
📊 模型: flux-realism
💰 消耗积分: X
```

---

## ⚠️ 注意事项

### API Key

- ✅ 自动从环境变量 `XSKILL_API_KEY` 读取
- ⚠️ 位置：`/home/node/.openclaw/.env`

### 多层备用方案

1. **jimeng-5.0**（优先）
2. **flux-realism**（备用）
3. **本地生成**（最后）

### 消耗积分

| 模型 | 积分/次 |
|------|---------|
| jimeng-5.0 | 2 |
| flux-realism | 待测试 |

---

## 📖 学习来源

### 从 ai-daily 学习

- ✅ 多层备用方案设计
- ✅ 智能判断逻辑（时间判断）
- ✅ 优先级筛选系统

### 从 article-illustrator 学习

- ✅ 详细的决策指南写法
- ✅ 场景匹配逻辑
- ✅ 多角度策略

---

**版本**: 3.0
**维护者**: Main Agent
**更新时间**: 2026-03-06
**新增功能**: 智能模型选择、多层备用方案、统一 API 接口
**学习来源**: ai-daily + article-illustrator
