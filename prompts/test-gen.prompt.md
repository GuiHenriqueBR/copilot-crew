---
description: "Gera testes abrangentes para código existente — testes unitários, edge cases, mocks."
---

# Generate Tests

Generate comprehensive tests for the current file or selection.

- **Framework**: ${input:framework}
- **Focus**: ${input:focus}

## Rules
1. Analyze the code to understand ALL behaviors, branches, and edge cases
2. Generate tests using the **Arrange → Act → Assert** pattern
3. Name tests descriptively: `test_<function>_<scenario>_<expected>` or `it('should <behavior> when <condition>')`
4. Cover:
   - Happy path (normal usage)
   - Edge cases (empty, null, boundary values, max/min)
   - Error cases (invalid input, exceptions, failures)
   - Boundary conditions (off-by-one, zero, negative, overflow)
5. Mock external dependencies (API calls, database, file system)
6. Each test should test ONE behavior
7. Tests must be independent — no shared mutable state between tests
8. Include setup/teardown (beforeEach/afterEach, fixtures) as needed

## Output
- Complete test file ready to run
- All imports and mock setup included
- No TODOs or placeholder tests
