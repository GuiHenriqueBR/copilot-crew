---
description: "Use when creating files or directories. Enforces naming conventions by language and framework."
applyTo: "**"
---

# File & Directory Naming Conventions

## By Language / Framework

### TypeScript / React
| Type | Convention | Example |
|------|-----------|---------|
| Component | `PascalCase.tsx` | `UserProfile.tsx` |
| View / Page | `PascalCase` + `View` suffix | `HomeView.tsx` |
| Hook | `camelCase` with `use` prefix | `useAuth.ts` |
| Context | `PascalCase` + `Context` suffix | `AuthContext.tsx` |
| Utility | `camelCase.ts` | `formatDate.ts`, `utils.ts` |
| Types / Interfaces | `camelCase.types.ts` | `database.types.ts` |
| Test | Same name + `.test.ts` or `.spec.ts` | `useAuth.test.ts` |
| Constants | `camelCase.ts` or `SCREAMING_SNAKE` inside | `config.ts` |
| CSS / Styles | `camelCase.module.css` or `kebab-case.css` | `index.css` |

### Python
| Type | Convention | Example |
|------|-----------|---------|
| Module | `snake_case.py` | `user_service.py` |
| Package | `snake_case/` | `data_pipeline/` |
| Test | `test_` prefix | `test_user_service.py` |
| Config | `snake_case` | `settings.py`, `config.py` |

### Go
| Type | Convention | Example |
|------|-----------|---------|
| File | `snake_case.go` | `user_handler.go` |
| Test | `_test.go` suffix | `user_handler_test.go` |
| Package | lowercase, single word | `auth/`, `handler/` |

### Java / C#
| Type | Convention | Example |
|------|-----------|---------|
| Class | `PascalCase.java` / `.cs` | `UserService.java` |
| Interface | `PascalCase` (Java) / `I` prefix (C#) | `IUserRepository.cs` |
| Test | `PascalCase` + `Test`/`Tests` suffix | `UserServiceTest.java` |

### Rust
| Type | Convention | Example |
|------|-----------|---------|
| Module | `snake_case.rs` | `user_handler.rs` |
| Directory | `snake_case/` | `data_pipeline/` |

### C / C++
| Type | Convention | Example |
|------|-----------|---------|
| Source | `snake_case.c` / `.cpp` | `memory_pool.cpp` |
| Header | `snake_case.h` / `.hpp` | `memory_pool.hpp` |

## Universal Rules
- NEVER use spaces in file or directory names
- NEVER start names with numbers
- ALWAYS use lowercase for directories (except framework convention)
- KEEP names short but descriptive (max 3 words)
- USE index files (`index.ts`) for barrel exports only at directory boundaries
- MATCH file name to primary export name
