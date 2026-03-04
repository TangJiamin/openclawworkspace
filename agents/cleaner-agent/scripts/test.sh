#!/bin/bash
# 测试清理系统

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLEANUP_SKILL_DIR="/home/node/.openclaw/workspace/skills/cleanup"

echo "🧪 测试清理系统"
echo "================"
echo ""

# 1. 测试扫描功能
echo "1️⃣ 测试扫描功能..."
bash "$CLEANUP_SKILL_DIR/scripts/cleanup.sh" scan
echo ""

# 2. 测试干跑模式
echo "2️⃣ 测试干跑模式..."
bash "$CLEANUP_SKILL_DIR/scripts/cleanup.sh" clean true
echo ""

echo "✅ 测试完成！"
echo ""
echo "📊 查看报告:"
echo "  cat /home/node/.openclaw/agents/cleaner-agent/reports/cleanup-report-$(date +%Y%m%d).md"
