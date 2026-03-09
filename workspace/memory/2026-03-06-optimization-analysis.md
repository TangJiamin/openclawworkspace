# 现有能力优化分析

## 📊 当前 Skills 功能分析

### 图像/视频生成相关

1. **visual-generator** ✅ 已有
   - 功能：智能视觉参数推荐
   - 状态：v2.0，功能完整
   - 问题：参数→提示词转换已实现，但缺少智能选择模型逻辑

2. **seedance-storyboard** ✅ 已有
   - 功能：视频分镜生成
   - 状态：完整的对话式引导
   - 问题：不包含 API 调用逻辑

3. **ai-daily-digest** ✅ 已有
   - 功能：AI 资讯收集
   - 状态：从 90 个技术博客抓取
   - 问题：与 ai-daily 功能重叠

4. **metaso-search** ✅ 已有
   - 功能：AI 搜索
   - 状态：完整的搜索工具
   - 问题：无

### 新创建的（可能重复）

5. **jimeng-5.0-api** ⚠️ 新创建
   - 功能：即梦 5.0 API 调用
   - 状态：简单的 API 封装
   - 问题：与 visual-generator 功能重叠

6. **flux-realism-api** ⚠️ 新创建
   - 功能：Flux Realism API 调用
   - 状态：简单的 API 封装
   - 问题：与 visual-generator 功能重叠

7. **seedance-pro-api** ⚠️ 新创建
   - 功能：Seedance Pro API 调用
   - 状态：简单的 API 封装
   - 问题：与 seedance-storyboard 功能重叠

---

## 🎯 优化策略

### 策略1: 增强现有 Skills（推荐）✅

**原则**: 不创建新 Skills，而是增强现有的

#### 1. 增强 visual-generator

**当前能力**:
- ✅ 参数推荐（style, layout, palette）
- ✅ 参数→提示词转换

**缺少能力**:
- ❌ 智能选择模型
- ❌ 调用 API 生成图片

**优化方案**:
```bash
visual-generator/
├── SKILL.md           # 增强版本（添加模型选择指南）
├── scripts/
│   ├── generate.sh    # 主逻辑（添加智能模型选择）
│   ├── params_to_prompt.sh  # 已有
│   └── call_api.sh    # 新增：统一的 API 调用
└── models.json        # 新增：模型配置
```

**增强功能**:
1. 智能模型选择（基于场景）
2. 统一 API 调用接口
3. 多层备用方案

#### 2. 增强 seedance-storyboard

**当前能力**:
- ✅ 对话式分镜生成
- ✅ 专业的提示词生成

**缺少能力**:
- ❌ 调用 API 生成视频

**优化方案**:
```bash
seedance-storyboard/
├── SKILL.md           # 增强版本（添加视频生成指南）
├── scripts/
│   ├── generate.sh    # 主逻辑（已有）
│   └── call_video_api.sh  # 新增：视频 API 调用
└── video_models.json  # 新增：视频模型配置
```

#### 3. 增强 ai-daily-digest

**当前能力**:
- ✅ 从 90 个技术博客抓取
- ✅ AI 评分筛选

**与 ai-daily 的区别**:
- ai-daily-digest: 技术博客（深度文章）
- ai-daily: 科技新闻（快速资讯）

**优化方案**:
- 保持 ai-daily-digest 不变（深度技术文章）
- 可以参考 ai-daily 的结构（SKILL.md 写法）

---

### 策略2: 简化为工具脚本（备选）

**将 API 调用简化为工具，不是 Skills**

```bash
/usr/local/bin/xskill-generate
├── jimeng-5.0
├── flux-realism
└── seedance-pro
```

**使用方式**:
```bash
# visual-generator 调用
xskill-generate jimeng-5.0 "$prompt" --ratio "3:4"
xskill-generate flux-realism "$prompt" --size "square_hd"
```

---

## 💡 关键洞察

### 1. visual-generator 应该是"统一入口"

**当前**:
- visual-generator（参数推荐）
- jimeng-5.0-api（API 调用）
- flux-realism-api（API 调用）

**优化后**:
- visual-generator（参数推荐 + 智能选择模型 + API 调用）

**优势**:
- ✅ 一个入口，统一管理
- ✅ 智能决策（根据场景选择模型）
- ✅ 减少 Skills 数量

### 2. seedance-storyboard 应该包含"视频生成"

**当前**:
- seedance-storyboard（分镜生成）
- seedance-pro-api（视频 API 调用）

**优化后**:
- seedance-storyboard（分镜生成 + 视频生成）

**优势**:
- ✅ 完整的视频生成流程
- ✅ 从分镜到成片
- ✅ 减少 Skills 数量

### 3. 不要为了学而学

**ai-daily 的价值**:
- ✅ 完整的决策逻辑（优先级筛选）
- ✅ 多层备用方案（API → RSS → 搜索）
- ✅ 智能时间判断（7点前/后）

**我应该学习的是**:
- ✅ SKILL.md 的写法（决策指南）
- ✅ 多层备用方案的设计
- ✅ 智能判断逻辑

**而不是**:
- ❌ 创建一个新的 ai-daily Skill（已有 ai-daily-digest）
- ❌ 每个模型都创建一个 API Skill（过度封装）

---

## 🎯 优化优先级

### 第一优先级：整合图像生成 ✅

**删除**:
- jimeng-5.0-api
- flux-realism-api

**增强**:
- visual-generator（添加模型选择 + API 调用）

### 第二优先级：整合视频生成

**删除**:
- seedance-pro-api

**增强**:
- seedance-storyboard（添加视频生成）

### 第三优先级：学习 ai-daily 的设计思想

**不创建新 Skill，而是学习其**:
- ✅ SKILL.md 的决策指南写法
- ✅ 多层备用方案的设计
- ✅ 智能判断逻辑

**应用到现在有 Skills**:
- visual-generator（智能模型选择）
- seedance-storyboard（智能视频生成）

---

## 📋 结论

### ✅ 正确的优化方式

1. **增强现有 Skills**
   - visual-generator：添加智能模型选择 + API 调用
   - seedance-storyboard：添加视频生成

2. **删除重复的 Skills**
   - jimeng-5.0-api（合并到 visual-generator）
   - flux-realism-api（合并到 visual-generator）
   - seedance-pro-api（合并到 seedance-storyboard）

3. **学习 ai-daily 的设计思想**
   - 不是创建新 Skill
   - 而是学习其 SKILL.md 写法
   - 应用到现有 Skills

### ❌ 错误的方式

1. 为每个模型创建一个 API Skill
2. 学习 ai-daily 就创建一个新的 ai-daily Skill
3. 不断增加 Skills，不整合现有能力

---

**维护者**: Main Agent
**日期**: 2026-03-06
**原则**: 优化现有能力，不盲目创建新 Skills
