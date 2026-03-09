# MEMORY.md

## 📋 快速索引

### 核心原则（⭐⭐⭐⭐⭐ 最高优先级）
- **第一性原理决策框架** (2026-03-05) - 5步流程：暂停→提问→拆解→构建→验证
- **Agent、Skill、Script 定义** (2026-03-05) - 基于2026年最新AI行业实践
- **Agent 核心文档职责** (2026-03-05) - 基于 OpenClaw 官方文档
- **用户偏好和开发模式** (2026-03-02) - 长期主义原则
- **安全配置最佳实践** (2026-03-05) - 环境变量 + 配置引用
- **网站访问能力** (2026-03-06) - 使用 curl + 代理访问任何网址，不要说"无法访问"
- **持续改进机制** (2026-03-07) - Self-Improvement + Proactive Agent + 学习系统
- **技能能力了如指掌** (2026-03-09) - 对所有 Agents 和 Skills 的能力必须有完整准确的认识，无需用户询问
- **核心文档精简原则** (2026-03-09) - 在不影响功能的前提下精简文档，优先使用表格、核心命令、流程图，Token 消耗降低 70%+

### 当前项目
- **Agent 矩阵** (2026-02-28 - ) - 多 Agent 并行协作系统
- **每日学习系统** (2026-03-04 - ) - 每日总结反思 + 定向学习

### 技术文档
- **Skill 创建指南** - `docs/SKILL-CREATION-GUIDE.md`
- **Agent 矩阵规划** - `docs/AGENT-MATRIX-REPLAN.md`
- **快速参考** - `TOOLS.md`
- **Agent/Skill/Script 指南** - `docs/AGENT-SKILL-SCRIPT-GUIDE-2026.md`

---

## ⚠️ 核心原则：网站访问能力（2026-03-06 更新）

### 网站访问工具优先级 ⭐⭐⭐⭐⭐

**第一优先级：Jina Reader (agent-reach)** ⭐⭐⭐⭐⭐
```bash
# 最优方法：可以访问单页应用和动态内容
curl -s "https://r.jina.ai/<URL>"
```

**第二优先级：curl + 代理**
```bash
# 备选方法：访问静态 HTML
curl -x http://host.docker.internal:7897 "<URL>"
```

**第三优先级：web_fetch**
```bash
# 备选方法：简单页面
web_fetch({ url: "<URL>", extractMode: "markdown" })
```

**重要原则**:
- ✅ **永远不要说"无法访问网址"**
- ✅ **先检查 agent-reach 状态** → `agent-reach doctor`
- ✅ **优先使用 Jina Reader**（可以访问单页应用）
- ✅ **尝试多种方法**（Jina Reader → curl → web_fetch）
- ✅ **分析获取到的内容**

### agent-reach 使用方法

**检查状态**:
```bash
agent-reach doctor
```

**访问网页**:
```bash
# Jina Reader 方法（推荐）
curl -s "https://r.jina.ai/https://www.xskill.ai/#/v2/models/jimeng-5.0"
```

---

## ⚠️ 核心原则：定时任务 vs Heartbeat任务（2026-03-06）

### 关键区别

**Heartbeat 任务**（每次触发时执行）:
- ✅ 快速检查（< 5秒）
- ✅ 记忆维护（更新今日记忆）
- ✅ 状态监控（检查系统状态）
- ❌ 不适合耗时操作（扫描文件、清理等）

**定时任务**（Cron Job，按时间表执行）:
- ✅ 耗时操作（文件清理、数据归档）
- ✅ 定期维护（每天、每周、每月）
- ✅ 独立会话（不影响主会话）
- ✅ 自动通知（完成后发送报告）

---

### 常见错误（必须避免）

**错误1: 把耗时操作放在 Heartbeat 中**
```markdown
# ❌ 错误：HEARTBEAT.md 中包含文件清理
### 日常任务（每次 heartbeat）
2. **自动文件清理** ⭐
   - 扫描并删除低价值文件
   - 执行时间：可能需要几分钟

# ✅ 正确：使用定时任务
### 定时任务（每天 07:00 自动执行）
1. **自动文件清理** ⭐
   - 任务名称: smart-cleanup-daily
   - 执行时间: 每天早上 07:00
```

**错误2: 混淆执行频率**
```markdown
# ❌ 错误理解：用户说"以后自己清理" = 每次 heartbeat 都清理
# ✅ 正确理解："以后自己清理" = 定时任务自动清理，无需确认

# 用户原话：
"我希望以后你自己清理所有你认为低价值的文件，不需要我来确认"

# 错误解读：每次 heartbeat 都执行清理
# 正确解读：定时任务自动清理，不需要用户确认
```

---

### 判断标准

**何时使用 Heartbeat 任务**:
- ✅ 快速状态检查（< 5秒）
- ✅ 记忆维护（更新今日记忆）
- ✅ 重要事件提醒

**何时使用定时任务**:
- ✅ 耗时操作（> 10秒）
- ✅ 定期维护（清理、归档）
- ✅ 批量处理（文件扫描）

---

### 实际案例

**案例1: 文件清理配置错误 (2026-03-06)**

**❌ 错误做法**:
- 用户要求："以后自己清理，不需要确认"
- 我的理解：每次 heartbeat 都执行清理
- 配置：在 HEARTBEAT.md 中添加"自动文件清理"任务

**用户纠正**:
- "清理不是一个定时任务吗？"
- "记住这个错误，不要再犯"
- "当你做出错误的修改时你应该及时修正，而不仅仅是告诉我你错了"
- "你并没有立即修正（移除定时任务描述），是后续我指出你的错误修改"

**实际情况**（被动修正过程）:
- 11:11 错误配置：在 HEARTBEAT.md 添加详细定时任务配置
- 11:12 用户指出："清理不是一个定时任务吗？"
- 11:14 第一次修正：简化描述，但没有完全移除
- 11:17 用户问："HEARTBEAT.md确认修正了吗？"
- 11:28 用户指出："心跳任务中不需要描述定时任务"
- 11:28 第二次修正：完全移除定时任务描述
- 13:49 用户指出："你并没有立即修正，是后续我指出你的错误修改"

**✅ 正确做法**（应该这样做）:
- 理解：用户希望定时任务自动清理，不需要每次确认
- 配置：使用 cron job `smart-cleanup-daily`（每天 07:00）
- 行为：自动删除低价值文件，完成后发送飞书通知
- **主动发现**: 修改后立即检查是否正确
- **主动修正**: 发现错误立即完全修正，不等待用户指出

**关键教训**:
1. ⭐⭐⭐⭐⭐ **定时任务** ≠ **Heartbeat任务**
2. 耗时操作必须使用定时任务
3. "不需要确认" = 定时任务自动执行，不是每次 heartbeat 都执行
4. ⭐⭐⭐⭐⭐ **主动性不足**: 我应该主动发现和修正错误，而不是被动等待用户指出
5. ⭐⭐⭐⭐⭐ **自我验证**: 修改后必须立即验证是否正确，不假设修改一定成功

---

**来源**: 2026-03-06 配置错误实践
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已深度理解并记住
**日期**: 2026-03-06

---

## ⚠️ 核心原则：Agent、Skill、Script（2026-03-05）

### 3条核心原则

#### 1. Agent = 智能（AI模型）
- ✅ 使用AI模型理解内容
- ✅ 自主决策和规划
- ✅ 独立的上下文和记忆
- ✅ **AI模型调用是Agent的核心能力，不应该外包给Skill**

#### 2. Skill = 可复用的技能包
- ✅ 模块化封装（单一功能）
- ✅ 可在Agent间共享
- ✅ AI自动发现和加载
- ✅ 渐进式加载（节省Token 60-80%）
- ✅ 用于：外部工具调用、数据处理逻辑、工作流封装

#### 3. Script = 工具（固定逻辑）
- ✅ 固定的执行逻辑
- ✅ 被Agent或Skill调用
- ✅ 单一数据源
- ✅ 只在一个地方使用

---

### 关键区别：AI模型调用 ≠ 工具调用

**AI模型调用**（不应该封装为Skill）:
- ❌ GLM-4-Plus调用（这是Agent的核心能力）
- ❌ 内容理解（这是AI模型的本职工作）
- ❌ 质量判断（这是AI模型的智能决策）
- ❌ 文案生成（这是AI模型的创造能力）

**外部工具调用**（应该封装为Skill）:
- ✅ Metaso搜索（外部API）
- ✅ Seedance API（外部服务）
- ✅ Refly Canvas（外部工具）
- ✅ 数据库操作（外部服务）

**数据处理逻辑**（应该封装为Skill）:
- ✅ 情感分析（专用算法）
- ✅ 文本清理（固定逻辑）
- ✅ 数据转换（可复用逻辑）

---

### 判断标准

**何时创建Agent**:
- ✅ 需要智能判断
- ✅ 需要自主决策
- ✅ 需要理解上下文
- ✅ 需要记忆能力

**何时创建Skill**:
- ✅ 功能在≥2个地方使用
- ✅ 外部工具调用（API、外部服务）
- ✅ 数据处理逻辑（固定算法、可复用逻辑）
- ✅ 工作流封装（多步骤操作）

**何时保持为Script**:
- ✅ 只在一个地方使用
- ✅ Agent启动脚本

---

### 常见错误（必须避免）

**错误1: 把AI模型调用封装为Skill**
```bash
# ❌ 错误
bash /home/node/.openclaw/workspace/skills/glm4-caller/scripts/call.sh "审核这个文案"

# ✅ 正确
sessions_spawn(agent_id="quality-agent", task="请审核以下文案...")
```

**错误2: 用脚本规则代替AI模型判断**
```bash
# ❌ 错误
if score >= 85: print("通过")

# ✅ 正确
quality-agent 使用AI模型分析内容
```

**错误3: 重复写脚本**
```bash
# ❌ 错误：在多个Agent中写相同的API调用逻辑
# ✅ 正确：创建Skill
```

---

### 实际例子

**content-agent**:
```python
# ✅ 正确：使用自己的AI模型生成文案
sessions_spawn(agent_id="content-agent", task="生成抖音文案...")
```

**quality-agent**:
```python
# ✅ 正确：使用自己的AI模型审核
sessions_spawn(agent_id="quality-agent", task="审核以下文案...")
```

**research-agent**:
```python
# ✅ 正确：AI模型决策，调用外部工具（Skills）
sessions_spawn(agent_id="research-agent", task="收集最新资讯...")
# research-agent 的AI模型决策，调用 metaso-search Skill
```

---

**来源**: 2026年最新AI行业实践（Metaso AI搜索）
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已理解并记住
**日期**: 2026-03-05

---

## ⚠️ 核心原则：安全配置最佳实践（2026-03-05）

### 环境变量 + 配置引用模式

**核心原则**:
- ✅ 敏感信息存储在环境变量中
- ✅ 配置文件使用引用而非明文
- ✅ 系统自动展开环境变量引用

### 实施方法

**1. 设置环境变量**（宿主机或容器启动时）:
```bash
export FEISHU_APP_ID="cli_xxx"
export FEISHU_APP_SECRET="xxx"
```

**2. 配置文件使用引用**:
```json
{
  "channels": {
    "feishu": {
      "appId": "${FEISHU_APP_ID}",
      "appSecret": "${FEISHU_APP_SECRET}"
    }
  }
}
```

**3. 系统自动展开**:
- OpenClaw Gateway 会自动展开 `${VAR_NAME}` 引用
- 无需手动处理环境变量

### 优势

1. **安全性**: 配置文件不包含明文敏感信息
2. **灵活性**: 不同环境可以使用不同的环境变量
3. **可维护性**: 敏感信息集中管理
4. **版本控制**: 配置文件可以安全提交到 Git

### 适用场景

- ✅ API 密钥
- ✅ 数据库密码
- ✅ OAuth Token
- ✅ 第三方服务凭据

### Docker 容器中的特殊处理

**访问宿主机服务**（如 Clash Verge 代理）:
- Mac/Windows: 使用 `host.docker.internal`
- Linux: 使用 `host-gateway` 或宿主机 IP
- 配置示例: `export PROXY_URL="http://host.docker.internal:7897"`

### 常见错误

**错误1: 直接将环境变量值写入配置文件**
```bash
# ❌ 错误：明文存储
jq '.appId = "cli_xxx"' config.json

# ✅ 正确：使用引用
jq '.appId = "${FEISHU_APP_ID}"' config.json
```

**错误2: 在脚本中硬编码敏感信息**
```bash
# ❌ 错误
export API_KEY="sk-xxx"

# ✅ 正确：从环境变量读取
export API_KEY=${OPENAI_API_KEY}
```

---

**来源**: 2026-03-05 安全修复实践
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已验证并记住
**日期**: 2026-03-05

---

## ⚠️ 核心原则：第一性原理决策框架（2026-03-05）

### 核心思想

**第一性原理**: 剥离所有表象和假设，回到最基础的事实，从零开始重新构建解决方案

**核心心态**:
- ❌ 不要因为"以前这样做"就继续这样做
- ❌ 不要接受"一直以来都是这样"
- ✅ 多问几次"为什么"
- ✅ 质疑所有假设

---

### 5步决策流程

#### Step 1: 暂停 🛑
不要立即动手，先停下来思考。

**检查清单**:
- [ ] 我是否在套用模板？
- [ ] 我是否在参考"上次怎么做的"？
- [ ] 我是否在急于解决表面问题？

#### Step 2: 提问 🤔
问自己 3 个核心问题：

1. **问题的本质是什么？**
   - 示例: 表象"GitHub无法访问" → 本质"容器内无法访问宿主机的代理服务"

2. **用户的真正需求是什么？**
   - 示例: 用户说"配置代理" → 真正需求"在容器内使用宿主机的Clash Verge代理"

3. **有没有更好的解决方案？**
   - 示例: 可行方案"创建一个visual-agent" → 更优方案"分离visual-agent和video-agent支持并行"

#### Step 3: 拆解 🔨
拆解到最基础的事实：

1. **最基础的事实是什么？**（剥离所有假设）
2. **还能再分解吗？**（问题是否可以继续分解）
3. **各部分之间的依赖关系是什么？**（哪些独立，哪些有依赖）

#### Step 4: 构建 🏗️
从基础事实出发，重新设计解决方案：

**最优解判断标准**:
- **效率** (时间/资源) - 并行 > 串行
- **灵活性** (适应性) - 独立模块 > 耦合模块
- **可维护性** (清晰度) - 职责分离 > 职责混乱
- **可扩展性** (未来需求) - 可插拔 > 硬编码

#### Step 5: 验证 ✅
验证方案是否真的解决了本质问题：

1. **这个方案真的解决了本质问题吗？**
2. **是最优解吗？**
3. **有没有更好的方式？**

---

### 关键工具

#### 工具1: 假设验证方法

1. **列出所有假设** - 我假设了什么？
2. **逐一验证** - 这个假设是正确的吗？
3. **调整方案** - 如果假设错误，立即调整

**示例**:
```
假设1: Clash Verge 已启动 → 验证: ❌ 未启用"允许局域网连接"
  → 调整方案: 先让用户启用 Clash Verge 设置
```

#### 工具2: "为什么"链条

连续问至少3次"为什么"，找到本质问题。

**示例**:
```
问题: GitHub 无法访问
为什么1: 为什么无法访问？→ DNS解析到错误的IP
为什么2: 为什么DNS解析错误？→ 容器内网络配置与宿主机不同
为什么3: 为什么容器网络不同？→ Docker容器有网络隔离

本质问题: Docker容器网络隔离，无法直接访问宿主机服务
最优解: 使用 host.docker.internal 访问宿主机代理
```

#### 工具3: 表象 vs 本质

区分表象和本质，解决本质而不是表象。

**示例**:
- 表象: "创建多Agent协同系统" → 本质: "提升内容生产效率"
- 表象: "visual-agent包含图片和视频" → 本质: "图片和视频是不同的生产工具，需要分离才能并行"

---

### 关键洞察

#### 洞察1: 信任用户的记忆，验证系统配置

**问题**: 用户说"昨天讨论过Clash Verge"，我说"我的记录中没有"

**第一性原理分析**:
- 本质: 谁的记忆更准确？
- 拆解: 用户记忆（基于实际讨论）vs 我的记录（可能遗漏）
- 最优解: 信任用户的记忆，验证系统配置

**行动**:
- ✅ 先检查系统是否真的配置了 Clash Verge
- ✅ 使用 `cat`、`ls` 等命令验证实际状态
- ❌ 不要假设之前的记录是正确的

#### 洞察2: 验证比修改更重要

**问题**: 用户指出"你并没有使用更安全的方式加载环境变量"

**第一性原理分析**:
- 本质: 配置是否真的生效了？
- 拆解: 我执行了命令 vs 实际结果仍是明文凭据
- 最优解: 修改后立即验证

**行动**:
- ✅ 修改配置后，立即验证: `jq '.channels.feishu' /path/to/config`
- ✅ 主动告知验证结果
- ❌ 不要假设修改一定成功

#### 洞察3: 多问"为什么"，而不是急于动手

**问题**: GitHub无法访问，我立即尝试多个端口

**第一性原理分析**:
- 本质: 为什么无法访问？
- 拆解: DNS问题？网络隔离？代理服务未启动？
- 最优解: 先问"为什么"，再动手

**行动**:
- ✅ 收到问题时，先问3次"为什么"
- ✅ 列出所有可能的原因
- ✅ 验证假设后再动手
- ❌ 不要急于尝试解决方案

---

### 实际案例

#### 案例1: 代理配置问题 (2026-03-05)

**❌ 缺少第一性原理**:
- 尝试多个端口 (7890/7891/7897)
- 浪费时间10分钟

**✅ 第一性原理**:
- Step 1: 暂停 - 不要立即尝试端口
- Step 2: 提问 - 本质是什么？→ 容器内无法访问宿主机代理
- Step 3: 拆解 - 基础事实：Docker网络隔离 + Clash Verge默认不允许局域网连接
- Step 4: 构建 - 先启用Clash Verge"允许局域网连接" + 使用host.docker.internal
- Step 5: 验证 - 1分钟定位问题，立即解决

#### 案例2: Agent矩阵设计 (2026-02-28)

**❌ 表面思维**:
- 用户要多个Agents → 创建5个Agents

**✅ 第一性原理**:
- 本质: 提升内容生产效率
- 拆解: 依赖关系分析，识别可并行的部分
- 构建: 分离visual-agent和video-agent，支持并行执行
- 验证: 清晰的架构，高效的执行

---

### 详细文档

完整的决策框架文档: `/home/node/.openclaw/workspace/docs/FIRST-PRINCIPLES-DECISION-FRAMEWORK.md`

包含内容:
- 详细的5步流程说明
- 关键问题清单
- 假设验证方法
- 最优解判断标准
- 实际案例分析
- 常见错误及避免方法

---

**来源**: 基于 SOUL.md 第一性原理思考原则
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已深度理解并应用
**日期**: 2026-03-05

---

## ⚠️ 核心原则：Agent 核心文档职责（2026-03-05）

### 基于官方文档

**来源**: https://docs.openclaw.ai/concepts/agent-workspace

### 目录结构

**两个关键目录**:
1. **agentDir**: `~/.openclaw/agents/<agentId>/` - 运行时数据
2. **workspace**: `/home/node/.openclaw/workspace/agents/<agentId>/` - 核心文档

**Skills 位置**:
- **共享 Skills**: `/home/node/.openclaw/workspace/skills/`
- **Agent 专属 Skills**: `/home/node/.openclaw/workspace/agents/<agentId>/skills/`

---

### 核心文档清单（按重要性排序）

| 文件 | 谁读？ | 目的 | 加载时机 | 必需？ | 重要性 |
|-----|---------|------|----------|--------|--------|
| **MEMORY.md** | Agent自己 | "我学到了什么" | 主私密会话 | ✅ 必需 | ⭐⭐⭐⭐⭐ |
| **SOUL.md** | Agent自己 | "我是谁" | 每个会话 | ✅ 必需 | ⭐⭐⭐⭐⭐ |
| **AGENTS.md** | Agent自己 | "如何行为" | 每个会话开始 | ✅ 必需 | ⭐⭐⭐⭐⭐ |
| **USER.md** | Agent自己 | "用户是谁" | 每个会话 | ⚠️ 可选 | ⭐⭐⭐⭐ |
| **TOOLS.md** | Agent自己 | "用什么工具" | 需要时 | ⚠️ 可选 | ⭐⭐⭐ |
| **IDENTITY.md** | Agent自己 | "我叫什么" | 引导仪式 | ⚠️ 可选 | ⭐⭐⭐ |
| **HEARTBEAT.md** | Agent自己 | 定时任务配置 | Heartbeat触发 | ⚠️ 可选 | ⭐⭐ |
| **README.md** | 开发者/用户 | "如何使用我" | 不加载 | ⚠️ 可选 | ⭐⭐ |

---

### 每个文件的详细职责

#### 1. MEMORY.md ⭐⭐⭐⭐⭐
- **谁读**: Agent 自己
- **目的**: "我学到了什么"
- **内容**: 核心原则、重要决策、长期记忆
- **加载时机**: 主私密会话（不在共享/群组上下文中）
- **职责**: 永久记忆，存储核心原则和重要学习
- **特殊**: 三层记忆系统的长期记忆层

#### 2. SOUL.md ⭐⭐⭐⭐⭐
- **谁读**: Agent 自己
- **目的**: "我是谁"
- **内容**: 人设、语气、边界
- **加载时机**: 每个会话
- **职责**: 定义 Agent 的本质、个性、行为准则

#### 3. AGENTS.md ⭐⭐⭐⭐⭐
- **谁读**: Agent 自己
- **目的**: "如何行为"
- **内容**: 操作指南、记忆使用、规则、优先级
- **加载时机**: 每个会话开始
- **职责**: 定义 Agent 应该如何工作、如何使用记忆、如何与其他 Agent 协作

#### 4. USER.md ⭐⭐⭐⭐
- **谁读**: Agent 自己
- **目的**: "用户是谁"
- **内容**: 用户信息、如何称呼他们、他们的偏好
- **加载时机**: 每个会话
- **职责**: 提供用户上下文，帮助 Agent 更好地服务用户

#### 5. TOOLS.md ⭐⭐⭐
- **谁读**: Agent 自己
- **目的**: "用什么工具"
- **内容**: 本地工具和惯例的说明
- **加载时机**: 需要时
- **职责**: 关于可用工具的参考和指导（**不控制工具可用性**）

#### 6. IDENTITY.md ⭐⭐⭐
- **谁读**: Agent 自己
- **目的**: "我叫什么"
- **内容**: 名称、风格、emoji、avatar
- **加载时机**: 引导仪式
- **职责**: Agent 的元数据

#### 7. HEARTBEAT.md ⭐⭐
- **谁读**: Agent 自己
- **目的**: 定时任务配置
- **内容**: 定时任务、提醒规则
- **加载时机**: Heartbeat 触发时
- **职责**: 定义 Heartbeat 行为

#### 8. README.md ⭐⭐
- **谁读**: 开发者/用户
- **目的**: "如何使用我"
- **内容**: 技术文档、使用说明
- **加载时机**: 不加载（开发者手动查看）
- **职责**: 帮助开发者理解和使用这个 Agent

---

### 关键原则

#### 1. 文件不是随意的
- ✅ 每个文件有明确的定义和职责
- ✅ 基于官方文档的设计意图
- ✅ 不能随意定义或混淆职责

#### 2. 读者不同
- ✅ **Agent 自己读的**: MEMORY.md, SOUL.md, AGENTS.md, USER.md, TOOLS.md, IDENTITY.md, HEARTBEAT.md
- ✅ **开发者读的**: README.md

#### 3. 目的不同
- ✅ **定义 Agent 的本质**: SOUL.md
- ✅ **定义 Agent 的行为**: AGENTS.md
- ✅ **存储长期记忆**: MEMORY.md
- ✅ **提供用户上下文**: USER.md
- ✅ **提供工具参考**: TOOLS.md
- ✅ **定义 Agent 的元数据**: IDENTITY.md
- ✅ **帮助开发者使用**: README.md
- ✅ **配置定时任务**: HEARTBEAT.md

#### 4. 必需性不同
- ✅ **必需**: MEMORY.md, SOUL.md, AGENTS.md
- ⚠️ **可选**: USER.md, TOOLS.md, IDENTITY.md, README.md, HEARTBEAT.md

---

### 常见错误（必须避免）

#### 错误1: 混淆文件职责
- ❌ 在 AGENTS.md 中包含工具列表（应该是 TOOLS.md）
- ❌ 在 SOUL.md 中包含工作流程（应该是 AGENTS.md）
- ❌ 创建"中心化原则文件"（违反职责分离）

#### 错误2: 文件位置错误
- ❌ 把共享 Skills 放在 `~/.openclaw/skills/`
- ✅ 应该在 `/home/node/.openclaw/workspace/skills/`
- ❌ 把核心文档放在 agentDir
- ✅ 应该在 workspace

#### 错误3: 必需 vs 可选混淆
- ❌ 认为 USER.md 是必需的（实际是可选的）
- ❌ 忽略 MEMORY.md（实际是最重要的）

---

### 实际例子

**research-agent 的核心文档**:
```
/home/node/.openclaw/workspace/agents/research-agent/
├── MEMORY.md     # ✅ 必需 - 核心原则和重要学习
├── SOUL.md       # ✅ 必需 - "信息猎人"人设
├── AGENTS.md     # ✅ 必需 - 操作指南和记忆使用
├── USER.md       # ⚠️ 可选 - 用户信息
├── TOOLS.md      # ⚠️ 可选 - 工具参考
├── IDENTITY.md   # ⚠️ 可选 - 名称、风格、emoji
└── README.md     # ⚠️ 可选 - 开发者文档
```

---

**来源**: OpenClaw 官方文档
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已理解并记住
**日期**: 2026-03-05

---

---

## 🎯 Agent 矩阵项目 (2026-02-28 - )

**架构**: 多 Agent 并行协作
```
Main Agent (协调者)
  ├─ content-producer Agent (文案)
  ├─ visual-designer Agent (视觉)
  └─ video-producer Agent (视频)
```

**核心 Agents**（智能体）:
- requirement-agent ✅ - 需求理解
- research-agent ✅ - 资料收集（24小时时效性 + AI热点筛选）
- content-agent ✅ - 内容生产
- visual-agent ✅ - 视觉生成
- video-agent ✅ - 视频生成
- quality-agent ✅ - 质量审核

**核心 Skills**（工具）:
- requirement-analyzer ✅ - 需求分析工具
- quality-reviewer ✅ - �质量审核工具
- visual-generator ✅ - 视觉生成工具（多维参数系统）
- seedance-storyboard ✅ - 视频分镜工具（对话引导）
- ai-daily-digest ✅ - 资讯收集工具（90个顶级技术博客）
- metaso-search ✅ - 网络搜索工具（时效性强化）
- daily-summary ✅ - 每日总结工具（智能分析）
- agent-optimizer ✅ - Agent 优化检查器

### 2026-03-05 重大测试验证 ⭐⭐⭐⭐⭐

**测试目标**: 验证智能协同工作流和分阶段质量审核

**测试流程**:
```
research-agent → quality-agent（资讯审核）
  ↓ ⬇️ 审核通过
content-agent → quality-agent（文案审核）
  ↓ ⬇️ 审核通过
visual-agent → quality-agent（图片审核）
  ↓ ⬇️ 审核通过
video-agent → quality-agent（视频审核）
```

**测试结果**:

#### ✅ 验证成功的关键点

1. **AI 模型决策** - 所有 Agents 都使用 AI 模型决策，而不是固定脚本
2. **智能数量设置** - research-agent 根据价值性和热度智能决定数量（8条，而非固定的TOP 3或TOP 10）
3. **时效性原则** - research-agent 理解"热点资讯"为"24小时时效性"
4. **分阶段质量审核** - 每个阶段都有质量审核，不是最后才审核
5. **多角度内容生成** - content-agent 生成5个不同思维角度的文案
6. **图片先行原则** - video-agent 需要先有图片才能生成视频

#### 📊 具体测试数据

**research-agent**:
- 收集资讯: 8条（智能数量，不是固定）
- 综合评分: 平均 8.1/10
- 时效性: 24小时内37.5%（未达90%要求）

**content-agent**:
- 生成角度: 5个不同思维角度
  1. 💰 创业机会
  2. 💼 职场发展
  3. 📈 投资理财
  4. 🎓 学习成长
  5. 💡 生活应用

**quality-agent（文案审核）**:
- 综合评分: 91/100（优秀）⭐⭐⭐⭐⭐
- 角度差异性: 95/100
- 小红书风格: 92/100
- 内容价值性: 90/100
- 互动引导: 87/100

**visual-agent**:
- 生成图片: 成功
- 尺寸: 1728x2304（3:4竖版）
- 文件大小: 789KB

**quality-agent（图片审核）**:
- 综合评分: 68/100（及格）⭐⭐⭐
- 尺寸比例: 100/100（完美）
- 风格匹配: 95/100（优秀）
- 清晰度: 75/100（良好）
- 色彩搭配: 65/100（需改进）
- AI科技感: 70/100（及格）

**video-agent**:
- 生成分镜: 成功
- 时长: 20秒
- 分镜: 7个镜头（需要6-7张图片）

#### ⚠️ 发现的问题

1. **资讯时效性** - research-agent 的时效性控制需加强（24小时内仅37.5%，要求90%）
2. **图片质量** - visual-agent 的色彩和科技感需提升
3. **Refly Canvas 连接** - 临时故障，影响可视化工作流
4. **流程控制** - 应该"先审核再进行下一步"（但测试时继续执行以验证功能）

#### 🎯 关键验证

**✅ 成功验证**:
- AI 模型决策（不是固定脚本）
- 分阶段质量审核
- 多角度内容生成
- 智能分镜规划
- 工具动态调用

**⚠️ 需要改进**:
- 时效性控制算法
- 色彩和科技感生成
- 流程门控逻辑

**状态**: ✅ 核心功能验证成功，需要细节优化

---

### 每日学习系统项目 (2026-03-04 - )

**核心创新**: 先总结，后学习（而非学习 → 总结）

**时间安排**:
- 21:00: 每日总结 + 自我反思
- 21:30: 定向学习（基于总结）
- 23:59: 深度回顾

**工作流程**:
```
17:00-21:00: 工作时间 → 记录到记忆
  ↓
21:00: 每日总结 + 自我反思
  ↓
识别可进化的能力
  ↓
生成学习计划
  ↓
21:30: 定向学习（基于总结）
  ↓
针对性学习和实践
  ↓
23:59: 深度回顾
  ↓
评估完成情况，规划明天
```

**核心原则**: 总结（自我反思）→ 学习计划 → 定向学习 → 深度回顾

**创建的文件**:
- `workspace/skills/daily-summary/SKILL.md`: 每日总结 Skill 规范
- `workspace/skills/daily-summary/scripts/generate-v2.sh`: 智能分析脚本（v2.0）
- `workspace/skills/agent-optimizer/SKILL.md`: Agent 优化检查器
- `workspace/memory/DAILY-LEARNING-SCHEDULE.md`: 完整时间设计文档

**智能分析脚本功能**:
- 自动扫描今日记忆
- 智能提取能力增长
- 自动识别错误和偏差
- 生成针对性学习计划
- 自动计算评分

### 2026-03-05 每日总结反思 ⭐⭐⭐⭐⭐

**综合评分**: 8.7/10 (优秀)

**主要成就**:
- ✅ 安全配置修复（环境变量 + 配置引用模式）
- ✅ Docker 容器代理配置（host.docker.internal）
- ✅ 记忆系统维护

**需要改进**:
- ⚠️ 第一性原理思考不足（6.5/10）
- ⚠️ 沟通方式需要优化（7.5/10）
- ⚠️ 依赖性说明不足

**明日学习计划**:
1. **第一性原理实践** ⭐⭐⭐⭐⭐ - 重读 SOUL.md，建立决策框架
2. **验证清单创建** ⭐⭐⭐⭐ - 创建配置修改后的验证清单
3. **Docker 进阶学习** ⭐⭐⭐ - 学习 Docker 网络配置

**核心洞察**:
1. 安全配置是基础设施
2. 验证比修改更重要
3. 第一性原理是最优解的前提

**总结报告**: `memory/daily-summary/2026-03-05.md`

---

### Agent 矩阵项目 (2026-02-28 - )

**架构**: 多 Agent 并行协作
```
Main Agent (协调者)
  ├─ content-producer Agent (文案)
  ├─ visual-designer Agent (视觉)
  └─ video-producer Agent (视频)
```

**核心 Agents**（智能体）:
- requirement-agent ✅ - 需求理解
- research-agent ✅ - 资料收集（24小时时效性 + AI热点筛选）
- content-agent ✅ - 内容生产
- visual-agent ✅ - 视觉生成
- video-agent ✅ - 视频生成
- quality-agent ✅ - 质量审核

**核心 Skills**（工具）:
- requirement-analyzer ✅ - 需求分析工具
- quality-reviewer ✅ - 质量审核工具
- visual-generator ✅ - 视觉生成工具（多维参数系统）
- seedance-storyboard ✅ - 视频分镜工具（对话引导）
- ai-daily-digest ✅ - 资讯收集工具（90个顶级技术博客）
- metaso-search ✅ - 网络搜索工具（时效性强化）
- daily-summary ✅ - 每日总结工具（智能分析）
- agent-optimizer ✅ - Agent 优化检查器

### 学习的技能

1. **visual-generator** (来自 Baoyu Skills)
   - 核心思想: Style × Layout 二维系统
   - 9种风格 (cute, fresh, warm, bold, minimal...)
   - 6种布局 (sparse, balanced, dense, list, comparison, flow)

2. **seedance-storyboard** (来自 elementsix/elementsix-skills)
   - 核心思想: 对话引导分镜
   - 5个维度引导 (内容/风格/镜头/动作/声音)
   - 时间轴 + 镜头序列

3. **agent-reach** (Agent-to-Agent 通信)
   - 安装工具: `uv`
   - 支持: YouTube, Reddit, Bilibili, RSS, Web

### 技术规范

**Skill 创建** (2026-02-28):
- Workspace Skill: SKILL.md + scripts/ (简单工具)
- Extension Skill: package.json + src/handler.ts (复杂系统)

**关键转变**: 从"全开发"到"整合复用"，技能复用率 70%

---

---

## ⚠️ 历史项目归档 (2026-02-28)

### AI Media Pipeline 项目

**状态**: 已删除，干扰新思路

该项目曾规划 9 个 Agent 的智能体矩阵，后被删除以支持重新规划。

---

## 🎯 用户偏好和开发模式 (2026-03-02)

### ⚠️ 核心原则：长期主义（最高优先级）

**决策标准**: 长期可维护性 > 高复用率 > 质量保证 > 短期速度

**禁止**: 短期快速但低复用率的设计（如绕过 Agents 直接调用 API）

**必须**:
- 复用优先 - 使用现有 Agents 和 Skills
- 完整流程 - 遵循 Agent 矩阵工作流
- 质量第一 - 使用专业工具

---

### ⚠️ 关键要求：自然语言视频生成原则（最高优先级）

**核心原则**: 在进行自然语言视频生成任务时，**必须先根据自然语言描述生成图片，再根据图片和对视频内容的要求（自然语言）生成视频**。

**适用范围**: 无论采用技术路线1（Seedance API）还是技术路线2（Refly Canvas），都必须坚持这个原则。

**执行流程**:
1. Step 1: 根据自然语言描述生成图片（必需完成）
2. Step 2: 使用生成的图片作为输入，结合视频描述生成视频

**禁止**:
- ❌ 并行生成图片和视频
- ❌ 直接从文本生成视频而跳过图片步骤

---

### ⚠️ 关键要求：三层记忆机制

**用户明确要求**: 使用三层记忆机制管理记忆

1. **短期记忆**: Session context（系统提供）
2. **中期记忆**: `memory/YYYY-MM-DD.md` - 结构化日志（决策、偏好、解决方案）
3. **长期记忆**: `MEMORY.md` - 压缩的智慧和模式

**行为规则**: 当用户说"请记住..."时，必须立即存储到适当的记忆层

---

### ⚠️ 关键要求：系统功能实现原则（2026-03-04 15:53）

**优先使用 Skill 和 Heartbeat，避免创建独立脚本系统**

**核心原则**: 系统功能应该优先实现为 Skill 或使用 Heartbeat，而不是创建独立的脚本系统。

**正确方式**:
- ✅ 可复用功能 → 实现 为 Skill（`workspace/skills/xxx/SKILL.md`）
- ✅ 定期任务 → 使用 Heartbeat（配置 cron 任务）
- ❌ 独立脚本系统 → 仅在特殊情况下使用

**原因**:
1. 符合架构原则："通用工具用 Skill"
2. 更好的集成：与现有 Agent 系统无缝集成
3. 更简单的维护：统一的工作流程
4. 统一的调用方式：Agent 可以调用，Heartbeat 定期执行

---

### ⚠️ 关键要求：Agent 核心文件职责分离（2026-03-04 17:13）⭐

**基于 OpenClaw 官方文档**: https://docs.openclaw.ai/concepts/agent-workspace

**每个文件有明确的职责**：

| 文件 | 谁读它？ | 目的 | 性质 |
|-----|---------|------|------|
| **SOUL.md** | Agent自己 | "我是谁" | 本质/个性/行为准则 |
| **IDENTITY.md** | Agent自己 | "我叫什么" | 元数据（名字、emoji、avatar） |
| **USER.md** | Agent自己 | "用户是谁" | 上下文（偏好、项目） |
| **README.md** | 开发者/用户 | "如何使用我" | 技术文档 |
| **AGENTS.md** | Agent自己 | "同事是谁" | 协作文档 |
| **TOOLS.md** | Agent自己 | "用什么工具" | 参考手册 |

**关键区别**:
- **SOUL.md** = "我是谁"（本质、个性、行为准则）
- **IDENTITY.md** = "我叫什么"（元数据）
- **USER.md** = "用户是谁"（上下文）
- **README.md** = "如何使用我"（技术说明）

**不应该**:
- ❌ 创建"中心化原则"文件（如 SYSTEM-PRINCIPLES.md、CORE-PRINCIPLES.md）
- ❌ 混淆文件职责
- ❌ 重复内容
- ❌ 破坏职责分离

**应该**:
- ✅ 每个文件有明确的职责
- ✅ Agent 自己读的文件 vs 开发者读的文件
- ✅ 单一数据源（SOUL.md 和 MEMORY.md）
- ✅ 不创建冗余的索引文件

**历史教训**:
- SYSTEM-PRINCIPLES.md (已删除) - 冗余的索引文件
- CORE-PRINCIPLES.md (已删除) - 重复的原则文件

---

### 开发模式
**默认实现方式**: 创建 Skill

规则：
1. 除非有更好的实现方式（需说明理由）
2. 除非用户明确指定其他方式
3. **根据实际需求和规范创建**，不是套用模板

### Skill 创建原则
- **需求驱动**: 根据具体需求设计功能
- **遵循规范**: 按照 Skill 创建规范（见 SKILL-CREATION-GUIDE.md）
- **灵活适配**: 不套用固定模板，根据实际需要调整结构
- **配置优先**: 使用配置文件，方便后续修改和优化

**重要**: "创建 Skill" ≠ 套用模板，而是根据需求 + 遵循规范 + 灵活设计

---

## 🎯 Docker 容器网络配置（2026-03-05）

### Clash Verge 代理配置

**场景**: Docker 容器访问宿主机的 Clash Verge 代理

**配置步骤**:
1. Clash Verge 启用"允许局域网连接"
2. 使用 `host.docker.internal:7897` 访问代理
3. 配置环境变量: `export http_proxy=http://host.docker.internal:7897`

**关键点**:
- Mac/Windows: `host.docker.internal` 自动解析到宿主机
- Linux: 需要添加 `--add-host=host.docker.internal:host-gateway`
- 端口: 7897 (Clash Verge Mixed 模式)

**验证**:
```bash
curl -x http://host.docker.internal:7897 https://github.com -I
```

---

## 🎯 Research Agent 规范 (2026-03-03)

### 核心原则

**三大核心原则**:
1. **时效性控制** ⏰ - 所有信息必须满足 24 小时时效性要求
2. **AI 领域聚焦** 🤖 - 重点筛选 AI 领域的高价值内容
3. **智能筛选** 🎯 - 评估、分析、筛选高关注度热点，而非简单罗列

### 评分系统

**综合评分** = 时效性(30%) + 热度(30%) + 价值(25%) + AI相关性(15%)

**筛选阈值**: 总分 ≥ 7.0

### 时效性要求

- ✅ **24小时内**: 标记为"最新资讯"或"今日热点"
- ⚠️ **超过24小时**: 标记为"背景资料"或"历史参考"
- ⚠️ **无时间信息**: 标注"时间未知"，优先级降低

### 质量标准

1. **时效性**: 90% 以上内容为 24 小时内
2. **相关性**: 95% 以上内容与 AI 相关
3. **价值密度**: 平均综合评分 ≥ 7.5
4. **覆盖面**: 至少 3 个 AI 子领域

### 相关文件

**Agent 位置**:
- Agent: `/home/node/.openclaw/agents/research-agent/`
- 规范: `/home/node/.openclaw/agents/research-agent/SKILL.md`
- 脚本: `/home/node/.openclaw/agents/research-agent/scripts/collect.sh`
- 数据: `/home/node/.openclaw/agents/research-agent/data/`

**使用的工具 Skills**:
- Metaso Search: `/home/node/.openclaw/workspace/skills/metaso-search/`
- AI Daily Digest: `/home/node/.openclaw/workspace/skills/ai-daily-digest/`

---

## Cleaner Agent - 自动清理系统 (2026-03-03)

### 职责

每天凌晨 3:00 自动清理 `.openclaw` 目录中的无用文件，保持容器干净整洁。

### 清理规则

**A 类：自动清理**
- 临时文件: *.tmp, *.temp, temp-*.json (>1天)
- 浏览器日志: browser/*/user-data/*/*.log (>7天)
- Agent 数据: agents/research-agent/data/*.md (>7天)
- 会话历史: agents/*/sessions/* (>30天)

**B 类：确认清理**
- 备份文件: 保留最近 3 个，删除更早的
- 废弃 Skills: requirement-analyzer, content-planner, quality-reviewer（已迁移）
- 过时文档: 删除 docs/ 中已完成的项目文档

**白名单（永不删除）**
- 用户数据: MEMORY.md, IDENTITY.md, USER.md, SOUL.md
- Agent 核心: README.md, models.json
- Skill 定义: SKILL.md
- 活跃扩展: feishu, dingtalk
- 所有 extensions/
- 核心文档: SKILL-CREATION-GUIDE.md, AGENT-MATRIX-REPLAN.md, ORCHESTRATION-EXAMPLES.md, AGENT-REACH-STUDY.md

### 文件结构

```
/home/node/.openclaw/agents/cleaner-agent/
├── README.md              # Agent 说明
├── USAGE.md               # 使用说明
├── agent/config.json      # Agent 配置
├── scripts/
│   ├── run.sh             # 主脚本
│   └── test.sh            # 测试脚本
├── logs/                  # 日志目录
└── reports/               # 报告目录

/home/node/.openclaw/workspace/skills/cleanup/
├── SKILL.md               # Skill 规范
└── scripts/
    ├── config.sh          # 配置文件
    ├── whitelist.sh       # 白名单
    ├── cleanup-simple.sh  # 扫描脚本
    └── cleanup-exec.sh    # 清理脚本
```

### 定时任务

```yaml
schedule: "0 3 * * *"  # 每天凌晨 3:00 UTC
payload: "执行每日清理任务"
delivery:
  mode: "announce"
  channel: "feishu"
```

### 使用方式

```bash
# 扫描文件系统
bash /home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-simple.sh

# 执行清理
bash /home/node/.openclaw/workspace/skills/cleanup/scripts/cleanup-exec.sh

# 查看报告
cat /home/node/.openclaw/agents/cleaner-agent/reports/cleanup-report-$(date +%Y%m%d).md
```

### 首次运行结果 (2026-03-03 07:19)

- ✅ 删除 6 个浏览器日志文件
- ✅ 删除 4 个过时文档
- ✅ 保留核心文档（4个）
- ✅ 保留所有 extensions（白名单）

### 维护者

Main Agent

---

## 📚 核心文档使用指南（2026-03-05 更新）

### 文档用途和更新时机

| 文件 | 用途 | 何时更新 |
|------|------|----------|
| **MEMORY.md** | 核心原则（永久记忆） | 学习到新原则时立即更新 |
| **AGENTS.md** | 智能体操作指南 | 规则/优先级/行为方式变化时更新 |
| **TOOLS.md** | 工具参考手册 | 新增/删除工具时更新 |
| **SOUL.md** | 我的本质和个性 | 思考方式变化时更新 |
| **IDENTITY.md** | 我的身份元数据 | 身份信息变化时更新 |
| **USER.md** | 用户上下文 | 了解到新用户偏好时更新 |
| **README.md** | 技术说明文档 | 项目变化时更新 |
| **HEARTBEAT.md** | Heartbeat 配置 | 定时任务变化时更新 |

### 重要说明

**AGENTS.md 的特殊用途**:
- ⭐ 每个会话开始时加载
- 适合放置：规则、优先级、"如何行为"的详细信息
- 智能体应该如何使用记忆

**MEMORY.md 的特殊用途**:
- ⭐⭐⭐⭐⭐ 核心原则（永久记忆）
- 仅在主私密会话中加载（不在共享/群组上下文中）
- 需要时查询（不是每次都加载）

**memory/YYYY-MM-DD.md 的特殊用途**:
- 每日记忆日志（每天一个文件）
- 建议在会话开始时读取今天 + 昨天的内容
- 记录关键决策、偏好、解决方案

---

## ⚠️ 核心原则：持续改进机制（2026-03-07）

### 学习系统架构

**三层学习机制**:
1. **Self-Improvement Skill** - 捕获学习、错误和纠正
2. **Proactive Agent** - 主动性和预测能力
3. **ClawHub 生态系统** - 社区技能学习

### 学习文件系统

**目录结构**:
```
.openclaw/workspace/.learnings/
├── LEARNINGS.md          # 学习记录（纠正、知识缺口、最佳实践）
├── ERRORS.md             # 错误日志（命令失败、异常）
└── FEATURE_REQUESTS.md   # 功能请求（用户需求）
```

**学习记录格式**（标准化）:
```markdown
## [LRN-YYYYMMDD-XXX] category
**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending | resolved | promoted | wont_fix
**Area**: frontend | backend | infra | tests | docs | config
```

### Self-Improvement Skill

**功能**: 捕获学习、错误和纠正，实现持续改进

**触发时机**:
- ✅ 命令或操作意外失败
- ✅ 用户纠正你（"不，这是错的..."、"实际上..."）
- ✅ 用户请求不存在的功能
- ✅ 外部 API 或工具失败
- ✅ 发现知识过时或不正确
- ✅ 发现更好的方法

**学习记录类型**:
- **correction** - 用户纠正
- **knowledge_gap** - 知识缺口
- **best_practice** - 最佳实践
- **feature_request** - 功能请求

**推广机制**:
- 广泛适用的学习 → 提升到 MEMORY.md、AGENTS.md、SOUL.md
- 可复用解决方案 → 提取为 Skill
- 工具使用技巧 → 提升到 TOOLS.md

### Proactive Agent

**核心特性**:
1. **WAL Protocol**（Write-Ahead Logging）
   - 在响应前先记录关键细节
   - 触发：纠正、专有名词、偏好、决策、草稿更改、具体数值
   - 规则：STOP → WRITE → THEN respond

2. **Working Buffer**
   - 危险区日志（60% 上下文后）
   - 捕获每次交换（人类消息 + AI 响应摘要）
   - 从缓冲区恢复（而非问"我们在做什么？"）

3. **Compaction Recovery**
   - 从工作缓冲区恢复上下文
   - 恢复步骤：读取缓冲区 → 读取 SESSION-STATE.md → 读取今日记忆
   - 提取并清除：从缓冲区提取重要上下文到 SESSION-STATE.md

4. **Relentless Resourcefulness**
   - 尝试 10 种方法后再求助
   - 使用所有工具：CLI、浏览器、搜索、生成 Agents
   - "Can't" = 耗尽所有选项，而非"第一次尝试失败"

5. **Self-Improvement Guardrails**
   - **ADL Protocol**（Anti-Drift Limits）- 禁止演变：假智能、不可验证、模糊概念
   - **VFM Protocol**（Value-First Modification）- 评分系统：高频(3x) + 失败减少(3x) + 用户负担(2x) + 自我成本(2x)

### ClawHub 生态系统

**访问方式**: Jina Reader（可以访问单页应用）
```bash
curl -s "https://r.jina.ai/https://clawhub.com"
```

**安装技能**:
```bash
npx clawhub@latest install <skill-name>
```

**已安装技能**:
- ✅ `self-improving-agent` - 持续改进和学习
- ✅ `proactive-agent` - 主动性和预测能力

**备选技能**（待安装）:
- ⏳ `find-skills` - 帮助发现和安装技能
- ⏳ `tavily-search` - AI 优化搜索
- ⏳ `summarize` - 总结 URL 或文件（支持 PDF、图片、音频、YouTube）
- ⏳ `github` - GitHub CLI 交互
- ⏳ `notion` - Notion API
- ⏳ `gog` - Google Workspace CLI

**HEARTBEAT.md 定期任务**:
- 定期访问 ClawHub 发现新技能
- 优先学习高价值技能
- 学习后更新 `.learnings/LEARNINGS.md`
- 关注 8 大技能类型

### 学习记录原则

**立即记录** - 上下文最清晰时记录
**具体明确** - 未来 Agents 需要快速理解
**包含重现步骤** - 特别是错误记录
**链接相关文件** - 便于修复
**推广学习** - 广泛适用的学习应提升到 MEMORY.md
**定期审查** - 在自然断点处审查学习

### 学习提升路径

```
问题/纠正 → 记录到 .learnings/
  ↓
识别模式 → 是否广泛适用？
  ↓
是 → 推广到 MEMORY.md/AGENTS.md/SOUL.md
  ↓
否 → 保留在 .learnings/ 作为参考
  ↓
可复用解决方案 → 提取为 Skill
```

---

**来源**: 2026-03-07 ClawHub 技能集成
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已部署并激活
**日期**: 2026-03-07

---

## ⚠️ 核心原则：ClawHub 技能生态系统（2026-03-08）

### ClawHub 是什么

**定义**: OpenClaw 的技能注册表（类似 npm）
- 版本化管理技能
- 支持向量搜索
- 一键安装：`npx clawhub@latest install <skill-name>`

### 访问方式

**推荐方法**: Jina Reader（可以访问单页应用）
```bash
curl -s "https://r.jina.ai/https://clawhub.com"
```

**访问技能详情**:
```bash
curl -s "https://r.jina.ai/https://clawhub.ai/<skill-id>/<skill-name>"
```

### 优先技能类型（基于 Agent 矩阵需求）

#### 1. 搜索和总结（research-agent 增强）
- **tavily-search** - AI 优化搜索（⭐⭐⭐⭐⭐ 高优先级）
- **summarize** - 多格式总结（YouTube、PDF、图片、音频）（⭐⭐⭐⭐⭐ 高优先级）

#### 2. 技能发现（Main Agent 增强）
- **find-skills** - 自动发现和安装技能（⭐⭐⭐⭐ 中优先级）

#### 3. 其他技能（按需）
- **github** - GitHub CLI 交互
- **notion** - Notion API
- **gog** - Google Workspace CLI
- **nano-pdf** - PDF 编辑

### 学习流程

1. 访问 ClawHub 发现新技能
2. 识别高价值技能（基于用户需求和工作流）
3. 安装技能: `npx clawhub@latest install <skill-name>`
4. 学习技能的 SKILL.md 文档
5. 记录学习到 `.learnings/LEARNINGS.md`
6. 运行 Agent 优化检查器
7. 生成优化建议
8. 集成到 Agent 矩阵

### 学习记录格式

```markdown
## [LRN-YYYYMMDD-XXX] category
**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending | resolved | promoted
**Area**: frontend | backend | infra | tests | docs | config
```

### Agent 优化检查流程

**触发时机**: 学习到新技能时

**执行步骤**:
1. 扫描所有 6 个 Agent
2. 检查是否需要更新优化
3. 生成详细的优化建议
4. 通过飞书发送报告
5. 等待用户确认
6. 自动应用优化（用户确认后）

**优化检查器**:
```bash
bash /home/node/.openclaw/workspace/skills/agent-optimizer/scripts/check.sh
```

### 学习记录系统

**目录结构**:
```
.openclaw/workspace/.learnings/
├── LEARNINGS.md          # 学习记录（纠正、知识缺口、最佳实践）
├── ERRORS.md             # 错误日志（命令失败、异常）
└── FEATURE_REQUESTS.md   # 功能请求（用户需求）
```

### 实际案例（2026-03-08）

**学习内容**:
- Tavily Web Search - AI 优化搜索
- Summarize - 多格式总结
- Find Skills - 自动发现

**优化建议**:
- research-agent: 集成 Tavily Search（搜索速度提升 30-50%）
- research-agent: 集成 Summarize（支持 YouTube、PDF）
- content-agent: 集成 Summarize（参考资料理解）
- Main Agent: 集成 Find Skills（自动发现）

**预期效果**:
- 搜索速度提升 30-50%
- 资料收集效率提升 2-3 倍
- 技能发现成本降低 80%

---

**来源**: 2026-03-08 ClawHub 定向学习
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已理解并记录
**日期**: 2026-03-08

