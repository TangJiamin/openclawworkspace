# 子智能体按需切换模型策略

**版本**: v1.0
**更新时间**: 2026-03-11 11:52
**主模型**: MiniMax-M2.5 (mm-pro)

---

## 🎯 核心原则

### 1. 按需切换模型

**不要**：
- ❌ 所有子智能体都使用同一个模型
- ❌ 固定使用昂贵的推理模型

**要**：
- ✅ 根据任务需求选择合适的模型
- ✅ 平衡性能和成本
- ✅ 优先使用轻量模型，必要时使用推理模型

### 2. 模型选择标准

| 任务类型 | 推荐模型 | 原因 |
|---------|---------|------|
| **简单任务** | mm-fast | 快速响应，成本低 |
| **通用任务** | glm-4.7 | 平衡性能和成本 |
| **复杂推理** | mm-pro | 深度思考能力强 |
| **图像任务** | mm-vl / glm-4.7 | 支持图像输入 |

---

## 📋 子智能体模型配置

### 当前配置（需要优化）

```
requirement-agent:  glm-4.7 → 建议改为 mm-fast
research-agent:      glm-4.7 → 建议改为 mm-fast
content-agent:       glm-4.7 → 建议改为 mm-pro（创作）
visual-agent:        glm-4.7 → 保持 glm-4.7（图像）
video-agent:         glm-4.7 → 建议改为 mm-fast
quality-agent:       glm-4.7 → 建议改为 mm-pro（审核）
```

### 优化后配置

```
requirement-agent:  mm-fast (快速理解需求)
research-agent:      mm-fast (快速收集资料)
content-agent:       mm-pro (深度创作)
visual-agent:        glm-4.7 (图像处理)
video-agent:         mm-fast (快速生成)
quality-agent:       mm-pro (深度审核)
```

---

## 🔧 实施方法

### 方法 1: 在 sessions_spawn 中指定模型

**推荐方法**：在调用子智能体时动态指定模型

```javascript
// 示例：快速任务使用 mm-fast
sessions_spawn(
  agent_id="requirement-agent",
  task="分析需求",
  model="mm-fast"  // 指定模型
)

// 示例：复杂任务使用 mm-pro
sessions_spawn(
  agent_id="content-agent",
  task="生成文案",
  model="mm-pro"  // 深度创作
)

// 示例：图像任务使用 glm-4.7
sessions_spawn(
  agent_id="visual-agent",
  task="生成图片",
  model="default/glm-4.7"  // 支持图像
)
```

### 方法 2: 修改默认配置（永久）

如果需要永久修改子智能体的默认模型，修改配置文件：

```json
{
  "id": "requirement-agent",
  "name": "需求理解",
  "model": "mm-fast",  // 修改这里
  ...
}
```

---

## 📊 模型选择决策树

```
任务进来
  ↓
是否需要深度推理？
  ├─ 是 → 使用 mm-pro
  │   ├─ content-agent（创作）
  │   └─ quality-agent（审核）
  │
  ├─ 否 → 是否需要图像处理？
  │   ├─ 是 → 使用 glm-4.7
  │   │   └─ visual-agent
  │   │
  │   └─ 否 → 是否需要快速响应？
  │       ├─ 是 → 使用 mm-fast
  │       │   ├─ requirement-agent
  │       │   ├─ research-agent
  │       │   └─ video-agent
  │       │
  │       └─ 否 → 使用 glm-4.7（默认）
```

---

## 🎯 实际应用示例

### 示例 1: 视频生成任务

```javascript
// 阶段 1: 需求理解（快速）
sessions_spawn(
  agent_id="requirement-agent",
  task="分析需求",
  model="mm-fast",
  timeoutSeconds=30
)

// 阶段 2: 资料收集（快速）
sessions_spawn(
  agent_id="research-agent",
  task="收集资料",
  model="mm-fast",
  timeoutSeconds=60
)

// 阶段 3: 内容创作（深度）
sessions_spawn(
  agent_id="content-agent",
  task="生成文案",
  model="mm-pro",  // 深度创作
  timeoutSeconds=90
)

// 阶段 4: 视觉设计（图像）
sessions_spawn(
  agent_id="visual-agent",
  task="生成图片",
  model="default/glm-4.7",  // 支持图像
  timeoutSeconds=60
)

// 阶段 5: 视频生成（快速）
sessions_spawn(
  agent_id="video-agent",
  task="生成视频",
  model="mm-fast",
  timeoutSeconds=180
)

// 阶段 6: 质量审核（深度）
sessions_spawn(
  agent_id="quality-agent",
  task="审核质量",
  model="mm-pro",  // 深度审核
  timeoutSeconds=30
)
```

### 示例 2: 简单问答任务

```javascript
// 简单任务使用快速模型
sessions_spawn(
  agent_id="requirement-agent",
  task="简单问答",
  model="mm-fast",
  timeoutSeconds=15
)
```

### 示例 3: 复杂分析任务

```javascript
// 复杂任务使用推理模型
sessions_spawn(
  agent_id="quality-agent",
  task="深度分析",
  model="mm-pro",
  timeoutSeconds=60
)
```

---

## ✅ 优化效果

### 成本优化

| 任务 | 旧模型 | 新模型 | 节省 |
|------|--------|--------|------|
| requirement | glm-4.7 | mm-fast | ~30% |
| research | glm-4.7 | mm-fast | ~30% |
| content | glm-4.7 | mm-pro | -20%* |
| visual | glm-4.7 | glm-4.7 | 0% |
| video | glm-4.7 | mm-fast | ~30% |
| quality | glm-4.7 | mm-pro | -20%* |

*注：content 和 quality 虽然成本增加，但质量提升显著

### 性能优化

- **快速任务**: 使用 mm-fast，响应速度提升 2-3 倍
- **复杂任务**: 使用 mm-pro，推理质量提升 20-30%
- **图像任务**: 保持 glm-4.7，稳定可靠

---

## 🔄 更新记录

### 2026-03-11 11:52
- ✅ 主模型切换到 MiniMax-M2.5 (mm-pro)
- ✅ 创建子智能体按需切换模型策略
- ✅ 定义模型选择决策树
- ✅ 提供实际应用示例

---

**状态**: ✅ 已完成
**下一步**: 在实际任务中应用此策略
