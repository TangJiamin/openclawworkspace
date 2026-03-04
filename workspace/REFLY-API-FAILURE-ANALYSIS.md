# Refly API 调用失败原因分析

**分析时间**: 2026-03-04 01:21 UTC

---

## ❌ 问题：没有使用 agent-canvas-confirm 技能

### 发现的问题

**visual-generator 的实现**:
- ❌ **绕过了 agent-canvas-confirm Skill**
- ❌ 直接调用 Refly API
- ❌ 违背了"通用工具用 Skill"的原则

**代码证据**:
```bash
# generate-test.sh 中的实现
echo "📡 直接调用 Refly API..."
curl -X POST "$API_BASE/openapi/workflow/$CANVAS_ID/run"
```

**应该的实现**:
```bash
# 应该调用 agent-canvas-confirm Skill
echo "📡 调用 agent-canvas-confirm Skill..."
RESULT=$(echo "$JSON_REQUEST" | bash "$CANVAS_SKILL_DIR/scripts/canvas.sh")
```

---

## 🔧 正确的架构

### 应该这样调用

```
visual-generator (Skill)
  ↓
调用 agent-canvas-confirm (Skill) ⭐
  ↓
agent-canvas-confirm 调用 Refly API
  ↓
返回结果给 visual-generator
```

### 而不是

```
visual-generator (Skill)
  ↓
直接调用 Refly API ❌
```

---

## ✅ 修复方案

### 创建正确版本脚本

**新脚本**: `generate-with-confirm.sh`

**特点**:
- ✅ 正确调用 agent-canvas-confirm Skill
- ✅ 通过 stdin 传递 JSON 参数
- ✅ 符合"通用工具用 Skill"原则

---

## 📊 为什么 Refly API 调用失败？

### 可能的原因

1. **没有使用 agent-canvas-confirm**
   - 绕过了 Skill 层
   - 可能缺少某些处理逻辑

2. **Refly API 本身的限制**
   - 执行时间过长
   - 需要更长的超时时间
   - Canvas 配置问题

3. **Canvas 工作流问题**
   - "抖音视频生成工作流" 包含多个步骤
   - 执行时间不确定

---

## 🎯 下一步

### 使用正确的脚本

```bash
# 使用 generate-with-confirm.sh（正确版本）
bash /home/node/.openclaw/workspace/skills/visual-generator/scripts/generate-with-confirm.sh \
  '{"title":"测试"}'
```

### 优势

- ✅ 正确调用 agent-canvas-confirm
- ✅ 符合架构原则
- ✅ 更容易调试
- ✅ 可以复用

---

**维护者**: Main Agent  
**状态**: ⚠️ 需要使用正确的架构
