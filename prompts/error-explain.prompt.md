---
description: "Cole um stack trace ou erro → receba diagnóstico da causa raiz + correção."
---

# Diagnose Error

Analyze this error and provide a fix:

```
${input:error}
```

## Analysis Steps
1. **Parse**: identify the error type, message, file, and line number
2. **Trace**: follow the stack trace from top (immediate cause) to bottom (origin)
3. **Root Cause**: determine WHY this error occurs — not just WHERE
4. **Context**: check the relevant source code to understand the surrounding logic
5. **Fix**: provide the exact code change to resolve it
6. **Prevention**: suggest how to prevent this class of error

## Output Format

### Error Type
`<ErrorName>`: one-sentence description

### Root Cause
Why this happened — the actual logic error, not the symptom.

### Fix
```diff
- broken line
+ fixed line
```

### Related Checks
- Other places in the codebase that might have the same issue
- Tests to add to prevent regression
