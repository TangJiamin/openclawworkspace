# time-parser - 时间解析工具

**版本**: v1.0
**更新**: 2026-03-10

---

## 🎯 功能

时间解析工具 - 支持多种时间格式，统一转换为 ISO-8601 格式

---

## 📋 支持的时间格式

### 1. 相对时间
- `2小时前`
- `3天前`
- `1周前`
- `2个月前`
- `1年前`

### 2. 英文月份
- `Mar 7`
- `March 7`
- `Mar 7, 2026`
- `March 7, 2026`

### 3. 中文月份
- `3月7日`
- `2026年3月7日`
- `3月7日 10:30`

### 4. ISO 格式
- `2026-03-07`
- `2026-03-07T10:30:00Z`
- `2026-03-07T10:30:00+08:00`

### 5. 时间戳
- `1712345678`（Unix 时间戳）

---

## 🚀 使用方法

### 基础用法

```bash
bash /home/node/.openclaw/workspace/skills/time-parser/scripts/parse-time.sh "2小时前"
```

**输出**:
```json
{
  "original": "2小时前",
  "parsed": {
    "iso": "2026-03-10T07:06:00+08:00",
    "unix": 1773104760,
    "relative": "2 hours ago",
    "timezone": "Asia/Shanghai"
  },
  "success": true
}
```

### 指定时区

```bash
bash /home/node/.openclaw/workspace/skills/time-parser/scripts/parse-time.sh "Mar 7" "America/New_York"
```

**输出**:
```json
{
  "original": "Mar 7",
  "parsed": {
    "iso": "2026-03-07T00:00:00-05:00",
    "unix": 1772916000,
    "relative": "3 days ago",
    "timezone": "America/New_York"
  },
  "success": true
}
```

---

## 📊 返回格式

### 成功

```json
{
  "original": "原始时间字符串",
  "parsed": {
    "iso": "ISO-8601 格式时间",
    "unix": "Unix 时间戳（秒）",
    "relative": "相对时间描述",
    "timezone": "时区"
  },
  "success": true
}
```

### 失败

```json
{
  "original": "原始时间字符串",
  "error": "错误信息",
  "success": false
}
```

---

## 🎯 应用场景

### 1. 资料收集（research-agent）

**问题**: 网站时间格式不统一

**解决**:
```python
# 解析多种时间格式
parsed = parse_time("Mar 7")
parsed = parse_time("2小时前")
parsed = parse_time("3月7日")

# 统一转换为 ISO 格式
iso_time = parsed["parsed"]["iso"]

# 验证时效性（24小时内）
if is_within_24_hours(iso_time):
    return "有效"
```

### 2. 时间范围过滤

```python
# 只收集 24 小时内的资讯
def is_within_24_hours(iso_time):
    from datetime import datetime, timedelta
    
    article_time = datetime.fromisoformat(iso_time)
    now = datetime.now()
    time_diff = now - article_time
    
    return time_diff <= timedelta(hours=24)
```

### 3. 时间排序

```python
# 统一转换为 Unix 时间戳进行排序
articles = [
    {"title": "A", "time": parse_time("2小时前")},
    {"title": "B", "time": parse_time("Mar 7")},
    {"title": "C", "time": parse_time("3天前")}
]

# 按 Unix 时间戳排序
articles.sort(key=lambda x: x["time"]["parsed"]["unix"])
```

---

## 🛠️ 技术实现

### 主要依赖

1. **chrono-node** - 自然语言时间解析
2. **moment-timezone** - 时区支持
3. **date 命令** - 备选方案

### 解析流程

```
时间字符串
  ↓
尝试 chrono-node（自然语言）
  ↓ 失败
尝试 moment（灵活解析）
  ↓ 失败
尝试相对时间（正则匹配）
  ↓ 失败
使用 date 命令（备选）
  ↓
输出 ISO 格式
```

---

## 📝 使用示例

### research-agent 集成

```python
import subprocess
import json

def parse_time(time_string, timezone="Asia/Shanghai"):
    """解析时间字符串"""
    cmd = [
        "bash",
        "/home/node/.openclaw/workspace/skills/time-parser/scripts/parse-time.sh",
        time_string,
        timezone
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    parsed = json.loads(result.stdout)
    
    if parsed["success"]:
        return parsed["parsed"]["iso"]
    else:
        return None

def collect_articles(articles):
    """收集并验证时效性"""
    valid_articles = []
    
    for article in articles:
        # 解析时间
        iso_time = parse_time(article["time"])
        
        if iso_time and is_within_24_hours(iso_time):
            valid_articles.append({
                **article,
                "iso_time": iso_time
            })
    
    return valid_articles
```

---

## ✅ 优势

1. **支持多种格式** - 相对时间、英文、中文、ISO 格式
2. **统一输出** - 统一转换为 ISO-8601 格式
3. **时区支持** - 支持全球时区
4. **错误处理** - 失败时返回错误信息
5. **备选方案** - Node.js 不可用时使用 date 命令

---

## 🎯 下一步

1. **集成到 research-agent**
   - 解析网站时间
   - 验证时效性
   - 提高资料收集准确率

2. **集成到 content-agent**
   - 检查参考资料时效性
   - 确保引用最新信息

3. **扩展功能**
   - 支持更多时间格式
   - 添加时间范围计算
   - 支持多语言

---

**维护者**: Main Agent
**版本**: v1.0
**最后更新**: 2026-03-10
