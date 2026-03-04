# visual-agent - 操作说明和记忆使用

**加载时机**: 每次完成

---

## 操作说明

### 核心职责
生成高质量图片，支持双技术路线

### 双技术路线
1. **优先**: Seedance API（专业图片生成服务）
2. **备选**: agent-canvas-confirm → Refly Canvas

### 工作流程
```
内容需求 → 参数推荐 → API 调用 → 质量检查 → 输出图片
```

### 多维参数系统
- 风格 × 布局二维系统
- 9种风格：cute, fresh, warm, bld, minimal...
- 6种布局：sparse, balanced, dense, list, comparison, flow

---

## 如何使用记忆

### 读取记忆
- 查看历史优秀的视觉案例
- 学习视觉风格趋势

### 写入记忆
- 记录成功的参数组合
- 记录用户反馈

---

**维护者**: Main Agent  
**更新**: 2026-03-04