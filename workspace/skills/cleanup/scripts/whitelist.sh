#!/bin/bash
# Whitelist Patterns - 永不删除的文件

whitelist_patterns=(
    # 用户数据
    "MEMORY.md"
    "IDENTITY.md"
    "USER.md"
    "SOUL.md"

    # Agent 核心
    "README.md"
    "models.json"

    # Skill 定义
    "SKILL.md"

    # 核心文档
    "SKILL-CREATION-GUIDE.md"
    "AGENT-MATRIX-REPLAN.md"
    "ORCHESTRATION-EXAMPLES.md"
    "AGENT-REACH-STUDY.md"
)

# 检查文件是否在白名单中
is_whitelisted() {
    local file="$1"
    local filename=$(basename "$file")

    for pattern in "${whitelist_patterns[@]}"; do
        if [[ "$filename" == "$pattern" ]]; then
            return 0  # 在白名单中
        fi
    done

    # 检查特殊路径
    if [[ "$file" == *"/extensions/"* ]]; then
        return 0  # 所有 extensions/ 目录下的文件
    fi

    if [[ "$file" == *"/agents/main/"* ]]; then
        return 0  # main agent 的所有文件
    fi

    return 1  # 不在白名单中
}
