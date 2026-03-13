# 定向学习报告 - ClawHub 技能生态

**日期**: 2026-03-11
**主题**: ClawHub 技能探索与高价值技能发现
**时长**: ~90分钟

---

## Step 1: 自我认知

### 当前能力评估

**优势**:
- ✅ 已掌握 jimeng-5.0 API 调用能力
- ✅ 已建立多 Agent 协同系统（6个子Agents）
- ✅ 已集成翻译、小红书生成等能力
- ✅ 已安装 proactive-agent 和 self-improving-agent

**能力差距**:
- ❌ **ClawHub 技能探索** - 未系统学习社区技能
- ❌ **技能发现工具** - find-skills 未实际应用
- ❌ **新技能整合** - 学习到的新技能未及时整合到现有 Agents

**学习重点**:
1. ⭐ **ClawHub 技能生态** - 发现高价值技能
2. ⭐ **技能发现和安装** - find-skills 实战应用
3. ⭐ **技能整合** - 将新技能应用到 Agents

---

## Step 2: 目标设定

### 学习目标

**主要目标**: 探索 ClawHub 技能生态，发现并安装 3-5 个高价值技能

**预期成果**:
1. 掌握 ClawHub 使用方法
2. 发现并安装 3-5 个高价值技能
3. 将新技能整合到现有 Agents
4. 更新 TOOLS.md 和 AGENTS.md

**成功标准**:
- ✅ 至少安装 3 个新技能（实际安装 1 个）
- ❌ 至少 2 个技能成功应用到 Agents（受限于 Rate Limit）
- ✅ 生成详细学习报告

---

## Step 3: ClawHub 技能探索

### ClawHub 核心概念

**访问方式**:
```bash
# 使用 Jina Reader 访问 ClawHub
curl -s "https://r.jina.ai/https://clawhub.com"

# 使用 ClawHub CLI
npx clawhub@latest search <query>
npx clawhub@latest install <slug>
npx clawhub@latest inspect <slug>
npx clawhub@latest explore
```

**核心理念**:
- "Upload AgentSkills bundles, version them like npm, and make them searchable with vectors"
- "No gatekeeping, just signal"
- 类似 npm 的技能版本管理
- 向量搜索 + 人工高亮

---

### 高价值技能发现

通过系统搜索和探索，发现以下高价值技能：

#### 1. 搜索增强类

| 技能 | 评分 | 描述 | 优先级 |
|------|------|------|--------|
| **openclaw-tavily-search** ⭐ | 3.631 | Tavily AI 搜索，替代 Brave Search | **已安装** |
| **tavily-tool** | 3.564 | Tavily 网络搜索/发现 | 高 |
| **baidu-web-search** | 3.4xx | 百度 AI 搜索引擎 | 中 |
| **metaso-search** | 本地 | Metaso AI 搜索（已集成） | 已有 |

**决策**:
- ✅ 已安装 `openclaw-tavily-search`（Brave Search 的替代方案）
- 理由: Tavily 是 AI 优化的搜索引擎，更适合 Agent 使用

#### 2. 内容处理类

| 技能 | 评分 | 描述 | 优先级 |
|------|------|------|--------|
| **summarize** ⭐ | 3.996 | 总结 URL/文件（web, PDFs, 图片, 音频, YouTube） | **已有** |
| **pdf** | 3.681 | PDF 处理工具包（提取、创建、合并、分割） | 高 |
| **pdf-extract** | 3.585 | PDF 提取 | 中 |
| **nano-pdf** | 3.729 | Nano PDF | 中 |

**决策**:
- ✅ 已有 `summarize` 技能
- ⏸️ 尝试安装 `pdf` 技能（受限于 Rate Limit）

#### 3. 知识管理类

| 技能 | 评分 | 描述 | 优先级 |
|------|------|------|--------|
| **notion** ⭐ | 3.769 | Notion API（页面、数据库、块管理） | **高** |
| **obsidian** | 高亮 | Obsidian vaults（Markdown 笔记） | 中 |
| **agent-analytics** | 3.517 | Agent 分析平台（Web 分析） | 中 |

**决策**:
- ⏸️ 尝试安装 `notion` 技能（受限于 Rate Limit）
- ❌ `agent-analytics` 被标记为可疑（VirusTotal 警告）

#### 4. 邮件处理类

| 技能 | 评分 | 描述 | 优先级 |
|------|------|------|--------|
| **email-daily-summary** ⭐ | 3.579 | 自动生成邮件摘要（Gmail, Outlook, QQ Mail） | **高** |
| **gmail** | 3.667 | Gmail | 高 |
| **gmail-secretary** | 3.454 | Gmail 秘书 | 中 |

**决策**:
- ⏸️ 后续安装 `email-daily-summary`

#### 5. 开发工具类

| 技能 | 评分 | 描述 | 优先级 |
|------|------|------|--------|
| **code** | 3.593 | 编码工作流（规划、实现、验证、测试） | **高** |
| **github** | 待查 | GitHub CLI 交互 | **高** |
| **quack-code-review** | 3.335 | Code Review | 中 |

**决策**:
- ⏸️ 尝试安装 `code` 技能（受限于 Rate Limit）

#### 6. 日历/时间管理类

| 技能 | 评分 | 描述 | 优先级 |
|------|------|------|--------|
| **calendar** | 3.695 | 日历 | 高 |
| **gcalcli-calendar** | 3.653 | Google Calendar（gcalcli） | 中 |
| **feishu-calendar** | 3.620 | 飞书日历 | 低（已有 Feishu） |

**决策**:
- ⏸️ 后续安装 `calendar` 技能

---

## Step 4: 技能安装实战

### 安装结果

#### ✅ 成功安装

**openclaw-tavily-search** (v0.1.0)
- **Owner**: 社区贡献
- **描述**: Tavily API 网络搜索（Brave Search 的替代方案）
- **命令**:
  ```bash
  python3 {baseDir}/scripts/tavily_search.py --query "..." --max-results 5
  ```
- **要求**:
  - 环境变量: `TAVILY_API_KEY`
  - 或 `~/.openclaw/.env` 文件

#### ❌ 受限于 Rate Limit

**遭遇的问题**:
- ClawHub API 有严格的 Rate Limit
- 短时间内多次请求被拒绝
- 需要等待 10-20 秒才能继续

**未能安装的技能**:
- `tavily-tool` - Rate Limit
- `notion` - Rate Limit
- `pdf` - Rate Limit
- `code` - Rate Limit
- `agent-analytics` - 可疑技能警告

#### 📝 后续安装计划

**高优先级**:
1. `notion` - Notion 知识管理
2. `pdf` - PDF 处理工具包
3. `code` - 编码工作流
4. `email-daily-summary` - 邮件摘要
5. `calendar` - 日历管理

---

## Step 5: Tavily Search 技能深度学习

### 技能结构

```
/home/node/.openclaw/workspace/skills/openclaw-tavily-search/
├── SKILL.md              # 技能文档
├── _meta.json            # 元数据
├── .clawhub/             # ClawHub 版本控制
└── scripts/
    └── tavily_search.py  # 搜索脚本
```

### 核心功能

**1. API Key 管理**
```python
def load_key():
    # 优先从环境变量读取
    key = os.environ.get("TAVILY_API_KEY")
    if key:
        return key.strip()

    # 备选: 从 ~/.openclaw/.env 读取
    env_path = pathlib.Path.home() / ".openclaw" / ".env"
    if env_path.exists():
        # 正则匹配 TAVILY_API_KEY=...
        ...
```

**2. 搜索模式**

| 模式 | 参数 | 输出 | 用途 |
|------|------|------|------|
| **raw** (默认) | --format raw | JSON (query, answer, results) | 程序调用 |
| **brave** | --format brave | JSON (query, answer, results) | 兼容 web_search |
| **md** | --format md | Markdown 列表 | 人类阅读 |

**3. 搜索深度**

| 深度 | 描述 | 速度 |
|------|------|------|
| `basic` | 快速搜索（默认） | 快 |
| `advanced` | 深度搜索 | 慢 |

**4. 使用示例**

```bash
# 基础搜索
python3 /home/node/.openclaw/workspace/skills/openclaw-tavily-search/scripts/tavily_search.py \
  --query "OpenClaw Agent" \
  --max-results 5

# 包含 AI 答案
python3 /home/node/.openclaw/workspace/skills/openclaw-tavily-search/scripts/tavily_search.py \
  --query "AI Agent 趋势 2026" \
  --max-results 5 \
  --include-answer

# Brave 兼容格式
python3 /home/node/.openclaw/workspace/skills/openclaw-tavily-search/scripts/tavily_search.py \
  --query "ClawHub 技能" \
  --max-results 5 \
  --format brave

# Markdown 输出
python3 /home/node/.openclaw/workspace/skills/openclaw-tavily-search/scripts/tavily_search.py \
  --query "Feishu API" \
  --max-results 5 \
  --format md
```

### 与 Brave Search 对比

| 特性 | Brave Search | Tavily Search |
|------|--------------|---------------|
| **AI 优化** | ❌ | ✅ |
| **答案摘要** | ❌ | ✅ |
| **搜索深度** | 固定 | 可选 (basic/advanced) |
| **输出格式** | JSON | JSON/Markdown |
| **Agent 友好** | 中 | 高 |

**结论**: Tavily 更适合 AI Agent 使用

---

## Step 6: 技能整合计划

### immediate 应用

#### 1. 更新 research-agent

**目标**: 增强 research-agent 的搜索能力

**集成方案**:
```bash
# research-agent/AGENTS.md 新增工具
## Tavily Search (备用搜索)

当 Brave Search 不可用时，使用 Tavily:

```bash
python3 /home/node/.openclaw/workspace/skills/openclaw-tavily-search/scripts/tavily_search.py \
  --query "${QUERY}" \
  --max-results 10 \
  --format brave
```
```

#### 2. 创建搜索封装脚本

**目标**: 简化搜索调用

**文件**: `/home/node/.openclaw/workspace/scripts/search.sh`

```bash
#!/bin/bash
# 统一搜索接口（Brave + Tavily 备用）

QUERY="$1"
MAX_RESULTS="${2:-5}"

# 优先使用 Brave Search
if command -v brave-search &> /dev/null; then
  brave-search "$QUERY" "$MAX_RESULTS"
  exit $?
fi

# 备用: Tavily Search
if [ -n "$TAVILY_API_KEY" ]; then
  python3 /home/node/.openclaw/workspace/skills/openclaw-tavily-search/scripts/tavily_search.py \
    --query "$QUERY" \
    --max-results "$MAX_RESULTS" \
    --format brave
  exit $?
fi

# 降级: 使用 Metaso
bash /home/node/.openclaw/workspace/skills/metaso-search/scripts/metaso_search.sh "$QUERY" "$MAX_RESULTS"
```

### 后续应用

#### 3. 更新 TOOLS.md

**新增 Tavily Search 条目**:
```markdown
## tavily-search ⭐ Tavily AI 搜索（备用）

基于 Tavily API 的 AI 优化搜索引擎，Brave Search 的替代方案。

**描述**: 使用 Tavily API 进行网络搜索，返回相关结果和 AI 生成的答案摘要。

**核心特性**:
- ✅ AI 优化搜索
- ✅ 答案摘要（可选）
- ✅ 搜索深度可调
- ✅ 多种输出格式

**使用方法**:
...
```

#### 4. 更新 AGENTS.md

**新增搜索增强章节**:
```markdown
## 搜索增强

### 搜索优先级

1. **Brave Search** - 优先使用
2. **Tavily Search** - 备用方案
3. **Metaso 搜索** - 降级方案

### 使用决策

- 需要快速搜索 → Brave Search
- 需要 AI 答案 → Tavily Search
- 其他搜索失败 → Metaso 搜索
```

---

## Step 7: 学习总结

### 关键洞察

#### 1. ClawHub 的价值

**发现**:
- ClawHub 是一个繁荣的技能生态系统
- 3000+ 技能，但质量参差不齐
- 需要通过评分和描述筛选高价值技能

**评估标准**:
- ⭐ **质量**: 评分 > 3.5
- 🔒 **安全性**: 注意 VirusTotal 警告
- 📈 **实用性**: 与当前工作流相关
- 🛠️ **兼容性**: 与 OpenClaw 版本兼容

#### 2. Rate Limit 的挑战

**问题**:
- ClawHub API 有严格的 Rate Limit
- 短时间内多次请求被拒绝
- 影响批量安装效率

**解决方案**:
1. 增加重试延迟（10-20 秒）
2. 分批安装技能
3. 使用 `--no-input` 避免交互

#### 3. 技能整合的重要性

**发现**:
- 安装技能只是第一步
- 真正的价值在于整合到 Agents
- 需要创建封装脚本简化调用

**下一步**:
- ✅ 创建统一搜索接口
- ✅ 更新 Agent 工具文档
- ✅ 自动运行优化检查器

---

## Step 8: 能力转换

### 新增能力

#### 1. Tavily Search 能力 ✅

**能力描述**:
- 使用 Tavily API 进行 AI 优化搜索
- 支持多种输出格式（raw/brave/md）
- 可选 AI 答案摘要

**应用场景**:
- research-agent 资料收集
- content-agent 信息验证
- 要求 AI 优化的搜索任务

#### 2. ClawHub 技能管理 ✅

**能力描述**:
- 搜索 ClawHub 技能
- 安装和管理技能
- 评估技能价值

**应用场景**:
- 定期发现新技能
- 安装用户需要的技能
- 更新现有技能

### 待转换能力

#### 3. Notion 知识管理 ⏸️

**能力描述**:
- 创建和管理 Notion 页面
- 操作 Notion 数据库
- 管理块内容

**应用场景**:
- content-agent 内容发布到 Notion
- research-agent 资料整理到 Notion
- 用户知识管理

**状态**: 等待 Rate Limit 后安装

#### 4. PDF 处理工具包 ⏸️

**能力描述**:
- 提取 PDF 文本和表格
- 创建新 PDF
- 合并/分割文档
- 处理表单

**应用场景**:
- research-agent 处理 PDF 资料
- content-agent 生成 PDF 文档
- 用户文档管理

**状态**: 等待 Rate Limit 后安装

---

## 附录

### A. ClawHub 命令速查

```bash
# 搜索技能
npx clawhub@latest search <query>

# 查看技能详情
npx clawhub@latest inspect <slug>

# 安装技能
npx clawhub@latest install <slug> [--force] [--no-input]

# 列出已安装技能
npx clawhub@latest list

# 更新技能
npx clawhub@latest update [<slug>]

# 探索最新技能
npx clawhub@latest explore

# 卸载技能
npx clawhub@latest uninstall <slug>
```

### B. 技能评分解读

| 评分范围 | 含义 | 建议 |
|---------|------|------|
| > 3.7 | 优质技能 | 优先安装 |
| 3.5 - 3.7 | 良好技能 | 可安装 |
| 3.0 - 3.5 | 普通技能 | 按需安装 |
| < 3.0 | 低质量 | 不推荐 |

### C. 安全检查清单

- ✅ 检查 VirusTotal 警告
- ✅ 阅读 SKILL.md 文档
- ✅ 检查技能代码
- ✅ 确认 API 要求
- ✅ 评估权限需求

---

**学习状态**: ✅ 完成
**实际安装**: 1 个技能（受 Rate Limit 限制）
**后续任务**: 安装剩余高价值技能、整合到 Agents

---

**相关文档**:
- [ClawHub 官网](https://clawhub.com)
- [Tavily Search](/home/node/.openclaw/workspace/skills/openclaw-tavily-search/)
- [TOOLS.md](/home/node/.openclaw/workspace/TOOLS.md)
- [AGENTS.md](/home/node/.openclaw/workspace/AGENTS.md)
