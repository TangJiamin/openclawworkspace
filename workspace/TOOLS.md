# Main Agent Tools

## find-skills

自动发现和安装社区技能（Skills CLI）。

**描述**: 当用户询问功能时，自动搜索相关技能并一键安装。

**使用场景**:
- 用户询问："你能做 PR 审查吗？"
- 用户询问："有 GitHub CLI 工具吗？"
- 用户询问："你能处理 PDF 文档吗？"

**使用方法**:
```bash
# 交互式搜索
npx skills find

# 搜索特定技能
npx skills find "pr review"
npx skills find "github"
npx skills find "pdf"

# 安装技能
npx skills add <owner/repo@skill> -g -y
```

**注意**:
- 如果 npm 网络连接失败，使用国内镜像：
  ```bash
  npm config set registry https://registry.npmmirror.com
  ```

---

## clawhub ⭐ **OpenClaw 官方技能商店**

ClawHub 是 OpenClaw 官方技能注册表，收录 3000+ 技能。

**描述**: 搜索、安装、更新 OpenClaw 官方技能。

**使用方法**:
```bash
# 搜索技能
npx clawhub search "calendar"

# 安装技能
npx clawhub install github
npx clawhub install notion
npx clawhub install tavily-search

# 更新所有技能
npx clawhub update --all

# 查看可更新技能
npx clawhub check-update
```

**高价值技能推荐**（2026年3月）:
1. **openclaw-tavily-search** ⭐ - Tavily AI 搜索（已安装，Brave 替代）
2. **summarize** - 内容总结（已安装，URL/PDF/图片/音频/YouTube）
3. **agent-browser** - 网页自动化交互
4. **github** - GitHub CLI 交互
5. **notion** - Notion 知识管理
6. **pdf** - PDF 处理工具包
7. **code** - 编码工作流
8. **email-daily-summary** - 邮件摘要
9. **calendar** - 日历管理
10. **proactive-agent** - 主动性 Agent（已安装）
11. **self-improving-agent** - 持续改进 Agent（已安装）

**技能评估标准**:
- ⭐ **质量**: 星级评分、评论质量
- 🔒 **安全性**: SKILL.md 定义公开、审核机制
- 📈 **实用性**: 下载量、更新频率
- 🛠️ **兼容性**: 与当前 OpenClaw 版本兼容

**注意事项**:
- ⚠️ 3000+ 技能中，90% 实用性较低，需要筛选
- ✅ 优先安装高频实用技能，避免过多导致卡顿
- 🔒 限制技能访问路径，避免敏感目录暴露
- 🔄 每周更新一次技能与 OpenClaw 版本

**学习资源**:
- ClawHub 网站: https://clawhub.ai（或使用 Jina Reader: `curl -s "https://r.jina.ai/https://clawhub.com"`）
- 官方文档: https://docs.openclaw.ai

---

## search ⭐ **统一搜索接口**（2026-03-11 新增）

统一搜索接口，支持 Brave Search、Tavily Search 和 Metaso 搜索。

**描述**: 自动选择最佳搜索服务，提供降级方案。

**核心特性**:
- ✅ **优先级**: Brave Search → Tavily Search → Metaso 搜索
- ✅ **自动降级**: 如果首选服务不可用，自动使用备用服务
- ✅ **统一接口**: 简化搜索调用

**使用方法**:
```bash
# 基础搜索（默认 5 个结果）
bash /home/node/.openclaw/workspace/scripts/search.sh "OpenClaw Agent"

# 自定义结果数量
bash /home/node/.openclaw/workspace/scripts/search.sh "AI Agent 趋势 2026" 10
```

**搜索服务**:
1. **Brave Search** (优先)
   - OpenClaw 内置 web_search tool
   - 快速、准确

2. **Tavily Search** (备用)
   - AI 优化搜索
   - 需要设置 TAVILY_API_KEY

3. **Metaso 搜索** (降级)
   - AI 搜索增强
   - 已集成到 workspace

**详细说明**: 详见学习报告 `.learnings/directed-learning-2026-03-11-clawhub.md`

---

## tavily-search ⭐ **Tavily AI 搜索**（2026-03-11 新增）

基于 Tavily API 的 AI 优化搜索引擎，Brave Search 的替代方案。

**描述**: 使用 Tavily API 进行网络搜索，返回相关结果和 AI 生成的答案摘要。

**核心特性**:
- ✅ AI 优化搜索
- ✅ 答案摘要（可选）
- ✅ 搜索深度可调（basic/advanced）
- ✅ 多种输出格式（raw/brave/md）

**使用方法**:
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

**要求**:
- 环境变量: `TAVILY_API_KEY`
- 或 `~/.openclaw/.env` 文件

**与 Brave Search 对比**:
| 特性 | Brave Search | Tavily Search |
|------|--------------|---------------|
| **AI 优化** | ❌ | ✅ |
| **答案摘要** | ❌ | ✅ |
| **搜索深度** | 固定 | 可选 |
| **Agent 友好** | 中 | 高 |

**详细说明**: 详见学习报告 `.learnings/directed-learning-2026-03-11-clawhub.md`

---

## orchestrate

多 Agent 编排工具 - 协调 6 个子 Agents 协同工作完成内容生产任务。

**描述**: 通过 `sessions_spawn` 创建真正的独立 Agent sessions，实现多 Agent 协同工作。

**参数**:
- `userInput` (string, required): 用户需求描述

**返回**: 
- 格式化的生成结果，包含：
  - 任务规范
  - 收集的资料
  - 生成的内容
  - 视觉参数/视频分镜
  - 质量审核报告

**子 Agents**:
1. **requirement-agent** - 需求理解（60秒）
2. **quality-agent** - 需求质量审核（30秒）
3. **research-agent** - 资料收集（120秒）
4. **quality-agent** - 资料质量审核（30秒）
5. **content-agent** - 内容生产（90秒）
6. **quality-agent** - 文案质量审核（30秒）
7. **visual-agent** - 视觉生成（60秒）
8. **quality-agent** - 图片质量审核（30秒）
9. **video-agent** - 视频生成（120秒）⚠️ **必须先完成 visual-agent**
10. **quality-agent** - 视频质量审核（30秒）

**使用示例**:

```
# 生成小红书图文
orchestrate("生成小红书内容，推荐5个提升效率的AI工具")

# 生成抖音视频
orchestrate("生成抖音视频，介绍ChatGPT使用技巧")

# 生成微信公众号文章
orchestrate("写微信公众号文章，分析AI行业趋势")
```

**工作流程**（v3.0 - 并行优化 2026-03-12）:

```
用户需求
  ↓
requirement-agent (分析需求 10秒快速 + 12秒深度)
  ↓
┌─────────────────────────────────────┐
│ requirement-agent (深度分析 12秒)   │
│ research-agent (收集资料 180秒)     │ ← 并行执行 ⚡
└─────────────────────────────────────┘
  ↓
content-agent (生成内容 90秒)
  ↓
┌─────────────────────────────────────┐
│ quality-agent (文案审核 30秒)       │
│ visual-agent (生成分镜 180秒)       │ ← 并行执行 ⚡
└─────────────────────────────────────┘
  ↓
video-agent (生成视频 360秒)
  ↓
quality-agent (视频审核 30秒)
  ↓
整合结果 → 返回用户
```

**并行优化说明**（v3.0 新增）：
- **并行1**：requirement-agent 深度分析 + research-agent 搜索（速度提升 15.5%）
- **并行2**：quality-agent 文案审核 + visual-agent 生成分镜（速度提升 33.3%）
- **总速度提升**：18.4%
- **风险控制**：如果文案不达标，立即停止 visual-agent

**核心改进**: 每个阶段都有质量审核，不达标立即重新生成

**输出格式**:

```markdown
🎯 生成结果

📋 任务规范: {...}
📚 收集资料: 15条
✍️  生成内容: 【标题】正文...
🎨 视觉参数: {...}
✅ 质量评分: 88/100 (良好)
```

**注意事项**:
- 每个子 Agent 都是独立的 session
- 每个阶段都有质量审核（分阶段质量控制）
- 质量不达标会重新生成（最多3次）
- 执行时间根据 Agent 数量而定（约 3-8 分钟，包含重试）
- 支持小红书、抖音、微信公众号等平台
- 可以生成图文、视频等多种内容类型

**技术实现**:
- 使用 `sessions_spawn` 创建独立 Agent sessions
- 每个有独立的上下文、记忆、超时控制
- 结果在 Agents 之间自动传递

---

## translate ⭐ **多语言翻译工具**（2026-03-11 新增）

基于 baoyu-translate 核心逻辑，专为 OpenClaw Agent 矩阵优化的翻译工具。

**描述**: 三模式翻译系统，支持术语管理、智能分块、一致性保证。

**核心特性**:
- ✅ **三模式翻译**: quick（快速）/ normal（标准）/ refined（精细）
- ✅ **术语管理**: 全局术语表 + 项目术语表 + 自动提取
- ✅ **智能分块**: >4000词自动分块，保证术语一致性
- ✅ **多语言支持**: 中英互译，可扩展到其他语言

**使用方法**:
```bash
# 快速翻译（短文本、聊天）
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  "Hello, world!" \
  --mode quick

# 标准翻译（文章、博客）
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  article.md \
  --mode normal \
  --to zh-CN

# 精细翻译（出版质量、重要文档）
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  important.md \
  --mode refined \
  --to zh-CN

# 指定风格和受众
bash /home/node/.openclaw/workspace/skills/translate/scripts/translate.sh \
  article.md \
  --mode normal \
  --style technical \
  --audience technical
```

**翻译模式对比**:

| 模式 | 质量 | 步骤 | 适用场景 | 时间 |
|------|------|------|----------|------|
| **quick** | ⭐⭐ | 直接翻译 | 短文本、聊天 | ~10秒 |
| **normal** | ⭐⭐⭐⭐ | 分析→翻译 | 文章、博客 | ~30秒 |
| **refined** | ⭐⭐⭐⭐⭐ | 分析→翻译→审核→润色 | 出版物、重要文档 | ~60秒 |

**翻译风格**:
- `storytelling` - 引人入胜的叙事（默认）
- `formal` - 专业、结构化
- `technical` - 精确、文档风格
- `literal` - 接近原文结构
- `academic` - 学术、严谨
- `business` - 简洁、结果导向
- `conversational` - 口语化
- `elegant` - 文学、优雅

**目标受众**:
- `general` - 普通读者（默认）
- `technical` - 开发者/工程师
- `academic` - 研究者/学者
- `business` - 商务人士

**输出结构**:
```
article-zh-CN/
├── translation.md          # 最终翻译（始终存在）
├── 01-analysis.md          # 内容分析（normal/refined）
├── 02-prompt.md            # 翻译提示词（normal/refined）
├── 03-draft.md             # 初始草稿（refined）
├── 04-critique.md          # 审核诊断（refined）
├── 05-revision.md          # 修订版本（refined）
└── chunks/                 # 分块（如有）
    ├── chunk-01.md
    ├── chunk-01-draft.md
    └── ...
```

**集成 Agents**:
- **research-agent**: 翻译外文资料
- **content-agent**: 多语言内容生产

**学习报告**: `docs/learning-baoyu-translate.md`

**基于**: baoyu-translate v1.56.1 (MIT-0)

---

## xhs-series ⭐ **小红书图文系列生成器**（2026-03-11 新增）

基于 baoyu-xhs-images 核心逻辑，专为 OpenClaw Agent 矩阵优化的小红书图文系列生成工具。

**描述**: Style × Layout 二维系统，自动将内容拆分为 1-10 张小红书风格的信息图。

**核心特性**:
- ✅ **Style × Layout 二维系统**: 11种风格 × 8种布局 = 88种组合
- ✅ **智能内容拆分**: 自动分析内容结构，拆分为 1-10 张图
- ✅ **快速预设**: 20+ 场景化预设，一键应用
- ✅ **三种策略**: 故事驱动、信息密集、视觉优先

**使用方法**:
```bash
# 自动模式（智能推荐）
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  "5个提高效率的AI工具"

# 使用预设
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --preset knowledge-card

# 自定义风格和布局
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --style notion \
  --layout dense

# 快速预设列表
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --preset checklist        # notion + list（清单）
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --preset concept-map      # notion + mindmap（概念图）
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --preset swot             # notion + quadrant（SWOT分析）
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --preset tutorial         # chalkboard + flow（教程）
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --preset cute-share       # cute + balanced（少女风分享）
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --preset warning          # bold + list（避坑指南）
bash /home/node/.openclaw/workspace/skills/xhs-series/scripts/generate.sh \
  article.md \
  --preset poster           # screen-print + sparse（海报风封面）
```

**风格系统**（11种）:

| 风格 | 类型 | 描述 | 最佳布局 |
|------|------|------|----------|
| **notion** | 知识系 | 极简手绘线稿，知识感 | dense, list, mindmap |
| **chalkboard** | 知识系 | 黑板粉笔风，教育感 | flow, balanced, dense |
| **study-notes** | 知识系 | 真实手写笔记风 | dense, list |
| **cute** | 甜美系 | 甜美可爱，经典小红书风 | sparse, balanced |
| **fresh** | 甜美系 | 清新自然 | balanced, flow |
| **warm** | 甜美系 | 温暖亲切 | balanced |
| **bold** | 强力系 | 强烈冲击 | list, comparison |
| **pop** | 强力系 | 活力炸裂 | sparse, list |
| **retro** | 强力系 | 复古怀旧 | list, balanced |
| **minimal** | 极简系 | 超级干净 | sparse, balanced |
| **screen-print** | 极简系 | 海报艺术风 | sparse, comparison |

**布局系统**（8种）:

| 布局 | 类型 | 点数/项目 | 适用场景 |
|------|------|-----------|----------|
| **sparse** | 密度 | 1-2 | 封面、金句 |
| **balanced** | 密度 | 3-4 | 标准内容 |
| **dense** | 密度 | 5-8 | 知识卡片 |
| **list** | 结构 | 4-7项 | 排行榜、清单 |
| **comparison** | 结构 | 2部分 | 前后对比、优缺点 |
| **flow** | 结构 | 3-6步 | 过程、时间线 |
| **mindmap** | 结构 | 4-8分支 | 概念图、脑图 |
| **quadrant** | 结构 | 4部分 | SWOT、分类 |

**快速预设**（20+）:

**知识学习类**:
- `knowledge-card` - 干货知识卡（notion + dense）
- `checklist` - 清单排行（notion + list）
- `concept-map` - 概念图（notion + mindmap）
- `swot` - SWOT分析（notion + quadrant）
- `tutorial` - 教程步骤（chalkboard + flow）
- `classroom` - 课堂笔记（chalkboard + balanced）
- `study-guide` - 学习笔记（study-notes + dense）

**生活分享类**:
- `cute-share` - 少女风分享（cute + balanced）
- `girly` - 甜美封面（cute + sparse）
- `cozy-story` - 生活故事（warm + balanced）
- `product-review` - 产品对比（fresh + comparison）

**强力观点类**:
- `warning` - 避坑指南（bold + list）
- `versus` - 正反对比（bold + comparison）
- `clean-quote` - 金句封面（minimal + sparse）
- `hype` - 炸裂封面（pop + sparse）

**复古娱乐类**:
- `retro-ranking` - 复古排行（retro + list）
- `throwback` - 怀旧分享（retro + balanced）
- `pop-facts` - 趣味冷知识（pop + list）

**海报编辑类**:
- `poster` - 海报风封面（screen-print + sparse）
- `editorial` - 观点文章（screen-print + balanced）
- `cinematic` - 电影对比（screen-print + comparison）

**智能选择**（基于内容信号）:

| 内容信号 | 推荐风格 | 推荐布局 | 推荐预设 |
|----------|----------|----------|----------|
| 美妆、时尚、可爱 | cute | sparse/balanced | cute-share |
| 健康、自然、清新 | fresh | balanced/flow | product-review |
| 生活、故事、情感 | warm | balanced | cozy-story |
| 警告、重要、必须 | bold | list/comparison | warning |
| 专业、商务、优雅 | minimal | sparse/balanced | clean-quote |
| 知识、概念、生产力 | notion | dense/list | knowledge-card |
| 教育、教程、学习 | chalkboard | balanced/dense | tutorial |
| 笔记、手写、学习 | study-notes | dense/list | study-guide |
| 电影、海报、观点 | screen-print | sparse/comparison | poster |

**输出结构**:
```
xhs-ai-tools-20260311/
├── source-article.md           # 源文件
├── analysis.md                 # 内容分析
├── outline.md                  # 最终大纲
├── 01-cover.png                # 封面图
├── 02-content-1.png            # 内容图1
├── 03-content-2.png            # 内容图2
├── ...
└── 10-ending.png               # 结尾图
```

**集成 Agents**:
- **visual-agent**: 小红书图文系列生成

**学习报告**: `docs/learning-baoyu-xhs-images.md`

**基于**: baoyu-xhs-images v1.56.1 (MIT-0)

---

## 🖼️ visual/video 脚本调用

### visual-agent 脚本

**文件**: `/home/node/.openclaw/workspace/agents/visual-agent/generate.sh`

**功能**: 调用 xskill API 生成图片

**使用方法**:
```bash
bash /home/node/.openclaw/workspace/agents/visual-agent/generate.sh '{"task_type":"image_generation","style":"cyberpunk"}'
```

**返回**: 图片 URL

### video-agent 脚本

**文件**: `/home/node/.openclaw/workspace/agents/video-agent/generate.sh`（待创建）

**功能**: 调用 xskill API 生成视频

**使用方法**:
```bash
bash /home/node/.openclaw/workspace/agents/video-agent/generate.sh '{"task_type":"video_generation","image_url":"..."}'
```

**返回**: 视频 URL

---

**原则**: 不要在提示词中写 bash 代码，调用脚本即可
