# Smart Cleaner Agent - 智能清理任务 (2026-03-05)

**时间**: 2026-03-05 10:43
**任务**: 智能清理 .openclaw 目录
**方法**: 基于内容理解的智能决策

---

## 🎯 核心发现

### 1. SYSTEM-PRINCIPLES.md 冗余问题 ⭐

**问题**:
- `/home/node/.openclaw/SYSTEM-PRINCIPLES.md` 是一个冗余的索引文件
- 内容与 SOUL.md + MEMORY.md 重复
- 违反了"单一数据源"原则

**原因**:
- 早期为了"集中管理原则"而创建
- 但实际上 SOUL.md 和 MEMORY.md 已经包含了所有原则
- 创建索引文件反而增加了维护负担

**决策**:
- ✅ 应该删除 SYSTEM-PRINCIPLES.md
- ✅ 保持 SOUL.md = "我是谁"（本质、行为准则）
- ✅ 保持 MEMORY.md = "我知道什么"（长期记忆）

**原则更新**:
新增 CLEANING-PRINCIPLES.md 原则 #2.5: 避免冗余索引文件

---

### 2. 文件职责分离的重要性

**问题**: 文件职责不清晰导致重复和混乱

**正确理解**（基于 OpenClaw 官方文档）:
| 文件 | 谁读它？ | 目的 | 性质 |
|-----|---------|------|------|
| **SOUL.md** | Agent自己 | "我是谁" | 本质/个性/行为准则 |
| **IDENTITY.md** | Agent自己 | "我叫什么" | 元数据（名字、emoji、avatar） |
| **USER.md** | Agent自己 | "用户是谁" | 上下文（偏好、项目） |
| **README.md** | 开发者/用户 | "如何使用我" | 技术文档 |
| **AGENTS.md** | Agent自己 | "同事是谁" | 协作文档 |
| **TOOLS.md** | Agent自己 | "用什么工具" | 参考手册 |

**关键区别**:
- **SOUL.md** ≠ IDENTITY.md
- **SOUL.md** = 本质、个性、行为准则（最高优先级：第一性原理思考）
- **IDENTITY.md** = 元数据（名字、emoji、avatar）

**不应该**:
- ❌ 创建"中心化原则"文件（如 SYSTEM-PRINCIPLES.md）
- ❌ 混淆文件职责
- ❌ 重复内容

---

### 3. 旧 Cleaner Agent 文档清理

**发现**: 旧版 Cleaner Agent 的文档仍在使用

**需要清理的文件**:
```
/home/node/.openclaw/agents/cleaner-agent/README.md
/home/node/.openclaw/agents/cleaner-agent/USAGE.md
/home/node/.openclaw/agents/cleaner-agent/scripts/run.sh
```

**原因**:
- 已被新的 smart-cleaner-agent 替代
- 旧文档不再使用
- 保留会造成混淆

**决策**: 删除旧文档，保留新的 smart-cleaner-agent

---

### 4. 浏览器日志堆积问题

**发现**: 浏览器日志文件超过 7 天未清理

**文件**:
```
/home/node/.openclaw/browser/openclaw/user-data/Default/Local Storage/leveldb/000004.log
```
（创建时间：2月25日，8天前）

**决策**: 删除旧日志，添加定期清理规则

**规则更新**:
- 浏览器日志：>7天 删除

---

### 5. Research Agent 临时数据

**发现**: Research Agent 的临时搜索数据未清理

**文件**:
```
/home/node/.openclaw/agents/research-agent/data/search-temp-1018.json
/home/node/.openclaw/agents/research-agent/data/search-temp-1034.json
```
（创建时间：3月3日，2天前）

**决策**: 删除临时数据，保留最终报告

**规则更新**:
- Research Agent 临时数据：>7天 删除

---

## 📋 清理候选列表（16 个文件）

### 1. Cleaner Agent 旧日志（6 个）
```
agents/cleaner-agent/logs/cleanup-20260303-071823.log
agents/cleaner-agent/logs/cleanup-20260303-071825.log
agents/cleaner-agent/logs/cleanup-20260303-071828.log
agents/cleaner-agent/logs/cleanup-20260303-071830.log
agents/cleaner-agent/logs/cleanup-20260303-071831.log
agents/cleaner-agent/logs/cleanup-20260303-071834.log
agents/cleaner-agent/logs/cleanup-20260303-071906.log
```

### 2. Cleaner Agent 旧文档（3 个）
```
agents/cleaner-agent/README.md
agents/cleaner-agent/USAGE.md
agents/cleaner-agent/scripts/run.sh
```

### 3. 临时测试报告（4 个）
```
workspace/archive/temp/test-reports/FULL-FLOW-TEST-REPORT.md
workspace/archive/temp/test-reports/TEST-RESULTS-FINAL.md
workspace/archive/temp/test-reports/SCENES1-SCENE2-COMPLETE.md
workspace/archive/temp/bug-fixes/REFLY-API-FAILURE-ANALYSIS.md
```

### 4. 浏览器日志（1 个）
```
browser/openclaw/user-data/Default/Local Storage/leveldb/000004.log
```

### 5. Research Agent 临时数据（2 个）
```
agents/research-agent/data/search-temp-1018.json
agents/research-agent/data/search-temp-1034.json
```

---

## ✅ 白名单保护 100%

所有核心文档均已严格保护：
- SOUL.md ✅
- IDENTITY.md ✅
- USER.md ✅
- MEMORY.md ✅
- AGENTS.md ✅
- TOOLS.md ✅
- HEARTBEAT.md ✅
- docs/*.md ✅
- archive/agents-history/ ✅
- archive/architecture-history/ ✅

---

## 🎯 清理原则更新

### 新增原则

**原则 #2.5: 避免冗余索引文件**

判断标准：
- 如果文件内容是"引用其他文档" → 索引文件，可删除
- 如果文件内容是"重复 SOUL.md/MEMORY.md" → 冗余文件，可删除
- 如果文件内容是"全新的原则" → 保留并合并到 SOUL.md 或 MEMORY.md

错误示例：
- ❌ SYSTEM-PRINCIPLES.md
- ❌ CORE-PRINCIPLES.md
- ❌ PRINCIPLES-INDEX.md

正确方式：
- ✅ SOUL.md = "我是谁"（本质、行为准则）
- ✅ MEMORY.md = "我知道什么"（长期记忆）
- ✅ 单一数据源

### 更新目录特殊性规则

新增规则：
- `browser/*/user-data/*/*.log` - 浏览器日志，7 天后删除
- `agents/research-agent/data/*.json` - 临时搜索数据，7 天后删除

---

## 📝 下一步行动

### 立即执行（用户确认后）
1. ✅ 运行清理脚本：`/home/node/.openclaw/cleanup-commands-20260305.sh`
2. ✅ 删除 16 个低价值文件
3. ✅ 记录清理结果

### 手动处理
1. ⚠️ 确认删除 SYSTEM-PRINCIPLES.md
2. ⚠️ 确认处理 STRUCTURE-FIX.md（已修复，可归档或删除）

### 未来改进
1. 📅 添加浏览器日志自动清理
2. 📅 优化 Research Agent 数据清理规则
3. 📅 改进临时报告的归档机制

---

## 🎓 学到的经验

### 1. 文件职责分离的重要性
- 每个文件应该有明确的职责
- SOUL.md ≠ IDENTITY.md
- 不要混淆"我是谁"和"我叫什么"

### 2. 避免创建冗余的索引文件
- 索引文件会增加维护负担
- 单一数据源更容易维护
- SOUL.md + MEMORY.md 已经足够

### 3. 基于内容理解的智能决策
- 不要机械地应用规则
- 真正读取文件内容
- 理解文件的价值和用途

### 4. 定期清理的必要性
- 临时文件会不断积累
- 需要定期清理规则
- 自动化清理很重要

---

**Smart Cleaner Agent**
**方法**: 从本质出发，理解内容价值，智能决策
**保护**: 白名单文件 100% 保护
**确认**: 删除前必须用户确认
