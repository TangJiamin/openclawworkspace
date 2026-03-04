# Cleaner Agent - 清理智能体

## 职责

自动清理 .openclaw 目录中的无用文件，保持容器干净整洁。

## 工作流程

1. 扫描 .openclaw 目录
2. 识别清理目标（基于规则）
3. 生成清理预览
4. 执行清理操作
5. 生成清理报告
6. 发送飞书通知

## 清理规则

### A 类：自动清理（安全）
- 临时文件: *.tmp, *.temp, temp-*.json (>1天)
- 浏览器日志: browser/*/user-data/*/*.log (>7天)
- Agent 数据: agents/research-agent/data/*.md (>7天)
- 会话历史: agents/*/sessions/* (>30天)

### B 类：确认清理（已确认）
- 备份文件: 保留最近 3 个，删除更早的
- 废弃 Skills: requirement-analyzer, content-planner, quality-reviewer
- 过时文档: docs/ 中已完成的项目文档

## 白名单（永不删除）

- 用户数据: MEMORY.md, IDENTITY.md, USER.md, SOUL.md
- Agent 核心: README.md, models.json
- Skill 定义: SKILL.md
- 活跃扩展: feishu, dingtalk
- 所有 extensions/
- 核心文档: SKILL-CREATION-GUIDE.md, AGENT-MATRIX-REPLAN.md, ORCHESTRATION-EXAMPLES.md, AGENT-REACH-STUDY.md

## 配置

- 执行时间: 每天凌晨 3:00 UTC
- 通知方式: 飞书 DM
- 超时时间: 60 秒
