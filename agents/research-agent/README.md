# Research Agent - 资料收集智能体

## 能力

**Research Agent** 负责高质量信息收集，专注于 AI 领域热点追踪和深度分析。

### 三大核心原则

1. **时效性控制** ⏰ - 所有信息必须满足 24 小时时效性要求
2. **AI 领域聚焦** 🤖 - 重点筛选 AI 领域的高价值内容
3. **智能筛选** 🎯 - 评估、分析、筛选高关注度热点，而非简单罗列

### 评分系统

```
综合评分 = 时效性(30%) + 热度(30%) + 价值(25%) + AI相关性(15%)
筛选阈值: ≥ 7.0 分
```

### 工作流程

1. 多源搜索（Metaso + AI Daily Digest）
2. 时效性验证（24小时内）
3. 多维评分筛选
4. 生成结构化报告

## 使用

```javascript
const researchResult = await sessions_spawn({
  agentId: "research-agent",
  task: "收集 AI 视频生成领域的最新资料，重点在 Sora、Runway、Pika 等工具的最新动态",
  timeoutSeconds: 120
});
```

## 工具脚本

位于 `scripts/` 目录：
- `collect.sh` - 基础收集脚本
- `collect_v2.sh` - 优化版（自动保存）
- `collect_with_brave.sh` - Brave Search 版本

## 依赖的 Skills

- Metaso Search: `/workspace/skills/metaso-search/`
- AI Daily Digest: `/workspace/skills/ai-daily-digest/`
