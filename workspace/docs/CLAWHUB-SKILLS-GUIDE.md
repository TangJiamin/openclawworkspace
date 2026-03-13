# ClawHub 技能生态指南

**版本**: v1.0
**更新时间**: 2026-03-10

---

## 📋 快速开始

### ClawHub 是什么？

ClawHub 是 OpenClaw 智能体（AI Agent）生态的官方公共技能注册表 / 技能商店。

**核心数据**:
- 📦 收录技能：3000+ 款
- 📈 时效性：2026年持续更新
- 🔒 安全性：举报、审核机制，SKILL.md 定义公开审查
- 🛠️ CLI 工具：`npx clawhub` 一键安装、更新、卸载

---

## 🚀 基本使用

### 1. 安装 ClawHub CLI

```bash
npm install -g clawhub
```

### 2. 搜索技能

```bash
# 搜索技能
npx clawhub search "calendar"
npx clawhub search "微信"
npx clawhub search "github"
```

### 3. 安装技能

```bash
# 安装单个技能
npx clawhub install github

# 批量安装
npx clawhub install notion wechat-notify tavily-search
```

### 4. 更新技能

```bash
# 更新所有技能
npx clawhub update --all

# 查看可更新技能
npx clawhub check-update

# 更新单个技能
npx clawhub update github
```

### 5. 卸载技能

```bash
# 卸载单个技能
npx clawhub uninstall github

# 批量卸载
npx clawhub uninstall notion wechat-notify
```

---

## 🌟 高价值技能推荐（2026年3月）

### TOP 8 必装技能

| 技能名称 | 描述 | 适用场景 |
|---------|------|---------|
| **agent-browser** | 网页自动化交互 | 爬虫、UI测试、数据采集 |
| **tavily-search** | AI 优化搜索 | 网络搜索、信息检索 |
| **github** | GitHub CLI 交互 | PR管理、Issue跟踪 |
| **notion** | Notion 知识管理 | 文档管理、知识库 |
| **email-summarizer** | 邮件总结 | 邮件处理、信息提取 |
| **openclaw-credential-manager** | 安全管理 | API Key管理、权限控制 |
| **openclaw-cost-optimizer** | 成本优化 | API调用优化、费用控制 |
| **openclaw-context-optimizer** | 上下文优化 | Token优化、性能提升 |

### 技能分类

**开发类**:
- `github` - GitHub CLI
- `git` - Git 操作
- `docker` - Docker 管理
- `kubernetes` - K8s 管理

**办公类**:
- `notion` - Notion 知识管理
- `wechat-notify` - 微信通知
- `email-summarizer` - 邮件总结
- `calendar` - 日程管理

**多模态类**:
- `fal-ai` - 图像生成
- `replicate` - 模型推理
- ` Stability AI` - 稳定扩散

**API 集成**:
- `slack` - Slack 集成
- `discord` - Discord 集成
- `telegram` - Telegram 集成

---

## 📊 技能评估标准

### 质量维度

**⭐ 质量**:
- 星级评分（4星+优先）
- 评论质量（正面评价占比）
- 维护活跃度（最近更新时间）

**🔒 安全性**:
- SKILL.md 定义公开
- 审核机制通过
- 代码审计通过

**📈 实用性**:
- 下载量（1000+优先）
- 更新频率（持续维护）
- 文档完整性

**🛠️ 兼容性**:
- 与当前 OpenClaw 版本兼容
- 依赖项清晰
- 无已知安全漏洞

### 评估流程

```bash
# 1. 查看技能详情
npx clawhub info <skill-name>

# 2. 阅读 SKILL.md
cat ~/.openclaw/skills/<skill-name>/SKILL.md

# 3. 查看评分和评论
# 访问 https://clawhub.ai/skills/<skill-name>

# 4. 测试安装
npx clawhub install <skill-name> --dry-run
```

---

## ⚠️ 使用注意事项

### 1. 质量筛选

**问题**: 3000+ 技能中，90% 实用性较低

**解决方案**:
- ✅ 优先安装高价值技能（TOP 8）
- ✅ 查看评分和评论（4星+优先）
- ✅ 测试后再批量安装

### 2. 性能优化

**问题**: 安装过多技能导致服务卡顿

**解决方案**:
- ✅ 优先安装高频实用技能
- ✅ 定期卸载不常用技能
- ✅ 监控服务性能

```bash
# 监控服务状态
systemctl status openclaw

# 查看已安装技能
npx clawhub list

# 卸载不常用技能
npx clawhub uninstall <skill-name>
```

### 3. 安全管理

**问题**: 技能访问敏感目录

**解决方案**:
- ✅ 限制技能访问路径
- ✅ 审查 SKILL.md 定义
- ✅ 定期审计权限

```bash
# 限制访问路径
openclaw config set fs.allow-path "/home/node/.openclaw/workspace"

# 查看技能权限
npx clawhub audit <skill-name>
```

### 4. 定期维护

**推荐频率**: 每周一次

```bash
# 更新 OpenClaw
npm update -g openclaw

# 更新所有技能
npx clawhub update --all

# 检查可更新技能
npx clawhub check-update

# 备份技能配置
npx clawhub backup --path ~/.openclaw/skills-backup
```

---

## 🔧 高级功能

### 1. 技能开发

```bash
# 创建自定义技能
npx clawhub init my-custom-skill

# 发布技能
npx clawhub publish ./my-custom-skill

# 版本管理
npx clawhub version bump patch
npx clawhub version bump minor
npx clawhub version bump major
```

### 2. 技能备份与恢复

```bash
# 备份所有技能
npx clawhub backup --path ~/.openclaw/skills-backup

# 从备份恢复
npx clawhub restore --path ~/.openclaw/skills-backup

# 导出技能列表
npx clawhub export > skills-list.txt
```

### 3. 批量管理

```bash
# 批量更新
npx clawhub update --all

# 批量卸载
npx clawhub uninstall skill1 skill2 skill3

# 批量安装（从文件）
npx clawhub install --file skills-list.txt
```

---

## 🌐 访问方式

### 1. 官方网站

**直接访问**: https://clawhub.ai

**Jina Reader**（推荐）:
```bash
curl -s "https://r.jina.ai/https://clawhub.com"
```

### 2. CLI 工具

```bash
# 搜索技能
npx clawhub search "<query>"

# 查看技能详情
npx clawhub info <skill-name>

# 列出所有技能
npx clawhub list
```

### 3. Metaso 搜索

```bash
# 搜索最新资讯
bash /home/node/.openclaw/workspace/skills/metaso-search/scripts/metaso_search.sh "ClawHub 2026 最新"
```

---

## 📚 学习资源

- **官方文档**: https://docs.openclaw.ai
- **ClawHub 网站**: https://clawhub.ai
- **GitHub**: https://github.com/openclaw/clawhub
- **社区**: https://discord.com/invite/clawd

---

## 💡 最佳实践

### 1. 技能选择原则

- ✅ **高频优先**: 优先安装高频使用技能
- ✅ **质量优先**: 选择4星以上、有良好维护的技能
- ✅ **安全优先**: 审查 SKILL.md，确认权限合理
- ❌ **避免贪多**: 不要一次性安装过多技能

### 2. 技能测试流程

```bash
# 1. 安装测试
npx clawhub install <skill-name> --dry-run

# 2. 查看定义
cat ~/.openclaw/skills/<skill-name>/SKILL.md

# 3. 正式安装
npx clawhub install <skill-name>

# 4. 功能测试
# 测试技能功能是否正常

# 5. 性能监控
systemctl status openclaw
```

### 3. 技能维护策略

**每周**:
- 更新所有技能
- 检查可更新技能
- 备份技能配置

**每月**:
- 卸载不常用技能
- 审查技能权限
- 评估技能质量

**每季度**:
- 重新评估技能需求
- 寻找更好的替代技能
- 更新技能组合

---

## 🎯 快速参考

### 常用命令

```bash
# 搜索
npx clawhub search "<query>"

# 安装
npx clawhub install <skill-name>

# 更新
npx clawhub update --all

# 卸载
npx clawhub uninstall <skill-name>

# 列表
npx clawhub list

# 详情
npx clawhub info <skill-name>
```

### 故障排除

**问题1**: npm 网络连接失败
```bash
# 解决方案：使用国内镜像
npm config set registry https://registry.npmmirror.com
```

**问题2**: ClawHub 网站无法访问
```bash
# 解决方案：使用 Jina Reader
curl -s "https://r.jina.ai/https://clawhub.com"
```

**问题3**: 技能安装失败
```bash
# 解决方案：查看详细日志
npx clawhub install <skill-name> --verbose
```

---

**维护者**: Main Agent
**更新时间**: 2026-03-10 21:30 UTC
**版本**: 1.0
