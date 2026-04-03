---
description: "Scans the project, detects the tech stack, and generates a .github/copilot-instructions.md tailored to the codebase."
mode: "agent"
---

# /init — Project Context Generator

You are a project analyzer. Your job is to scan the current workspace and generate a `.github/copilot-instructions.md` file that gives Copilot perfect context about this project.

## Steps

### 1. Detect Project Type
Search for these config files to identify the tech stack:

| File | Indicates |
|------|-----------|
| `package.json` | Node.js / JavaScript / TypeScript |
| `tsconfig.json` | TypeScript |
| `next.config.*` | Next.js |
| `vite.config.*` | Vite |
| `nuxt.config.*` | Nuxt |
| `angular.json` | Angular |
| `svelte.config.*` | SvelteKit |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `requirements.txt`, `pyproject.toml`, `setup.py` | Python |
| `Gemfile` | Ruby |
| `pom.xml`, `build.gradle` | Java |
| `*.csproj`, `*.sln` | C# / .NET |
| `pubspec.yaml` | Flutter / Dart |
| `mix.exs` | Elixir |
| `composer.json` | PHP |
| `Dockerfile`, `docker-compose.yml` | Containerized |
| `supabase/config.toml` | Supabase |
| `prisma/schema.prisma` | Prisma ORM |
| `drizzle.config.*` | Drizzle ORM |
| `.env.example`, `.env.local` | Environment-based config |

### 2. Detect Conventions
For each detected technology, search for patterns:

- **Folder structure** — Run `list_dir` on root and key directories (`src/`, `app/`, `lib/`, `components/`, `pages/`, `api/`)
- **Import style** — Are imports using `@/` aliases? Relative paths? Barrel files?
- **Naming conventions** — Check 3-5 files for camelCase vs snake_case, PascalCase components, etc.
- **Testing** — Find test files to detect framework (Jest, Vitest, pytest, go test, etc.)
- **State management** — Search for Redux, Zustand, Pinia, Context, signals, etc.
- **Styling** — Detect Tailwind, CSS Modules, styled-components, Sass, etc.
- **Error handling** — Find how errors are thrown and caught
- **API patterns** — REST, GraphQL, tRPC, Server Actions, etc.

### 3. Generate `.github/copilot-instructions.md`

Create the file with this structure:

```markdown
# Project: [name from package.json or folder name]

## Tech Stack
[List detected technologies with versions]

## Project Structure
[Key directories and their purpose]

## Conventions
[Detected naming, import, and styling patterns]

## Architecture
[Detected patterns: monolith, microservices, monorepo, etc.]

## State Management
[Detected state management approach]

## Database & ORM
[Detected database and ORM patterns]

## Testing
[Test framework and conventions]

## Important Rules
[Any special rules detected from existing lint configs, .editorconfig, etc.]
```

### 4. Confirm with User
After generating, show a summary of what was detected and ask if anything needs correction.

## Rules
- Be thorough — scan at least 10 files to understand patterns
- Don't guess — only include what you can verify from the codebase
- If `.github/copilot-instructions.md` already exists, read it first and offer to update (don't overwrite)
- Include the detected stack versions (from lockfiles or config files)
