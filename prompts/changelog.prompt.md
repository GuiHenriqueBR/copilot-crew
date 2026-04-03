---
description: "Analisa o git log e gera um changelog formatado (formato Keep a Changelog)."
---

# Generate Changelog

Analyze the git history and generate a changelog.

- **Since**: ${input:since}

## Rules
1. Run `git log --oneline` for the specified range
2. Group commits by type (Added, Changed, Fixed, Removed, Security, Deprecated)
3. Follow **Keep a Changelog** format (https://keepachangelog.com)
4. Write entries from the USER's perspective — what changed for them, not implementation details
5. Merge related commits into single entries
6. Skip internal refactors, CI changes, and trivial formatting commits
7. Include the date and version number if provided

## Output Format
```markdown
## [Version] - YYYY-MM-DD

### Added
- New feature descriptions

### Changed
- Modified behavior descriptions

### Fixed
- Bug fix descriptions

### Removed
- Removed feature descriptions
```
