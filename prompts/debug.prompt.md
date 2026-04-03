---
description: "Workflow estruturado de debugging: reproduzir → isolar → diagnosticar → corrigir → testar."
---

# Debug Issue

Debug the following issue: **${input:issue_description}**

## Workflow

### 1. Reproduce
- Identify the exact steps to reproduce
- Check error messages, stack traces, console output
- Determine if it's consistent or intermittent

### 2. Isolate
- Find the EXACT file and line where the error originates
- Trace the call chain backwards from the error
- Identify the specific input/state that triggers it
- Use binary search (comment out halves) if the source is unclear

### 3. Diagnose
- Determine the ROOT CAUSE (not just the symptom)
- Understand WHY the code behaves this way
- Check for common patterns: null/undefined, race condition, stale state, wrong type, off-by-one, missing await

### 4. Fix
- Apply the MINIMAL change that fixes the root cause
- Do NOT change unrelated code
- Ensure the fix doesn't introduce new issues

### 5. Verify
- Confirm the original issue is fixed
- Test edge cases around the fix
- Check that existing functionality still works

## Output
- **Root Cause**: one sentence explaining WHY
- **Fix**: the code change with explanation
- **Prevention**: how to prevent this class of bug in the future
