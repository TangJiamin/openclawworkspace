# 定向学习任务配置（更新版）

**任务名称**: daily-directed-learning
**执行时间**: 每天 21:30
**会话类型**: isolated
**超时**: 9000 秒（2.5 小时）

---

## 🎯 任务目标

不盲目学习，而是基于清晰的自我认知，针对性地提升能力。

**新增**: 多平台自动学习（LobeHub + ClawHub + GitHub）

---

## 📚 学习途径（更新）

### 1. LobeHub Skills Marketplace ⭐⭐⭐⭐⭐ **最高优先级（新增）**

**访问方式**: LobeHub CLI（已注册）

**搜索命令**:
```bash
npx -y @lobehub/market-cli skills search --q "关键词" --page-size 10 --sort installCount --order desc
```

**优势**:
- ✅ 100,000+ 技能（全球最大）
- ✅ 任务导向搜索
- ✅ 评分和安装量统计
- ✅ 用户评价系统
- ✅ 自动认证

**使用场景**:
- 用户询问功能时自动搜索
- 发现新能力时自动学习
- 定期自动升级

---

### 2. ClawHub ⭐⭐⭐⭐

**访问方式**: Jina Reader

**搜索命令**:
```bash
curl -s "https://r.jina.ai/https://clawhub.com"
```

---

### 3. GitHub ⭐⭐⭐

**访问方式**: GitHub API

**搜索命令**:
```bash
curl -s "https://api.github.com/search/repositories?q=关键词+language:javascript&stars:>50"
```

---

## 🔍 多平台搜索策略

### 搜索顺序

1. **LobeHub**（首选）→ 100,000+ 技能
2. **ClawHub**（备选）→ OpenClaw 社区
3. **GitHub**（备选）→ 开源项目

### 搜索关键词（基于能力短板）

核心能力领域：
- AI content production
- PDF tools
- video editing
- API integration
- automation
- data analysis
- writing assistant

### 筛选标准

**LobeHub**:
- 安装量 >= 100
- 评分 >= 4.0/5.0
- 3个月内更新

**ClawHub**:
- 下载量 >= 100
- 3个月内更新

**GitHub**:
- Stars >= 50
- 3个月内更新

---

## 🔄 自动学习流程

### Step 1: 自我认知（5分钟）

**内容**:
- 基于每日总结评估当前能力
- 识别能力短板
- 设定学习目标

### Step 2: 目标设定（5分钟）

**内容**:
- 明确学习目标和预期成果
- 优先级排序

### Step 3: 多平台自动学习（60-90分钟）⭐

#### 3.1 LobeHub 搜索 ⭐⭐⭐⭐⭐

```bash
# 搜索技能
npx -y @lobehub/market-cli skills search --q "$goal" --page-size 10 --sort installCount --order desc

# 评估前 10 个技能
# 选择高价值技能

# 安装（符合 100/3 法则 + 安全检查）
npx -y @lobehub/market-cli skills install <identifier>
```

#### 3.2 ClawHub 搜索

```bash
# 搜索技能
curl -s "https://r.jina.ai/https://clawhub.com" | grep -i "$goal"

# 评估发现的技能
# 选择高价值技能
```

#### 3.3 GitHub 搜索

```bash
# 搜索项目
curl -s "https://api.github.com/search/repositories?q=$goal+language:javascript&stars:>50"

# 评估发现的项目
# 选择高价值项目
```

### Step 4: 能力转换（30-60分钟）

**内容**:
- 将学习到的技能转换为实际能力
- 更新 TOOLS.md、AGENTS.md
- 创建或更新 Skills

### Step 5: ⭐ 立即应用新技能（重要！）

**内容**:
- ✅ **立即应用**新技能到相关 Agents
- ✅ 更新 TOOLS.md、AGENTS.md
- ❌ **不要等待用户确认**
- ✅ 记录应用结果

### Step 6: Agent 优化检查

**内容**:
- 自动运行优化检查器
- 生成详细的优化建议
- **自动应用优化**（不要等待确认）

### Step 7: 实践验证（15分钟）

**内容**:
- 测试新安装的技能
- 验证功能正常
- 评分和评论（LobeHub）

---

## 🛡️ 安全检查（严格执行）

安装任何技能前必须：

1. **检查 100/3 法则**
   - 下载量 >= 100
   - 发布时间 >= 3个月

2. **运行 Security Check**
   ```bash
   bash /home/node/.openclaw/workspace/skills/security-check/scripts/check-skill.sh <skill-path>
   ```

3. **确认风险等级**
   - 🟢 SAFE → 可以安装
   - 🟡 CAUTION → 仔细审核
   - 🔴 DANGEROUS → 拒绝安装

---

## 📊 学习记录

### 记录位置

- **主要记录**: `.learnings/LEARNINGS.md`
- **今日记忆**: `memory/YYYY-MM-DD.md`
- **自动学习记录**: `.learnings/auto-learning-YYYY-MM-DD.md`

### 记录内容

- 搜索关键词
- 发现的技能
- 评估结果
- 安装决策
- 应用结果

---

## 🎯 预期效果

| 指标 | 当前 | 目标 | 提升 |
|-----|------|------|------|
| 学习平台数 | 1 | 3 | +200% |
| 发现技能数/天 | ~3 | ~30 | +900% |
| 自动应用率 | 0% | 100% | +∞ |
| 迭代速度 | 手动 | 自动 | +500% |

---

## ⚠️ 重要提醒

- ✅ **安全第一** - 严格执行 100/3 法则和安全检查
- ✅ **质量优先** - 只安装高质量技能
- ✅ **立即应用** - 学习后立即应用，不要等待确认
- ✅ **自动迭代** - 每天自动升级能力

---

## 📢 通知发送（重要）

**发送飞书通知时必须包含以下参数**:
- channel: "feishu"
- target: "ou_42097cc9852e3aae3de5893b96a67219"

**示例代码**:
```javascript
message({
  action: "send",
  channel: "feishu",
  target: "ou_42097cc9852e3aae3de5893b96a67219",
  message: "你的通知内容..."
})
```

**注意**: 如果不包含 target 参数，通知将发送失败！

---

**更新时间**: 2026-03-10 10:55
**执行时间**: 每天 21:30
**下次运行**: 2026-03-10 21:30
**版本**: v4.0 - 多平台自动学习版
