#!/bin/bash

# 时间解析工具
# 支持多种时间格式，统一转换为 ISO-8601 格式

# 使用方法
usage() {
    echo "时间解析工具"
    echo ""
    echo "使用方法:"
    echo "  $0 <time_string> [timezone]"
    echo ""
    echo "参数:"
    echo "  time_string  : 时间字符串（支持多种格式）"
    echo "  timezone     : 时区（默认: Asia/Shanghai）"
    echo ""
    echo "支持的时间格式:"
    echo "  - 相对时间: \"2小时前\", \"3天前\", \"1周前\""
    echo "  - 英文月份: \"Mar 7\", \"March 7\", \"Mar 7, 2026\""
    echo "  - 中文月份: \"3月7日\", \"2026年3月7日\""
    echo "  - ISO 格式: \"2026-03-07\", \"2026-03-07T10:30:00Z\""
    echo "  - 时间戳: \"1712345678\""
    echo ""
    echo "示例:"
    echo "  $0 \"2小时前\""
    echo "  $0 \"Mar 7\""
    echo "  $0 \"2026-03-07T10:30:00Z\""
    exit 1
}

# 参数解析
if [ $# -lt 1 ]; then
    usage
fi

TIME_STRING="$1"
TIMEZONE="${2:-Asia/Shanghai}"

# 使用 Node.js 解析时间（更准确）
node -e "
const { program } = require('commander');
const chrono = require('chrono-node');  // 需要安装: npm install chrono-node
const moment = require('moment-timezone');  // 需要安装: npm install moment-timezone

const timeString = '$TIME_STRING';
const timezone = '$TIMEZONE';

// 尝试解析时间
let parsed;
try {
    // 尝试 chrono-node（自然语言解析）
    parsed = chrono.parseDate(timeString);
    
    if (!parsed) {
        // 尝试 moment（更灵活的解析）
        parsed = moment.tz(timeString, timezone);
        
        if (!parsed.isValid()) {
            // 尝试相对时间
            if (timeString.match(/(\d+)\s*(小时|天|周|月|年)?前/)) {
                const match = timeString.match(/(\d+)\s*(小时|天|周|月|年)?前/);
                const value = parseInt(match[1]);
                const unit = match[2] || '小时';
                
                parsed = moment.tz(timezone);
                switch (unit) {
                    case '小时': parsed.subtract(value, 'hours'); break;
                    case '天': parsed.subtract(value, 'days'); break;
                    case '周': parsed.subtract(value, 'weeks'); break;
                    case '月': parsed.subtract(value, 'months'); break;
                    case '年': parsed.subtract(value, 'years'); break;
                }
            }
        }
    }
    
    if (parsed) {
        const momentObj = moment(parsed);
        const iso = momentObj.tz(timezone).format();
        const unix = momentObj.unix();
        const relative = momentObj.fromNow();
        
        console.log(JSON.stringify({
            original: timeString,
            parsed: {
                iso: iso,
                unix: unix,
                relative: relative,
                timezone: timezone
            },
            success: true
        }, null, 2));
    } else {
        console.log(JSON.stringify({
            original: timeString,
            error: '无法解析时间',
            success: false
        }, null, 2));
    }
} catch (error) {
    console.log(JSON.stringify({
        original: timeString,
        error: error.message,
        success: false
    }, null, 2));
}
" 2>/dev/null || {
    # 备选方案：使用 date 命令
    echo "⚠️ Node.js 不可用，使用基础解析"
    
    # 尝试使用 date 命令
    if date -d "$TIME_STRING" >/dev/null 2>&1; then
        ISO=$(date -d "$TIME_STRING" -u +"%Y-%m-%dT%H:%M:%SZ")
        UNIX=$(date -d "$TIME_STRING" -u +"%s")
        
        echo "{\"original\":\"$TIME_STRING\",\"parsed\":{\"iso\":\"$ISO\",\"unix\":$UNIX,\"timezone\":\"UTC\"},\"success\":true}"
    else
        echo "{\"original\":\"$TIME_STRING\",\"error\":\"无法解析时间\",\"success\":false}"
    fi
}
