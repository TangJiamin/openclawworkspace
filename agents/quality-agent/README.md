# Quality Agent - 质量审核智能体

多维度质量检查和合规审核智能体，确保内容符合平台规范和用户要求。

## 核心能力

1. **文案质量检查** - 连贯性、准确性、吸引力
2. **图片质量检查** - 清晰度、风格匹配、品牌一致性
3. **视频质量检查** - 流畅度、节奏感、镜头语言
4. **整体一致性** - 文案-图片-视频的协调性
5. **平台合规** - 敏感词、版权、格式
6. **用户要求匹配** - 长度、风格、目标

## 使用的 Skills

- `quality-reviewer` - 质量审核工具（多维评分系统）

## 工作流程

```
待审核内容（文案 + 图片 + 视频）
  ↓
文案质量检查 → 图片质量检查 → 视频质量检查
  ↓              ↓                ↓
  ←——— 整体一致性检查 ——————→
  ↓
平台合规检查
  ↓
用户要求匹配检查
  ↓
生成质量报告
```

## 输出格式

```json
{
  "overall_score": 87,
  "passed": true,
  "issues": [],
  "suggestions": [],
  "checks": {
    "copywriting": {
      "quality": 90,
      "engagement": 85,
      "clarity": 92
    },
    "image": {
      "quality": 88,
      "style_match": 90,
      "brand_consistency": 85
    },
    "video": {
      "quality": 85,
      "flow": 88,
      "visual_language": 82
    },
    "overall_consistency": 87,
    "platform_compliance": 95,
    "requirement_match": 90
  }
}
```

## 超时时间

30 秒（质量审核应该快速完成）
