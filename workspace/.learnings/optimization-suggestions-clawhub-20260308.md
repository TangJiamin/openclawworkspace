# ClawHub 技能学习 - Agent 优化建议

## 学习时间
2026-03-08 21:45

## 学习的新技能

### 1. Tavily Web Search
- **来源**: ClawHub
- **核心功能**: AI 优化搜索 API，返回简洁、相关的结果
- **优势**: 专为 AI Agent 设计，结果更直接，减少处理时间

### 2. Summarize
- **来源**: ClawHub
- **核心功能**: 多格式总结（Web、PDF、图片、音频、YouTube）
- **优势**: 统一接口处理多种格式

### 3. Find Skills
- **来源**: ClawHub
- **核心功能**: 自动发现和安装 Agent 技能
- **优势**: 理解自然语言查询，持续发现新技能

---

## Agent 优化建议

### 🎯 research-agent 优化（高优先级）

#### 发现的问题
1. **搜索工具单一**: 当前仅使用 metaso-search
2. **格式限制**: 无法总结 YouTube 视频、PDF 等格式
3. **处理时间**: metaso-search 需要调用外部脚本，结果需要格式化

#### 优化方案

##### 优化1: 集成 Tavily Search（性能提升）

**实施方案**:
1. 安装 tavily-search
2. 配置 Tavily API Key
3. 在 research-agent/AGENTS.md 中添加搜索工具选择逻辑
4. 对比测试（tavily vs metaso）

**代码示例**:
```bash
# research-agent/AGENTS.md
## 搜索工具选择

### Tavily Search（首选）
- 优势: AI 优化，结果简洁，速度快
- 使用: bash /home/node/.openclaw/workspace/skills/tavily-search/scripts/search.sh

### Metaso Search（备选）
- 优势: 中文优化，免费使用
- 使用: bash /home/node/.openclaw/workspace/skills/metaso-search/scripts/metaso_search.sh

### 选择策略
- 默认使用 Tavily Search
- 如果遇到 Rate Limit 或失败，降级到 Metaso Search
```

**预期效果**:
- 搜索速度提升 30-50%
- 结果质量更稳定
- 减少结果处理时间

**风险评估**:
- 风险: Tavily 可能有 API 配额限制
- 缓解: 保留 metaso-search 作为备选

##### 优化2: 集成 Summarize（能力扩展）

**实施方案**:
1. 安装 summarize
2. 在 research-agent/AGENTS.md 中添加多格式总结能力
3. 添加 YouTube 视频总结工作流
4. 添加 PDF 研究报告总结工作流

**代码示例**:
```bash
# research-agent/AGENTS.md
## 多格式总结

### YouTube 视频总结
summarize-youtube() {
    bash /home/node/.openclaw/workspace/skills/summarize/scripts/summarize.sh --youtube "$1"
}

### PDF 总结
summarize-pdf() {
    bash /home/node/.openclaw/workspace/skills/summarize/scripts/summarize.sh --pdf "$1"
}

### 长文章总结
summarize-article() {
    bash /home/node/.openclaw/workspace/skills/summarize/scripts/summarize.sh --url "$1"
}
```

**预期效果**:
- 可以总结 YouTube 视频（AI 行业动态）
- 可以总结 PDF 研究报告
- 资料收集能力大幅提升

**应用场景**:
- 收集 YouTube 上的 AI 教程和演讲
- 总结 GitHub 项目的 PDF 文档
- 快速理解长篇技术文章

---

### ✍️ content-agent 优化（中优先级）

#### 发现的问题
1. **参考资料理解**: 当前依赖 Agent 自己理解，没有总结辅助
2. **多格式支持**: 无法直接总结 PDF、YouTube 等格式

#### 优化方案

##### 集成 Summarize（参考资料理解）

**实施方案**:
1. 在 content-agent/AGENTS.md 中添加 summarize 工具
2. 在生成文案前，先用 summarize 理解参考资料

**代码示例**:
```bash
# content-agent/AGENTS.md
## 参考资料理解

### 使用 Summarize 理解参考资料
when_receiving_references() {
    # 如果参考资料是长文章、PDF、YouTube
    # 先用 summarize 生成摘要
    summary=$(bash /home/node/.openclaw/workspace/skills/summarize/scripts/summarize.sh --url "$reference_url")
    # 基于摘要生成文案
}
```

**预期效果**:
- 参考资料理解速度提升
- 文案生成更准确
- 支持更多格式

---

### 🤖 Main Agent 优化（中优先级）

#### 发现的问题
1. **技能发现困难**: 用户询问功能时，无法自动发现相关技能
2. **被动学习**: 需要手动访问 ClawHub 发现新技能

#### 优化方案

##### 集成 Find Skills（自动发现）

**实施方案**:
1. 安装 find-skills
2. 在 Main Agent/AGENTS.md 中添加技能发现逻辑
3. 当用户询问功能时，自动搜索相关技能

**代码示例**:
```bash
# Main Agent/AGENTS.md
## 技能自动发现

### 触发条件
- 用户询问"能否做 X"
- 用户询问"怎么做 X"
- 用户询问"有技能能做 X 吗"
- 发现现有能力不足时

### 自动发现流程
find_skill_for_task() {
    local task="$1"
    bash /home/node/.openclaw/workspace/skills/find-skills/scripts/find.sh "$task"
}
```

**预期效果**:
- 自动发现相关技能
- 减少手动搜索成本
- 持续学习新技能

**应用场景**:
- 用户: "能否总结 PDF?" → 自动发现 summarize skill
- 用户: "能否搜索 GitHub?" → 自动发现 github skill
- 用户: "能否优化搜索?" → 自动发现 tavily-search

---

### ✅ 其他 Agent（无需优化）

#### requirement-agent
- **评估**: 无需优化
- **原因**: 需求理解不涉及搜索或总结功能

#### visual-agent
- **评估**: 无需优化
- **原因**: 视觉生成不涉及搜索功能

#### video-agent
- **评估**: 无需优化
- **原因**: 视频生成不涉及搜索功能

#### quality-agent
- **评估**: 无需优化
- **原因**: 质量审核不涉及搜索功能

---

## 实施计划

### Phase 1: 安装和测试（今天）⏰

- [ ] 安装 tavily-search
- [ ] 安装 summarize
- [ ] 安装 find-skills
- [ ] 配置 API Keys（如果需要）
- [ ] 基本功能测试

### Phase 2: 集成 research-agent（明天）⏰

- [ ] 更新 research-agent/AGENTS.md
- [ ] 添加 Tavily Search 工具
- [ ] 添加 Summarize 工具
- [ ] 对比测试（tavily vs metaso）
- [ ] YouTube 总结测试
- [ ] PDF 总结测试

### Phase 3: 集成其他 Agents（后天）⏰

- [ ] 更新 content-agent/AGENTS.md
- [ ] 更新 Main Agent/AGENTS.md
- [ ] 集成测试
- [ ] 性能对比

### Phase 4: 文档更新（本周）⏰

- [ ] 更新 MEMORY.md（记录新技能）
- [ ] 更新 AGENTS.md（使用说明）
- [ ] 更新 TOOLS.md（工具列表）

---

## 优先级总结

### 🔥 高优先级（立即实施）
1. **research-agent + Tavily Search** - 搜索性能提升
2. **research-agent + Summarize** - 多格式总结

### ⭐ 中优先级（近期实施）
3. **content-agent + Summarize** - 参考资料理解
4. **Main Agent + Find Skills** - 自动发现

### ✅ 低优先级（按需实施）
5. 其他 Agent - 根据实际需求

---

## 预期效果

### 性能提升
- **research-agent 搜索速度**: 30-50% 提升
- **资料收集效率**: 2-3 倍提升（支持更多格式）
- **技能发现成本**: 降低 80%（自动发现）

### 能力扩展
- ✅ 支持 YouTube 视频总结
- ✅ 支持 PDF 研究报告总结
- ✅ 支持多种搜索工具（自动选择）
- ✅ 自动发现新技能

### 架构优化
- ✅ 搜索工具降级机制（Tavily → Metaso）
- ✅ 多格式统一接口（Summarize）
- ✅ 持续学习机制（Find Skills）

---

## 风险评估

### Tavily Search
- **风险**: API 配额限制、Rate Limit
- **缓解**: 保留 Metaso Search 作为备选

### Summarize
- **风险**: 可能需要 API Key、处理时间较长
- **缓解**: 仅在需要时使用，保留直接阅读能力

### Find Skills
- **风险**: 可能误判用户意图
- **缓解**: 人工确认后安装

---

## 下一步

**请用户确认**:
1. 是否同意上述优化建议？
2. 是否立即开始 Phase 1（安装和测试）？
3. 是否需要调整优先级？

**确认后**:
- 自动执行 Phase 1（安装技能）
- 测试基本功能
- 发送测试报告

---

**维护者**: Main Agent
**生成时间**: 2026-03-08 21:45
**版本**: 1.0
