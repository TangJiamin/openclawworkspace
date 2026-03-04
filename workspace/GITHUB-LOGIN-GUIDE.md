# GitHub 登录指南

**时间**: 2026-03-04 02:48 UTC

---

## 🔐 GitHub 登录方式

### 方式1: 个人访问令牌（推荐）

**优点**: 完整功能，可以搜索仓库、查看代码、提 Issue

**步骤**:

1. **创建 Token**:
   - 浏览器登录 GitHub
   - 点击头像 → Settings
   - Developer settings → Personal access tokens → Tokens (classic)
   - Generate new token (classic)
   - 勾选 `repo` 权限
   - 生成并复制 token

2. **配置 Token**:
   ```bash
   export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   ```

3. **使用**:
   ```bash
   # 使用 curl + GitHub API
   curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/openai/openai-python"
   
   # 或使用环境变量
   curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/search/repositories?q=LLM&per_page=10"
   ```

---

### 方式2: Jina Reader（无需配置）

**优点**: 无需 token，立即可用

**缺点**: 只能读取公开信息

**使用**:
```bash
# 读仓库页面
curl -s "https://r.jina.ai/https://github.com/openai/openai-python" -H "Accept: text/markdown"

# 搜索结果有限
```

---

## 🎯 推荐方案

**如果你需要**:
- ✅ 搜索仓库
- ✅ 查看代码
- ✅ 提 Issue/PR

**使用方式1（个人访问令牌）**

---

**如果你只需要**:
- ✅ 读取 README
- ✅ 查看仓库信息

**使用方式2（Jina Reader）**

---

**请告诉我你想使用哪种方式？**

如果选择方式1，我会帮你配置 token。
如果选择方式2，我们可以立即使用 Jina Reader。

---

**维护者**: Main Agent  
**状态**: 等待用户选择登录方式
