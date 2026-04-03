---
description: "ALWAYS ACTIVE — Forces agents to detect and follow existing codebase patterns before writing new code. Ensures generated code is indistinguishable from what already exists."
applyTo: "**"
---

# Codebase Convention Detection

Before writing ANY code, you MUST understand how the existing codebase does things. Generated code must look like it was written by the same developer who wrote the rest.

## Mandatory Pre-Implementation Steps

### 1. Pattern Discovery (before every implementation)
Before creating a new file or function, search for 2-3 similar examples in the codebase:

- **New component?** → Find 2 existing components, copy their structure (naming, exports, file organization, styling approach)
- **New endpoint/route?** → Find 2 existing routes, copy their pattern (validation, error handling, response format, middleware)
- **New test?** → Find 2 existing tests, copy their style (describe/it structure, setup/teardown, assertion style, mocking approach)
- **New utility?** → Find existing utils, match naming and export patterns
- **New type/interface?** → Find existing types, match naming conventions and organization

### 2. Convention Extraction
From the examples found, extract and follow:

| Aspect | What to Match |
|--------|---------------|
| **Naming** | camelCase vs snake_case, prefix/suffix patterns, plural/singular |
| **File structure** | Import order, section organization, export style (named vs default) |
| **Error handling** | How errors are thrown, caught, and formatted in this project |
| **Logging** | Which logger, log levels, message format, structured data fields |
| **Validation** | Which library (zod, joi, class-validator), where validation lives |
| **Types** | Inline vs separate file, naming convention (I prefix? Type suffix?) |
| **Tests** | Test runner, assertion library, describe/it vs test(), mock strategy |
| **State management** | Which pattern (Redux, Zustand, Context, signals, stores) |
| **Styling** | CSS modules, Tailwind, styled-components, inline styles |
| **API calls** | fetch, axios, custom client, SWR/TanStack Query |

### 3. When Patterns Conflict
- The **most recent** pattern wins (newer files = current team preference)
- The **most common** pattern wins in a tie
- If genuinely unclear, state the ambiguity and pick one — don't mix

## Rules

- **Consistency > personal preference** — Even if you know a "better" way, match the existing style.
- **Copy structure, not just syntax** — If all controllers have a specific middleware order, follow it exactly.
- **Don't introduce new libraries** unless the user explicitly asks — use what the project already uses.
- **Don't change file organization** — If tests are in `__tests__/`, put new tests there too. If they're colocated, colocate.
- **Match comment style** — If the codebase uses JSDoc, use JSDoc. If it uses no comments, don't add them.
- **Match export style** — If the codebase uses named exports, don't use default exports (and vice versa).

## Quick Reference Searches

When you need to discover conventions, use these searches:

```
# Find how the project structures components
file_search("**/*.tsx") → read first 3 results

# Find how tests are organized
file_search("**/*.test.*") or file_search("**/*.spec.*")

# Find how routes/endpoints are defined
grep_search("router.|app.get|app.post|@Controller|@Get|@Post")

# Find error handling patterns
grep_search("throw new|catch|AppError|HttpException")

# Find validation patterns
grep_search("z.object|Joi.|@IsString|class-validator|yup.")

# Find logging patterns
grep_search("logger.|console.log|winston|pino|log.")
```
