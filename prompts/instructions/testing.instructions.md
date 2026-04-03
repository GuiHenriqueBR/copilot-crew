---
description: "Use when creating or modifying tests, test files, test configurations, or when discussing testing strategy."
applyTo: "**"
---

# Testing Standards

## Test Hierarchy (Testing Pyramid)

Invest in tests proportionally:
1. **Unit Tests (70%)** — Fast, isolated, cover all logic branches
2. **Integration Tests (20%)** — Verify component interactions, API contracts, database queries
3. **E2E Tests (10%)** — Critical user journeys only, expensive to maintain

## Test Structure

Every test follows the AAA pattern:

```
// Arrange — Set up the preconditions and inputs
// Act — Execute the function or operation under test
// Assert — Verify the expected outcome
```

## Naming Convention

Tests should read like specifications:

```
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', () => {})
    it('should throw ValidationError when email is empty', () => {})
    it('should throw ConflictError when email already exists', () => {})
  })
})
```

Pattern: `should [expected behavior] when [condition]`

## What to Test

### Always Test
- Business-critical logic (payments, auth, data mutations)
- Complex functions with multiple code paths
- Error handling and edge cases
- Input validation at system boundaries
- State transitions
- API contracts (request/response shapes and status codes)

### What NOT to Test
- Framework internals (React rendering, Express routing)
- Third-party library behavior
- Simple getters/setters with no logic
- Private implementation details (test through public interface)
- Constants and configurations

## Test Quality Rules

- **One concept per test**: Each test verifies ONE behavior. Multiple asserts are fine if they verify the same concept.
- **Independent**: Tests must not depend on each other or on execution order.
- **Deterministic**: Same result every run. No randomness, no time-dependency, no network calls in unit tests.
- **Fast**: Unit tests < 100ms each. Slow tests don't get run.
- **Readable**: A failing test must clearly communicate what broke and why.
- **Resilient**: Tests break when behavior changes, not when implementation details change.

## Mocking Rules

- Mock external dependencies (HTTP calls, databases, file system) in unit tests
- DON'T mock what you don't own without an integration test backup
- DON'T mock everything — over-mocking creates tests that pass but mis bugs
- Prefer fakes/stubs over complex mock setups
- Verify mock interactions only when the interaction IS the behavior being tested

## Edge Cases to Cover

- Empty/null/undefined inputs
- Boundary values (0, -1, MAX_INT, empty string, max length)
- Invalid types (string where number expected)
- Concurrent operations
- Network failures and timeouts
- Permission denied scenarios
- Large datasets (pagination boundaries)

## Test Data

- Use factories or builders for test data — not hardcoded objects spread across tests
- Keep test data minimal — only specify fields relevant to the test
- Use realistic but not real data (no production data in tests)
- Clean up after tests (use beforeEach/afterEach)

## Coverage

- Aim for meaningful coverage of critical paths, not 100% line coverage
- Uncovered code should be a conscious decision, not an oversight
- Coverage < 80% on business logic deserves attention
- New code should come with tests — no exceptions for "simple" changes
