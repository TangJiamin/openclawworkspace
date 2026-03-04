# Git 文件回撤指南

## 回撤修改的方法

### 1. 回撤未提交的修改（工作区修改）

**场景**: 你修改了文件，但还没有 `git add`

```bash
# 查看修改
git diff <file>

# 回撤单个文件
git checkout -- <file>

# 回撤所有文件
git checkout -- .
```

**示例**:
```bash
# 回撤 AGENTS.md 的修改
git checkout -- workspace/AGENTS.md
```

---

### 2. 回撤已暂存但未提交的修改

**场景**: 你已经 `git add`，但还没有 `git commit`

```bash
# 查看已暂存的修改
git diff --cached <file>

# 取消暂存（保留修改）
git reset HEAD <file>

# 取消暂存并回撤修改
git reset HEAD <file>
git checkout -- <file>
```

**示例**:
```bash
# 取消暂存 AGENTS.md
git reset HEAD workspace/AGENTS.md

# 回撤修改
git checkout -- workspace/AGENTS.md
```

---

### 3. 回撤已提交的修改

**场景**: 你已经 `git commit`，想回到之前的版本

#### 方法 A: 回撤到指定提交（保留历史）

```bash
# 查看提交历史
git log --oneline

# 回撤到指定提交（保留当前修改）
git revert <commit-hash>
```

**示例**:
```bash
# 回撤最近的提交
git revert HEAD

# 回撤指定提交
git revert b6c26e2
```

#### 方法 B: 重置到指定提交（删除历史）

⚠️ **危险操作**：会删除之后的所有提交

```bash
# 软重置（保留修改）
git reset --soft <commit-hash>

# 混合重置（取消暂存）
git reset --mixed <commit-hash>

# 硬重置（删除修改）⚠️ 最危险
git reset --hard <commit-hash>
```

**示例**:
```bash
# 回到上一个提交（保留修改）
git reset --soft HEAD~1

# 回到指定提交（删除所有之后修改）
git reset --hard 1ffc9f6
```

---

### 4. 回撤单个文件到指定版本

**场景**: 只想回撤某个文件到之前的版本

```bash
# 查看文件修改历史
git log --oneline -- <file>

# 回撤到指定提交的版本
git checkout <commit-hash> -- <file>

# 提交回撤
git commit -m "Revert <file> to <commit-hash>"
```

**示例**:
```bash
# 回撤 AGENTS.md 到初始提交
git checkout 1ffc9f6 -- workspace/AGENTS.md

# 提交回撤
git add workspace/AGENTS.md
git commit -m "Revert AGENTS.md to initial version"
```

---

### 5. 查看任意版本的文件内容

```bash
# 查看指定提交的文件
git show <commit-hash>:<file>

# 示例：查看初始提交的 AGENTS.md
git show 1ffc9f6:workspace/AGENTS.md
```

---

## 当前仓库状态

**最近的提交**:
```
b6c26e2 Add Agent scripts and configs to monitoring
1ffc9f6 Initial commit: Core files monitoring
```

**回撤示例**:

1. **回到初始提交**（保留所有修改）:
   ```bash
   git reset --soft 1ffc9f6
   ```

2. **回到添加脚本之前**（删除之后的所有提交）:
   ```bash
   git reset --hard 1ffc9f6
   ```

3. **只回撤某个 Agent 的修改**:
   ```bash
   git checkout 1ffc9f6 -- agents/visual-agent/
   ```

---

## ⚠️ 安全提示

1. **重要操作前先备份**:
   ```bash
   git branch backup-$(date +%Y%m%d)
   ```

2. **查看将要回撤的内容**:
   ```bash
   git diff <commit-hash> HEAD
   ```

3. **测试回撤**（使用 stash）:
   ```bash
   git stash
   # 尝试回撤
   # 如果有问题：git stash pop
   ```

---

## 实际案例

### 案例 1: 回撤刚才对 AGENTS.md 的所有修改

```bash
# 查看修改历史
git log --oneline -- workspace/AGENTS.md

# 回到初始版本
git checkout 1ffc9f6 -- workspace/AGENTS.md

# 提交回撤
git add workspace/AGENTS.md
git commit -m "Revert AGENTS.md to initial version"
```

### 案例 2: 回撤所有未提交的修改

```bash
# 查看修改
git status
git diff

# 回撤所有修改
git checkout -- .

# 或者重置到上一个提交
git reset --hard HEAD
```

---

## 总结

✅ **完全支持回撤**：
- 未提交的修改 → `git checkout -- <file>`
- 已提交的修改 → `git revert` 或 `git reset`
- 单个文件 → `git checkout <commit> -- <file>`
- 整个项目 → `git reset --hard <commit>`

⚠️ **建议**：
- 重要操作前创建分支备份
- 经常提交，形成多个检查点
- 使用 `git log` 查看历史再回撤
