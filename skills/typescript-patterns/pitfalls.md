# TypeScript Pitfalls

## The `any` Escape Hatch

```typescript
// BAD: any disables ALL type checking
const data: any = fetchData();
data.nonExistentMethod(); // No error, runtime crash

// GOOD: Use unknown + narrowing
const data: unknown = fetchData();
if (typeof data === 'object' && data !== null) {
  // safely access properties with checks
}

// GOOD: Use Zod/Valibot for runtime validation
const UserSchema = z.object({ id: z.string(), name: z.string() });
const user = UserSchema.parse(data); // typed + runtime-validated
```

## Type Assertion Abuse

```typescript
// BAD: Forces the compiler to trust you (it shouldn't)
const element = document.getElementById('app') as HTMLDivElement;

// GOOD: Check for null
const element = document.getElementById('app');
if (!(element instanceof HTMLDivElement)) {
  throw new Error('Expected #app to be a div element');
}
// element is HTMLDivElement here

// EXCEPTION: Double assertion is a code smell
const x = someValue as unknown as TargetType; // Almost always wrong
```

## Enum Traps

```typescript
// BAD: Numeric enums allow invalid values
enum Status { Active, Inactive }
const s: Status = 999; // No error!

// GOOD: Use string literal unions or const enums
type Status = 'active' | 'inactive';

// Or const enum for zero runtime cost
const enum Direction { Up = 'UP', Down = 'DOWN' }
```

## Object.keys() Returns string[]

```typescript
const config = { port: 3000, host: 'localhost' };

// BAD: key is string, not 'port' | 'host'
Object.keys(config).forEach(key => {
  config[key]; // Error: Element implicitly has 'any' type
});

// GOOD: Use type-safe iteration
(Object.keys(config) as Array<keyof typeof config>).forEach(key => {
  config[key]; // Correctly typed
});

// BETTER: Use Object.entries
Object.entries(config).forEach(([key, value]) => {
  console.log(key, value);
});
```

## Optional Chaining + Nullish Coalescing Gotchas

```typescript
// CAREFUL: ?. returns undefined, not the falsy value
const length = arr?.length; // number | undefined, NOT number

// BAD: || treats 0 and '' as falsy
const port = config.port || 3000; // If port is 0, uses 3000!

// GOOD: ?? only triggers on null/undefined
const port = config.port ?? 3000; // 0 stays as 0
```

## Interface vs Type — When to Use Each

```typescript
// Interface: for objects that can be extended (API contracts, class shapes)
interface UserService {
  getUser(id: string): Promise<User>;
}

// Type: for unions, intersections, mapped types, computed properties
type Result<T> = { success: true; data: T } | { success: false; error: Error };
type Nullable<T> = T | null;

// DON'T: Use interface for unions (impossible)
// DON'T: Use type when you need declaration merging (rare)
```

## Structural Typing Surprises

```typescript
interface Point2D { x: number; y: number }
interface Point3D { x: number; y: number; z: number }

// This compiles! Point3D is assignable to Point2D (structural typing)
const p3d: Point3D = { x: 1, y: 2, z: 3 };
const p2d: Point2D = p3d; // No error — extra properties allowed in assignment

// BUT: Object literals are checked strictly (excess property checking)
const p2d_bad: Point2D = { x: 1, y: 2, z: 3 }; // Error: 'z' does not exist
```

## Promise Error Handling

```typescript
// BAD: Unhandled rejection
async function fetchUser(id: string) {
  const res = await fetch(`/api/users/${id}`);
  return res.json(); // What if status is 404?
}

// GOOD: Always check response
async function fetchUser(id: string): Promise<User> {
  const res = await fetch(`/api/users/${id}`);
  if (!res.ok) {
    throw new ApiError(`Failed to fetch user ${id}`, res.status);
  }
  return res.json() as Promise<User>;
}
```

## Readonly is Shallow

```typescript
// BAD: Readonly doesn't protect nested objects
type Config = Readonly<{ db: { host: string } }>;
const config: Config = { db: { host: 'localhost' } };
config.db.host = 'hacked'; // No error! Readonly is shallow

// GOOD: Use DeepReadonly or freeze
type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object ? DeepReadonly<T[K]> : T[K];
};
```

## Index Signatures Allow Anything

```typescript
// BAD: Loose index signature
interface Cache {
  [key: string]: any; // Any key, any value — type-unsafe
}

// GOOD: Use Map or Record with known types
const cache = new Map<string, User>();
// Or
type Cache = Record<string, User | undefined>; // undefined forces null checks
```
