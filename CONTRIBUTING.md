# Contributing to Copilot Crew

Thank you for helping make AI agents smarter! Here's how to contribute.

## What You Can Contribute

| Type | Directory | Template |
|------|-----------|----------|
| **Agent** | `prompts/agents/` | [`community/agent-template.agent.md`](community/agent-template.agent.md) |
| **Skill** | `skills/[name]/` | [`community/skill-template/SKILL.md`](community/skill-template/SKILL.md) |
| **Prompt** | `prompts/` | [`community/prompt-template.prompt.md`](community/prompt-template.prompt.md) |
| **Instruction** | `prompts/instructions/` | See existing instructions for format |

## How to Contribute

### 1. Fork & Clone
```bash
git clone https://github.com/YOUR_USERNAME/copilot-crew.git
cd copilot-crew
```

### 2. Create a Branch
```bash
git checkout -b feat/your-agent-name
```

### 3. Create Your File
Use the appropriate template from `community/` as a starting point.

### 4. Test It
Install locally and verify your agent/skill/prompt works:
```bash
# Windows
.\install.ps1

# macOS / Linux
bash install.sh
```

Open VS Code, trigger your agent/prompt, and verify the output.

### 5. Submit a PR
```bash
git add .
git commit -m "feat: add [name] agent/skill/prompt"
git push origin feat/your-agent-name
```

Then open a Pull Request on GitHub.

## Quality Checklist

Before submitting, verify:

- [ ] **YAML frontmatter** is valid (description, mode/model, tools)
- [ ] **Description** is clear and accurate (it's shown in VS Code menus)
- [ ] **No hardcoded paths** — works on Windows, macOS, and Linux
- [ ] **No secrets or personal data** in the file
- [ ] **Tested locally** — the agent/skill/prompt produces useful output
- [ ] **Follows naming conventions** — see `prompts/instructions/file-naming.instructions.md`
- [ ] **Single responsibility** — does one thing well
- [ ] **Includes examples** — show good and bad patterns in skills

## Agent Quality Standards

A good agent:
- Has a clear **role statement** ("You are an expert in X")
- Defines a **concrete workflow** (numbered steps)
- Specifies **what NOT to do** (rules/constraints)
- Uses the right **tools** (read-only agents don't need edit/execute)
- Reports results in a **structured format**

A good skill:
- Shows **GOOD vs BAD** code patterns with explanations
- Lists **anti-patterns** with fixes
- Includes a **verification checklist**
- Has clear **trigger keywords** in the description

## File Naming

- Agents: `kebab-case.agent.md`
- Skills: `kebab-case/SKILL.md`
- Prompts: `kebab-case.prompt.md`
- Instructions: `kebab-case.instructions.md`

## Code of Conduct

- Be respectful and constructive
- Focus on making agents genuinely useful
- Test before submitting
- Keep files focused and concise
