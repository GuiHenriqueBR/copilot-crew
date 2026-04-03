---
description: "Use when writing or modifying any code. Universal clean code standards, SOLID principles, naming conventions, error handling, function design, complexity management."
applyTo: "**"
---

# Clean Code Standards

These standards apply to all code in all languages and frameworks.

## Naming

- **Variables**: Descriptive nouns that reveal intent. `userAge` not `a`, `isActive` not `flag`.
- **Functions**: Verb phrases describing the action. `calculateTotal()`, `validateEmail()`, `fetchUserById()`.
- **Booleans**: Prefix with `is`, `has`, `should`, `can`. `isValid`, `hasPermission`, `shouldRetry`.
- **Constants**: UPPER_SNAKE_CASE for true constants. `MAX_RETRIES`, `API_BASE_URL`.
- **Classes/Types**: PascalCase, noun describing the entity. `UserService`, `PaymentGateway`.
- **Avoid**: Abbreviations (except universally known: `id`, `url`, `api`), single letters (except loop counters), misleading names.

## Functions

- **Single Responsibility**: Each function does exactly one thing. If you need "and" to describe it, split it.
- **Small**: Prefer < 20 lines. If longer, extract sub-functions.
- **Few Parameters**: Max 3 parameters. More? Use an options object.
- **No Side Effects**: If a function is named `getUser`, it should NOT modify anything. Side effects go in functions named with action verbs (`save`, `update`, `delete`).
- **Early Returns**: Handle errors/edge cases first, then the main logic. Avoid deep nesting.
- **Pure when possible**: Same input → same output, no external state dependency.

```
// BAD: Deep nesting
function process(data) {
  if (data) {
    if (data.isValid) {
      if (data.items.length > 0) {
        // actual logic buried 3 levels deep
      }
    }
  }
}

// GOOD: Guard clauses
function process(data) {
  if (!data) return;
  if (!data.isValid) return;
  if (data.items.length === 0) return;
  // actual logic at top level
}
```

## Error Handling

- **Validate at boundaries**: Validate all external input (API requests, user input, file reads, env vars) at the system boundary, not deep inside business logic.
- **Fail fast**: Detect and report errors as early as possible.
- **Specific errors**: Use specific error types/messages. Not `throw new Error('Error')` but `throw new ValidationError('Email format invalid')`.
- **Never swallow errors**: Every catch block must either handle the error meaningfully or re-throw it.
- **No error codes in returns**: Use exceptions/error types instead of return codes.
- **Graceful degradation**: When a non-critical feature fails, the rest should continue working.

## Code Structure

- **DRY (Rule of Three)**: Don't abstract until you've duplicated 3 times. Premature abstraction is worse than duplication.
- **YAGNI**: Don't build for hypothetical future requirements. Build what's needed now.
- **KISS**: The simplest solution that works is the best solution.
- **Separation of Concerns**: UI logic, business logic, and data access in separate layers.
- **Dependency Direction**: Dependencies point inward (UI → Business → Data). Never the reverse.
- **Composition over Inheritance**: Prefer composing small, focused modules over complex inheritance hierarchies.

## Comments

- **DO**: Explain WHY, not WHAT. The code tells you what; comments tell you why.
- **DO**: Document non-obvious business rules, workarounds, and edge cases.
- **DO**: Link to related issues, docs, or external resources for context.
- **DON'T**: Comment obvious code. `i++ // increment i` is noise.
- **DON'T**: Leave commented-out code. Use version control.
- **DON'T**: Use comments as a substitute for clear names and simple logic.

## Complexity

- **Cyclomatic Complexity**: Keep < 10 per function. Each if/else/for/while/case adds 1.
- **Nesting Depth**: Max 3 levels. Use guard clauses and extracted functions.
- **File Length**: If a file > 300 lines, consider splitting by responsibility.
- **Import Count**: If a file imports > 10 modules, it may be doing too much.

## Async Code

- Always handle promise rejections (`.catch()` or `try/catch` with `async/await`)
- Clean up subscriptions, timers, and listeners when the scope ends
- Avoid callback hell — use async/await
- Handle race conditions with proper synchronization (locks, queues, debounce)
- Set timeouts on external calls (never wait forever)
