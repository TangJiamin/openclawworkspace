# Python 执行方式：使用 uv

**记录时间**: 2026-06-12 16:19

---

## ⚠️ 核心原则

**Python 应该使用 uv 执行，而不是直接使用 python**

---

## 🔧 正确的执行方式

### 使用 uv

```bash
# 运行 Python 脚本
uv run script.py

# 运行 Python 命令
uv run python script.py

# 安装依赖
uv pip install package

# 运行特定 Python 版本
uv run python3.11 script.py
```

### ❌ 错误的执行方式

```bash
# 不要直接使用 python
python script.py

# 不要使用 python3
python3 script.py
```

---

## 🎯 为什么要用 uv

### 1. 更快

**uv 比 pip 快 10-100 倍**
- 用 Rust 编写，性能优异
- 依赖解析和安装更快

### 2. 更可靠

**uv 是官方推荐的 Python 包管理器**
- 由 Astral 开发（Ruff 的作者）
- 更好的依赖解析
- 更好的锁文件支持

### 3. 更现代

**uv 支持 PEP 621 和 PEP 668**
- 更好的依赖隔离
- 更好的虚拟环境管理

---

## 📋 实际应用

### visual-agent 脚本中的 Python 调用

如果需要运行 Python 脚本，应该：

```bash
# ❌ 错误
python3 /path/to/script.py

# ✅ 正确
uv run python /path/to/script.py
```

---

## 🎯 记忆要求

**每次执行 Python 时**：
1. ✅ 检查是否有 `uv`
2. ✅ 使用 `uv run` 而不是 `python`
3. ✅ 如果没有 uv，提示安装

---

**来源**: 2026-06-12 用户反馈
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已理解并记住
**日期**: 2026-06-12 16:19
