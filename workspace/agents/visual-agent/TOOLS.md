# Visual Agent 工具列表

## 内置工具

### 文件操作
- `read` - 读取配置文件和输入数据
- `write` - 保存生成结果

### 执行工具
- `exec` - 执行生成脚本

## 生成脚本（v3.1 - 用户意图判断版）

### generate.sh
- **功能**: 两阶段图片生成（规划 + 生产）
- **阶段1**: 参数规划（visual-generator Skill）
- **阶段2**: 实际生产（基于用户意图）

### 工作流程

```
用户输入（平台、主题、背景、是否可视化）
    ↓
阶段1: 参数规划
    visual-generator Skill → 推荐参数
    （风格、布局、颜色）
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
       └─ 仅返回参数规划
```

## 使用的 Skills

### visual-generator（阶段1 - 参数规划）
- **类型**: 图片参数规划工具
- **用途**: 多维参数系统
- **位置**: `/home/node/.openclaw/workspace/skills/visual-generator/`
- **调用时机**: 阶段1，每次都会调用
- **必需**: ✅ 必需

### agent-canvas-confirm（阶段2 - 可选生产工具）
- **类型**: 可视化工作流工具
- **用途**: Refly Canvas 可视化工作流
- **位置**: `/home/node/.openclaw/workspace/skills/agent-canvas-confirm/`
- **调用时机**: 阶段2，如果用户希望可视化
- **必需**: ⚠️ 可选

## 外部 API

### Seedance API（阶段2 - 可选生产工具）
- **类型**: 图片生成 API
- **用途**: 专业图片生成服务
- **认证**: API Key（从环境变量读取）
- **调用时机**: 阶段2，如果用户不希望可视化
- **必需**: ⚠️ 可选

---

## 判断逻辑（用户修正版）

### 阶段1（必需）
1. ✅ **visual-generator Skill** - 参数规划（必需）

### 阶段2（基于用户意图）

**判断条件**:
1. **没有 Seedance API** → 使用 Refly Canvas
2. **有 Seedance API + 用户希望可视化** → 使用 Refly Canvas
3. **有 Seedance API + 用户不希望可视化** → 使用 Seedance API
4. **都没有** → 仅返回参数规划

**参数说明**:
- 第4个参数: `USER_WANTS_VISUAL`（true/false）
- 默认值: `false`（直接使用 Seedance API）

---

## 关键原则

### 第一性原理
1. **先规划，后执行** - 先生成参数，再实际生产
2. **参数可复用** - 规划的参数可以用于多个生产工具
3. **基于用户意图** - 根据用户需求智能选择

### 技术优势
1. ✅ **两阶段分离** - 规划和生产独立
2. ✅ **参数可调整** - 用户可以在可视化工作流中调整参数
3. ✅ **用户意图优先** - 基于用户需求智能选择
4. ✅ **完全自动化** - 无需人工选择，自动判断最佳方案

---

**维护者**: Main Agent
**更新时间**: 2026-03-05 16:03 UTC（新增用户意图判断）
**版本**: v3.1
