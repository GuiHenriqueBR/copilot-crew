# Copilot Crew 🚀

**Transform GitHub Copilot into a full development team.**

Copilot Crew is a curated kit of **58 specialist agents**, **33 slash commands**, **21 skills**, and **10 always-on coding standards** that turn VS Code + GitHub Copilot into an autonomous multi-agent development environment.

> Just describe what you want in plain language — Copilot Crew automatically routes your request to the right specialist agent.

---

## What's Included

| Category | Count | Description |
|----------|-------|-------------|
| **Agents** | 58 | Specialist sub-agents for every domain |
| **Prompts** | 33 | Slash commands for common workflows |
| **Instructions** | 10 | Always-active coding standards |
| **Skills** | 21 | Deep language/framework knowledge |
| **Toolsets** | 4 | Tool access profiles |
| **ADR Template** | 1 | Architecture Decision Records |
| **Architecture Map** | 1 | Full kit documentation |

### Agent Categories

| Category | Agents |
|----------|--------|
| **Core Dev** | frontend-dev, backend-dev, node-dev |
| **Languages** | java-dev, go-dev, rust-dev, cpp-dev, python-dev, csharp-dev, swift-dev, kotlin-dev, flutter-dev, php-dev, ruby-dev, elixir-dev, scala-dev, lua-dev, zig-dev |
| **Architecture** | architect, system-designer, stack-advisor, migration-planner |
| **Quality** | code-reviewer, qa-engineer, e2e-tester, security-auditor, performance, visual-auditor |
| **Data** | db-architect, db-dev, data-engineer |
| **DevOps** | devops, git-specialist |
| **Design** | ux-designer, creative, accessibility |
| **Debug** | debugger, explorer |
| **Specialized** | game-dev, unreal-dev, game-designer, ml-engineer, blockchain-dev, embedded-dev, electron-dev, mobile-dev |
| **Workflow** | planner, project-bootstrapper, cross-platform-strategist, dependency-picker, dependency-auditor |
| **Content** | docs-writer, i18n, prompt-improver |
| **Meta** | algorithm-expert, regex-expert, refactor |

### Skills (Language Knowledge)

| Skill | Content |
|-------|---------|
| **typescript-patterns** | Idioms, pitfalls, testing, performance, project structure |
| **go-patterns** | Idioms, concurrency, pitfalls, testing, project structure |
| **java-patterns** | Idioms, Spring Boot, testing, performance |
| **python-patterns** | Idioms, async, testing, typing |
| **rust-patterns** | Ownership, error handling, async, testing |
| **csharp-patterns** | Idioms, .NET/EF Core, testing |
| **php-patterns** | PHP 8.1+, Laravel patterns |
| **ruby-patterns** | Ruby 3+, Rails patterns |
| **kotlin-patterns** | Coroutines, Jetpack Compose |
| **swift-patterns** | SwiftUI, structured concurrency |
| **elixir-patterns** | Phoenix, OTP, LiveView |
| **flutter-patterns** | Dart 3, Riverpod |
| **react-anti-patterns** | Common React mistakes and fixes |
| **node-anti-patterns** | Node.js traps and solutions |
| **common-errors** | Cross-language error database |
| **stack-profiles** | Pre-built tech stack combos |
| **api-documentation** | REST/GraphQL doc patterns |
| **e2e-testing** | End-to-end testing strategies |
| **performance-profiling** | Performance analysis techniques |
| **prompt-engineering** | LLM prompt design |
| **incident-debug** | Production incident debugging |

### Slash Commands

| Command | Purpose |
|---------|---------|
| `/deploy` | Full deployment pipeline with pre-flight checks |
| `/status` | Project health report (git, tests, TODOs, deps) |
| `/preview` | Preview changes with local server |
| `/learn` | Interactive programming tutor |
| `/code-review` | Structured code review |
| `/test-gen` | Generate tests for your code |
| `/refactor` | Guided refactoring |
| `/debug` | Debug helper |
| `/scaffold` | Project scaffolding |
| `/commit` | Conventional commit message helper |
| `/create-pr` | PR creation with template |
| ...and 22 more |

### Always-On Standards

These rules apply to **every interaction** automatically:

- **Auto-Orchestration** — Routes requests to the right agent
- **Clean Code** — Naming, functions, complexity limits
- **Code Completeness** — No TODOs, no placeholders
- **Error Handling** — Proper patterns per language
- **Security** — OWASP top 10, input validation
- **Testing** — Testing pyramid, AAA pattern
- **Git Conventions** — Conventional commits, branch naming
- **File Naming** — Per-framework conventions
- **Import Organization** — Consistent ordering
- **Spec Format** — Specification document structure

---

## Installation

### Prerequisites

- [VS Code](https://code.visualstudio.com/) with [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) extension
- GitHub Copilot Chat enabled

### Windows (PowerShell)

```powershell
git clone https://github.com/YOUR_USERNAME/copilot-crew.git
cd copilot-crew
.\install.ps1
```

### macOS / Linux (Bash)

```bash
git clone https://github.com/YOUR_USERNAME/copilot-crew.git
cd copilot-crew
chmod +x install.sh
./install.sh
```

### Manual Installation

If you prefer to install manually:

1. Copy `skills/` contents → `~/.copilot/skills/`
2. Copy `prompts/` contents → VS Code User prompts folder:
   - **Windows**: `%APPDATA%\Code\User\prompts\`
   - **macOS**: `~/Library/Application Support/Code/User/prompts/`
   - **Linux**: `~/.config/Code/User/prompts/`

### After Installation

Restart VS Code. The kit is **globally active** — no per-project setup needed.

---

## How It Works

```
You type a request in plain language
         │
         ▼
┌─────────────────────────────┐
│   Auto-Orchestration Layer  │  ← Classifies & routes
│   (Request Classifier)      │
└──────────┬──────────────────┘
           │
    ┌──────┴──────┐
    │  Complexity  │
    │    Tier?     │
    └──────┬──────┘
           │
  ┌────────┼────────┬────────┐
  ▼        ▼        ▼        ▼
QUESTION  SIMPLE  MODERATE  COMPLEX
Answer    Do it   1-2       2+ agents
directly  myself  agents    + planning
```

### Request Classification

| Tier | Example | Action |
|------|---------|--------|
| **Question** | "O que é CQRS?" | Answer directly |
| **Simple** | "Renomeia essa variável" | Do it — no delegation |
| **Moderate** | "Cria um endpoint de users" | Delegate to backend-dev |
| **Complex** | "Cria um sistema de auth completo" | Plan → backend-dev → db-dev → security-auditor |
| **Design** | "Cria uma tela bonita de login" | ux-designer → frontend-dev → visual-auditor |
| **Exploration** | "Onde fica o código de auth?" | explorer agent |

---

## Uninstalling

### Windows

```powershell
.\uninstall.ps1
```

### macOS / Linux

```bash
./uninstall.sh
```

This removes all Copilot Crew files but **keeps a backup** at `~/.copilot-crew-backup/`.

---

## Customization

### Adding Your Own Agents

Create a `.agent.md` file in `prompts/agents/`:

```markdown
---
mode: "agent"
description: "What this agent does"
tools: ["semantic_search", "read_file", "replace_string_in_file"]
---

# Agent Name

You are a specialist in [domain]. Your role is to...
```

### Adding Your Own Skills

Create a folder in `skills/` with a `SKILL.md`:

```markdown
---
name: my-skill
description: "When to load this skill"
---

# My Skill

## Content here...
```

### Adding Slash Commands

Create a `.prompt.md` file in `prompts/`:

```markdown
---
mode: "agent"
description: "What this command does"
---

# Command Name

Steps to execute...
```

---

## Architecture

See [ARCHITECTURE.md](prompts/ARCHITECTURE.md) for the full kit map including all agents, skills, instructions, and how they connect.

---

## Contributing

1. Fork this repo
2. Create a branch: `feat/my-agent` or `feat/my-skill`
3. Add your agent/skill/prompt following the patterns above
4. Submit a PR with a description of what you added

---

## License

[MIT](LICENSE) — Use it, modify it, share it.
