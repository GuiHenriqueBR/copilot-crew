---
description: "Use when making git commits, creating branches, writing PR descriptions, or managing git workflow."
applyTo: "**"
---

# Git Conventions

## Branch Naming
```
feat/<ticket>-<description>    → feat/123-add-user-profile
fix/<ticket>-<description>     → fix/456-login-redirect
refactor/<description>         → refactor/extract-auth-service
chore/<description>            → chore/update-dependencies
hotfix/<description>           → hotfix/critical-payment-bug
```

## Commit Messages (Conventional Commits)
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
- `feat`: new feature (triggers MINOR version bump)
- `fix`: bug fix (triggers PATCH version bump)
- `refactor`: code restructuring (no behavior change)
- `style`: formatting only (no code change)
- `docs`: documentation
- `test`: adding/updating tests
- `chore`: tooling, dependencies, CI
- `perf`: performance improvement
- `ci`: CI/CD changes
- `build`: build system changes

### Rules
- Subject line: imperative mood, lowercase, no period, max 72 chars
- Body: explain WHY, not WHAT (the diff shows what)
- One logical change per commit
- `BREAKING CHANGE:` footer for breaking changes

## PR Description Template
```markdown
## What
Brief description of what this PR does.

## Why
Why is this change needed? Link to issue/ticket.

## How
Key implementation decisions and trade-offs.

## Testing
How was this tested? What should reviewers test?

## Screenshots
Before/after if UI changed.
```
