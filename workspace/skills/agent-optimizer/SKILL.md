# Agent 优化检查器

## 职责

当学习到新技能时，自动检查现有 Agent 是否需要更新优化，生成详细的优化建议，等待用户确认后自动应用。

## 核心原则

**学习 → 检查 → 建议 → 确认 → 应用**

## 工作流程

### Step 1: 学习新技能
- 在定向学习中学习到新技能
- 理解核心功能和优势
- 提取关键模式

### Step 2: Agent 检查
扫描所有现有 Agent，检查：
1. **功能重叠** - 新技能是否与现有 Agent 功能重叠
2. **性能提升** - 新技能是否能提升现有 Agent 性能
3. **架构改进** - 新技能是否能改进 Agent 架构
4. **错误修复** - 新技能是否能修复现有问题
5. **能力扩展** - 新技能是否能扩展 Agent 能力

### Step 3: 生成优化建议
为每个需要优化的 Agent 生成：

```markdown
# Agent 优化建议 - [Agent 名称]

## 发现的问题
- 问题描述

## 优化方案
- 具体改进方案

## 预期效果
- 性能提升：...
- 功能改进：...
- 架构优化：...

## 实施步骤
1. ...
2. ...
3. ...

## 风险评估
- 风险：...
- 缓解措施：...

## 需要修改的文件
- 文件路径
- 修改内容
```

### Step 4: 发送给用户确认
通过飞书发送优化建议，包含：
- 优化概述
- 详细建议
- 预期效果
- 风险评估
- 确认按钮

### Step 5: 应用优化
用户确认后，自动应用优化：
1. 备份当前版本
2. 应用修改
3. 运行测试
4. 验证效果
5. 更新文档

## 检查维度

### 1. 功能性检查
- 新技能是否提供更好的实现方式？
- 现有功能是否有 bug 或限制？
- 是否有缺失的功能？

### 2. 性能检查
- 新技能是否更高效？
- 是否能减少资源消耗？
- 是否能提升响应速度？

### 3. 架构检查
- 新技能是否符合架构原则？
- 是否能提高可维护性？
- 是否能提高可扩展性？

### 4. 兼容性检查
- 新技能是否与现有系统兼容？
- 是否需要更新依赖？
- 是否影响其他 Agent？

### 5. 安全性检查
- 新技能是否引入安全风险？
- 是否需要更新权限？
- 是否需要更新配置？

## 输出格式

### 优化建议报告

```markdown
# Agent 优化检查报告

## 检查时间
YYYY-MM-DD HH:MM:SS

## 学习的新技能
- 技能名称：...
- 技能来源：...
- 核心功能：...

## 检查的 Agent
- requirement-agent
- research-agent
- content-agent
- visual-agent
- video-agent
- quality-agent

## 需要优化的 Agent

### [Agent 1]
[详细优化建议]

### [Agent 2]
[详细优化建议]

## 无需优化的 Agent
- xxx-agent: 原因：...

## 总结
- 需要优化：X 个
- 无需优化：Y 个
- 总计：Z 个

## 下一步
请确认是否需要应用优化建议。
```

## 使用方式

### 在定向学习中调用

```bash
# 学习到新技能后，自动触发
agent-optimizer-check \
  --skill "新技能名称" \
  --source "学习来源" \
  --description "技能描述"
```

### 手动触发

```bash
# 检查所有 Agent
bash /home/node/.openclaw/workspace/skills/agent-optimizer/scripts/check.sh

# 检查特定 Agent
bash /home/node/.openclaw/workspace/skills/agent-optimizer/scripts/check.sh --agent research-agent
```

## 文件结构

```
workspace/skills/agent-optimizer/
├── SKILL.md                           # 本文件
├── scripts/
│   ├── check.sh                       # 主检查脚本
│   ├── generate-suggestions.sh        # 生成优化建议
│   ├── apply-optimizations.sh         # 应用优化
│   └── test-optimizations.sh          # 测试优化
├── templates/
│   └── optimization-suggestion.md     # 优化建议模板
└── reports/
    └── optimization-YYYYMMDD.md       # 优化报告
```

## 集成到定向学习

在定向学习任务的"能力转换"步骤中，自动调用优化检查器：

```bash
# 学习到新技能后
if [ 新技能 ]; then
    bash /home/node/.openclaw/workspace/skills/agent-optimizer/scripts/check.sh \
        --skill "$新技能名称" \
        --source "$学习来源"
fi
```

## 维护者

Main Agent
