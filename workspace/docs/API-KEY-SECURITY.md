# API Key 安全原则（最高优先级）

## ⚠️ 铁律：禁止硬编码 API Key

### 核心原则

**禁止行为**：
1. ❌ **绝对禁止** 在任何脚本中硬编码 API Key
2. ❌ **绝对禁止** 在代码中设置默认 API Key 值
3. ❌ **绝对禁止** 将 API Key 写入文档或注释
4. ❌ **绝对禁止** 在会话历史中记录完整 API Key

**唯一来源**：
- ✅ **.env 文件是所有 API Key 的唯一来源**
- ✅ 所有脚本必须从环境变量或 .env 文件读取
- ✅ 永远不要硬编码

---

## ✅ 正确做法

### Bash 脚本

```bash
#!/bin/bash

# ✅ 正确：从 .env 文件读取
set -a
source /home/node/.openclaw/.env 2>/dev/null || true

API_KEY="${XSKILL_API_KEY}"

if [ -z "$API_KEY" ]; then
    echo "❌ 错误: 未设置 XSKILL_API_KEY"
    echo "请在 .env 文件中设置: XSKILL_API_KEY=sk-your-api-key"
    exit 1
fi

# 使用 API_KEY
curl -H "Authorization: Bearer $API_KEY" ...
```

### Python 脚本

```python
import os
from pathlib import Path

# ✅ 正确：从 .env 文件读取
def load_dotenv(dotenv_path: Path) -> None:
    if dotenv_path.exists():
        for line in dotenv_path.read_text().splitlines():
            if '=' in line and not line.strip().startswith('#'):
                key, value = line.split('=', 1)
                key = key.strip()
                value = value.strip().strip('"').strip("'")
                if key and key not in os.environ:
                    os.environ[key] = value

load_dotenv(Path('.env'))
api_key = os.getenv('XSKILL_API_KEY')

if not api_key:
    print("❌ 错误: 未设置 XSKILL_API_KEY")
    print("请在 .env 文件中设置: XSKILL_API_KEY=sk-your-api-key")
    exit(1)
```

---

## ❌ 错误做法

### 错误示例 1：硬编码

```bash
# ❌ 错误：硬编码 API Key
API_KEY="sk-YOUR_API_KEY_HERE"

# ❌ 错误：设置默认值
API_KEY="${XSKILL_API_KEY:-sk-YOUR_API_KEY_HERE}"
```

### 错误示例 2：导出环境变量

```bash
# ❌ 错误：在脚本中导出
export XSKILL_API_KEY="sk-YOUR_API_KEY_HERE"
```

### 错误示例 3：写入文档

```markdown
# ❌ 错误：在文档中记录完整 API Key
配置 API_KEY=sk-YOUR_API_KEY_HERE
```

---

## 🔒 安全显示原则

**显示格式**：
```bash
# ✅ 正确：只显示前 10 个字符
echo "✅ API Key: ${API_KEY:0:10}..."

# ❌ 错误：显示完整 API Key
echo "API Key: $API_KEY"
```

---

## 🛡️ 防御措施

### 检查清单

创建新脚本时：
1. [ ] 是否从 .env 文件读取？
2. [ ] 是否没有硬编码？
3. [ ] 是否没有设置默认值？
4. [ ] 是否只显示前 10 个字符？

### 审查命令

```bash
# 检查是否有硬编码的 API Key
grep -r "sk-" /home/node/.openclaw/workspace/ --exclude-dir=.git --exclude-dir=node_modules

# 检查是否有默认值
grep -r "API_KEY=.*sk-" /home/node/.openclaw/workspace/ --exclude-dir=.git --exclude-dir=node_modules
```

---

## 📝 事故记录（2026-03-10）

### 问题发现

**时间**: 2026-03-10 19:05

**问题**:
1. 我在 2026-03-06 硬编码了 API Key `sk-EXAMPLE_KEY...` 到脚本
2. 这个值被记录到会话历史 `.jsonl` 文件
3. 这个值污染了环境变量
4. 环境变量覆盖了 .env 文件的正确值 `sk-EXAMPLE_KEY...`

**修复**:
1. ✅ 删除 `xskill-mcp-deep-debug.sh` 中的硬编码默认值
2. ✅ 修复 `generate_hedao_images.sh` 中的硬编码
3. ✅ 验证没有其他硬编码

**教训**:
1. ⭐⭐⭐⭐⭐ **永远不要硬编码 API Key**
2. ⭐⭐⭐⭐⭐ **永远不要设置默认值**
3. ⭐⭐⭐⭐⭐ **.env 文件是唯一来源**

---

## 🎯 承诺

**我承诺**:
1. ✅ 严格遵守此原则
2. ✅ 检查所有新脚本
3. ✅ 定期审查现有代码
4. ✅ 立即修复任何违规

**如果违反此原则**:
- 立即修复
- 记录到事故日志
- 分析原因
- 防止再次发生

---

**来源**: 用户要求立即解决（2026-03-10 19:05）
**重要性**: ⭐⭐⭐⭐⭐ 最高优先级
**状态**: ✅ 已修复并记录
