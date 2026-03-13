#!/bin/bash
# Agent Output 统一管理工具 v2.0
# 用于在 Agent 目录下创建标准化的产出目录结构

set -e

# 配置
AGENTS_BASE="/home/node/.openclaw/workspace/agents"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# 帮助信息
show_help() {
    cat << 'EOF'
Agent Output 统一管理工具 v2.0

用法:
    agent-output-tool.sh create <agent_name> [task_id]
    agent-output-tool.sh list [agent_name]
    agent-output-tool.sh clean <agent_name> [keep_days]
    agent-output-tool.sh archive <agent_name> [task_id]

目录结构:
    agents/
    └── <agent_name>/
        └── output/
            └── task-<timestamp>/
                └── <files>...

命令:
    create   创建新的产出目录（自动生成时间戳任务ID）
    list     列出产出目录
    clean    清理旧产出（默认保留7天）
    archive  归档指定任务的产出

示例:
    # 创建产出目录（自动生成时间戳任务ID）
    agent-output-tool.sh create research-agent

    # 创建产出目录（指定任务ID）
    agent-output-tool.sh create research-agent task-001

    # 列出所有 Agent 的产出
    agent-output-tool.sh list

    # 列出特定 Agent 的产出
    agent-output-tool.sh list research-agent

    # 清理7天前的产出
    agent-output-tool.sh clean research-agent 7

    # 归档任务
    agent-output-tool.sh archive research-agent task-20260312-092307
EOF
}

# 创建产出目录
create_output() {
    local agent_name="$1"
    local task_id="${2:-task-$TIMESTAMP}"
    local agent_dir="$AGENTS_BASE/$agent_name"
    local output_dir="$agent_dir/output/$task_id"

    # 检查 Agent 目录是否存在
    if [ ! -d "$agent_dir" ]; then
        echo "❌ Agent 目录不存在: $agent_dir"
        return 1
    fi

    # 创建目录
    mkdir -p "$output_dir"

    # 创建 .gitkeep
    touch "$output_dir/.gitkeep"

    echo "✅ 产出目录已创建: $output_dir"

    # 输出路径到 stdout（便于脚本捕获）
    echo "$output_dir"
}

# 列出产出目录
list_output() {
    local agent_name="$1"

    if [ -z "$agent_name" ]; then
        # 列出所有 Agent
        echo "📁 所有 Agent 产出目录："
        echo ""

        for agent_dir in "$AGENTS_BASE"/*/; do
            if [ -d "$agent_dir" ]; then
                local agent=$(basename "$agent_dir")
                local output_dir="$agent_dir/output"

                if [ -d "$output_dir" ]; then
                    local task_count=$(find "$output_dir" -maxdepth 1 -type d -name "task-*" 2>/dev/null | wc -l)
                    echo "🤖 $agent ($task_count 个任务)"
                else
                    echo "🤖 $agent (无产出目录)"
                fi
            fi
        done
    else
        # 列出特定 Agent
        local agent_dir="$AGENTS_BASE/$agent_name"
        local output_dir="$agent_dir/output"

        if [ ! -d "$agent_dir" ]; then
            echo "❌ Agent 目录不存在: $agent_dir"
            return 1
        fi

        echo "📁 $agent_name 的任务产出："
        echo ""

        if [ -d "$output_dir" ]; then
            for task_dir in "$output_dir"/task-*/; do
                if [ -d "$task_dir" ]; then
                    local task=$(basename "$task_dir")
                    local file_count=$(find "$task_dir" -type f ! -name ".gitkeep" | wc -l)
                    local size=$(du -sh "$task_dir" 2>/dev/null | cut -f1)
                    echo "  📦 $task ($file_count 个文件, $size)"
                fi
            done
        else
            echo "  (无产出目录)"
        fi
    fi
}

# 清理旧产出
clean_output() {
    local agent_name="$1"
    local keep_days="${2:-7}"
    local agent_dir="$AGENTS_BASE/$agent_name"
    local output_dir="$agent_dir/output"

    if [ ! -d "$agent_dir" ]; then
        echo "❌ Agent 目录不存在: $agent_dir"
        return 1
    fi

    if [ ! -d "$output_dir" ]; then
        echo "❌ 产出目录不存在: $output_dir"
        return 1
    fi

    echo "🧹 清理 $agent_name $keep_days 天前的产出..."

    # 查找并删除旧目录
    find "$output_dir" -maxdepth 1 -type d -name "task-*" -mtime +$keep_days -print0 | while IFS= read -r -d '' task_dir; do
        echo "🗑️  删除: $task_dir"
        rm -rf "$task_dir"
    done

    echo "✅ 清理完成"
}

# 归档任务
archive_output() {
    local agent_name="$1"
    local task_id="$2"
    local agent_dir="$AGENTS_BASE/$agent_name"
    local output_dir="$agent_dir/output"
    local task_dir="$output_dir/$task_id"
    local archive_dir="$agent_dir/output/.archive"
    local timestamp=$(date +%Y%m%d-%H%M%S)

    if [ ! -d "$task_dir" ]; then
        echo "❌ 任务目录不存在: $task_dir"
        return 1
    fi

    # 创建归档目录
    mkdir -p "$archive_dir"

    # 归档
    local archive_file="$archive_dir/${task_id}_archived_${timestamp}.tar.gz"
    tar -czf "$archive_file" -C "$output_dir" "$task_id"

    echo "📦 已归档: $archive_file"

    # 删除原目录
    rm -rf "$task_dir"

    echo "✅ 归档完成"
}

# 主逻辑
case "${1:-}" in
    create)
        if [ -z "${2:-}" ]; then
            echo "❌ 错误: 缺少 agent_name 参数"
            echo ""
            show_help
            exit 1
        fi
        create_output "$2" "${3:-}"
        ;;
    list)
        list_output "${2:-}"
        ;;
    clean)
        if [ -z "${2:-}" ]; then
            echo "❌ 错误: 缺少 agent_name 参数"
            echo ""
            show_help
            exit 1
        fi
        clean_output "$2" "${3:-7}"
        ;;
    archive)
        if [ -z "${2:-}" ] || [ -z "${3:-}" ]; then
            echo "❌ 错误: 缺少必需参数"
            echo ""
            show_help
            exit 1
        fi
        archive_output "$2" "$3"
        ;;
    *)
        show_help
        ;;
esac
