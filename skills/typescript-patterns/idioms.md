# TypeScript Idioms

## Type Narrowing (prefer over type assertions)

```typescript
// BAD: Type assertion
const user = data as User;

// GOOD: Type guard
function isUser(data: unknown): data is User {
  return typeof data === 'object' && data !== null && 'id' in data && 'email' in data;
}

if (isUser(data)) {
  // data is User here — compiler-verified
}
```

## Discriminated Unions (prefer over class hierarchies)

```typescript
// GOOD: Exhaustive pattern matching
type Result<T> =
  | { status: 'success'; data: T }
  | { status: 'error'; error: Error }
  | { status: 'loading' };

function handle<T>(result: Result<T>) {
  switch (result.status) {
    case 'success': return result.data;
    case 'error': throw result.error;
    case 'loading': return null;
    // No default — compiler catches missing cases
  }
}
```

## Branded/Opaque Types (prevent primitive confusion)

```typescript
type UserId = string & { readonly __brand: unique symbol };
type OrderId = string & { readonly __brand: unique symbol };

function createUserId(id: string): UserId { return id as UserId; }
function createOrderId(id: string): OrderId { return id as OrderId; }

// getUserById(orderId) → compile error! Types are incompatible
function getUserById(id: UserId): User { /* ... */ }
```

## Utility Types (use built-ins, don't reinvent)

```typescript
// Partial for optional updates
function updateUser(id: UserId, updates: Partial<User>): User { /* ... */ }

// Pick/Omit for API boundaries
type CreateUserDTO = Omit<User, 'id' | 'createdAt'>;
type UserSummary = Pick<User, 'id' | 'name' | 'email'>;

// Record for dictionaries
type UserRoles = Record<UserId, Role[]>;

// Readonly for immutability
type Config = Readonly<{ apiUrl: string; timeout: number }>;

// ReturnType / Parameters for inference
type ServiceReturn = ReturnType<typeof userService.getUser>;
```

## Const Assertions (lock down literals)

```typescript
// BAD: types widen to string[]
const ROLES = ['admin', 'user', 'guest'];

// GOOD: types are readonly tuple of literals
const ROLES = ['admin', 'user', 'guest'] as const;
type Role = (typeof ROLES)[number]; // 'admin' | 'user' | 'guest'
```

## Template Literal Types

```typescript
type EventName = `on${Capitalize<string>}`;
type HTTPMethod = 'GET' | 'POST' | 'PUT' | 'DELETE';
type APIRoute = `/${string}`;
type Endpoint = `${HTTPMethod} ${APIRoute}`;
```

## Satisfies Operator (validate without widening)

```typescript
type Theme = Record<string, string>;

// BAD: loses specific key info
const theme: Theme = { primary: '#000', secondary: '#fff' };

// GOOD: validates structure but keeps literal types
const theme = {
  primary: '#000',
  secondary: '#fff',
} satisfies Theme;
// theme.primary is '#000', not string
```

## Infer in Conditional Types

```typescript
type UnwrapPromise<T> = T extends Promise<infer U> ? U : T;
type ArrayElement<T> = T extends readonly (infer E)[] ? E : never;
type FunctionReturn<T> = T extends (...args: any[]) => infer R ? R : never;
```

## Generic Constraints

```typescript
// Constrain generics to what you actually need
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}

// Use extends for minimum shape
function getLength<T extends { length: number }>(item: T): number {
  return item.length;
}
```

## Overloads (for complex signatures)

```typescript
function parse(input: string): object;
function parse(input: string, format: 'json'): Record<string, unknown>;
function parse(input: string, format: 'csv'): string[][];
function parse(input: string, format?: string) {
  if (format === 'csv') return parseCSV(input);
  return JSON.parse(input);
}
```

## Module Augmentation

```typescript
// Extend third-party types without modifying source
declare module 'express' {
  interface Request {
    userId?: string;
    sessionId?: string;
  }
}
```
