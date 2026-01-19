#!/bin/bash
# Vibe Kanban Helper Script
# Usage: vk-helper.sh <command> [args...]

set -e

# Find Vibe Kanban port
find_port() {
    local port_file="${TMPDIR:-/tmp}/vibe-kanban/vibe-kanban.port"
    if [[ -f "$port_file" ]]; then
        cat "$port_file"
    else
        # Try common default
        echo "50556"
    fi
}

VK_PORT=$(find_port)
VK_BASE="http://127.0.0.1:$VK_PORT/api"

# Check if Vibe Kanban is running
check_health() {
    local response=$(curl -s "$VK_BASE/health" 2>/dev/null)
    if [[ $(echo "$response" | jq -r '.success' 2>/dev/null) == "true" ]]; then
        echo "Vibe Kanban is running on port $VK_PORT"
        return 0
    else
        echo "Vibe Kanban is not running or not accessible"
        return 1
    fi
}

# List all projects
list_projects() {
    curl -s "$VK_BASE/projects" | jq '.data[] | {id, name}'
}

# List tasks in a project
list_tasks() {
    local project_id="$1"
    if [[ -z "$project_id" ]]; then
        echo "Usage: vk-helper.sh list-tasks <project_id>"
        exit 1
    fi
    curl -s "$VK_BASE/tasks?project_id=$project_id" | jq '.data[] | {id, title, status}'
}

# Get task details
get_task() {
    local task_id="$1"
    if [[ -z "$task_id" ]]; then
        echo "Usage: vk-helper.sh get-task <task_id>"
        exit 1
    fi
    curl -s "$VK_BASE/tasks/$task_id" | jq '.data'
}

# Create a task
create_task() {
    local project_id="$1"
    local title="$2"
    local description="${3:-}"

    if [[ -z "$project_id" || -z "$title" ]]; then
        echo "Usage: vk-helper.sh create-task <project_id> <title> [description]"
        exit 1
    fi

    local payload="{\"project_id\":\"$project_id\",\"title\":\"$title\""
    if [[ -n "$description" ]]; then
        payload="$payload,\"description\":\"$description\""
    fi
    payload="$payload}"

    curl -s -X POST "$VK_BASE/tasks" \
        -H "Content-Type: application/json" \
        -d "$payload" | jq '.data'
}

# List repos for a project
list_repos() {
    local project_id="$1"
    if [[ -z "$project_id" ]]; then
        echo "Usage: vk-helper.sh list-repos <project_id>"
        exit 1
    fi
    curl -s "$VK_BASE/repos?project_id=$project_id" | jq '.data[] | {id, name, path}'
}

# Start a workspace session via MCP
start_session() {
    local task_id="$1"
    local repo_id="$2"
    local base_branch="${3:-main}"
    local executor="${4:-CLAUDE_CODE}"

    if [[ -z "$task_id" || -z "$repo_id" ]]; then
        echo "Usage: vk-helper.sh start-session <task_id> <repo_id> [base_branch] [executor]"
        echo "Executors: CLAUDE_CODE, CODEX, GEMINI, AMP, OPENCODE, CURSOR_AGENT, QWEN_CODE, COPILOT, DROID"
        exit 1
    fi

    (cat << EOF
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"vk-helper","version":"1.0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"start_workspace_session","arguments":{"task_id":"$task_id","executor":"$executor","repos":[{"repo_id":"$repo_id","base_branch":"$base_branch"}]}}}
EOF
    sleep 5) | npx -y vibe-kanban@latest --mcp 2>/dev/null | grep -o '{"jsonrpc":"2.0","id":2.*' | jq '.result.content[0].text | fromjson'
}

# MCP call helper
mcp_call() {
    local tool_name="$1"
    local arguments="$2"

    if [[ -z "$tool_name" ]]; then
        echo "Usage: vk-helper.sh mcp-call <tool_name> [arguments_json]"
        exit 1
    fi

    arguments="${arguments:-{}}"

    (cat << EOF
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"vk-helper","version":"1.0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"$tool_name","arguments":$arguments}}
EOF
    sleep 3) | npx -y vibe-kanban@latest --mcp 2>/dev/null | grep -o '{"jsonrpc":"2.0","id":2.*'
}

# Show help
show_help() {
    cat << 'HELP'
Vibe Kanban Helper Script

Commands:
  health                                    Check if Vibe Kanban is running
  list-projects                             List all projects
  list-tasks <project_id>                   List tasks in a project
  get-task <task_id>                        Get task details
  create-task <project_id> <title> [desc]   Create a new task
  list-repos <project_id>                   List repositories in a project
  start-session <task_id> <repo_id> [branch] [executor]
                                            Start a workspace session
  mcp-call <tool_name> [args_json]          Make a raw MCP call

Examples:
  vk-helper.sh health
  vk-helper.sh list-projects
  vk-helper.sh create-task abc-123 "Fix bug" "Bug description"
  vk-helper.sh start-session task-id repo-id main CLAUDE_CODE
HELP
}

# Main command dispatcher
case "${1:-help}" in
    health)
        check_health
        ;;
    list-projects)
        list_projects
        ;;
    list-tasks)
        list_tasks "$2"
        ;;
    get-task)
        get_task "$2"
        ;;
    create-task)
        create_task "$2" "$3" "$4"
        ;;
    list-repos)
        list_repos "$2"
        ;;
    start-session)
        start_session "$2" "$3" "$4" "$5"
        ;;
    mcp-call)
        mcp_call "$2" "$3"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
