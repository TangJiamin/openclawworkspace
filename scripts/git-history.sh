#!/bin/bash

# Git 快速查看文件修改历史

FILE="${1:-.}"
LINES="${2:-10}"

cd /home/node/.openclaw

if [ "$FILE" = "." ]; then
    echo "=== 最近的提交 ==="
    git log --oneline -10
else
    echo "=== $FILE 的修改历史 ==="
    git log --oneline -"$LINES" -- "$FILE"
    echo ""
    echo "=== 最近一次修改 ==="
    git log -1 --pretty=format:"%h - %an, %ar : %s" -- "$FILE"
    echo ""
    read -p "查看详细差异? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git diff HEAD~1 HEAD -- "$FILE"
    fi
fi
