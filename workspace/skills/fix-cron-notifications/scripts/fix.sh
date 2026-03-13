#!/bin/bash

# Cron Job 通知修复脚本
# 在所有 Cron Jobs 的 message 末尾添加通知说明

set -e

NOTICE_TEXT="

## 📢 通知发送（重要）

**发送飞书通知时必须包含以下参数**:
- channel: \"feishu\"
- target: \"ou_42097cc9852e3aae3de5893b96a67219\"

**示例代码**:
```javascript
message({
  action: \"send\",
  channel: \"feishu\",
  target: \"ou_42097cc9852e3aae3de5893b96a67219\",
  message: \"你的通知内容...\"
})
```

**注意**: 如果不包含 target 参数，通知将发送失败！
"

CONFIG_FILE="/home/node/.openclaw/cron/jobs.json"
BACKUP_FILE="${CONFIG_FILE}.backup-$(date +%Y%m%d-%H%M%S)"

echo "🔧 Cron Job 通知修复脚本"
echo "====================="
echo ""

# 备份
echo "📦 备份当前配置..."
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "✅ 备份完成: $BACKUP_FILE"
echo ""

# 读取并修改
echo "🔨 修改 Cron Jobs..."
python3 << 'PYTHON_SCRIPT'
import json
import sys

NOTICE_TEXT = """

## 📢 通知发送（重要）

**发送飞书通知时必须包含以下参数**:
- channel: "feishu"
- target: "ou_42097cc9852e3aae3de5893b96a67219"

**示例代码**:
```javascript
message({
  action: "send",
  channel: "feishu",
  target: "ou_42097cc9852e3aae3de5893b96a67219",
  message: "你的通知内容..."
})
```

**注意**: 如果不包含 target 参数，通知将发送失败！
"""

config_file = "/home/node/.openclaw/cron/jobs.json"

# 读取配置
with open(config_file, 'r', encoding='utf-8') as f:
    config = json.load(f)

# 修改每个 job
modified_count = 0
for job in config.get('jobs', []):
    payload = job.get('payload', {})
    message = payload.get('message', '')

    # 检查是否已经包含通知说明
    if '📢 通知发送' not in message:
        # 添加通知说明
        payload['message'] = message + NOTICE_TEXT
        modified_count += 1
        print(f"  ✅ 修改: {job['name']}")
    else:
        print(f"  ⏭️  跳过: {job['name']} (已包含)")

# 保存修改后的配置
with open(config_file, 'w', encoding='utf-8') as f:
    json.dump(config, f, ensure_ascii=False, indent=2)

print(f"\n📊 修改统计:")
print(f"  总 jobs: {len(config.get('jobs', []))}")
print(f"  已修改: {modified_count}")
print(f"  已跳过: {len(config.get('jobs', [])) - modified_count}")
PYTHON_SCRIPT

echo ""
echo "✅ 修复完成！"
echo ""
echo "📋 下一步:"
echo "1. 检查修改后的配置: cat $CONFIG_FILE"
echo "2. 重启 Gateway: openclaw gateway restart"
echo "3. 等待下一次 Cron Job 执行，验证通知是否成功"
echo ""
echo "🔄 如需回滚:"
echo "   cp $BACKUP_FILE $CONFIG_FILE"
echo "   openclaw gateway restart"
