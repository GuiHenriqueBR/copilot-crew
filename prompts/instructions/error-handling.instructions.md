---
description: "Use when writing or modifying any code. Enforces proper error handling patterns — no swallowed errors, no bare catches, proper logging."
applyTo: "**"
---

# Error Handling Standards

## Universal Rules
- NEVER swallow errors silently — always log or propagate
- NEVER use empty catch blocks — at minimum log the error
- NEVER catch generic exceptions unless re-throwing
- ALWAYS include context in error messages: what operation failed and with what input
- ALWAYS preserve the original error as the cause (chaining)
- ALWAYS differentiate between operational errors (expected) and programmer errors (bugs)
- LOG errors with structured data: `{ error, userId, operation, input }`

## By Language

### TypeScript/JavaScript
```typescript
// BAD
try { await fetchUser(id) } catch (e) {}

// GOOD
try {
  return await fetchUser(id);
} catch (error) {
  logger.error('Failed to fetch user', { userId: id, error });
  throw new UserNotFoundError(id, { cause: error });
}
```
- Use custom error classes extending `Error` with `cause`
- Use `unknown` for catch parameter, narrow with `instanceof`
- Handle Promise rejections — never leave `.catch()` empty

### Python
```python
# BAD
try: fetch_user(user_id)
except: pass

# GOOD
try:
    return fetch_user(user_id)
except UserNotFoundError:
    raise
except DatabaseError as e:
    logger.error("Failed to fetch user", extra={"user_id": user_id})
    raise ServiceUnavailableError(f"Database error for user {user_id}") from e
```

### Go
```go
// ALWAYS check errors — never use blank identifier
result, err := fetchUser(id)
if err != nil {
    return fmt.Errorf("fetch user %s: %w", id, err)
}
```

### Rust
```rust
// Use ? operator with proper error types
let user = fetch_user(id)
    .map_err(|e| AppError::UserNotFound { id, source: e })?;
```

### C#
```csharp
// Catch specific exceptions, preserve stack trace
try { return await FetchUserAsync(id, ct); }
catch (HttpRequestException ex)
{
    _logger.LogError(ex, "Failed to fetch user {UserId}", id);
    throw new UserServiceException($"Failed to fetch user {id}", ex);
}
```

## Error Response Format (APIs)
```json
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with ID 123 was not found",
    "details": []
  }
}
```
- Use machine-readable error codes (not HTTP status descriptions)
- Include user-friendly message
- Never expose stack traces or internal details to clients
