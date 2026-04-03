---
description: "Sugere nomes melhores para variáveis, funções, classes e arquivos."
---

# Improve Naming

Analyze the current file or selection and suggest better names.

## Rules
1. Names should reveal INTENT — what it IS or what it DOES
2. Names should be pronounceable and searchable
3. Follow the language's conventions:
   - JavaScript/TypeScript: `camelCase` functions/vars, `PascalCase` classes/components, `UPPER_CASE` constants
   - Python: `snake_case` functions/vars, `PascalCase` classes, `UPPER_CASE` constants
   - Go: `PascalCase` exported, `camelCase` unexported
   - Rust: `snake_case` functions/vars, `PascalCase` types, `SCREAMING_SNAKE` constants
   - C#: `PascalCase` public, `_camelCase` private fields
4. Avoid abbreviations unless universally understood (`id`, `url`, `http`)
5. Booleans should read as questions: `isActive`, `hasPermission`, `canEdit`
6. Functions should be verbs: `calculateTotal`, `fetchUser`, `validateInput`
7. Collections should be plural: `users`, `orderItems`

## Output Format
| Current Name | Suggested Name | Reason |
|-------------|---------------|--------|
| `d` | `createdDate` | Reveal intent |
| `processData` | `calculateMonthlyRevenue` | Be specific |
| `flag` | `isEmailVerified` | Boolean as question |

Apply the renames directly using rename symbol when possible.
