---
description: "Análise profunda e otimização de código para performance, legibilidade e boas práticas."
---

# Optimize Code

Analyze and optimize the code in the current selection or file with focus on: **${input:focus}**

## Analysis Steps
1. **Performance**: identify O(n²) loops, unnecessary allocations, missing caching, N+1 queries, blocking operations
2. **Memory**: find leaks, unnecessary copies, missing cleanup, oversized buffers
3. **Readability**: simplify complex conditions, extract methods, improve naming
4. **Idioms**: replace patterns with language-specific idiomatic equivalents
5. **Security**: spot injection risks, hardcoded secrets, unsafe operations
6. **Type Safety**: strengthen types, remove `any`/`object`, add generics

## Output Format
For each finding:
- **Issue**: what's wrong and why
- **Impact**: severity (critical/medium/low)
- **Fix**: the optimized code

Apply the fixes directly. Don't just suggest — implement.
