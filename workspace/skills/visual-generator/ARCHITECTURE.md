# Visual Generator Skill - 架构说明

**位置**: `/home/node/.openclaw/workspace/skills/visual-generator/`

## 职责

1. 分析内容（类型、基调、复杂度）
2. 推荐视觉参数（Style × Layout）
3. **调用 agent-canvas-confirm Skill 生成图片** ⭐
4. 返回结果

## 调用链

```
visual-generator (Skill)
  ↓
agent-canvas-confirm (Skill)
  ↓
Refly API
```

## 实现

### scripts/generate.sh

```bash
#!/bin/bash
# visual-generator 主脚本

CONTENT="$1"

# 1. 分析内容
analyze_content "$CONTENT"

# 2. 推荐参数
recommend_params "$CONTENT_TYPE" "$TONE"

# 3. 调用 agent-canvas-confirm 生成图片 ⭐
CANVAS_SKILL="/home/node/.openclaw/workspace/skills/agent-canvas-confirm"

RESULT=$(bash "$CANVAS_SKILL/scripts/canvas.sh" << EOF
{
  "action": "generate",
  "type": "image",
  "prompt": "$PROMPT",
  "parameters": {
    "style": "$RECOMMEND_STYLE",
    "layout": "$RECOMMEND_LAYOUT"
  }
}
EOF
)

# 4. 返回结果
echo "$RESULT"
```

## 关键点

- ✅ visual-generator 是 Skill，不是 Agent
- ✅ 被 visual-agent 调用
- ✅ 内部调用 agent-canvas-confirm
- ✅ 不直接调用 Refly API

---

**维护者**: Main Agent  
**架构原则**: "通用工具用 Skill"
