---
description: "ALWAYS ACTIVE — Optimizes how agents search and read files. Prevents wasteful tool usage, anti-hallucination guards, and enforces verification before using any symbol."
applyTo: "**"
---

# Tool Strategy & Anti-Hallucination

## Search Strategy (pick the right tool first time)

| You need... | Use this | NOT this |
|-------------|----------|----------|
| Exact text/symbol name | `grep_search` | semantic_search |
| Concept/behavior (don't know the name) | `semantic_search` | grep_search (you'd miss it) |
| File by name or extension | `file_search` | grep_search (too slow) |
| Directory overview | `list_dir` | read_file on every file |
| File contents | `read_file` (100+ lines at once) | Multiple 10-line reads |

### Search Rules
- **Read big, not often** — Read 100-200 lines at a time. 10 reads of 10 lines = waste.
- **Search before reading** — Don't `read_file` unless you know the file exists and is relevant.
- **One concept per search** — Don't combine unrelated queries. They dilute results.
- **Stop when you have enough** — If 2 searches found the answer, don't do a 3rd.

## Anti-Hallucination Guards

These rules prevent the most common agent mistakes:

### Never Invent — Always Verify
- **NEVER import a module** without first confirming it exists (`grep_search` for the export or `file_search` for the file)
- **NEVER call a function** without reading its actual signature (parameter names, types, return type)
- **NEVER assume an object's shape** — read the type/interface definition first
- **NEVER guess a file path** — use `file_search` to find the real path
- **NEVER assume a package is installed** — check `package.json`, `go.mod`, `Cargo.toml`, or equivalent
- **NEVER fabricate API endpoints** — read the actual route definitions

### Confidence Check
Before writing code that uses an external symbol (import, function call, type reference):

1. **Can I point to the exact file and line where this is defined?**
   - Yes → proceed
   - No → search for it first

2. **Am I sure about the parameter order and types?**
   - Yes → proceed
   - No → read the function signature

3. **Does this package/module exist in this project's dependencies?**
   - Yes → proceed
   - No → suggest installing it, don't just import it

## Error Recovery Protocol

When `get_errors()` returns errors after your changes:

1. **First failure** — Read the error carefully, understand the cause, fix it
2. **Second failure (same area)** — Step back, re-read the surrounding code, check your assumptions
3. **Third failure** — Try a different approach entirely. Your mental model is probably wrong.
4. **Still stuck** — Explain the blocker to the user honestly. Say what you tried and what's failing.

### Recovery Rules
- NEVER apply the same fix twice hoping it will work
- NEVER add `// @ts-ignore`, `# type: ignore`, or suppress warnings to "fix" errors
- NEVER use `any` type to bypass type errors — fix the actual type
- NEVER delete code you don't understand just because it has errors
- NEVER use `--force`, `--no-verify`, or `--skip-checks` as a workaround
