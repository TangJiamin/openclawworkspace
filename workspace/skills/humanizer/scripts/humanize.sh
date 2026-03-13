#!/bin/bash
# Humanizer - AI 文本人类化
# 2026-03-13

set -e

# 输入文本
INPUT_TEXT="$1"

# 如果没有输入，从 stdin 读取
if [ -z "$INPUT_TEXT" ]; then
  INPUT_TEXT=$(cat)
fi

# 输出目录
OUTPUT_DIR="$HOME/.openclaw/workspace/tmp/humanizer"
mkdir -p "$OUTPUT_DIR"

# 生成时间戳
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
OUTPUT_FILE="$OUTPUT_DIR/humanizer-$TIMESTAMP.md"

# 生成报告
cat > "$OUTPUT_FILE" << EOF
# Humanizer 分析报告

**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')

---

## 原文

$INPUT_TEXT

---

## 检测到的问题

$(echo "$INPUT_TEXT" | node -e "
const text = require('fs').readFileSync(0, 'utf-8');
const problems = [];

// 检测 1: 夸张的象征主义
if (text.match(/(革命性|突破性|前所未有的)/)) {
  problems.push({
    type: '夸张的象征主义',
    severity: '中',
    description: '使用夸张的修饰词',
    suggestion: '删除或替换为更中性的词汇'
  });
}

// 检测 2: 促销语言
if (text.match(/(先进的|强大的|优秀的|无缝的|完美的)/)) {
  problems.push({
    type: '促销语言',
    severity: '高',
    description: '使用过度积极的促销词汇',
    suggestion: '使用更中性的词汇'
  });
}

// 检测 3: AI 词汇
if (text.match(/(leverage|utilize|optimize|seamless|robust|cutting-edge)/i)) {
  problems.push({
    type: 'AI 词汇',
    severity: '高',
    description: '使用 AI 常用的商务术语',
    suggestion: '替换为更常见的词汇'
  });
}

// 检测 4: 破折号过度使用
const dashCount = (text.match(/—/g) || []).length;
if (dashCount > 2) {
  problems.push({
    type: '破折号过度使用',
    severity: '中',
    description: \`使用了 \${dashCount} 个破折号\`,
    suggestion: '使用其他标点符号或拆分长句'
  });
}

// 检测 5: 模糊的归属
if (text.match(/(专家认为|研究表明|数据显示)/)) {
  problems.push({
    type: '模糊的归属',
    severity: '中',
    description: '使用模糊的引用',
    suggestion: '提供具体来源或删除'
  });
}

// 检测 6: 过度连接词
if (text.match(/(此外|另外|再者|同时)/g)) {
  const count = (text.match(/(此外|另外|再者|同时)/g) || []).length;
  if (count > 2) {
    problems.push({
      type: '过多的连接词',
      severity: '低',
      description: \`使用了 \${count} 个连接词\`,
      suggestion: '减少过渡词，让句子更简洁'
    });
  }
}

// 输出问题
if (problems.length === 0) {
  console.log('✅ 未检测到明显的 AI 写作痕迹');
} else {
  problems.forEach((p, i) => {
    console.log(\`\${i + 1}. **\${p.type}** - \${p.severity}\`);
    console.log(\`   - 问题描述：\${p.description}\`);
    console.log(\`   - 修复建议：\${p.suggestion}\`);
    console.log();
  });
}
")

---

## 人类化文本

$(echo "$INPUT_TEXT" | node -e "
const text = require('fs').readFileSync(0, 'utf-8');

// 简单的替换规则
let humanized = text
  // 删除夸张的象征主义
  .replace(/革命性的/g, '新的')
  .replace(/突破性的/g, '重要的')
  .replace(/前所未有的/g, '少有的')
  
  // 删除促销语言
  .replace(/先进的/g, '新')
  .replace(/强大的/g, '有效')
  .replace(/优秀的/g, '好')
  .replace(/无缝的/g, '顺畅')
  .replace(/完美的/g, '完整')
  
  // 替换 AI 词汇
  .replace(/leverage/gi, 'use')
  .replace(/utilize/gi, 'use')
  .replace(/optimize/gi, 'improve')
  .replace(/seamless/gi, 'smooth')
  .replace(/robust/gi, 'strong')
  .replace(/cutting-edge/gi, 'new')
  
  // 减少破折号
  .replace(/—/g, '——')
  
  // 减少连接词
  .replace(/此外，/g, '')
  .replace(/另外，/g, '')
  .replace(/再者，/g, '')
  .replace(/同时，/g, '');

console.log(humanized);
")

---

## 改进说明

- 简化了修饰词
- 替换了 AI 词汇
- 减少了连接词
- 优化了句子结构

---

**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')
**Humanizer 版本**: v1.0
EOF

# 输出结果
cat "$OUTPUT_FILE"

# 返回文件路径
echo ""
echo "📄 报告已保存: $OUTPUT_FILE"
