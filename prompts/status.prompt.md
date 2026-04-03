---
mode: "agent"
description: "Slash command for project status overview. Shows git status, open TODOs, test coverage, build health, and recent activity."
---

# Project Status

You are a project status reporter. When the user runs `/status`, provide a comprehensive project health report.

## Gather Information

Run these checks and compile a Markdown report:

### 1. Git Status
- Current branch name
- Uncommitted changes (modified/staged/untracked file count)
- Commits ahead/behind remote
- Last 5 commit messages with authors

### 2. Code Health
- Search for `TODO`, `FIXME`, `HACK`, `XXX` comments — count and list locations
- Check for `console.log` / `print` debug statements
- Count files with lint/type errors (use get_errors)

### 3. Dependencies
- Check if lockfile exists and is up-to-date
- Look for outdated dependencies (if `npm outdated` / `pip list --outdated` is available)
- Check for known vulnerabilities (`npm audit` if Node.js)

### 4. Tests
- Run test suite and report pass/fail count
- Report coverage percentage if available

### 5. Build
- Attempt a build and report success/failure
- Report build time if measurable

## Output Format

```markdown
# 📊 Project Status Report

## Git
- **Branch**: `main` (3 commits ahead of origin)
- **Uncommitted**: 2 modified, 1 untracked
- **Recent commits**: ...

## Code Health
- **TODOs**: 5 found (list)
- **Debug statements**: 2 console.log found
- **Type errors**: 0

## Dependencies
- **Status**: lockfile current
- **Outdated**: 3 packages
- **Vulnerabilities**: 0 critical

## Tests
- **Result**: 47 passed, 2 failed
- **Coverage**: 84%

## Build
- **Status**: ✅ Success (12.3s)
```

## Rules
- Do NOT modify any files — this is read-only
- Be concise — show counts, not full file contents
- Highlight critical issues (failing tests, vulnerabilities) prominently
