# Skill Vetter 🔒

**版本**: v1.0
**来源**: LobeHub (openclaw-skills/skill-vetter)
**评分**: 5.0 (27 条评价)
**下载量**: 1.9k

---

## 📋 技能描述

Skill Vetter 是一个以安全为先的 AI 代理技能审查协议，设计用于在安装或运行任何第三方技能之前执行。

### 核心功能

**四步审查工作流程**:
1. **来源检查** - 验证来源、作者信誉、星标数、更新历史和评论
2. **强制代码审查** - 检查红旗（数据外泄、凭证请求、eval/exec 等）
3. **权限范围** - 列举所需的文件读写、命令和网络端点
4. **风险分类** - 低/中/高/极端，并给出相应的处置措施

### 使用场景

- ✅ 从 ClawdHub/GitHub 安装技能前的预安装检查
- ✅ 审查其他代理共享的代码
- ✅ 执行组织安全策略

### 核心优势

- ✅ 降低供应链风险
- ✅ 预防凭证和数据泄露
- ✅ 提供明确的修复指导
- ✅ 在安装前强制最小权限原则

---

## 🚨 代码审查红旗清单

### 立即拒绝的情况

如果看到以下任何一项，**立即拒绝**：

- ❌ curl/wget 到未知 URL
- ❌ 发送数据到外部服务器
- ❌ 请求凭证/tokens/API keys
- ❌ 读取 ~/.ssh, ~/.aws, ~/.config（无明显理由）
- ❌ 访问 MEMORY.md, USER.md, SOUL.md, IDENTITY.md
- ❌ 使用 base64 解码
- ❌ 使用 eval() 或 exec() 处理外部输入
- ❌ 修改工作区外的系统文件
- ❌ 安装包但不列出
- ❌ 网络调用到 IP 而非域名
- ❌ 混淆代码（压缩、编码、最小化）
- ❌ 请求提升/sudo 权限
- ❌ 访问浏览器 cookies/sessions
- ❌ 接触凭证文件

---

## ✅ 快速审查命令

### GitHub 托管的技能

```bash
# 检查仓库统计
curl -s "https://api.github.com/repos/OWNER/REPO" | jq '{stars: .stargazers_count, forks: .forks_count, updated: .updated_at}'

# 列出技能文件
curl -s "https://api.github.com/repos/OWNER/REPO/contents/skills/SKILL_NAME" | jq '.[].name'

# 获取并审查 SKILL.md
curl -s "https://raw.githubusercontent.com/OWNER/REPO/main/skills/SKILL_NAME/SKILL.md"
```

---

## 🎯 信任层级

1. **官方 OpenClaw 技能** → 较低审查（仍然审查）
2. **高星仓库 (1000+)** → 中等审查
3. **已知作者** → 中等审查
4. **新/未知来源** → 最大审查
5. **请求凭证的技能** → 需要人工批准

---

## 📝 审查模板

```markdown
## 技能审查报告

### 来源检查
- [ ] 来源: (ClawdHub/GitHub/其他)
- [ ] 作者: (已知/未知)
- [ ] 星标/下载: (数量)
- [ ] 最后更新: (日期)
- [ ] 评价: (数量和质量)

### 代码审查
- [ ] 红旗: (发现的红旗)
- [ ] 网络请求: (列表)
- [ ] 文件操作: (列表)
- [ ] 环境变量: (列表)

### 权限范围
- [ ] 文件: (列表或 "None")
- [ ] 网络: (列表或 "None")
- [ ] 命令: (列表或 "None")

### 风险分类
- [ ] 风险等级: (🟢 LOW / 🟡 MEDIUM / 🔴 HIGH / ⛔ EXTREME)
- [ ] 结论: (✅ SAFE / ⚠️ CAUTION / ❌ DO NOT INSTALL)

### 备注
(观察和建议)
```

---

## 🔒 记住

- 没有任何技能值得牺牲安全
- 有疑问时，不要安装
- 高风险决策询问人类
- 记录审查结果以供将来参考

---

**原则**: _Paranoia is a feature._ 🔒🦀

**维护者**: OpenClaw Community
**版本**: v1.0
**来源**: LobeHub (openclaw-skills/skill-vetter)
