# Contributing to Vibe Kanban Skill

Thank you for your interest in contributing! This document provides guidelines for contributing to this Claude Code skill.

## How to Contribute

### Reporting Issues

- Check existing issues before creating a new one
- Use a clear, descriptive title
- Include steps to reproduce the issue
- Include your environment details (OS, Claude Code version, Vibe Kanban version)

### Suggesting Features

- Open an issue with the "enhancement" label
- Describe the use case and expected behavior
- Explain why this would benefit other users

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear, descriptive messages
6. Push to your fork
7. Open a Pull Request

## Development Guidelines

### Skill Files (SKILL.md)

- Follow the established YAML frontmatter format
- Keep descriptions specific and searchable
- Include concrete examples
- Document all trigger conditions
- Add references for external sources

### Scripts

- Use `#!/bin/bash` shebang
- Add `set -e` for error handling
- Include usage documentation
- Handle edge cases gracefully
- Test on both macOS and Linux if possible

### Commit Messages

Follow conventional commits:
- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Example: `feat: add support for batch task creation`

### Code Style

- Use consistent indentation (2 spaces for JSON, 4 spaces for bash)
- Add comments for non-obvious logic
- Keep functions focused and single-purpose
- Use meaningful variable names

## Testing

Before submitting:

1. Verify Vibe Kanban integration works:
   ```bash
   ./scripts/vk-helper.sh health
   ```

2. Test all modified commands:
   ```bash
   ./scripts/vk-helper.sh list-projects
   ./scripts/vk-helper.sh list-tasks <project_id>
   ```

3. Verify MCP commands work:
   ```bash
   ./scripts/vk-helper.sh mcp-call list_projects '{}'
   ```

## Questions?

Open an issue or start a discussion. We're happy to help!
