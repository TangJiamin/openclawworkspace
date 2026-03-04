# AGENTS.md - Agent 矩阵文档

**更新时间**: 2026-03-03 06:58 UTC
**版本**: 2.0 (迁移后版本)

---

## 📊 Agent 矩阵概览

### 6 个核心 Agents

| Agent | 职责 | 状态 | 实现方式 |
|-------|------|------|---------|
| **requirement-agent** | 需求理解 | ✅ 已迁移 | 内部实现 |
| **research-agent** | 资料收集 | ✅ 已优化 | 内部实现 (v3.2) |
| **content-agent** | 内容生产 | ✅ 已迁移 | 内部实现 |
| **visual-agent** | 视觉生成 | ✅ 就绪 | 调用 visual-generator Skill |
| **video-agent** | 视频生成 | ✅ 就绪 | 调用 seedance-storyboard Skill |
| **quality-agent** | 质量审核 | ✅ 已迁移 | 内部实现 |

### 6 个工具 Skills

| Skill | 类型 | 被调用者 |
|-------|------|---------|
| **metaso-search** | 通用搜索工具 | research-agent, content-agent |
| **ai-daily-digest** | 资讯抓取工具 | research-agent |
| **agent-canvas-confirm** | 确认工作流 | 系统 |
| **seedance-storyboard** | 分镜生成工具 | video-agent |
| **visual-generator** | 视觉参数工具 | visual-agent |

---

## 🎯 架构原则

### Agent vs Skill

**Agent（智能体）**:
- 有独立上下文和记忆
- 通过 `sessions_spawn` 调用
- 处理复杂任务和决策
- 位置: `/agents/<agent-name>/`

**Skill（工具）**:
- 可复用的功能模块
- 被 Agent 调用
- 执行具体任务
- 位置: `/workspace/skills/<skill-name>/`

### 迁移策略

**特定功能的逻辑 → 迁移到 Agents**
**通用工具和执行器 → 保留为 Skills**

---

## 📋 Agents 详细说明

### 1. requirement-agent - 需求理解

**职责**: 理解用户需求，生成结构化任务规范

**核心能力**:
- 意图识别（内容生产/资料收集）
- 属性提取（平台、风格、长度）
- 缺失信息追问
- 生成任务规范 JSON

**工作流程**:
```
用户需求 → 意图识别 → 属性提取 → 检查完整性 → 生成任务规范
```

**输出格式**:
```json
{
  "task_id": "req_20260303_001",
  "content_type": ["文案", "图片"],
  "platforms": ["小红书"],
  "style": "轻松",
  "tone": "友好",
  "length": {"min": 100, "max": 200},
  "quality_threshold": 85
}
```

**超时**: 60 秒

**目录**: `/home/node/.openclaw/agents/requirement-agent/`
**文档**: `README.md`
**脚本**: `scripts/analyze.sh`

---

### 2. research-agent - 资料收集

**职责**: 多渠道收集资料，时效性控制，智能筛选

**核心能力**:
- 网络搜索（metaso-search）
- 技术资讯抓取（ai-daily-digest）
- 24 小时时效性控制
- 智能评分筛选（四维度评分）

**工作流程**:
```
需求 → 搜索策略 → 多源收集 → 评分筛选 → 输出高价值资料
```

**评分系统**:
```
综合评分 = 时效性(30%) + 热度(30%) + 价值(25%) + AI相关性(15%)
筛选阈值: ≥ 7.0 分
```

**超时**: 120 秒

**目录**: `/home/node/.openclaw/agents/research-agent/`
**文档**: `README.md`
**脚本**: `scripts/collect_v3_final.sh`
**状态**: ✅ v3.2 优化版（时效性提升 400%）

---

### 3. content-agent - 内容生产

**职责**: 基于需求规范和资料，生成高质量文案

**核心能力**:
- 平台特性分析（小红书/抖音/微信）
- 用户画像分析
- 内容策略生成（Hook、结构、CTA）
- 文案生成（GLM-4-Plus）

**工作流程**:
```
需求规范 + 资料 → 平台分析 → 策略生成 → 文案生成 → 质量检查
```

**输出格式**:
```markdown
## 📝 内容生成结果

### 标题（5个备选）
1. 标题1
2. 标题2
...

### 正文
[生成的文案内容]

### 元数据
- 长度: 180字
- 风格: 轻松
- 标签: #AI工具 #效率提升
```

**超时**: 90 秒

**目录**: `/home/node/.openclaw/agents/content-agent/`
**文档**: `README.md`
**脚本**: `scripts/generate.sh`

---

### 4. visual-agent - 视觉生成

**职责**: 生成高质量图片

**核心能力**:
- 内容分析和参数推荐
- 调用 visual-generator Skill
- Seedance API 图片生成
- 质量检查

**工作流程**:
```
内容需求 → 分析内容 → 推荐参数 → 调用 Skill → API 生成 → 质量检查
```

**使用的工具**:
- ✅ visual-generator Skill - 多维参数系统

**超时**: 60 秒

**目录**: `/home/node/.openclaw/agents/visual-agent/`

---

### 5. video-agent - 视频生成

**职责**: 生成高质量视频

**核心能力**:
- **检查图片存在**（关键原则）
- 调用 seedance-storyboard Skill
- Seedance API 视频生成
- 质量检查

**工作流程**:
```
视频需求 → 检查图片
         ↓ (如果没有)
         → 调用 visual-agent 生成图片 ⚠️ 必须完成
         ↓ (有图片后)
         → 调用 Skill → 对话引导 → API 生成 → 质量检查
```

**关键原则**: ⚠️ **必须先完成图片生成**

**使用的工具**:
- ✅ seedance-storyboard Skill - 对话引导分镜

**超时**: 120 秒

**目录**: `/home/node/.openclaw/agents/video-agent/`

---

### 6. quality-agent - 质量审核

**职责**: 多维度质量检查和合规审核

**核心能力**:
- 文案质量检查（连贯性、准确性、吸引力）
- 图片质量检查（清晰度、风格匹配）
- 视频质量检查（流畅度、节奏感）
- 整体一致性检查
- 平台合规检查（敏感词、版权、格式）
- 用户要求匹配检查

**工作流程**:
```
待审核内容 → 文案检查 → 图片检查 → 视频检查 → 整体一致性 → 合规检查 → 用户要求 → 生成报告
```

**输出格式**:
```json
{
  "overall_score": 87,
  "passed": true,
  "issues": [],
  "suggestions": [],
  "checks": {
    "copywriting": {"quality": 90},
    "image": {"quality": 88},
    "video": {"quality": 85},
    "overall_consistency": 87,
    "platform_compliance": 95,
    "requirement_match": 90
  }
}
```

**超时**: 30 秒

**目录**: `/home/node/.openclaw/agents/quality-agent/`
**文档**: `README.md`
**脚本**: `scripts/review.sh`

---

## 🔄 编排流程

### 标准内容生产流程

```
用户需求
  ↓
requirement-agent (需求理解)
  ↓
research-agent (资料收集)
  ↓
content-agent (文案生成)
  ↓
visual-agent (图片生成)
  ↓
video-agent (视频生成，可选)
  ↓
quality-agent (质量审核)
  ↓
输出结果
```

### 并行机会

**可并行**:
- research-agent + requirement-agent（部分并行）
- content-agent → visual-agent（文案和图片可并行）

**必须串行**:
- visual-agent → video-agent（视频必须等图片）⚠️
- 所有生产 → quality-agent（最后统一审核）

---

## 📊 迁移历史

### 已完成的迁移（2026-03-03）

1. ✅ **material-collector** → research-agent
   - 迁移时间: 上午
   - 状态: v3.2 优化版

2. ✅ **requirement-analyzer** → requirement-agent
   - 迁移时间: 06:53 UTC
   - Skill 已删除

3. ✅ **content-planner** → content-agent
   - 迁移时间: 06:55 UTC
   - Skill 已删除

4. ✅ **quality-reviewer** → quality-agent
   - 迁移时间: 06:57 UTC
   - Skill 已删除

### 保留的工具 Skills

- ✅ metaso-search - 通用搜索工具
- ✅ ai-daily-digest - 资讯抓取工具
- ✅ agent-canvas-confirm - 系统确认工具
- ✅ seedance-storyboard - 分镜生成工具（video-agent 调用）
- ✅ visual-generator - 视觉参数工具（visual-agent 调用）

---

## 🎯 总结

**架构清晰度**: ✅ 大幅提升
**功能完整性**: ✅ 无损失
**维护成本**: ✅ 显著降低
**符合原则**: ✅ "复杂功能用 Agent，通用工具用 Skill"

---

**维护者**: Main Agent
**更新频率**: 随 Agent 变化更新
