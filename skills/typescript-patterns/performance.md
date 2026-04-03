# TypeScript Performance

## Const Enums (zero runtime cost)

```typescript
// Regular enum: generates runtime object
enum Direction { Up, Down } // emits { 0: 'Up', 1: 'Down', Up: 0, Down: 1 }

// Const enum: inlined at compile time
const enum Direction { Up, Down } // emits nothing, usages become 0 or 1
```

## Avoiding Excessive Type Computation

```typescript
// BAD: Deep recursive types cause slow compilation
type DeepPartial<T> = T extends object
  ? { [K in keyof T]?: DeepPartial<T[K]> }
  : T;

// BETTER: Limit recursion depth
type DeepPartial<T, Depth extends number[] = []> =
  Depth['length'] extends 5 ? T
  : T extends object
    ? { [K in keyof T]?: DeepPartial<T[K], [...Depth, 0]> }
    : T;
```

## Import Cost Awareness

```typescript
// BAD: Imports entire library
import _ from 'lodash'; // ~70KB
_.get(obj, 'a.b.c');

// GOOD: Import only what you need
import get from 'lodash/get'; // ~2KB

// BETTER: Use native
obj?.a?.b?.c; // 0KB, built-in
```

## tsconfig for Performance

```jsonc
{
  "compilerOptions": {
    "incremental": true,           // Cache compilation results
    "skipLibCheck": true,          // Skip .d.ts checking (faster builds)
    "isolatedModules": true,       // Required for SWC/esbuild
    "moduleResolution": "bundler", // Modern resolution (no index.ts crawling)
    "verbatimModuleSyntax": true   // Enforce explicit type imports
  }
}
```

## Explicit Type Imports (tree-shaking friendly)

```typescript
// BAD: Bundler may include runtime code
import { User } from './types';

// GOOD: Explicit type import — guaranteed to be erased
import type { User } from './types';

// GOOD: Inline type import
import { type User, createUser } from './user';
```

## Avoid Re-exports Barrel Files in Large Projects

```typescript
// BAD: index.ts re-exports everything — breaks tree-shaking
// src/utils/index.ts
export * from './string';
export * from './date';
export * from './math';
// Importing ONE function loads ALL modules

// GOOD: Import directly from source
import { formatDate } from '@/utils/date';
```

## Use Map/Set Over Object for Dynamic Keys

```typescript
// Object: string keys only, prototype pollution risk, no size property
const cache: Record<string, Data> = {};

// Map: any key type, O(1) lookup, .size, iterable, no prototype issues
const cache = new Map<string, Data>();
cache.set(key, value);
cache.has(key);
cache.size;
```
