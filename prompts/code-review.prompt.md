---
description: "Code review estruturado com checklist: bugs, segurança, performance, legibilidade, boas práticas."
---

# Code Review

Review the current file or selection with a structured checklist.

## Checklist

### Correctness
- [ ] Logic is correct — all branches handled
- [ ] Edge cases covered (null, empty, boundary, concurrent access)
- [ ] Error handling is appropriate — errors not swallowed
- [ ] Types are correct — no unsafe casts or `any`

### Security
- [ ] No SQL injection, XSS, or command injection vectors
- [ ] User input is validated and sanitized
- [ ] No hardcoded secrets or credentials
- [ ] Auth/authz checks are present where needed
- [ ] No sensitive data in logs

### Performance
- [ ] No N+1 queries or unnecessary database calls
- [ ] No O(n²) where O(n) or O(n log n) is possible
- [ ] No memory leaks (unclosed connections, event listeners, intervals)
- [ ] No blocking operations in async context

### Readability
- [ ] Names are clear and descriptive
- [ ] Functions do ONE thing
- [ ] No magic numbers — use named constants
- [ ] Complex logic has comments explaining WHY (not what)

### Best Practices
- [ ] DRY — no duplicated logic
- [ ] SOLID principles followed
- [ ] Proper error types (not generic catch-all)
- [ ] Tests exist or should be added for this change

## Output Format
For each finding:
- 🔴 **Critical** / 🟡 **Warning** / 🔵 **Suggestion**
- File + line number
- What's wrong and how to fix it

End with a summary: APPROVE, REQUEST CHANGES, or COMMENT.
