---
description: "Use when writing code that handles user input, authentication, authorization, secrets, database queries, file operations, external APIs, or any security-sensitive operation."
applyTo: "**"
---

# Security Standards

These security rules apply to all code and must never be bypassed.

## Input Validation

- Validate ALL external input at system boundaries (API endpoints, form handlers, file uploads)
- Use allowlists over blocklists. Define what IS valid, not what ISN'T.
- Validate type, length, format, and range
- Sanitize before use in any output context (HTML, SQL, shell, URL)
- Never trust client-side validation alone — always validate server-side

## Injection Prevention

- **SQL**: Always use parameterized queries or ORM methods. NEVER concatenate user input into queries.
- **XSS**: Encode output for the correct context (HTML, JavaScript, URL, CSS). Use framework's built-in escaping.
- **Command Injection**: Never pass user input to shell commands. If unavoidable, use allowlisted values only.
- **NoSQL Injection**: Validate types strictly. MongoDB operators (`$gt`, `$ne`) in user input are an attack.
- **Template Injection**: Never pass user input as template strings.
- **Path Traversal**: Validate and sanitize file paths. Reject `..`, absolute paths, and null bytes.

```
// DANGEROUS — SQL injection
const query = `SELECT * FROM users WHERE id = '${userId}'`;

// SAFE — Parameterized query
const query = `SELECT * FROM users WHERE id = $1`;
const result = await db.query(query, [userId]);
```

## Authentication

- Hash passwords with bcrypt (cost factor ≥ 12) or Argon2. NEVER md5 or sha1.
- Use constant-time comparison for tokens and hashes to prevent timing attacks.
- Implement rate limiting on login endpoints (max 5 attempts per minute).
- Use secure session management:
  - HttpOnly cookies (no JavaScript access)
  - Secure flag (HTTPS only)
  - SameSite=Strict or Lax
  - Reasonable expiration
- JWT tokens: validate algorithm, expiry, and issuer. Never use `"alg": "none"`.

## Authorization

- Check permissions on EVERY request that accesses protected resources
- Verify resource ownership — user can only access THEIR data (`WHERE user_id = $currentUser`)
- Never rely on client-side authorization checks alone
- Use principle of least privilege — grant minimum necessary permissions
- Re-validate permissions for state-changing operations (don't cache authorization)

## Secrets Management

- NEVER hardcode secrets, API keys, passwords, or tokens in source code
- Use environment variables or dedicated secret managers
- Add `.env` to `.gitignore` immediately
- Provide `.env.example` with placeholder values for documentation
- Rotate secrets regularly and after any potential exposure
- Different secrets for each environment (dev, staging, prod)

## Data Protection

- Encrypt sensitive data at rest (PII, financial data, health records)
- Use HTTPS for all data in transit
- Minimize data collection — don't store what you don't need
- Implement data retention policies — delete old data
- Mask sensitive data in logs (`user@***.com`, `****1234`)
- Never log passwords, tokens, or full credit card numbers

## HTTP Security Headers

Apply these headers on all responses:
- `Strict-Transport-Security: max-age=31536000; includeSubDomains`
- `Content-Security-Policy: default-src 'self'` (adjust per needs)
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY` (or SAMEORIGIN if iframes needed)
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy: camera=(), microphone=(), geolocation=()`

## Dependency Security

- Keep dependencies updated — check for CVEs regularly
- Use lockfiles (package-lock.json, yarn.lock, Pipfile.lock)
- Audit dependencies before adding: check maintainers, download count, last update
- Remove unused dependencies
- Pin major versions to avoid breaking changes

## Error Handling (Security)

- Never expose stack traces, internal paths, or database errors to users
- Use generic error messages for clients: "Authentication failed" (not "Password incorrect for user admin")
- Log detailed errors server-side for debugging
- Implement proper error boundaries that don't leak information
