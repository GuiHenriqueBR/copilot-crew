# Kit Architecture

> Auto-generated architecture map of the VS Code Copilot customization kit.

## Overview

This kit transforms GitHub Copilot into a **multi-agent development team** with specialized agents, reusable skills, workflow automations, and enforced coding standards.

```
┌──────────────────────────────────────────────────────┐
│                   User Request                        │
└───────────────┬──────────────────────────────────────┘
                │
                ▼
┌──────────────────────────────────────────────────────┐
│         auto-orchestration.instructions.md            │
│   (Tech Lead — routes requests to specialist agents)  │
│                                                       │
│   Intent Detection → Keyword Matching → Delegation    │
└───────┬──────────┬──────────┬──────────┬─────────────┘
        │          │          │          │
        ▼          ▼          ▼          ▼
   ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
   │ Agent  │ │ Agent  │ │ Agent  │ │ Agent  │
   │  Pool  │ │  Pool  │ │  Pool  │ │  Pool  │
   │(57 AI) │ │(Skills)│ │(Instr.)│ │(Prompts│
   └────────┘ └────────┘ └────────┘ └────────┘
```

## Directory Layout

```
~/.copilot/skills/                    # Reusable knowledge skills
├── api-documentation/                # REST/GraphQL API doc patterns
├── e2e-testing/                      # E2E testing strategies
├── incident-debug/                   # Production incident debugging
├── performance-profiling/            # Performance analysis
├── prompt-engineering/               # LLM prompt design
├── typescript-patterns/              # TS idioms, pitfalls, testing, perf
├── go-patterns/                      # Go idioms, concurrency, testing
├── java-patterns/                    # Java 21+, Spring Boot, testing
├── python-patterns/                  # Python 3.11+, async, typing
├── rust-patterns/                    # Ownership, error handling, async
├── csharp-patterns/                  # C# 12, .NET 8+, EF Core
├── php-patterns/                     # PHP 8.1+, Laravel
├── ruby-patterns/                    # Ruby 3+, Rails
├── kotlin-patterns/                  # Kotlin, Jetpack Compose
├── swift-patterns/                   # Swift, SwiftUI, structured concurrency
├── elixir-patterns/                  # Elixir, Phoenix, OTP
├── flutter-patterns/                 # Dart 3, Riverpod
├── react-anti-patterns/              # React mistakes and fixes
├── node-anti-patterns/               # Node.js traps and solutions
├── common-errors/                    # Cross-language error database
└── stack-profiles/                   # Pre-built tech stack combos

~/AppData/Roaming/Code/User/prompts/  # VS Code prompts root
├── instructions/                     # Always-active rules
│   ├── auto-orchestration.instructions.md  # Agent routing
│   ├── clean-code.instructions.md          # Naming, functions, complexity
│   ├── code-completeness.instructions.md   # No TODOs, no placeholders
│   ├── error-handling.instructions.md      # Error patterns per language
│   ├── file-naming.instructions.md         # File naming conventions
│   ├── git-conventions.instructions.md     # Commits, branches, PRs
│   ├── import-organization.instructions.md # Import ordering
│   ├── security.instructions.md            # OWASP, auth, secrets
│   ├── spec-format.instructions.md         # Spec document structure
│   └── testing.instructions.md             # Testing pyramid, AAA pattern
│
├── agents/                           # Specialist sub-agents (57)
│   ├── accessibility.agent.md
│   ├── algorithm-expert.agent.md
│   ├── api-designer.agent.md
│   ├── architect.agent.md
│   ├── backend-dev.agent.md
│   ├── blockchain-dev.agent.md
│   ├── code-reviewer.agent.md
│   ├── cpp-dev.agent.md
│   ├── creative.agent.md
│   ├── cross-platform-strategist.agent.md
│   ├── csharp-dev.agent.md
│   ├── data-engineer.agent.md
│   ├── db-architect.agent.md
│   ├── db-dev.agent.md
│   ├── debugger.agent.md
│   ├── dependency-auditor.agent.md
│   ├── dependency-picker.agent.md
│   ├── devops.agent.md
│   ├── docs-writer.agent.md
│   ├── e2e-tester.agent.md
│   ├── electron-dev.agent.md
│   ├── elixir-dev.agent.md
│   ├── embedded-dev.agent.md
│   ├── explorer.agent.md          ← NEW
│   ├── flutter-dev.agent.md
│   ├── frontend-dev.agent.md
│   ├── game-designer.agent.md
│   ├── game-dev.agent.md
│   ├── git-specialist.agent.md
│   ├── go-dev.agent.md
│   ├── i18n.agent.md
│   ├── java-dev.agent.md
│   ├── kotlin-dev.agent.md
│   ├── lua-dev.agent.md
│   ├── migration-planner.agent.md
│   ├── ml-engineer.agent.md
│   ├── mobile-dev.agent.md
│   ├── node-dev.agent.md
│   ├── performance.agent.md
│   ├── php-dev.agent.md
│   ├── planner.agent.md
│   ├── project-bootstrapper.agent.md
│   ├── prompt-improver.agent.md
│   ├── python-dev.agent.md
│   ├── qa-engineer.agent.md
│   ├── refactor.agent.md
│   ├── regex-expert.agent.md
│   ├── ruby-dev.agent.md
│   ├── rust-dev.agent.md
│   ├── scala-dev.agent.md
│   ├── security-auditor.agent.md
│   ├── stack-advisor.agent.md
│   ├── swift-dev.agent.md
│   ├── system-designer.agent.md
│   ├── tech-lead.agent.md
│   ├── unreal-dev.agent.md
│   ├── ux-designer.agent.md
│   ├── visual-auditor.agent.md
│   └── zig-dev.agent.md
│
├── *.prompt.md                       # Slash commands / workflows
│   ├── api-design.prompt.md          # API design helper
│   ├── audit-site.prompt.md          # Site audit
│   ├── brainstorm.prompt.md          # Brainstorming
│   ├── changelog.prompt.md           # Changelog generation
│   ├── code-review.prompt.md         # Code review
│   ├── commit.prompt.md              # Commit message helper
│   ├── compare.prompt.md             # Code comparison
│   ├── convert-language.prompt.md    # Language conversion
│   ├── create-icon.prompt.md         # Icon generation
│   ├── create-pr.prompt.md           # PR creation
│   ├── debug.prompt.md               # Debug helper
│   ├── deploy.prompt.md              # Deploy pipeline        ← NEW
│   ├── dev-workflow.prompt.md        # Development workflow
│   ├── diagram.prompt.md             # Diagram creation
│   ├── dockerfile.prompt.md          # Dockerfile helper
│   ├── env-setup.prompt.md           # Environment setup
│   ├── error-explain.prompt.md       # Error explanation
│   ├── explain-code.prompt.md        # Code explanation
│   ├── full-pipeline.prompt.md       # Full pipeline
│   ├── improve-prompt.prompt.md      # Prompt improvement
│   ├── learn.prompt.md               # Interactive learning    ← NEW
│   ├── migration.prompt.md           # Migration helper
│   ├── naming.prompt.md              # Naming helper
│   ├── optimize.prompt.md            # Optimization
│   ├── plan.prompt.md                # Planning
│   ├── preview.prompt.md             # Preview changes         ← NEW
│   ├── refactor.prompt.md            # Refactoring
│   ├── regex.prompt.md               # Regex helper
│   ├── review-changes.prompt.md      # Review changes
│   ├── scaffold.prompt.md            # Project scaffolding
│   ├── status.prompt.md              # Project status          ← NEW
│   └── test-gen.prompt.md            # Test generation
│
├── *.toolsets.jsonc                   # Tool restrictions
├── ARCHITECTURE.md                   # This file                ← NEW
└── adr/                              # Architecture Decision Records ← NEW
    └── template.md
```

## Agent Categories

| Category | Agents | Purpose |
|----------|--------|---------|
| **Core Dev** | frontend-dev, backend-dev, node-dev | Feature implementation |
| **Language Specialists** | java-dev, go-dev, rust-dev, cpp-dev, python-dev, csharp-dev, swift-dev, kotlin-dev, flutter-dev, php-dev, ruby-dev, elixir-dev, scala-dev, lua-dev, zig-dev | Language-specific expertise |
| **Architecture** | architect, system-designer, stack-advisor, migration-planner | System design & decisions |
| **Quality** | code-reviewer, qa-engineer, e2e-tester, security-auditor, performance, visual-auditor | Code quality & security |
| **Data** | db-architect, db-dev, data-engineer | Database & data pipelines |
| **DevOps** | devops, git-specialist | CI/CD, deployments, git |
| **Design** | ux-designer, creative, accessibility | UI/UX & visual design |
| **Debug** | debugger, incident-debug (skill) | Production issues & debugging |
| **Specialized** | game-dev, unreal-dev, game-designer, ml-engineer, blockchain-dev, embedded-dev, electron-dev, mobile-dev | Domain-specific development |
| **Workflow** | planner, project-bootstrapper, cross-platform-strategist, dependency-picker, dependency-auditor | Planning & project management |
| **Content** | docs-writer, i18n, prompt-improver | Documentation & content |
| **Exploration** | explorer | Codebase mapping & understanding |
| **Meta** | algorithm-expert, regex-expert, refactor | Problem-solving tools |

## Request Flow

1. **User writes a message** in natural language (Portuguese or English)
2. **auto-orchestration** detects intent via keyword matching
3. **Routing** delegates to the best specialist agent(s)
4. **Agent executes** using its tools, skills, and instructions
5. **Quality gates** run automatically (code-reviewer + security-auditor when applicable)
6. **Report** back with summary of changes

## Instruction Layers (always active)

All instructions in `instructions/` are applied to every interaction:

- **auto-orchestration** — Routes requests to agents
- **clean-code** — Enforces naming, function design, complexity limits
- **code-completeness** — Prevents TODOs, placeholders, empty catches
- **error-handling** — Proper error patterns per language
- **file-naming** — File naming conventions per framework
- **git-conventions** — Conventional commits, branch naming, PR templates
- **import-organization** — Consistent import ordering
- **security** — OWASP top 10, input validation, auth, secrets
- **spec-format** — Specification document structure
- **testing** — Testing pyramid, AAA pattern, mocking rules

## Skills (loaded on demand)

Skills are loaded when their trigger keywords match the context:

| Skill | Triggers | Content |
|-------|----------|---------|
| typescript-patterns | .ts, .tsx, tsconfig | Idioms, pitfalls, testing, performance, project structure |
| go-patterns | .go, go.mod | Idioms, concurrency, pitfalls, testing, project structure |
| java-patterns | .java, pom.xml | Idioms, Spring Boot, testing, performance |
| python-patterns | .py, pyproject.toml | Idioms, async, testing, typing |
| rust-patterns | .rs, Cargo.toml | Idioms, error handling, async, testing |
| csharp-patterns | .cs, .csproj | Idioms, .NET, EF Core, testing |
| react-anti-patterns | React, component | Common React mistakes and fixes |
| node-anti-patterns | Node.js, Express | Node.js traps and solutions |
| common-errors | debug, error, crash | Cross-language error database |
| stack-profiles | stack, new project | Pre-built technology stack profiles |
| api-documentation | API docs, OpenAPI | API documentation patterns |
| e2e-testing | E2E, Playwright | End-to-end testing strategies |
| performance-profiling | slow, profiling | Performance analysis techniques |
| prompt-engineering | prompt, LLM | Prompt design and optimization |
| incident-debug | incident, production | Production incident debugging |
