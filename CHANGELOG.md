# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-19

### Added
- Initial release of Vibe Kanban skill for Claude Code
- Complete REST API documentation and examples
- MCP JSON-RPC protocol integration
- `vk-helper.sh` script with commands:
  - `health` - Check Vibe Kanban status
  - `list-projects` - List all projects
  - `list-tasks` - List tasks in a project
  - `get-task` - Get task details
  - `create-task` - Create new tasks
  - `list-repos` - List repositories
  - `start-session` - Start workspace sessions
  - `mcp-call` - Raw MCP calls
- Support for all Vibe Kanban executors (Claude Code, Codex, Gemini, etc.)
- Complete workflow examples
- Troubleshooting guide

### Documentation
- Comprehensive SKILL.md with API reference
- README with quick start guide
- CONTRIBUTING guidelines
