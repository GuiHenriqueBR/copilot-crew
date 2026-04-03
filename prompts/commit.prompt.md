---
description: "Gera mensagem de commit semântica analisando o git diff atual."
---

# Generate Commit Message

Analyze the current git diff and generate a proper commit message following **Conventional Commits**.

## Format
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## Types
- `feat`: new feature
- `fix`: bug fix
- `refactor`: code change that neither fixes a bug nor adds a feature
- `style`: formatting, missing semicolons, etc. (no code change)
- `docs`: documentation only
- `test`: adding or updating tests
- `chore`: build process, dependencies, tooling
- `perf`: performance improvement
- `ci`: CI/CD changes

## Rules
1. Run `git diff --staged` (or `git diff` if nothing staged) to see actual changes
2. Analyze WHAT changed and WHY
3. Write description in imperative mood: "add" not "added" or "adds"
4. Keep subject line under 72 characters
5. Scope should be the module/component affected
6. Body explains WHY the change was needed (not WHAT, the diff shows that)
7. If multiple unrelated changes, suggest splitting into separate commits
8. Include `BREAKING CHANGE:` footer if applicable

Generate the message — don't ask what changed.
