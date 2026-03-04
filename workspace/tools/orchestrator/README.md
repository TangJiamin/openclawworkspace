# Orchestrator Tool

通过 `sessions_spawn` 创建真正的独立 Agent sessions，实现多 Agent 协同工作。

## 功能

协调 6 个子 Agents 协同完成内容生产任务：

1. **requirement-agent** - 需求理解
2. **research-agent** - 资料收集
3. **content-agent** - 内容生产
4. **visual-agent** - 视觉生成
5. **video-agent** - 视频生成
6. **quality-agent** - 质量审核

## 使用方法

### 基本用法

```javascript
orchestrate("生成小红书内容，推荐5个提升效率的AI工具")
```

### 工作流程

```
用户需求
  ↓
requirement-agent (独立 session)
  ↓ 传递结果
research-agent (独立 session)
  ↓ 传递结果
content-agent (独立 session)
  ↓ 传递结果
visual-agent/video-agent (独立 session)
  ↓ 传递结果
quality-agent (独立 session)
  ↓
整合结果 → 返回用户
```

## 关键特性

### 1. 真正的独立 Agents

每个 Agent 都是独立的 session：
- 有自己的上下文
- 可以并行执行
- 独立的超时控制

### 2. 结果传递

前一个 Agent 的结果自动传递给下一个：
```javascript
spawnAgent(agentName, originalInput, previousResult)
```

### 3. 灵活的工作流

自动识别需求类型：
- 图文内容 → visual-agent
- 视频内容 → video-agent
- 多平台 → 并行执行

## 返回格式

```javascript
{
  success: true,
  formatted: "🎯 生成结果\n\n...",
  raw: {
    "requirement-agent": {...},
    "research-agent": {...},
    "content-agent": {...},
    "visual-agent": {...},
    "quality-agent": {...}
  }
}
```

## 示例

### 输入
```
生成小红书内容，推荐5个提升效率的AI工具
```

### 输出
```
🎯 生成结果

📋 任务规范:
{
  "content_type": ["文案", "图片"],
  "platforms": ["小红书"],
  "topic": "5个AI工具推荐"
}

📚 收集资料: 15 条

✍️  生成内容:
【5个效率翻倍的AI工具】✨
还在为工作效率低烦恼？...
#AI工具 #效率提升

🎨 视觉参数:
{
  "style": "fresh",
  "layout": "list"
}

✅ 质量审核:
评分: 88/100
等级: 良好
状态: 通过
```
