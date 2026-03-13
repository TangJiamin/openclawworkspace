# Baoyu Skills 安装指南

**创建时间**: 2026-03-11 09:00
**目的**: 正确安装 Baoyu Skills 的完整指南

---

## 🔍 问题诊断

### 当前状态

**符号链接已创建，但目标不存在**:
```
lrwxrwxrwx 1 node node   36 /home/node/.openclaw/skills/baoyu-translate -> ../../.agents/skills/baoyu-translate
```

**问题**:
- 符号链接指向 `../../.agents/skills/baoyu-translate`
- 但 `/home/node/.openclaw/.agents/skills/` 目录不存在
- MCP Server (mcporter) 未安装

**结论**: Baoyu Skills **未正确安装**

---

## 📦 正确的安装方式

### 方法 1: 通过 xskill.ai One-Click Deploy (推荐)

**步骤**:

1. **登录 xskill.ai**
   - 访问: https://xskill.ai
   - 创建账号或登录

2. **获取安装命令**
   - 点击 "One-Click Deploy"
   - 复制安装命令

3. **执行安装命令**
   ```bash
   # 示例（实际命令请从 xskill.ai 获取）
   npx @xskill/install
   ```

4. **验证安装**
   ```bash
   # 检查 mcporter
   which mcporter

   # 检查技能
   mcporter list-skills
   ```

---

### 方法 2: 手动安装 MCP Server

**步骤**:

1. **安装 MCP Server**
   ```bash
   # 从 GitHub 安装
   npm install -g https://github.com/JimLiu/baoyu-skills

   # 或使用 npm 包（如果存在）
   npm install -g @baoyu/mcp-server
   ```

2. **配置 MCP Server**
   ```bash
   # 初始化配置
   mcporter init

   # 配置 API Keys
   mcporter config set xskill_api_key YOUR_API_KEY
   ```

3. **安装技能**
   ```bash
   # 安装所有 Baoyu 技能
   mcporter install baoyu-translate
   mcporter install baoyu-post-to-x
   mcporter install baoyu-infographic
   mcporter install baoyu-xhs-images
   # ... 等等
   ```

---

### 方法 3: 使用 skills CLI (备选)

**步骤**:

1. **安装 skills CLI**
   ```bash
   npm install -g skills
   ```

2. **安装 Baoyu Skills**
   ```bash
   # 从 GitHub 仓库安装
   skills add jimliu/baoyu-skills
   ```

3. **验证安装**
   ```bash
   skills list
   ```

---

## 🚨 100/3 法则检查

**100/3 法则**:
- ⚠️ Baoyu Skills **不在 npm 仓库中**
- ⚠️ 无法直接验证下载量和发布时间
- ⚠️ 需要通过 xskill.ai 平台安装

**安全检查**:
- ✅ 来源: GitHub 官方仓库 (JimLiu/baoyu-skills)
- ✅ Star 数量: 8.1k ⭐ (高人气)
- ✅ 作者: 知名开发者
- ⚠️ 需要 xskill.ai API Key

**建议**:
1. 使用 **方法 1** (One-Click Deploy) - 最安全
2. 或使用 **方法 2** (手动安装 MCP Server)
3. 避免使用未经验证的第三方安装方式

---

## 📋 安装后验证

### 检查清单

- [ ] `mcporter` 命令可用
- [ ] `mcporter list-skills` 显示 Baoyu Skills
- [ ] `/baoyu-translate` 命令可用
- [ ] `/baoyu-post-to-x` 命令可用
- [ ] `/baoyu-infographic` 命令可用
- [ ] `/baoyu-xhs-images` 命令可用

### 测试命令

```bash
# 测试翻译
/baoyu-translate --help

# 测试发布（需要配置 X 账号）
/baoyu-post-to-x --help

# 测试信息图
/baoyu-infographic --help

# 测试小红书图文
/baoyu-xhs-images --help
```

---

## 🔄 备选方案

### 如果无法安装 Baoyu Skills

#### 方案 1: 使用现有工具

**翻译**:
- 使用 Google Translate API
- 使用 DeepL API
- 使用 OpenAI API

**发布**:
- 手动发布（复制粘贴）
- 使用平台官方 API

**信息图**:
- 使用 visual-generator
- 使用 Canva API
- 手动创建

#### 方案 2: 等待 ClawHub 官方技能

- ClawHub 可能会发布官方技能
- 经过安全审查
- 符合 100/3 法则

---

## 🎯 下一步行动

### 建议 1: 联系用户

**需要用户提供**:
1. xskill.ai 账号（或创建新账号）
2. One-Click Deploy 命令
3. API Key（如果需要）

### 建议 2: 更新测试报告

**更新测试报告**:
1. 标注 Baoyu Skills 安装问题
2. 提供备选方案
3. 等待用户决策

### 建议 3: 先测试现有能力

**测试现有 Agents**:
1. requirement-agent - ✅ 完全可用
2. research-agent - ✅ metaso-search 可用
3. content-agent - ✅ AI 生成可用
4. visual-agent - ✅ visual-generator 可用
5. video-agent - ✅ Seedance 可用
6. quality-agent - ✅ 完全可用

**缺失能力**:
- ❌ 翻译（可备选方案）
- ❌ 自动发布（可手动发布）
- ❌ 信息图（可用 visual-generator）
- ❌ 小红书图文系列（可用 visual-generator）

---

## 📝 总结

**核心问题**:
- Baoyu Skills **未正确安装**
- 符号链接损坏
- MCP Server 未安装

**解决方案**:
- ✅ **最佳**: 通过 xskill.ai One-Click Deploy
- ✅ **备选**: 手动安装 MCP Server
- ⏰ **临时**: 使用现有工具 + 手动操作

**优先级**:
1. 🔴 联系用户获取 xskill.ai 安装命令
2. 🔴 安装 MCP Server 和 Baoyu Skills
3. 🟡 验证所有功能
4. 🟢 更新测试报告

---

**创建者**: Main Agent
**日期**: 2026-03-11 09:00
**状态**: 等待用户决策
