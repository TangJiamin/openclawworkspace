# 双模式生成架构 - 最终正确版本

**更新时间**: 2026-03-03 10:42 UTC

---

## ✅ 正确的双模式架构

### visual-agent（图片生成）

```
visual-agent
  ↓
调用 visual-generator Skill ⭐
  ↓
visual-generator 选择模式:
  ├─ 方式1: Seedance API（优先）
  │   └─ TODO: 实现 Seedance API 调用
  └─ 方式2: Refly Canvas（降级）
      └─ 调用 agent-canvas-confirm Skill ⭐
```

### video-agent（视频生成）

```
video-agent
  ↓
检查图片是否存在 ⭐
  ↓ (如果没有)
  调用 visual-agent 生成图片（支持双模式）
  ↓ (有图片后)
  调用 seedance-storyboard Skill ⭐
  ↓
  seedance-storyboard 选择模式:
  ├─ 方式1: Seedance Video API（优先）
  │   └─ TODO: 实现Seedance Video API 调用
  └─ 方式2: Refly Canvas（降级）
      └─ 调用 agent-canvas-confirm Skill ⭐
```

---

## 🔧 关键组件

### 1. visual-generator Skill（双模式）

**位置**: `/home/node/.openclaw/workspace/skills/visual-generator/`

**功能**:
- ✅ 支持 Seedance API（待实现）
- ✅ 支持 Refly Canvas（已实现）
- ✅ 自动模式选择
- ✅ 降级机制

**脚本**: `scripts/generate-dual-mode.sh`

### 2. seedance-storyboard Skill（双模式）

**位置**: `/home/node/.openclaw/workspace/skills/seedance-storyboard/`

**功能**:
- ✅ 支持 Seedance Video API（待实现）
- ✅ 支持 Refly Canvas（已实现）
- ✅ 自动模式选择
- ✅ 降级机制

**脚本**: `scripts/generate-dual-mode.sh`

### 3. agent-canvas-confirm Skill（Refly Canvas）

**位置**: `/home/node/.openclaw/workspace/skills/agent-canvas-confirm/`

**功能**:
- ✅ 查找 Refly API Key
- ✅ 搜索 Canvas
- ✅ 触发执行
- ✅ 返回结果

**脚本**: `scripts/canvas.sh`

---

## 📊 架构原则

### ✅ 符合原则

1. **"通用工具用 Skill"**
   - ✅ Refly API 调用封装在 agent-canvas-confirm
   - ✅ 双模式逻辑封装在各自的 Skills
   - ✅ Agents 调用 Skills，不直接调用 API

2. **复用性**
   - ✅ agent-canvas-confirm 被多个 Skills 调用
   - ✅ visual-generator 和 seedance-storyboard 可被其他 Agents 调用

3. **职责分离**
   - ✅ Agent: 业务逻辑和协调
   - ✅ Skill: 具体实现和API调用

---

## 🎯 双模式工作流程

### 场景1: 使用 Seedance API

```bash
# 配置 API Key
export SEEDANCE_API_KEY=你的密钥

# 调用 visual-agent
bash /home/node/.openclaw/agents/visual-agent/workspace/scripts/generate-dual-mode.sh \
  '{"title":"AI工具推荐"}' \
  "seedance"

# ↓
# visual-generator 检测到 API Key
# ↓
# 使用 Seedance API 生成
```

### 场景2: 降级到 Refly Canvas

```bash
# 没有 API Key

# 调用 visual-agent
bash /home/node/.openclaw/agents/visual-agent/workspace/scripts/generate-dual-mode.sh \
  '{"title":"AI工具推荐"}' \
  "auto"

# ↓
# visual-generator 检测到没有 API Key
# ↓
# 降级到 Refly Canvas
# ↓
# 调用 agent-canvas-confirm
```

---

## ✅ 总结

- ✅ visual-agent 和 video-agent 都支持双模式
- ✅ 方式1: Seedance API（优先，待实现）
- ✅ 方式2: Refly Canvas（降级，已实现）
- ✅ Refly Canvas 通过 agent-canvas-confirm 调用
- ✅ 符合"通用工具用 Skill"原则

---

**维护者**: Main Agent  
**架构**: ✅ 正确的双模式生成
