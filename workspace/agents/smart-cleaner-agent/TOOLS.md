# TOOLS.md - Smart Cleaner Agent 工具参考

## 可用工具

### 文件操作
- **read** - 读取文件内容
- **write** - 写入文件（生成报告）
- **exec** - 执行 shell 命令

### 通信工具
- **message** - 发送飞书通知

---

## 使用示例

### 扫描文件
```bash
# 扫描 .openclaw 目录
find /home/node/.openclaw -type f -name "*.md" -o -name "*.json" | head -1000
```

### 读取文件
```python
# 读取文件前 100 行
read("/path/to/file.md", limit=100)
```

### 发送飞书报告
```python
message(
  action="send",
  channel="feishu",
  to="ou_42097cc9852e3aae3de5893b96a67219",
  message="清理报告..."
)
```

---

## 白名单检查

### 检查文件是否在白名单
```python
def is_whitelisted(file_path):
  whitelist = [
    "/home/node/.openclaw/workspace/SOUL.md",
    "/home/node/.openclaw/workspace/IDENTITY.md",
    # ... 更多白名单
  ]
  return any(file_path.startswith(w) for w in whitelist)
```

---

## 价值评估

### 评估文件价值
```python
def assess_value(content, file_path):
  # 高价值指标
  high_value_keywords = ["设计决策", "架构", "第一性原理", "学习"]

  # 低价值指标
  low_value_keywords = ["临时", "日志", "安装", "测试"]

  # 检查内容
  if any(kw in content for kw in high_value_keywords):
    return "high"
  elif any(kw in content for kw in low_value_keywords):
    return "low"
  else:
    return "medium"
```

---

## 时效判断

### 评估文件时效
```python
def assess_freshness(file_path):
  # 获取文件修改时间
  mtime = os.path.getmtime(file_path)
  age_days = (time.time() - mtime) / 86400

  if age_days < 1:
    return "new"
  elif age_days < 7:
    return "recent"
  elif age_days < 30:
    return "medium"
  else:
    return "old"
```

---

**记住**: 工具是手段，内容理解是目的。不要滥用工具，要智能使用。
