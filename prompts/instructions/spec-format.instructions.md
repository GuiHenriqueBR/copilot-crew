---
description: "Use when creating or modifying spec files (.spec.md), planning features, or writing specifications. Ensures specs follow the standard structure."
applyTo: "**/*.spec.md"
---

# Spec File Standards

All spec files must follow this structure:

## Required Frontmatter
```yaml
---
createdAt: {ISO8601 date}
ticket: {ticket ID or "none"}
status: draft | approved | in-progress | completed
---
```

## Required Sections

1. **Requirements** — Functional (user stories + acceptance criteria) + Non-functional
2. **Design** — Technical overview, files affected, data models, error handling, testing strategy
3. **Tasks** — Numbered checklist, TDD-first ordering, references to requirements

## Rules

- Every user story follows: `AS A [role], I WANT [feature], SO THAT [benefit]`
- Every acceptance criterion follows EARS: `WHEN [trigger], THEN the system SHALL [action]`
- Every task references which requirement it fulfills
- Tasks are ordered: write test → implement → verify
- Mermaid diagrams for component graphs (new=green, changed=yellow, removed=red)
- Status must be updated as the spec progresses through the workflow
