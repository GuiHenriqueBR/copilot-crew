# TypeScript Project Structure

## Standard Application Layout

```
src/
├── modules/              # Feature modules (domain-first)
│   ├── user/
│   │   ├── user.service.ts
│   │   ├── user.repository.ts
│   │   ├── user.controller.ts
│   │   ├── user.types.ts
│   │   ├── user.schema.ts      # Zod/Valibot validation
│   │   └── __tests__/
│   │       ├── user.service.test.ts
│   │       └── user.controller.test.ts
│   └── order/
│       └── ...
├── shared/               # Cross-cutting concerns
│   ├── errors/           # Custom error classes
│   ├── middleware/        # Express/Fastify middleware
│   ├── utils/            # Pure utility functions
│   └── types/            # Shared type definitions
├── config/               # Environment, app config
├── infra/                # Database, cache, queue clients
└── index.ts              # Entry point only — no logic
```

## Key Principles

1. **Feature-first, not layer-first**: Group by domain (`user/`, `order/`), not by technical layer (`controllers/`, `services/`)
2. **Co-locate tests**: Tests live next to the code they test in `__tests__/`
3. **One export per file**: Each file exports one primary thing (class, function, type)
4. **Types near usage**: `user.types.ts` lives inside `user/`, not in a global `types/` folder
5. **Barrel exports only at module boundary**: Only `modules/user/index.ts` re-exports, not deep folders

## tsconfig Path Aliases

```jsonc
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"],
      "@/modules/*": ["src/modules/*"],
      "@/shared/*": ["src/shared/*"]
    }
  }
}
```

## Monorepo Layout (Turborepo/Nx)

```
packages/
├── shared/               # Shared types, utils (no framework deps)
│   ├── src/
│   ├── package.json
│   └── tsconfig.json
├── api/                  # Backend application
│   ├── src/
│   ├── package.json
│   └── tsconfig.json     # extends ../../tsconfig.base.json
└── web/                  # Frontend application
    ├── src/
    ├── package.json
    └── tsconfig.json
tsconfig.base.json        # Shared compiler options
turbo.json                # Task pipeline definition
```

## Environment Configuration Pattern

```typescript
// config/env.ts — validate at startup, fail fast
import { z } from 'zod';

const EnvSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']),
  PORT: z.coerce.number().default(3000),
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
});

export const env = EnvSchema.parse(process.env);
// If any var is missing/invalid → crash immediately with clear error
```
