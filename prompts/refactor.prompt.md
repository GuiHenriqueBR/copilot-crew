---
description: "Refatoração guiada: identificar code smells → aplicar design pattern → validar."
---

# Refactor Code

Refactor the current file or selection.

- **Goal**: ${input:goal}

## Workflow

### 1. Detect Code Smells
- Long methods (>20 lines)
- Deep nesting (>3 levels)
- Duplicated logic
- God classes (too many responsibilities)
- Feature envy (method uses another class's data more than its own)
- Primitive obsession (using primitives instead of value objects)
- Long parameter lists (>3 parameters)
- Dead code (unreachable, unused)

### 2. Plan Refactoring
Choose the appropriate technique:
- **Extract Method**: long functions → smaller, named functions
- **Extract Class**: god class → focused classes
- **Replace Conditional with Polymorphism**: complex switch/if chains
- **Introduce Parameter Object**: long parameter lists → config object
- **Replace Magic Numbers**: with named constants
- **Move Method**: method closer to the data it uses
- **Compose Method**: make the flow readable at one level of abstraction

### 3. Apply
- Make ONE refactoring at a time
- Run tests after each change to verify behavior is preserved
- Keep the external API/interface stable

### 4. Validate
- Code is shorter OR more readable (ideally both)
- All existing tests still pass
- No behavior change — pure structural improvement

Apply the refactoring directly. Don't just describe it.
