---
description: "Converte código entre linguagens preservando lógica, idiomas e boas práticas da linguagem alvo."
---

# Convert Code Between Languages

Convert the following code from **${input:source_language}** to **${input:target_language}**.

## Rules
- Preserve the original logic and behavior EXACTLY
- Use IDIOMATIC patterns of the target language (not a literal translation)
- Apply the target language's naming conventions (camelCase, snake_case, PascalCase as appropriate)
- Use the target language's standard library equivalents
- Handle error patterns appropriately (exceptions → Result types, try/catch → if err, etc.)
- Include equivalent imports/dependencies
- Add type annotations if the target language supports/expects them
- Note any features that don't have a direct equivalent and explain the adaptation

## Input Code
```${input:source_language}
${input:code}
```

Provide the converted code with brief notes on any significant adaptations made.
