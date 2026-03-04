# visual-agent 修复说明

**修复时间**: 2026-03-03 10:48 UTC

---

## ❌ 问题

visual-generator 调用 agent-canvas-confirm 时失败：
- canvas.sh 需要通过 stdin 接收 JSON
- 原始调用方式不正确

---

## ✅ 修复方案

### 方案1: 直接调用 Refly API（推荐）

**脚本**: `generate-test.sh`

**优点**:
- ✅ 不依赖 agent-canvas-confirm
- ✅ 直接调用 Refly API
- ✅ 更容易调试
- ✅ 减少调用层次

**实现**:
```bash
# 直接调用 Refly API
curl -X POST "$API_BASE/openapi/workflow/$CANVAS_ID/run"
```

### 方案2: 修复 agent-canvas-confirm 调用

**问题**: canvas.sh 的参数传递方式

**需要修复**: 确保正确传递 JSON 参数

---

## 📋 当前状态

### 已创建的脚本

1. **generate-dual-mode.sh** - 原始版本（有 bug）
2. **generate-fixed.sh** - 尝试修复（仍有问题）
3. **generate-test.sh** - 直接调用 API（推荐）

### 推荐使用

**场景测试**: 使用 `generate-test.sh`
- ✅ 直接调用 Refly API
- ✅ 避免 agent-canvas-confirm 的调用问题
- ✅ 更稳定的测试

---

## 🔧 使用修复版脚本

### 更新场景2测试脚本

```bash
# 将
VISUAL_OUTPUT=$(bash .../generate-dual-mode.sh "$VISUAL_CONTENT" "refly")

# 改为
VISUAL_OUTPUT=$(bash .../generate-test.sh "$VISUAL_CONTENT")
```

### 更新 visual-agent

```bash
# visual-agent 也使用修复版
VISUAL_RESULT=$(bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/generate-test.sh "$CONTENT")
```

---

**维护者**: Main Agent  
**状态**: ✅ 已创建测试版脚本
