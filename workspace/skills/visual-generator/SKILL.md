---
name: visual-generator
description: 智能视觉内容生成器（v3.1 增强版）。自动分析内容、智能选择模型、生成高质量图片。支持小红书、抖音、微信等平台。
tags: [visual, image, generation, xhs, infographic, ai]
category: content-production
version: 3.1
---

# 🎨 Visual Generator v3.1 - 智能视觉生成器

基于内容分析自动推荐视觉风格、智能选择模型、生成高质量图片的智能生成工具（v3.1 增强版）。

## 🎯 v3.1 核心升级

### 1. 详细的决策标准（NEW ⭐）

**学习自 article-illustrator**

- ✅ 场景判断标准（关键词识别）
- ✅ 风格选择决策树
- ✅ 模型选择决策逻辑

### 2. 参考文档系统（NEW ⭐）

**学习自 article-illustrator**

- ✅ `style-guide.md` - 视觉风格指南
- ✅ `model-guide.md` - 模型选择指南
- ✅ 避免在 SKILL.md 中重复细节

### 3. 保留 v3.0 能力

- ✅ 智能模型选择
- ✅ 多层备用方案
- ✅ 统一 API 接口

---

## 🚀 快速开始

### 基础使用

```bash
# 自动模式（推荐）
bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/generate.sh \
  "5个提高效率的AI工具"

# 系统会自动：
# 1. 分析内容类型
# 2. 推荐风格和参数
# 3. 选择最优模型
# 4. 生成图片
```

---

## 🎓 决策标准

### 场景识别标准

**判断流程**：

1. **扫描关键词**
   - 商业广告 → flux-realism
   - 人物肖像 → flux-realism
   - 小红书 → jimeng-5.0
   - 抖音 → jimeng-5.0
   - 其他 → jimeng-5.0

2. **分析内容类型**
   - 教程/指南 → fresh
   - 新闻/资讯 → bold
   - 情感/故事 → warm
   - 技术/文档 → technical

3. **评估质量要求**
   - 商业级 → flux-realism
   - 日常级 → jimeng-5.0
   - 测试级 → flux/schnell

### 风格选择决策

```markdown
| 内容类型 | 情感基调 | 推荐风格 |
|---------|---------|---------|
| 教程/指南 | 轻松 | fresh |
| 新闻/资讯 | 震撼 | bold |
| 情感/故事 | 宁静 | warm |
| 技术/文档 | 专业 | technical |
| 商务/广告 | 高级 | elegant |
```

### 模型选择决策

```markdown
## 决策树

用户请求生成图片
    ↓
是否需要照片级写实？
    ↓ 是
├─ 商业广告 → flux-realism
├─ 人物肖像 → flux-realism
└─ 产品渲染 → flux-realism
    ↓ 否
├─ 小红书封面 → jimeng-5.0
├─ 抖音封面 → jimeng-5.0
└─ 微信配图 → jimeng-5.0
```

---

## 📖 参考文档

详细的指南请参考：

- **视觉风格指南**: `references/style-guide.md`
  - 风格分类（fresh, bold, minimal, warm, technical, elegant）
  - 平台风格（小红书、抖音、微信）
  - 配色方案
  - 构图原则

- **模型选择指南**: `references/model-guide.md`
  - 模型对比（jimeng-5.0, flux-realism, flux/schnell）
  - 场景匹配（商业项目、小红书、抖音、肖像）
  - 决策树
  - 成本对比

---

## 🔄 工作流程

```
用户输入内容
    ↓
步骤一：内容分析
    ├─ 识别内容类型
    ├─ 识别情感基调
    └─ 识别目标平台
    ↓
步骤二：风格推荐
    ├─ 匹配风格（fresh/bold/warm/etc）
    ├─ 匹配布局（sparse/balanced/dense/list）
    └─ 匹配色彩（vivid/pastel/monochrome）
    ↓
步骤三：模型选择
    ├─ 判断场景
    ├─ 评估质量要求
    └─ 选择最优模型
    ↓
步骤四：生成提示词
    ├─ 风格 → 描述
    ├─ 布局 → 描述
    └─ 色彩 → 描述
    ↓
步骤五：调用 API
    ├─ 主模型（jimeng-5.0/flux-realism）
    ├─ 备用模型（失败时）
    └─ 返回图片 URL
```

---

## 💡 使用示例

### 示例1：小红书封面

```bash
# 输入
generate "小红书封面，推荐5个AI写作工具"

# 自动处理
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
generate "商业产品广告，luxury perfume bottle" --model "flux-realism"

# 自动处理
# 1. 识别：商业 + 产品
# 2. 推荐：professional, studio lighting
# 3. 选择：flux-realism（用户指定）
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

**版本**: 3.1（增强版）
**维护者**: Main Agent
**更新时间**: 2026-03-06
**新增功能**: 详细的决策标准、参考文档系统
**学习来源**: article-illustrator（决策逻辑 + 参考文档）
