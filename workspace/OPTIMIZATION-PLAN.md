# Visual Generator 优化计划

**分析时间**: 2026-03-03 10:13 UTC
**参考**: baoyu-skills 的 baoyu-xhs-images

---

## 🎯 学习目标

### 1. 理解 baoyu-xhs-images 的核心思想

基于 README.md 的信息：

**核心概念**: Style × Layout 二维系统

**9种风格**:
- cute（可爱）
- fresh（清新）
- warm（温暖）
- bold（大胆）
- minimal（极简）
- tech（技术）
- nature（自然）
- elegant（优雅）
- dark（暗色）

**6种布局**:
- sparse（稀疏）
- balanced（平衡）
- dense（密集）
- list（列表）
- comparison（对比）
- flow（流程）

### 2. 对比我的 visual-generator

| 特性 | baoyu-xhs-images | visual-generator |
|------|------------------|-------------------|
| 概念 | Style × Layout | Style × Layout ✅ |
| 风格 | 9 种 | 9 种 ✅ |
| 布局 | 6 种 | 6 种 ✅ |
| 平台 | 小红书 | 多平台 |
| 实现 | Claude Code Plugin | Shell + GLM-4 |
| 集成 | Claude Code | Seedance API |

### 3. 识别优化点

**baoyu-xhs-images 的优势**:
- ✅ 与 Claude Code 深度集成
- ✅ 智能内容分析
- ✅ 自动参数推荐
- ✅ 优化的小红书体验

**我的 visual-generator 可以学习的**:
1. 自动内容分析
2. 智能参数推荐算法
3. 更好的用户体验
4. Claude Code 集成经验

---

## 📋 优化计划

### Phase 1: 增强自动分析（立即）

**当前**: 用户手动指定参数

**优化**: 自动分析内容并推荐参数

**实现**:
```bash
# 自动模式
visual-generator "生成小红书信息图：5个AI工具推荐"

# 系统会：
# 1. 分析内容类型（列表型/教程型/对比型）
# 2. 分析情感基调（积极/专业/轻松）
# 3. 推荐最佳 Style × Layout 组合
# 4. 生成图片
```

### Phase 2: 优化参数推荐（学习）

**当前**: 手动选择

**优化**: 智能推荐算法

**算法**:
```
内容分析 → 类型识别 → 风格匹配 → 布局匹配 → 输出推荐
```

### Phase 3: 集成到 Agent 系统

**当前**: 独立 Skill

**优化**: 深度集成到 visual-agent

```
visual-agent
  ↓
优先尝试调用 baoyu-xhs-images（如果已安装）
  ↓
如果不可用，使用 visual-generator
```

---

## 🔧 具体实施

### Step 1: 创建增强版 visual-generator v2.0

**文件**: `/home/node/.openclaw/workspace/skills/visual-generator-v2/SKILL.md`

**新功能**:
- 自动内容分析
- 智能参数推荐
- 更好的用户体验

### Step 2: 更新 visual-agent

**集成 baoyu-xhs-images**:
```bash
# 优先使用 baoyu-xhs-images
if has_skill "baoyu-xhs-images"; then
  /baoyu-xhs-images "$CONTENT"
else
  /visual-generator "$CONTENT"
fi
```

### Step 3: 创建对比文档

创建详细的对比分析文档

---

## 🎯 预期成果

1. ✅ 更智能的 visual-generator
2. ✅ 更好的用户体验
3. ✅ 与 baoyu-skills 互补
4. ✅ 保持现有功能

---

**维护者**: Main Agent  
**状态**: 准备开始实施
