<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Skill-blueviolet?style=for-the-badge&logo=anthropic" alt="Claude Code Skill"/>
  <img src="https://img.shields.io/badge/Vibe%20Kanban-Integration-ff6b6b?style=for-the-badge" alt="Vibe Kanban"/>
  <img src="https://img.shields.io/github/license/SamuelDevdas/skill-vibe-kanban?style=for-the-badge&cacheSeconds=0" alt="License"/>
  <img src="https://img.shields.io/github/stars/SamuelDevdas/skill-vibe-kanban?style=for-the-badge" alt="Stars"/>
</p>

<h1 align="center">Vibe Kanban Skill for Claude Code</h1>

<p align="center">
  <strong>Control AI coding agents like a boss. One skill to orchestrate them all.</strong>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-features">Features</a> •
  <a href="#-demo">Demo</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-support">Support</a>
</p>

---

## 🔥 Why This Skill?

> **"I went from manually managing 5 AI agents to orchestrating 50+ tasks automatically. This skill changed everything."**

Stop switching between terminals. Stop losing track of tasks. **Start orchestrating AI agents like a pro.**

| Before | After |
|--------|-------|
| Manually track tasks | Automated task lifecycle |
| One agent at a time | Parallel agent execution |
| Copy-paste between tools | Seamless API integration |
| Lose context switching | Everything in Claude Code |

## ✨ Features

- **🎯 Full REST API** - CRUD operations for projects, tasks, repos
- **🔌 MCP Protocol** - Direct JSON-RPC integration
- **🚀 Workspace Sessions** - Start any agent programmatically
- **📊 Task Monitoring** - Real-time status tracking
- **🛠️ Helper Scripts** - One-liners for common ops
- **🤖 Multi-Agent** - Claude, Codex, Gemini, Amp & more

## 🎬 Demo

```bash
# Create a task and kick off Claude Code in 3 commands:
PROJECT=$(vk-helper.sh list-projects | jq -r '.[0].id')
TASK=$(vk-helper.sh create-task $PROJECT "Build landing page" | jq -r '.id')
vk-helper.sh start-session $TASK $REPO_ID main CLAUDE_CODE

# 🎉 Claude Code is now working on your task!
```

## ⚡ Quick Start

**30 seconds to orchestration:**

```bash
# 1. Install the skill
git clone https://github.com/SamuelDevdas/skill-vibe-kanban.git ~/.claude/skills/vibe-kanban

# 2. Check connection
~/.claude/skills/vibe-kanban/scripts/vk-helper.sh health

# 3. Start orchestrating!
~/.claude/skills/vibe-kanban/scripts/vk-helper.sh list-projects
```

## 📦 Installation

### Option 1: One-Line Install (Recommended)

```bash
git clone https://github.com/SamuelDevdas/skill-vibe-kanban.git ~/.claude/skills/vibe-kanban
```

### Option 2: With MCP Integration

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

Then restart Claude Code.

## 🎮 Usage

### Helper Script Commands

| Command | What it does |
|---------|--------------|
| `vk-helper.sh health` | Check if Vibe Kanban is alive |
| `vk-helper.sh list-projects` | Show all your projects |
| `vk-helper.sh list-tasks <id>` | Show tasks in a project |
| `vk-helper.sh create-task <proj> <title>` | Create a new task |
| `vk-helper.sh start-session <task> <repo> <branch> <agent>` | Launch an agent |

### Supported Agents

| Agent | Status |
|-------|--------|
| Claude Code | ✅ Fully supported |
| OpenAI Codex | ✅ Fully supported |
| Google Gemini | ✅ Fully supported |
| Sourcegraph Amp | ✅ Fully supported |
| Cursor Agent | ✅ Fully supported |
| GitHub Copilot | ✅ Fully supported |

## 📖 Documentation

- **[SKILL.md](SKILL.md)** - Complete API reference
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute
- **[CHANGELOG.md](CHANGELOG.md)** - Version history

## 🌟 Show Your Support

**If this skill saved you time, please:**

1. ⭐ **Star this repo** - It helps others discover it
2. 🐦 **Tweet about it** - Share with `#VibeKanbanSkill #ClaudeCode`
3. 📝 **Write about it** - Blog posts, tutorials welcome
4. 💖 **Sponsor** - [GitHub Sponsors](https://github.com/sponsors/SamuelDevdas)

## 🤝 Contributing

Contributions make open source amazing! See [CONTRIBUTING.md](CONTRIBUTING.md).

```bash
# Fork, clone, branch, code, PR!
git checkout -b feature/amazing-feature
```

## 📣 Spread the Word

**Copy-paste for Twitter/X:**
```
Just discovered this Claude Code skill for Vibe Kanban - orchestrate AI coding agents from your terminal! 🔥

One command to create tasks, start agents, monitor progress.

Check it out: github.com/SamuelDevdas/skill-vibe-kanban

#ClaudeCode #VibeKanban #AI #DevTools
```

**Copy-paste for LinkedIn:**
```
🚀 Exciting discovery for AI-assisted development!

This Claude Code skill lets you orchestrate multiple AI coding agents (Claude, Codex, Gemini) from a single interface.

Features:
✅ REST API integration
✅ MCP protocol support
✅ Multi-agent orchestration
✅ Automated task management

Perfect for teams managing complex development workflows.

Link: github.com/SamuelDevdas/skill-vibe-kanban

#AI #SoftwareDevelopment #ClaudeCode #DevTools #Automation
```

## 📜 License

MIT License - Use it, fork it, ship it! See [LICENSE](LICENSE).

**Attribution appreciated** - Star the repo, link back, share the love!

---

<p align="center">
  <strong>Built with ❤️ by <a href="https://github.com/SamuelDevdas">Samuel Devdas</a></strong>
</p>

<p align="center">
  <a href="https://github.com/SamuelDevdas/skill-vibe-kanban/stargazers">⭐ Star</a> •
  <a href="https://github.com/SamuelDevdas/skill-vibe-kanban/fork">🍴 Fork</a> •
  <a href="https://twitter.com/intent/tweet?text=Check%20out%20this%20Claude%20Code%20skill%20for%20Vibe%20Kanban!&url=https://github.com/SamuelDevdas/skill-vibe-kanban">🐦 Tweet</a>
</p>

