# API Documentation Skill

## Trigger Words
"API docs", "OpenAPI", "Swagger", "document API", "API reference", "Postman collection", "endpoint documentation"

## Workflow: Discover → Document → Generate → Validate

### Phase 1: Discover Endpoints
Scan the codebase for API routes:

```bash
# Express/Fastify
grep -rn "app\.\(get\|post\|put\|patch\|delete\)" src/ --include="*.ts"
grep -rn "router\.\(get\|post\|put\|patch\|delete\)" src/ --include="*.ts"

# NestJS
grep -rn "@\(Get\|Post\|Put\|Patch\|Delete\)" src/ --include="*.ts"

# FastAPI
grep -rn "@app\.\(get\|post\|put\|patch\|delete\)" . --include="*.py"

# Spring Boot
grep -rn "@\(GetMapping\|PostMapping\|PutMapping\|PatchMapping\|DeleteMapping\|RequestMapping\)" src/ --include="*.java"

# ASP.NET Core
grep -rn "\[Http\(Get\|Post\|Put\|Patch\|Delete\)\]" . --include="*.cs"
```

### Phase 2: OpenAPI Specification

**Template:**
```yaml
openapi: 3.1.0
info:
  title: API Name
  version: 1.0.0
  description: Brief description
  contact:
    name: Team Name
    email: team@example.com

servers:
  - url: http://localhost:3000/api
    description: Development
  - url: https://api.example.com
    description: Production

tags:
  - name: Users
    description: User management
  - name: Orders
    description: Order operations

paths:
  /users:
    get:
      tags: [Users]
      summary: List users
      description: Returns paginated list of users
      operationId: listUsers
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
            minimum: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
            minimum: 1
            maximum: 100
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/User'
                  pagination:
                    $ref: '#/components/schemas/Pagination'
        '401':
          $ref: '#/components/responses/Unauthorized'

    post:
      tags: [Users]
      summary: Create user
      operationId: createUser
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          $ref: '#/components/responses/BadRequest'
        '409':
          description: Email already exists

components:
  schemas:
    User:
      type: object
      required: [id, email, name, createdAt]
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
          maxLength: 100
        createdAt:
          type: string
          format: date-time

    CreateUserRequest:
      type: object
      required: [email, name, password]
      properties:
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 2
          maxLength: 100
        password:
          type: string
          minLength: 8

    Pagination:
      type: object
      properties:
        page:
          type: integer
        limit:
          type: integer
        total:
          type: integer
        totalPages:
          type: integer

    ErrorResponse:
      type: object
      required: [error]
      properties:
        error:
          type: object
          required: [code, message]
          properties:
            code:
              type: string
            message:
              type: string
            details:
              type: array
              items:
                type: object

  responses:
    Unauthorized:
      description: Authentication required
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'
    BadRequest:
      description: Invalid request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

security:
  - bearerAuth: []
```

### Phase 3: Endpoint Documentation Pattern

For each endpoint, document:

```markdown
## POST /api/orders

Create a new order.

### Authentication
Requires Bearer token.

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| items | array | Yes | List of order items |
| items[].productId | string (uuid) | Yes | Product ID |
| items[].quantity | integer | Yes | Quantity (min: 1) |
| couponCode | string | No | Discount coupon code |

### Example Request
```json
{
  "items": [
    { "productId": "abc-123", "quantity": 2 }
  ],
  "couponCode": "SAVE10"
}
```

### Responses
| Status | Description |
|--------|-------------|
| 201 | Order created successfully |
| 400 | Invalid request body |
| 401 | Not authenticated |
| 404 | Product not found |
| 422 | Insufficient stock |

### Example Response (201)
```json
{
  "id": "order-456",
  "status": "pending",
  "total": 49.98,
  "items": [...],
  "createdAt": "2024-01-15T10:30:00Z"
}
```
```

### Phase 4: Validate

```bash
# Validate OpenAPI spec
npx @redocly/cli lint openapi.yaml

# Generate HTML docs
npx @redocly/cli build-docs openapi.yaml -o docs/api.html

# Mock server for testing
npx @stoplight/prism-cli mock openapi.yaml
```

## Rules
- ALWAYS include request/response examples with realistic data
- ALWAYS document error responses with error codes and messages
- ALWAYS specify required fields explicitly
- ALWAYS use `$ref` for reusable schemas — avoid duplication
- ALWAYS include authentication requirements per endpoint
- NEVER expose internal implementation details in docs
- NEVER include sensitive data (real tokens, passwords) in examples
- USE semantic versioning for the API
- DOCUMENT breaking changes prominently
- KEEP docs in sync with code — generate from code annotations when possible
