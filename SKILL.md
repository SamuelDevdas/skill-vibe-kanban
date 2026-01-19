---
name: vibe-kanban
description: |
  Complete Vibe Kanban orchestration from Claude Code. Use when: (1) managing AI coding tasks
  across projects, (2) creating/updating/monitoring tasks programmatically, (3) starting
  workspace sessions with Claude Code, Codex, Gemini, or other agents, (4) integrating with
  Vibe Kanban's MCP server, (5) automating task workflows end-to-end. Covers REST API,
  MCP JSON-RPC protocol, workspace sessions, and task lifecycle management.
author: Claude Code
version: 1.0.0
date: 2026-01-19
---

# Vibe Kanban Integration

Complete guide for controlling Vibe Kanban end-to-end from Claude Code, including REST API, MCP server, and workflow automation.

## Problem

Vibe Kanban is a powerful orchestration tool for AI coding agents, but programmatic control requires understanding multiple interfaces (REST API, MCP server) and their limitations.

## Context / Trigger Conditions

Use this skill when:
- Managing AI coding tasks across multiple projects
- Creating, updating, or monitoring tasks programmatically
- Starting workspace sessions with coding agents (Claude Code, Codex, Gemini, etc.)
- Integrating Claude Code with Vibe Kanban's MCP server
- Automating complete task workflows from planning to execution
- Needing to interact with Vibe Kanban without the UI

## Finding Vibe Kanban Installation

### Check if Running
```bash
# Check for running instance
curl -s http://127.0.0.1:50556/api/health 2>/dev/null
# Returns: {"success":true,"data":"OK","error_data":null,"message":null}

# Find the port file (contains dynamic port)
cat /var/folders/*/vibe-kanban/vibe-kanban.port 2>/dev/null || \
cat "$TMPDIR/vibe-kanban/vibe-kanban.port" 2>/dev/null
```

### Installation Locations
```bash
# Native binary (recommended)
~/.vibe-kanban/bin/*/macos-arm64/vibe-kanban  # macOS ARM
~/.vibe-kanban/bin/*/macos-x64/vibe-kanban    # macOS Intel
~/.vibe-kanban/bin/*/linux-x64/vibe-kanban    # Linux

# NPX (downloads if needed)
npx vibe-kanban
```

### Starting Vibe Kanban
```bash
# Option 1: Native binary (fastest)
~/.vibe-kanban/bin/v*/macos-arm64/vibe-kanban

# Option 2: NPX
npx vibe-kanban

# The UI will be available at http://127.0.0.1:<port>/
```

## REST API Reference

Base URL: `http://127.0.0.1:50556/api` (port may vary)

### Projects

```bash
# List all projects
curl -s "http://127.0.0.1:50556/api/projects" | jq '.'

# Get project details
curl -s "http://127.0.0.1:50556/api/projects/{project_id}" | jq '.'
```

### Tasks (CRUD Operations)

```bash
# List tasks in a project
curl -s "http://127.0.0.1:50556/api/tasks?project_id={project_id}" | jq '.'

# Get task details
curl -s "http://127.0.0.1:50556/api/tasks/{task_id}" | jq '.'

# Create a task
curl -s -X POST "http://127.0.0.1:50556/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{"project_id":"<uuid>","title":"Task title","description":"Optional description"}' | jq '.'

# Update a task (PATCH)
curl -s -X PATCH "http://127.0.0.1:50556/api/tasks/{task_id}" \
  -H "Content-Type: application/json" \
  -d '{"title":"New title","status":"inprogress"}' | jq '.'

# Delete a task
curl -s -X DELETE "http://127.0.0.1:50556/api/tasks/{task_id}"
```

### Repositories

```bash
# List repos (all repos across projects)
curl -s "http://127.0.0.1:50556/api/repos?project_id={project_id}" | jq '.'

# Get repo details
curl -s "http://127.0.0.1:50556/api/repos/{repo_id}" | jq '.'
```

### Task Status Values
- `todo` - Not started
- `inprogress` - Currently being worked on
- `inreview` - Completed, awaiting review
- `done` - Completed and reviewed
- `cancelled` - Cancelled

## MCP Server Integration

The MCP server provides additional capabilities not available via REST API, including starting workspace sessions.

### Adding MCP Server to Claude Code

Add to `~/.claude/settings.json`:
```json
{
  "mcpServers": {
    "vibe_kanban": {
      "command": "npx",
      "args": ["-y", "vibe-kanban@latest", "--mcp"]
    }
  }
}
```

**Restart Claude Code after adding this configuration.**

### MCP Tools Available

| Tool | Purpose | Required Parameters |
|------|---------|---------------------|
| `list_projects` | Fetch all projects | None |
| `list_tasks` | List tasks in a project | `project_id` |
| `create_task` | Create a new task | `project_id`, `title` |
| `get_task` | Get task details | `task_id` |
| `update_task` | Update task details | `task_id` |
| `delete_task` | Delete a task | `task_id` |
| `start_workspace_session` | Start a coding agent on a task | `task_id`, `executor`, `repos` |
| `list_repos` | List repositories in a project | `project_id` |
| `get_repo` | Get repository details | `repo_id` |
| `get_context` | Get current workspace context | None (only in active workspace) |

### Supported Executors
- `CLAUDE_CODE` / `claude-code`
- `CODEX` / `codex`
- `GEMINI` / `gemini`
- `AMP` / `amp`
- `OPENCODE` / `opencode`
- `CURSOR_AGENT` / `cursor_agent`
- `QWEN_CODE` / `qwen-code`
- `COPILOT` / `copilot`
- `DROID` / `droid`

## Direct MCP JSON-RPC Protocol

When MCP tools aren't loaded (before restart), you can interact with the MCP server directly via JSON-RPC:

### Initialize Connection
```bash
(cat << 'EOF'
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"claude-code","version":"1.0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
EOF
sleep 2) | npx -y vibe-kanban@latest --mcp 2>/dev/null
```

### List Projects via MCP
```bash
(cat << 'EOF'
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"list_projects","arguments":{}}}
EOF
sleep 3) | npx -y vibe-kanban@latest --mcp 2>/dev/null
```

### Start Workspace Session via MCP
```bash
(cat << 'EOF'
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"start_workspace_session","arguments":{"task_id":"<task-uuid>","executor":"CLAUDE_CODE","repos":[{"repo_id":"<repo-uuid>","base_branch":"main"}]}}}
EOF
sleep 5) | npx -y vibe-kanban@latest --mcp 2>/dev/null
```

### Get Task Status via MCP
```bash
(cat << 'EOF'
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_task","arguments":{"task_id":"<task-uuid>"}}}
EOF
sleep 3) | npx -y vibe-kanban@latest --mcp 2>/dev/null | grep -o '{"jsonrpc":"2.0","id":2.*'
```

## Complete Workflow Examples

### Workflow 1: Create and Execute a Task

```bash
# Step 1: Get project ID
PROJECT_ID=$(curl -s "http://127.0.0.1:50556/api/projects" | jq -r '.data[0].id')

# Step 2: Get repo ID for the project
REPO_ID=$(curl -s "http://127.0.0.1:50556/api/repos?project_id=$PROJECT_ID" | jq -r '.data[0].id')

# Step 3: Create the task
TASK_RESPONSE=$(curl -s -X POST "http://127.0.0.1:50556/api/tasks" \
  -H "Content-Type: application/json" \
  -d "{\"project_id\":\"$PROJECT_ID\",\"title\":\"Implement feature X\",\"description\":\"Add feature X with tests\"}")
TASK_ID=$(echo $TASK_RESPONSE | jq -r '.data.id')

# Step 4: Start workspace session via MCP
(cat << EOF
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"script","version":"1.0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"start_workspace_session","arguments":{"task_id":"$TASK_ID","executor":"CLAUDE_CODE","repos":[{"repo_id":"$REPO_ID","base_branch":"main"}]}}}
EOF
sleep 5) | npx -y vibe-kanban@latest --mcp 2>/dev/null

# Step 5: Monitor task status
curl -s "http://127.0.0.1:50556/api/tasks/$TASK_ID" | jq '.data.status'
```

### Workflow 2: Batch Task Creation

```bash
PROJECT_ID="your-project-uuid"

# Create multiple tasks from a plan
for task in "Set up database schema" "Create API endpoints" "Add authentication" "Write tests"; do
  curl -s -X POST "http://127.0.0.1:50556/api/tasks" \
    -H "Content-Type: application/json" \
    -d "{\"project_id\":\"$PROJECT_ID\",\"title\":\"$task\"}" | jq '.data.id'
done
```

### Workflow 3: Monitor All In-Progress Tasks

```bash
PROJECT_ID="your-project-uuid"
curl -s "http://127.0.0.1:50556/api/tasks?project_id=$PROJECT_ID" | \
  jq '.data[] | select(.status == "inprogress") | {id, title, status}'
```

## API Limitations

### REST API Cannot:
- Start workspace sessions (use MCP server)
- Execute tasks (use MCP server)
- Access real-time workspace logs

### MCP Server Can:
- All REST API operations
- Start workspace sessions
- Get current workspace context (when in active session)
- Orchestrate coding agents

## Verification

After starting a workspace session:
1. Check task status changes from `todo` to `inprogress` to `inreview`
2. View the Vibe Kanban UI at `http://127.0.0.1:<port>/`
3. Monitor the terminal where the coding agent runs for output

```bash
# Verify task status changed
curl -s "http://127.0.0.1:50556/api/tasks/{task_id}" | jq '.data.status'
# Expected progression: "todo" -> "inprogress" -> "inreview" -> "done"
```

## Troubleshooting

### Port Not Found
```bash
# Find the actual port
lsof -i -P | grep vibe-kanban
# Or check the port file
cat "$TMPDIR/vibe-kanban/vibe-kanban.port"
```

### MCP Connection Issues
```bash
# Verify MCP server can start
npx -y vibe-kanban@latest --mcp --help

# Check if Vibe Kanban backend is running
curl -s http://127.0.0.1:50556/api/health
```

### REST API Returns HTML
Some endpoints return the UI instead of JSON. Use the documented API paths above, which are confirmed to work.

## Notes

- Vibe Kanban is free and open source; you only pay for the underlying AI services
- The MCP server is local-only and cannot be accessed remotely
- Workspace sessions create isolated git worktrees for each task
- Task status automatically updates as the coding agent progresses
- Multiple coding agents can run in parallel on different tasks

## References

- [Vibe Kanban Official Docs](https://www.vibekanban.com/docs)
- [Vibe Kanban MCP Server Guide](https://www.vibekanban.com/docs/integrations/vibe-kanban-mcp-server)
- [GitHub - BloopAI/vibe-kanban](https://github.com/BloopAI/vibe-kanban)
- [MCP Protocol Specification](https://modelcontextprotocol.io/docs)
