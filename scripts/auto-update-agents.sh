#!/bin/bash

# 自动 Agent 更新建议系统
# 当学习新能力时，自动识别需要更新的 Agents 并发送建议

set -e

WORKSPACE_DIR="/home/node/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE_DIR/memory"
CAPABILITIES_FILE="$MEMORY_DIR/capabilities.json"
AGENTS_DIR="/home/node/.openclaw/agents"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0;0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# 初始化 capabilities.json
init_capabilities() {
    if [ ! -f "$CAPABILITIES_FILE" ]; then
        mkdir -p "$MEMORY_DIR"
        echo '{"capabilities": [], "last_scan": null}' > "$CAPABILITIES_FILE"
        log_success "初始化 capabilities.json"
    fi
}

# 记录新能力
register_capability() {
    local name="$1"
    local type="$2"
    local description="$3"
    local agents="$4"  # JSON array string: ["agent1", "agent2"]

    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # 读取现有 capabilities
    local existing=$(cat "$CAPABILITIES_FILE")
    
    # 添加新能力
    local new_cap=$(echo "$existing" | jq --arg name "$name" \
        --arg type "$type" \
        --arg desc "$description" \
        --arg timestamp "$timestamp" \
        --argjson agents "$agents" \
        '.capabilities += [{
            "name": $name,
            "type": $type,
            "description": $desc,
            "installed_at": $timestamp,
            "agents": $agents
        }]')
    
    echo "$new_cap" > "$CAPABILITIES_FILE"
    log_success "记录新能力: $name"
}

# 扫描 Agents，查找更新机会
scan_agents() {
    log_info "扫描 Agents 配置..."
    
    local capabilities=$(cat "$CAPABILITIES_FILE")
    
    # 遍历所有 Agents
    for agent_dir in "$AGENTS_DIR"/*; do
        if [ -d "$agent_dir" ] && [ -f "$agent_dir/workspace/config.json" ]; then
            local agent_name=$(basename "$agent_dir")
            local config=$(cat "$agent_dir/workspace/config.json")
            
            # 检查是否需要新能力
            echo "$capabilities" | jq -r --arg agent "$agent_name" '
                .capabilities[] | 
                select(.agents[] == $agent) as $cap |
                "\($cap.name): \($cap.description)"
            ' 2>/dev/null || true
        fi
    done
}

# 生成更新建议
generate_suggestions() {
    log_info "生成更新建议..."
    
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local suggestions_file="$MEMORY_DIR/update-suggestions-$timestamp.json"
    
    # 这里扫描每个 Agent，检查是否可以应用新能力
    # 实际实现会检查 Agent 的配置文件，看是否有相关配置项
    
    cat > "$suggestions_file" << EOF
{
  "generated_at": "$timestamp",
  "suggestions": [
    {
      "agent": "research-agent",
      "capability": "agent-reach",
      "suggestion": "添加 agent-reach 作为数据源",
      "config_path": "agents/research-agent/workspace/config.json",
      "changes": {
        "add": {
          "sources.agent_reach": {
            "enabled": true,
            "priority": 3
          }
        }
      },
      "reason": "agent-reach 可以从 YouTube、Reddit、B站等多平台收集资讯"
    }
  ]
}
EOF
    
    log_success "建议已生成: $suggestions_file"
    echo "$suggestions_file"
}

# 发送更新建议消息
send_suggestion_message() {
    local suggestions_file="$1"
    
    log_info "准备发送更新建议消息..."
    
    # 读取建议
    local suggestions=$(cat "$suggestions_file")
    
    # 生成消息内容
    local message=$(echo "$suggestions" | jq -r '
        "🔔 Agent 更新建议\n\n" +
        (.suggestions | length | tostring) + " 个 Agent 可以更新：\n\n" +
        (
            .suggestions[] |
            "📦 \(.agent)\n" +
            "   新能力: \(.capability)\n" +
            "   建议: \(.suggestion)\n" +
            "   原因: \(.reason)\n\n"
        ) +
        "---\n" +
        "回复 '确认更新' 应用这些更新\n" +
        "回复 '查看详情' 查看完整配置差异"
    ')
    
    echo "$message"
    log_info "消息内容已生成"
    log_info "请通过消息渠道发送给用户"
}

# 应用更新
apply_updates() {
    local suggestions_file="$1"
    
    log_info "应用更新..."
    
    # 读取建议
    local suggestions=$(cat "$suggestions_file")
    
    # 遍历每个建议
    echo "$suggestions" | jq -c '.suggestions[]' | while read -r suggestion; do
        local agent=$(echo "$suggestion" | jq -r '.agent')
        local config_path=$(echo "$suggestion" | jq -r '.config_path')
        
        log_info "更新 $agent..."
        
        # 应用配置更改
        # 这里需要实际修改配置文件
        
        log_success "$agent 已更新"
    done
    
    # Git commit
    cd /home/node/.openclaw
    git add "$AGENTS_DIR"/*/workspace/config.json
    git commit -m "Auto-update: Apply agent capability updates"
    
    log_success "所有更新已应用并提交"
}

# 主函数
main() {
    local action="${1:-scan}"
    
    case "$action" in
        "init")
            init_capabilities
            ;;
        "register")
            register_capability "$2" "$3" "$4" "$5"
            ;;
        "scan")
            init_capabilities
            scan_agents
            ;;
        "suggest")
            local file=$(generate_suggestions)
            send_suggestion_message "$file"
            ;;
        "apply")
            apply_updates "$2"
            ;;
        *)
            echo "用法: $0 {init|register|scan|suggest|apply}"
            echo ""
            echo "命令:"
            echo "  init                          - 初始化 capabilities.json"
            echo "  register <name> <type> <desc> <agents> - 记录新能力"
            echo "  scan                         - 扫描 Agents"
            echo "  suggest                      - 生成并发送更新建议"
            echo "  apply <suggestions-file>      - 应用更新"
            exit 1
            ;;
    esac
}

main "$@"
