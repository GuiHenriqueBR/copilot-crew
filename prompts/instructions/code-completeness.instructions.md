---
description: "Use when writing or modifying any code. Rules to prevent incomplete code, TODO hacks, placeholder implementations, and half-finished features."
applyTo: "**"
---

# Code Completeness Standards

## Zero Tolerance for Incomplete Code

- NEVER commit placeholder implementations that silently do nothing
- NEVER leave empty catch blocks — always handle or re-throw
- NEVER use `// TODO` without a linked tracking issue
- NEVER return hardcoded/mock data from production code
- NEVER leave `console.log` debug statements in committed code
- NEVER disable eslint/typescript rules with comments unless justified AND documented

## Every Function Must Be Complete

A function is complete when:
1. ✅ It handles all documented input types
2. ✅ It handles error cases (not just happy path)
3. ✅ It returns the correct type (no `any` escapes)
4. ✅ It cleans up resources it opens (connections, files, subscriptions)
5. ✅ It has been manually traced through at least one scenario

## Common "Incomplete Code" Patterns to Avoid

```typescript
// BAD: Empty catch — errors silently disappear
try { await saveUser(data); } catch (e) { }

// GOOD: Handle or re-throw
try { await saveUser(data); } catch (e) {
  logger.error('Failed to save user', { error: e, data });
  throw new ServiceError('User save failed');
}

// BAD: Unfinished feature behind a flag
if (newFeature) {
  // TODO: implement this later
  return null;
}

// GOOD: Either implement it or don't ship the code path
if (newFeature) {
  return processNewFeature(data);
}

// BAD: Returning mock data
function getUser(id: string) {
  return { id: '1', name: 'Test User' }; // FIXME: connect to DB
}

// BAD: Type escaping
const result: any = fetchData();

// GOOD: Proper typing
const result: UserResponse = await fetchData();
```

## Before Committing Checklist

- [ ] No `console.log` debug statements
- [ ] No empty catch blocks
- [ ] No `any` types (unless genuinely unavoidable with justification)
- [ ] No TODO/FIXME without linked issue
- [ ] No commented-out code blocks
- [ ] No hardcoded test data in production paths
- [ ] All functions complete with proper error handling
- [ ] All imports are used
- [ ] All variables are used
