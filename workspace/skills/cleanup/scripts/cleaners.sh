#!/bin/bash
# Cleaner Functions - 执行清理操作

# 1. 清理临时文件
clean_temp_files() {
    echo "## 1️⃣ 临时文件清理" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local deleted=0
    local protected=0

    while IFS= read -r -d '' file; do
        if is_whitelisted "$file"; then
            echo "- ⛔ **保护**: \`$file\` (白名单)" >> "$REPORT_FILE"
            ((protected++))
            continue
        fi

        local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
        if [ $file_age -lt $KEEP_DAYS_TEMP ]; then
            continue
        fi

        if [ "$DRY_RUN" = "true" ]; then
            echo "- 🔍 **预览**: \`$file\` (${file_age}天前)" >> "$REPORT_FILE"
        else
            rm -f "$file"
            echo "- ✅ **删除**: \`$file\` (${file_age}天前)" >> "$REPORT_FILE"
        fi
        ((deleted++))
    done < <(find "$CLEANUP_ROOT" -type f \( -name "*.tmp" -o -name "*.temp" -o -name "temp-*.json" \) -print0 2>/dev/null)

    echo "" >> "$REPORT_FILE"
    echo "**统计**: 删除 $deleted 个，保护 $protected 个" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# 2. 清理浏览器日志
clean_browser_logs() {
    echo "## 2️⃣ 浏览器日志清理" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local deleted=0

    while IFS= read -r -d '' file; do
        if is_whitelisted "$file"; then
            continue
        fi

        local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
        if [ $file_age -lt $KEEP_DAYS_LOGS ]; then
            continue
        fi

        if [ "$DRY_RUN" = "true" ]; then
            echo "- 🔍 **预览**: \`$file\` (${file_age}天前)" >> "$REPORT_FILE"
        else
            rm -f "$file"
            echo "- ✅ **删除**: \`$file\` (${file_age}天前)" >> "$REPORT_FILE"
        fi
        ((deleted++))
    done < <(find "$CLEANUP_ROOT/browser" -type f -name "*.log" -print0 2>/dev/null)

    echo "" >> "$REPORT_FILE"
    echo "**统计**: 删除 $deleted 个日志文件" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# 3. 清理 Agent 数据
clean_agent_data() {
    echo "## 3️⃣ Agent 数据清理" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local deleted=0

    while IFS= read -r -d '' file; do
        if is_whitelisted "$file"; then
            continue
        fi

        local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
        if [ $file_age -lt $KEEP_DAYS_AGENT_DATA ]; then
            continue
        fi

        if [ "$DRY_RUN" = "true" ]; then
            echo "- 🔍 **预览**: \`$file\` (${file_age}天前)" >> "$REPORT_FILE"
        else
            rm -f "$file"
            echo "- ✅ **删除**: \`$file\` (${file_age}天前)" >> "$REPORT_FILE"
        fi
        ((deleted++))
    done < <(find "$CLEANUP_ROOT/agents/research-agent/data" -type f -name "*.md" -print0 2>/dev/null)

    echo "" >> "$REPORT_FILE"
    echo "**统计**: 删除 $deleted 个数据文件" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# 4. 清理会话历史
clean_sessions() {
    echo "## 4️⃣ 会话历史清理" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local deleted=0

    while IFS= read -r -d '' file; do
        if is_whitelisted "$file"; then
            continue
        fi

        local file_age=$(( ($(date +%s) - $(stat -c %Y "$file")) / 86400 ))
        if [ $file_age -lt $KEEP_DAYS_SESSIONS ]; then
            continue
        fi

        if [ "$DRY_RUN" = "true" ]; then
            echo "- 🔍 **预览**: \`$file\` (${file_age}天前)" >> "$REPORT_FILE"
        else
            rm -f "$file"
            echo "- ✅ **删除**: \`$file\` (${file_age}天前)" >> "$REPORT_FILE"
        fi
        ((deleted++))
    done < <(find "$CLEANUP_ROOT/agents" -type f -path "*/sessions/*" -print0 2>/dev/null)

    echo "" >> "$REPORT_FILE"
    echo "**统计**: 删除 $deleted 个会话文件" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# 5. 清理备份文件
clean_backups() {
    echo "## 5️⃣ 备份文件清理 (保留最近 $KEEP_BACKUPS 个)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local deleted=0

    # 清理 agents/.backup
    while IFS= read -r -d '' file; do
        if [ "$DRY_RUN" = "true" ]; then
            local size=$(du -h "$file" | cut -f1)
            echo "- 🔍 **预览**: \`$file\` ($size)" >> "$REPORT_FILE"
        else
            local size=$(du -h "$file" | cut -f1)
            rm -f "$file"
            echo "- ✅ **删除**: \`$file\` ($size)" >> "$REPORT_FILE"
        fi
        ((deleted++))
    done < <(find "$CLEANUP_ROOT/agents/.backup" -type f -name "*.tar.gz" -print0 2>/dev/null | \
             sort -rz | tail -n +$((KEEP_BACKUPS + 1)))

    # 清理 skills/.backup
    while IFS= read -r -d '' file; do
        if [ "$DRY_RUN" = "true" ]; then
            local size=$(du -h "$file" | cut -f1)
            echo "- 🔍 **预览**: \`$file\` ($size)" >> "$REPORT_FILE"
        else
            local size=$(du -h "$file" | cut -f1)
            rm -f "$file"
            echo "- ✅ **删除**: \`$file\` ($size)" >> "$REPORT_FILE"
        fi
        ((deleted++))
    done < <(find "$CLEANUP_ROOT/workspace/skills/.backup" -type f -name "*.tar.gz" -print0 2>/dev/null | \
             sort -rz | tail -n +$((KEEP_BACKUPS + 1)))

    echo "" >> "$REPORT_FILE"
    echo "**统计**: 删除 $deleted 个备份文件" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# 6. 清理废弃的 Skills
clean_deprecated_skills() {
    echo "## 6️⃣ 废弃 Skills 清理" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local deprecated_skills=(
        "requirement-analyzer"
        "content-planner"
        "quality-reviewer"
    )

    local deleted=0
    for skill in "${deprecated_skills[@]}"; do
        local skill_path="$CLEANUP_ROOT/workspace/skills/$skill"
        if [ -d "$skill_path" ]; then
            local size=$(du -sh "$skill_path" 2>/dev/null | cut -f1)
            if [ "$DRY_RUN" = "true" ]; then
                echo "- 🔍 **预览**: \`$skill_path\` ($size)" >> "$REPORT_FILE"
            else
                rm -rf "$skill_path"
                echo "- ✅ **删除**: \`$skill_path\` ($size)" >> "$REPORT_FILE"
            fi
            ((deleted++))
        fi
    done

    echo "" >> "$REPORT_FILE"
    echo "**统计**: 删除 $deleted 个废弃 Skills" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# 7. 清理过时的文档
clean_outdated_docs() {
    echo "## 7️⃣ 过时文档清理" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    local keep_docs=(
        "SKILL-CREATION-GUIDE.md"
        "AGENT-MATRIX-REPLAN.md"
        "ORCHESTRATION-EXAMPLES.md"
        "AGENT-REACH-STUDY.md"
    )

    local deleted=0
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
            if [ "$DRY_RUN" = "true" ]; then
                echo "- 🔍 **预览**: \`$file\` ($size)" >> "$REPORT_FILE"
            else
                rm -f "$file"
                echo "- ✅ **删除**: \`$file\` ($size)" >> "$REPORT_FILE"
            fi
            ((deleted++))
        fi
    done < <(find "$CLEANUP_ROOT/workspace/docs" -type f -name "*.md" -print0 2>/dev/null)

    echo "" >> "$REPORT_FILE"
    echo "**统计**: 删除 $deleted 个过时文档" >> "$REPORT_FILE"
    echo "**保留**: ${keep_docs[*]}" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# 生成清理总计
generate_cleanup_summary() {
    echo "## 📊 清理总计" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    if [ "$DRY_RUN" = "true" ]; then
        echo "⚠️  **干跑模式**: 上述文件为预览，未实际删除" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        echo "**建议**: 确认无误后，运行 \`./cleanup.sh clean false\` 执行清理" >> "$REPORT_FILE"
    else
        echo "✅ **清理完成**: 上述文件已成功删除" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        echo "**下次清理**: 明天凌晨 3:00 自动执行" >> "$REPORT_FILE"
    fi
}
