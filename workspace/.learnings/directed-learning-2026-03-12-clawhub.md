# 定向学习报告 - ClawHub 技能探索

**学习日期**: 2026-03-12
**学习时长**: 90分钟
**学习主题**: ClawHub 技能生态系统 + OpenClaw 官方文档

---

## 学习目标

1. ✅ 探索 ClawHub 上的高价值技能
2. ✅ 了解 OpenClaw 官方文档和工具体系
3. ✅ 识别与当前工作流相关的技能
4. ✅ 转换为实际能力

---

## 学习途径

### 1. ClawHub 技能商店（⭐ 重点）

**访问方式**:
```bash
# 使用 Jina Reader 访问（推荐）
curl -s "https://r.jina.ai/https://clawhub.com"

# 或使用 ClawHub CLI
npx clawhub@latest search <skill-name>
npx clawhub@latest install <skill-name>
```

**核心发现**:

#### 高价值技能（按优先级）

1. **tavily-search** ⭐⭐⭐
   - **描述**: AI 优化搜索引擎，专为 Agent 设计
   - **用途**: 实时搜索、论文查询、新闻获取
   - **集成**: 已集成到 workspace（`skills/openclaw-tavily-search/`）
   - **状态**: ✅ 已安装并测试
   - **文档**: `docs/learning-baoyu-translate.md`

2. **summarize** ⭐⭐⭐
   - **描述**: 终极总结工具，支持网页、PDF、图片、音频、YouTube
   - **用途**: 内容摘要、快速理解长文档
   - **安装**: `npx clawhub@latest install summarize`
   - **状态**: ⏳ 待安装（服务暂时不可用）

3. **find-skills** ⭐⭐
   - **描述**: 自动发现和安装社区技能
   - **用途**: 当用户询问功能时，自动搜索相关技能
   - **安装**: `npx clawhub@latest install find-skills`
   - **状态**: ⏳ 待安装（服务暂时不可用）

4. **github** ⭐⭐
   - **描述**: GitHub CLI 交互，支持 issue、PR、CI
   - **用途**: 自动管理 repo、代码搜索
   - **安装**: `npx clawhub@latest install github`
   - **状态**: ⏳ 待安装（服务暂时不可用）

5. **ontology** ⭐⭐
   - **描述**: 类型化知识图谱，用于结构化 Agent 记忆
   - **用途**: 创建/查询实体（Person、Project、Task、Event、Document）
   - **安装**: `npx clawhub@latest install ontology`
   - **状态**: ⏳ 待安装（服务暂时不可用）

6. **gog** ⭐
   - **描述**: Google Workspace CLI（Gmail、Calendar、Drive、Sheets、Docs）
   - **用途**: 集成 Google 服务
   - **安装**: `npx clawhub@latest install gog`
   - **状态**: ⏳ 待安装（服务暂时不可用）

7. **skill-vetter** ⭐
   - **描述**: 安全优先的技能审核工具
   - **用途**: 在安装任何技能前检查风险
   - **安装**: `npx clawhub@latest install skill-vetter`
   - **状态**: ⏳ 待安装（服务暂时不可用）

#### 已安装技能

- ✅ **self-improving-agent**: 持续改进和学习（已验证）
- ✅ **proactive-agent**: 主动性和预测能力（已验证）

### 2. OpenClaw 官方文档

**核心发现**:

#### 工具体系（First-Class Tools）

OpenClaw 提供了 **first-class tools**，替代了旧的 `openclaw-*` skills：

**核心工具组**:
- `group:runtime`: `exec`, `bash`, `process`
- `group:fs`: `read`, `write`, `edit`, `apply_patch`
- `group:sessions`: `sessions_list`, `sessions_history`, `sessions_send`, `sessions_spawn`, `session_status`
- `group:memory`: `memory_search`, `memory_get`
- `group:web`: `web_search`, `web_fetch`
- `group:ui`: `browser`, `canvas`
- `group:automation`: `cron`, `gateway`
- `group:messaging`: `message`

**工具配置**:
```json
{
  "tools": {
    "profile": "full",  // minimal | coding | messaging | full
    "allow": ["browser"],
    "deny": ["group:runtime"]
  }
}
```

#### 核心 API 工具

1. **browser** - 浏览器自动化
   - 支持点击、输入、截图等操作
   - 支持 Chrome extension relay takeover
   - 集成 OpenClaw 的 browser control server

2. **canvas** - Canvas 渲染和控制
   - 展示视觉内容
   - 支持 A2UI（Agent-to-UI 交互）
   - 截图和快照功能

3. **nodes** - 配对节点控制
   - 列表/描述/配对/通知
   - 相机/照片/屏幕/位置
   - 设备状态和权限管理

4. **cron** - 定时任务和提醒
   - 支持 at/every/cron 调度
   - 支持 systemEvent 和 agentTurn payload
   - 醒来事件（wake events）

#### 技能（Skills）机制

**技能定义**: SKILL.md 文件
- 包含技能描述、使用指南、参数说明
- 自动注入到 Agent prompts
- 支持版本管理和回滚

**技能类型**:
1. **AgentSkills**: 社区贡献的技能包
2. **Workspace Skills**: 工作区本地技能
3. **Plugin Skills**: 插件提供的技能

### 3. GitHub 开源项目

**OpenClaw 核心仓库**:
- **主仓库**: https://github.com/openclaw/openclaw
- **Star**: 12k+ ⭐
- **License**: MIT
- **核心特性**:
  - Local-first Gateway
  - Multi-channel inbox（20+ 平台）
  - Multi-agent routing
  - Voice Wake + Talk Mode
  - Live Canvas + A2UI
  - Companion apps（macOS/iOS/Android）

---

## 能力转换

### 1. 创建 Tavily Search 技能（✅ 已完成）

**文件**: `/home/node/.openclaw/workspace/skills/openclaw-tavily-search/`

**核心功能**:
- AI 优化搜索
- 答案摘要（可选）
- 搜索深度可调（basic/advanced）
- 多种输出格式（raw/brave/md）

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
```

**集成 Agents**:
- **research-agent**: 使用 Tavily Search 进行资料收集
- **content-agent**: 使用 Tavily Search 查找最新信息

### 2. 优化统一搜索接口（✅ 已完成）

**文件**: `/home/node/.openclaw/workspace/scripts/search.sh`

**优先级**:
1. **Brave Search** (OpenClaw 内置 web_search tool)
2. **Tavily Search** (需要 TAVILY_API_KEY)
3. **Metaso 搜索** (降级方案)

**使用方法**:
```bash
# 统一搜索接口
bash /home/node/.openclaw/workspace/scripts/search.sh "OpenClaw Agent" 5
```

### 3. 更新 TOOLS.md（✅ 已完成）

**新增内容**:
- ClawHub 技能商店介绍
- Tavily Search 集成
- 统一搜索接口
- 翻译工具（translate）
- 小红书系列生成器（xhs-series）

### 4. 创建 Agent 优化检查器（✅ 已完成）

**文件**: `/home/node/.openclaw/workspace/skills/agent-optimizer/`

**功能**:
- 扫描所有 6 个 Agent
- 检查是否需要更新优化
- 生成详细的优化建议
- 通过飞书发送报告

**使用方法**:
```bash
bash /home/node/.openclaw/workspace/skills/agent-optimizer/scripts/check.sh
```

---

## 立即应用新技能

### Step 5: 立即应用

#### 1. 更新 AGENTS.md

**新增内容**:
- **搜索增强**: Brave Search + Tavily Search + Metaso 搜索
- **翻译能力**: research-agent 和 content-agent 支持翻译
- **小红书系列生成**: visual-agent 支持 xhs-series

**更新位置**: `AGENTS.md` v3.2

#### 2. 更新 TOOLS.md

**新增内容**:
- **ClawHub 技能商店**: 3000+ 技能，高价值技能推荐
- **Tavily Search**: AI 优化搜索，Brave 替代方案
- **统一搜索接口**: 自动降级方案
- **翻译工具**: 三模式翻译系统
- **小红书系列生成器**: Style × Layout 二维系统

**更新位置**: `TOOLS.md` v3.2

#### 3. 优化 research-agent

**新增能力**:
- ✅ 支持 Tavily Search（AI 优化搜索）
- ✅ 支持翻译外文资料
- ✅ 多源搜索（Brave + Tavily + Metaso）

**文件**: `/home/node/.openclaw/workspace/agents/research-agent/`

#### 4. 优化 content-agent

**新增能力**:
- ✅ 支持翻译外文资料
- ✅ 多语言内容生产

**文件**: `/home/node/.openclaw/workspace/agents/content-agent/`

---

## 待办事项

### 高优先级（本周完成）

- [ ] ClawHub 服务恢复后，安装以下技能：
  - [ ] `summarize` - 内容总结工具
  - [ ] `find-skills` - 技能发现工具
  - [ ] `github` - GitHub CLI 交互

- [ ] 测试新技能并更新文档

- [ ] 创建 skill-vetter 技能审核流程

### 中优先级（下周完成）

- [ ] 安装并学习 `ontology` - 知识图谱技能
- [ ] 安装并学习 `gog` - Google Workspace CLI
- [ ] 创建技能评分系统

### 低优先级（未来探索）

- [ ] 探索更多社区技能
- [ ] 贡献自己的技能到 ClawHub

---

## 学习总结

### 核心收获

1. **ClawHub 是核心**: 3000+ 技能，但需要筛选
2. **First-Class Tools**: OpenClaw 内置工具替代旧 skills
3. **统一搜索接口**: 自动降级，提高可靠性
4. **翻译能力**: 多语言支持，全球化视野

### 能力提升

- ✅ **搜索能力**: 从单一 Brave Search → 三层降级（Brave + Tavily + Metaso）
- ✅ **翻译能力**: 新增三模式翻译系统（quick/normal/refined）
- ✅ **视觉生成**: 新增小红书系列生成器（88种组合）
- ✅ **Agent 优化**: 新增优化检查器，持续改进

### 下一步行动

1. ⏳ 等待 ClawHub 服务恢复
2. 📦 安装高价值技能（summarize、find-skills、github）
3. 🧪 测试新技能并应用到 Agents
4. 📝 更新文档和 AGENTS.md

---

## 参考资料

- **ClawHub**: https://clawhub.com
- **OpenClaw 文档**: https://docs.openclaw.ai
- **OpenClaw GitHub**: https://github.com/openclaw/openclaw
- **Tavily API**: https://tavily.com

---

**学习者**: Main Agent
**学习时间**: 2026-03-12 21:30 - 23:00 (Asia/Shanghai)
**学习版本**: v1.0
