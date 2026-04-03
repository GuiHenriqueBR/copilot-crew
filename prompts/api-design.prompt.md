---
description: "Projeta uma API REST ou GraphQL a partir de descrição em linguagem natural."
---

# Design API

Design an API for: **${input:description}**

- **Style**: ${input:style}

## Output

### 1. Endpoints / Schema
For REST: table with Method, Path, Description, Request Body, Response, Status Codes
For GraphQL: full schema with types, queries, mutations, subscriptions

### 2. Data Models
- Entity definitions with all fields, types, and relationships
- Request/Response DTOs (what the client sends vs what it receives)

### 3. Auth & Authorization
- Which endpoints need authentication
- Role-based access rules

### 4. Error Handling
- Standard error response format
- Error codes for domain-specific errors

### 5. Pagination, Filtering, Sorting
- Cursor-based pagination (preferred) or offset
- Query parameters for filtering and sorting

### 6. Rate Limiting
- Suggested limits per endpoint category

### 7. Example Requests/Responses
- At least one example per endpoint with realistic data

Design for evolution — make breaking changes avoidable through versioning or additive changes.
