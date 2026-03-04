# Refly 视觉设计师 Hook

## 📖 概述

将 Refly 视觉设计工作流集成到 OpenClaw，实现 AI 驱动的视觉素材自动化生成。

**工作流 ID**: `c-anlbsxecm4d201aj4zgnph8y`

---

## 🎯 功能特性

### 支持的设计任务

- ✅ **封面图生成** - 文章封面、视频缩略图
- ✅ **信息图设计** - 数据可视化、流程图解
- ✅ **社交媒体图片** - 微博、小红书、Instagram 配图
- ✅ **品牌素材** - Logo、海报、Banner
- ✅ **PPT 配图** - 演示文稿插图

### 设计风格

- 🎨 **现代简约** - 扁平化、极简风格
- 🌈 **色彩丰富** - 渐变、鲜艳配色
- 💼 **商务专业** - 企业、科技风格
- 🎭 **创意艺术** - 抽象、艺术化设计

---

## 🚀 快速开始

### 1. 安装 Hook

```bash
cd ~/.openclaw/hooks/refly-visual-designer
npm install
npm run build
```

### 2. 配置环境变量

```bash
# 编辑 Gateway 配置
nano ~/.openclaw/gateway.env
```

添加：

```bash
REFLY_URL=http://refly.kmos.ai
REFLY_API_KEY=your-api-key
REFLY_VISUAL_WORKFLOW_ID=c-anlbsxecm4d201aj4zgnph8y
```

### 3. 启用 Hook

```bash
openclaw hooks enable refly-visual-designer
openclaw gateway restart
```

### 4. 测试

在任意平台发送：

```
生成封面图：AI时代的生产力革命
```

或：

```
设计信息图：2024年AI技术发展趋势
```

---

## 💬 使用示例

### 示例 1: 文章封面

```
生成封面图：
标题：ChatGPT-5 发布前瞻
风格：科技感
尺寸：16:9
```

### 示例 2: 数据可视化

```
设计信息图：
主题：AI模型参数量增长趋势
数据：GPT-3 (175B) → GPT-4 (1.7T) → GPT-5 (10T?)
形式：柱状图
```

### 示例 3: 社交媒体配图

```
生成小红书配图：
主题：AI工具推荐
风格：清新可爱
尺寸：1:1
```

### 示例 4: 批量生成

```
批量生成封面：
1. "AI重构工作流"
2. "自动化革命"
3. "智能决策系统"
风格统一：商务科技
```

---

## 🔧 配置选项

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `REFLY_URL` | `http://refly.kmos.ai` | Refly API 地址 |
| `REFLY_API_KEY` | *必填* | API 密钥 |
| `REFLY_VISUAL_WORKFLOW_ID` | *必填* | 视觉设计工作流 ID |
| `REFLY_TIMEOUT` | `60000` | 超时时间（毫秒）|
| `DESIGN_DEFAULT_STYLE` | `modern` | 默认设计风格 |
| `DESIGN_DEFAULT_SIZE` | `16:9` | 默认尺寸 |

### 设计风格选项

- `modern` - 现代简约
- `gradient` - 渐变色彩
- `business` - 商务专业
- `artistic` - 创意艺术
- `cute` - 清新可爱
- `dark` - 深色模式

---

## 📐 支持的尺寸

| 尺寸 | 用途 | 比例 |
|------|------|------|
| `16:9` | 视频缩略图、PPT | 1920x1080 |
| `4:3` | 传统演示 | 1440x1080 |
| `1:1` | 社交媒体 | 1080x1080 |
| `9:16` | 短视频 | 1080x1920 |
| `21:9` | 宽屏海报 | 2560x1080 |

---

## 🎨 工作流程

```
用户发送设计请求
    ↓
Hook 拦截并分析意图
    ↓
提取设计参数（主题、风格、尺寸）
    ↓
调用 Refly API
    ↓
Refly 工作流执行：
  - DALL-E/Midjourney 生成图片
  - 文字排版设计
  - 色彩方案优化
    ↓
返回设计结果
    ↓
发送图片到对话
    ↓
保存到本地（可选）
```

---

## 🤝 与 AI 媒体 Pipeline 集成

### 自动化流程

```bash
# 每日视觉设计任务（每天 11:00）
openclaw cron add \
  --name "daily-visual-design" \
  --schedule "cron" \
  --cron "0 11 * * *" \
  --sessionTarget "isolated" \
  --message "执行今日视觉素材生成"
```

### 与内容生成联动

```
热点监控 → 内容生成 → 视觉设计 → 发布
           (文案)      (配图)
```

---

## 📊 数据存储

设计结果保存在：

```
~/.openclaw/workspace/skills/ai-media-pipeline/data/designs/
├── designs_2026-02-27.json
└── images/
    ├── cover_20260227_001.png
    ├── cover_20260227_002.png
    └── ...
```

---

## 🛠️ 故障排除

### 问题：Hook 无响应

```bash
# 检查 Hook 状态
openclaw hooks check

# 查看 Gateway 日志
openclaw logs --tail 50 | grep visual-designer
```

### 问题：图片生成失败

- 检查 Refly API 密钥
- 验证工作流 ID 正确
- 确认 API 额度充足

### 问题：生成质量不佳

- 优化提示词描述
- 指定明确的设计风格
- 提供参考图片（如支持）

---

## 🚀 下一步

1. **优化提示词模板** - 建立不同场景的 prompt 库
2. **批量处理** - 支持一次性生成多个设计
3. **风格迁移** - 基于现有图片生成相似风格
4. **智能推荐** - 根据内容自动推荐设计风格

---

**让 AI 为你设计！** 🎨✨
