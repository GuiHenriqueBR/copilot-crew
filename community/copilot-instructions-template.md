# Project: [Your Project Name]

> Generated with Copilot Crew `/init` command.
> Customize this file with your project's specific conventions.

## Tech Stack
<!-- List your technologies and versions -->
- **Language**: TypeScript 5.x
- **Framework**: Next.js 15 (App Router)
- **Styling**: Tailwind CSS 4
- **Database**: PostgreSQL via Prisma ORM
- **Auth**: [Your auth solution]
- **Testing**: Vitest + Playwright

## Project Structure
```
src/
├── app/              # Next.js App Router pages and layouts
├── components/       # Reusable UI components
│   ├── ui/           # Primitive components (Button, Input, etc.)
│   └── features/     # Feature-specific components
├── lib/              # Shared utilities and configurations
├── server/           # Server-side code (actions, API logic)
├── types/            # Shared TypeScript types
└── styles/           # Global styles
```

## Naming Conventions
- **Components**: PascalCase (`UserProfile.tsx`)
- **Utilities**: camelCase (`formatDate.ts`)
- **Types**: PascalCase with descriptive names (`UserResponse`, `CreateOrderInput`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRIES`)
- **Directories**: kebab-case (`user-profile/`)

## Import Conventions
```typescript
// 1. External packages
import { useState } from 'react'

// 2. Internal aliases (@/)
import { Button } from '@/components/ui/Button'

// 3. Relative imports
import { formatDate } from './utils'

// 4. Types (type-only imports)
import type { User } from '@/types'
```

## Component Patterns
```typescript
// Preferred component structure
interface Props {
  title: string
  children: React.ReactNode
}

export function MyComponent({ title, children }: Props) {
  return (
    <div>
      <h1>{title}</h1>
      {children}
    </div>
  )
}
```

## Error Handling
- Use custom error classes for domain errors
- Always handle errors at API boundaries
- Log errors with structured context: `{ error, userId, operation }`
- Return user-friendly messages to the client

## Database
- Use Prisma for all database operations
- Migrations live in `prisma/migrations/`
- Seed data in `prisma/seed.ts`
- Always use transactions for multi-table operations

## Testing
- Unit tests: colocated with source files (`*.test.ts`)
- E2E tests: in `tests/e2e/` directory
- Use `describe/it` blocks with `should [behavior] when [condition]` naming

## Important Rules
- Never use `any` type — use `unknown` and narrow
- Always validate user input at API boundaries (use Zod)
- Never commit `.env` files — use `.env.example` for documentation
- Prefer Server Components — only use `"use client"` when needed
- All async operations must have proper error handling
