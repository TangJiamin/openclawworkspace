# Video Agent 工具列表

## 内置工具

### 文件操作
- `read` - 读取配置文件和输入数据
- `write` - 保存生成结果

### 执行工具
- `exec` - 执行生成脚本

## 生成脚本（v3.1 - 用户意图判断版）

### generate.sh
- **功能**: 两阶段视频生成（规划 + 生产）
- **阶段1**: 分镜规划（seedance-storyboard Skill）
- **阶段2**: 实际生产（基于用户意图）
- **关键**: 必须先有图片（优先 visual-agent）

### 工作流程

```
用户输入（平台、主题、图片路径、背景、是否可视化）
    ↓
检查图片是否存在
    ↓
阶段1: 分镜规划
    seedance-storyboard Skill → 生成分镜脚本
    （镜头、时长、节奏）
    ↓
阶段2: 实际生产
    判断逻辑：
    ├─ 没有 Seedance API
    │  └─ 使用 Refly Canvas
    ├─ 有 Seedance API + 用户希望可视化
    │  └─ 使用 Refly Canvas
    ├─ 有 Seedance API + 用户不希望可视化
    │  └─ 使用 Seedance API
    └─ 都没有
       └─ 仅返回分镜脚本
```

## 使用的 Skills

### seedance-storyboard（阶段1 - 分镜规划）
- **类型**: 分镜规划工具
- **用途**: 对话引导分镜生成
- **位置**: `/home/node/.openclaw/workspace/skills/seedance-storyboard/`
- **调用时机**: 阶段1，每次都会调用
- **必需**: ✅ 必需

---

### xskill.ai MCP Server（阶段2 - 视频生成）⭐⭐⭐⭐⭐ **新增**

**类型**: MCP 协议视频生成
**用途**: Seedance 视频生成（MCP 方式）
**MCP 工具**: `submit_task`

#### 可用模型

**1. v1.5 Pro 文生视频（带音频）** ⭐⭐⭐⭐⭐
- **模型 ID**: `fal-ai/bytedance/seedance/v1.5/pro/text-to-video`
- **特性**: 原生音频生成、唇形同步、电影级摄像机
- **分辨率**: 480p/720p/1080p
- **时长**: 4-12 秒
- **计费**: 10-47积分/秒

**2. v1.5 Pro 图生视频（带音频）** ⭐⭐⭐⭐⭐
- **模型 ID**: `fal-ai/bytedance/seedance/v1.5/pro/image-to-video`
- **特性**: 首帧图生视频、音频生成
- **分辨率**: 480p/720p
- **计费**: 10-21积分/秒

**3. Pro Fast 首帧图生视频** ⭐⭐⭐⭐
- **模型 ID**: `fal-ai/bytedance/seedance/v1/pro/fast/image-to-video`
- **特性**: 高性能低成本
- **分辨率**: 480p/720p/1080p
- **计费**: 5-20积分/秒

**4. Lite 参考图生视频** ⭐⭐⭐⭐
- **模型 ID**: `fal-ai/bytedance/seedance/v1/lite/reference-to-video`
- **特性**: 人物一致性更强
- **分辨率**: 480p/720p
- **计费**: 8-15积分/秒

#### MCP 调用方式

```json
{
  "model_id": "fal-ai/bytedance/seedance/v1.5/pro/text-to-video",
  "parameters": {
    "prompt": "{{用户提示词}}",
    "resolution": "720p",
    "duration": "5",
    "generate_audio": true
  }
}
```

**优势**:
- ✅ AI Agent 自主调用
- ✅ 专家级提示词
- ✅ 跨平台兼容
- ✅ 已包含音频生成

**对比 API 方式**:
- API 方式: 手动编写提示词、需要编程
- MCP 方式: AI 自主调用、专家级提示词

**集成状态**: ✅ 已学习，准备集成

### agent-canvas-confirm（阶段2 - 可选生产工具）
- **类型**: 可视化工作流工具
- **用途**: Refly Canvas 可视化工作流
- **位置**: `/home/node/.openclaw/workspace/skills/agent-canvas-confirm/`
- **调用时机**: 阶段2，如果用户希望可视化
- **必需**: ⚠️ 可选

## 依赖的 Agents

### visual-agent
- **用途**: 生成图片（视频生成必需）
- **调用方式**: `sessions_spawn("visual-agent", task)`
- **关系**: video-agent 依赖 visual-agent 的输出

## 外部 API

### Seedance API（阶段2 - 可选生产工具）
- **类型**: 视频生成 API
- **用途**: 专业视频生成服务
- **认证**: API Key（从环境变量读取）
- **调用时机**: 阶段2，如果用户不希望可视化
- **必需**: ⚠️ 可选

---

## 判断逻辑（用户修正版）

### 阶段1（必需）
1. ✅ **seedance-storyboard Skill** - 分镜规划（必需）

### 阶段2（基于用户意图）

**判断条件**:
1. **没有 Seedance API** → 使用 Refly Canvas
2. **有 Seedance API + 用户希望可视化** → 使用 Refly Canvas
3. **有 Seedance API + 用户不希望可视化** → 使用 Seedance API
4. **都没有** → 仅返回分镜脚本

**参数说明**:
- 第5个参数: `USER_WANTS_VISUAL`（true/false）
- 默认值: `false`（直接使用 Seedance API）

---

## 关键原则

### 第一性原理
1. **先规划，后执行** - 先生成分镜，再实际生产
2. **分镜可复用** - 规划的分镜可以用于多个生产工具
3. **基于用户意图** - 根据用户需求智能选择

### 技术优势
1. ✅ **两阶段分离** - 规划和生产独立
2. ✅ **分镜可调整** - 用户可以在可视化工作流中调整分镜
3. ✅ **用户意图优先** - 基于用户需求智能选择
4. ✅ **完全自动化** - 无需人工选择，自动判断最佳方案

---

## 工作流程

### 生成视频的正确流程

1. **先调用 visual-agent** → 生成图片（两阶段：规划 + 生产）
2. **获取图片路径** → 保存图片
3. **再调用 video-agent** → 根据图片生成视频（两阶段：规划 + 生产）

### 两阶段生成机制

#### visual-agent（图片生成）
```
阶段1: visual-generator Skill → 参数规划
阶段2: Refly Canvas / Seedance API → 实际生产（基于用户意图）
```

#### video-agent（视频生成）
```
阶段1: seedance-storyboard Skill → 分镜规划
阶段2: Refly Canvas / Seedance API → 实际生产（基于用户意图）
```

---

**维护者**: Main Agent
**更新时间**: 2026-03-05 16:03 UTC（新增用户意图判断）
**版本**: v3.1
