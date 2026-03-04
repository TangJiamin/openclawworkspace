#!/bin/bash
# Scanner Functions - 扫描文件系统

# 1. 扫描临时文件
scan_temp_files() {
    echo "## 1️⃣ 临时文件 (*.tmp, *.temp, temp-*.json)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local count=0
    local total_size=0

    while IFS= read -r -d '' file; do
        if is_whitelisted "$file"; then
            continue
        fi

        # 检查文件年龄
        local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
        if [ $file_age -lt $KEEP_DAYS_TEMP ]; then
            continue
        fi

        local size=$(du -h "$file" | cut -f1)
        echo "- \`$file\` ($size, ${file_age}天前)" >> "$REPORT_FILE"
        ((count++))
    done < <(find "$CLEANUP_ROOT" -type f \( -name "*.tmp" -o -name "*.temp" -o -name "temp-*.json" \) -print0 2>/dev/null || true)

    if [ $count -eq 0 ]; then
        echo "_无过期文件_" >> "$REPORT_FILE"
    fi

    echo "" >> "$REPORT_FILE"
}

# 2. 扫描浏览器日志
scan_browser_logs() {
    echo "## 2️⃣ 浏览器日志 (*.log)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local count=0

    while IFS= read -r -d '' file; do
        if is_whitelisted "$file"; then
            continue
        fi

        local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
        if [ $file_age -lt $KEEP_DAYS_LOGS ]; then
            continue
        fi

        local size=$(du -h "$file" | cut -f1)
        echo "- \`$file\` ($size, ${file_age}天前)" >> "$REPORT_FILE"
        ((count++))
    done < <(find "$CLEANUP_ROOT/browser" -type f -name "*.log" -print0 2>/dev/null || true)

    if [ $count -eq 0 ]; then
        echo "_无过期文件_" >> "$REPORT_FILE"
    fi

    echo "" >> "$REPORT_FILE"
}

# 3. 扫描 Agent 数据
scan_agent_data() {
    echo "## 3️⃣ Agent 数据文件" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local count=0

    while IFS= read -r -d '' file; do
        if is_whitelisted "$file"; then
            continue
        fi

        local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
        if [ $file_age -lt $KEEP_DAYS_AGENT_DATA ]; then
            continue
        fi

        local size=$(du -h "$file" | cut -f1)
        echo "- \`$file\` ($size, ${file_age}天前)" >> "$REPORT_FILE"
        ((count++))
    done < <(find "$CLEANUP_ROOT/agents/research-agent/data" -type f -name "*.md" -print0 2>/dev/null || true)

    if [ $count -eq 0 ]; then
        echo "_无过期文件_" >> "$REPORT_FILE"
    fi

    echo "" >> "$REPORT_FILE"
}

# 4. 扫描会话历史
scan_sessions() {
    echo "## 4️⃣ 会话历史 (>30天)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local count=0

    while IFS= read -r -d '' file; do
        if is_whitelisted "$file"; then
            continue
        fi

        local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
        if [ $file_age -lt $KEEP_DAYS_SESSIONS ]; then
            continue
        fi

        echo "- \`$file\` (${file_age}天前)" >> "$REPORT_FILE"
        ((count++))
    done < <(find "$CLEANUP_ROOT/agents" -type f -path "*/sessions/*" -print0 2>/dev/null || true)

    if [ $count -eq 0 ]; then
        echo "_无过期文件_" >> "$REPORT_FILE"
    fi

    echo "" >> "$REPORT_FILE"
}

# 5. 扫描备份文件
scan_backups() {
    echo "## 5️⃣ 备份文件 (保留最近 $KEEP_BACKUPS 个)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local count=0

    # 扫描 agents/.backup
    while IFS= read -r -d '' file; do
        local size=$(du -h "$file" | cut -f1)
        echo "- \`$file\` ($size)" >> "$REPORT_FILE"
        ((count++))
    done < <(find "$CLEANUP_ROOT/agents/.backup" -type f -name "*.tar.gz" -print0 2>/dev/null || true | \
             sort -rz | tail -n +$((KEEP_BACKUPS + 1)))

    # 扫描 skills/.backup
    while IFS= read -r -d '' file; do
        local size=$(du -h "$file" | cut -f1)
        echo "- \`$file\` ($size)" >> "$REPORT_FILE"
        ((count++))
    done < <(find "$CLEANUP_ROOT/workspace/skills/.backup" -type f -name "*.tar.gz" -print0 2>/dev/null || true | \
             sort -rz | tail -n +$((KEEP_BACKUPS + 1)))

    if [ $count -eq 0 ]; then
        echo "_无过期备份_" >> "$REPORT_FILE"
    fi

    echo "" >> "$REPORT_FILE"
}

# 6. 扫描废弃的 Skills
scan_deprecated_skills() {
    echo "## 6️⃣ 废弃的 Skills (已迁移到 Agents)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local deprecated_skills=(
        "requirement-analyzer"
        "content-planner"
        "quality-reviewer"
    )

    local count=0
    for skill in "${deprecated_skills[@]}"; do
        local skill_path="$CLEANUP_ROOT/workspace/skills/$skill"
        if [ -d "$skill_path" ]; then
            local size=$(du -sh "$skill_path" 2>/dev/null | cut -f1)
            echo "- \`$skill_path\` ($size)" >> "$REPORT_FILE"
            ((count++))
        fi
    done

    if [ $count -eq 0 ]; then
        echo "_无废弃 Skills_" >> "$REPORT_FILE"
    fi

    echo "" >> "$REPORT_FILE"
}

# 7. 扫描过时的文档
scan_outdated_docs() {
    echo "## 7️⃣ 过时的项目文档" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local keep_docs=(
        "SKILL-CREATION-GUIDE.md"
        "AGENT-MATRIX-REPLAN.md"
        "ORCHESTRATION-EXAMPLES.md"
        "AGENT-REACH-STUDY.md"
    )

    local count=0
    while IFS= read -r -d '' file; do
        local filename=$(basename "$file")

        # 检查是否在保留列表中
        local keep=false
        for doc in "${keep_docs[@]}"; do
            if [[ "$filename" == "$doc" ]]; then
                keep=true
                break
            fi
        done

        if [ "$keep" = false ]; then
            local size=$(du -h "$file" | cut -f1)
            echo "- \`$file\` ($size)" >> "$REPORT_FILE"
            ((count++))
        fi
    done < <(find "$CLEANUP_ROOT/workspace/docs" -type f -name "*.md" -print0 2>/dev/null || true)

    if [ $count -eq 0 ]; then
        echo "_无过时文档_" >> "$REPORT_FILE"
    fi

    echo "" >> "$REPORT_FILE"
}

# 生成总计
generate_summary() {
    echo "## 📊 扫描总计" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "✅ 扫描完成！请查看上述各类文件的清理建议。" >> "$REPORT_FILE"
}
