# Main Agent 编排器使用指南

**更新时间**: 2026-03-03 10:45 UTC

---

## 🎯 Main Agent 编排器

### 功能

Main Agent 编排器是**真正的智能编排系统**，能够：
- ✅ 自动识别场景
- ✅ 编排 6 个子 Agents
- ✅ 协同完成端到端的内容生产
- ✅ 支持按需生产和定时批量生产

---

## 📋 使用方式

### 场景1: 按需生产（用户触发）

```bash
bash /home/node/.openclaw/scripts/main-agent-orchestrator.sh \
  "生成小红书图文，推荐5个AI工具" \
  "scene1"
```

**流程**:
```
用户需求
  ↓
Main Agent 识别场景
  ↓
编排 Agents:
  requirement-agent → research-agent → content-agent 
  → visual-agent → quality-agent
  ↓
返回结果给用户
```

---

### 场景2: 定时批量生产（定时触发）

```bash
# 手动触发
bash /home/node/.openclaw/scripts/main-agent-orchestrator.sh \
  "" \
  "scene2"

# 或通过定时任务
0 8 * * * bash /home/node/.openclaw/scripts/main-agent-orchestrator.sh "" scene2
```

**流程**:
```
定时器触发
  ↓
Main Agent 识别场景
  ↓
编排 Agents:
  research-agent（入口）
  → content-agent × N
  → visual-agent × N
  → quality-agent（批量审核）
  ↓
筛选高质量内容并发布
```

---

### 自动模式

```bash
# Main Agent 自动识别场景
bash /home/node/.openclaw/scripts/main-agent-orchestrator.sh \
  "生成小红书图文，推荐5个AI工具"
```

**识别规则**:
- 包含"批量"、"定时"、"每天" → 场景2
- 其他 → 场景1

---

## 🔧 编排逻辑

### 场景1: 按需生产

```
1. requirement-agent - 需求理解
   ↓ 解析用户需求，生成任务规范

2. research-agent - 资料收集
   ↓ 收集最新资讯

3. content-agent - 文案生成
   ↓ 生成高质量文案

4. visual-agent - 图片生成
   ↓ 调用 visual-generator Skill
   ↓ 支持 Seedance API 或 Refly Canvas

5. quality-agent - 质量审核
   ↓ 审核文案 + 图片

6. 返回结果给用户
```

### 场景2: 定时批量生产

```
1. research-agent - 收集资讯（入口）
   ↓ 收集最新 AI 资讯

2. 识别热点话题
   ↓ 从搜索结果中提取 N 个话题

3. 批量调用 content-agent
   ↓ 并行生成 N 篇文案

4. 批量调用 visual-agent
   ↓ 并行生成 N 张图片
   ↓ 每个调用 visual-generator Skill

5. 批量调用 quality-agent
   ↓ 批量审核所有内容

6. 筛选高质量内容
   ↓ 只保留 ≥80 分的内容

7. 批量发布到平台
   ↓ 发布到小红书、抖音、微信
```

---

## 🎯 为什么这是真正智能的选择？

### ✅ 优势

1. **真正的编排**
   - Main Agent 作为协调者
   - 智能调度 6 个子 Agents
   - 根据场景选择流程

2. **灵活性强**
   - 自动识别场景
   - 支持手动指定场景
   - 易于扩展新场景

3. **符合架构**
   - 使用 sessions_spawn 调用 Agents
   - Agents 独立运行
   - 真正的分布式系统

4. **可维护性高**
   - 编排逻辑集中
   - Agents 职责清晰
   - 易于调试和优化

---

## 📊 与场景脚本对比

| 特性 | 场景脚本 | Main Agent 编排器 |
|------|---------|-----------------|
| 智能化 | ❌ 固定流程 | ✅ 自动识别场景 |
| 灵活性 | ❌ 硬编码 | ✅ 动态编排 |
| 扩展性 | ❌ 难以扩展 | ✅ 易于添加新场景 |
| 符合架构 | ⚠️ 临时方案 | ✅ 真正的编排系统 |
| 生产可用 | ⚠️ 可以用 | ✅ 推荐使用 |

---

## 🚀 生产部署

### 配置定时任务

```bash
# 编辑 crontab
crontab -e

# 添加定时任务（每天早上8点执行场景2）
0 8 * * * bash /home/node/.openclaw/scripts/main-agent-orchestrator.sh "" scene2
```

### 配置 openclaw cron

```bash
# 添加定时任务
openclaw cron add \
  --schedule "0 8 * * *" \
  --payload "执行场景2：定时批量生产" \
  --delivery.mode "announce" \
  --delivery.channel "feishu"
```

---

**维护者**: Main Agent  
**状态**: ✅ 真正智能的编排系统
