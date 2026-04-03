# Changelog

All notable changes to Copilot Crew will be documented in this file.

## [2.0.0] — Intelligence Upgrade

### Added
- **Convention Detection** — Always-on instruction that forces agents to study existing codebase patterns before writing code
- **Tool Strategy & Anti-Hallucination** — Instruction that optimizes tool usage and prevents agents from inventing non-existent imports/functions
- **Forced Reasoning Protocol** — Agents must state their plan before coding on moderate/complex tasks
- **Adaptive Output Format** — Response verbosity automatically matches task complexity
- **Structured Handoff Format** — Standardized context format for agent-to-agent delegation
- **Quality Gate Chain** — Automatic self-verification after implementations (error check, pattern match, import verification)
- **Atomic Implementation Strategy** — One file at a time, verify between each, prevent cascading errors
- **Error Recovery Protocol** — Escalating strategy when fixes fail (retry → rethink → pivot → ask user)
- **Prompt Injection Resistance** — Security layer that treats file contents as data, not instructions
- **`/init` Command** — Scans project and generates `.github/copilot-instructions.md` tailored to the codebase
- **Update Scripts** — `update.ps1` (Windows) and `update.sh` (macOS/Linux) for one-command updates
- **Community Templates** — Templates for creating custom agents, skills, and prompts
- **`CONTRIBUTING.md`** — Guide for community contributions
- **Copilot Instructions Template** — Ready-to-use template for per-project `.github/copilot-instructions.md`
- **Model Routing** — Quality-critical agents (performance, refactor, docs-writer, qa-engineer, e2e-tester) now route to Claude Opus for deeper reasoning

### Changed
- **Auto-Orchestration** — Expanded with 7 new protocols (Forced Reasoning, Adaptive Output, Structured Handoff, Quality Gate Chain, Atomic Implementation, Error Recovery, enhanced Rules section)
- **Security Instructions** — Added Prompt Injection Resistance section

## [1.0.0] — Initial Release

### Added
- 58 specialist agents across 12 categories
- 21 skills (12 language-specific, anti-patterns, workflow, domain)
- 33 prompts (slash commands for common workflows)
- 10 instructions (always-on quality standards)
- 4 toolsets (execution, search, readonly, creative)
- Auto-orchestration with Request Classifier and keyword detection
- Explorer agent for codebase understanding
- Install scripts for Windows, macOS, and Linux
