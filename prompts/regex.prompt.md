---
description: "Cria e explica padrões regex a partir de descrições em linguagem natural."
---

# Build Regex

Create a regex pattern for: **${input:description}**

- **Flavor**: ${input:flavor}

## Output
1. **Pattern**: the complete regex
2. **Explanation**: break down each part of the regex visually
3. **Test cases**: 5+ examples showing matches and non-matches
4. **Edge cases**: what could break this pattern
5. **Optimized version**: if the initial pattern can be simplified

## Visual Breakdown Example
```
^(?:https?:\/\/)?(?:www\.)?([a-zA-Z0-9-]+)\.([a-z]{2,})$
│   │              │        │                  │
│   │              │        │                  └─ TLD (2+ lowercase letters)
│   │              │        └─ domain name (alphanumeric + hyphens)
│   │              └─ optional "www."
│   └─ optional "http://" or "https://"
└─ start of string
```

Provide the pattern ready to use — with proper escaping for the target language if specified.
