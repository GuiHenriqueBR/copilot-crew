---
description: "Gera .env.example documentado escaneando o código por variáveis de ambiente."
---

# Generate .env.example

Scan the codebase for all environment variable references and generate a documented `.env.example` file.

## Rules
1. Search for all patterns: `process.env.`, `os.environ`, `env::var`, `os.Getenv`, `Environment.GetEnvironmentVariable`, `import.meta.env.`
2. Group variables by category (Database, Auth, API Keys, Feature Flags, etc.)
3. Add comments explaining each variable's purpose
4. Use placeholder values that indicate the expected format
5. Mark required vs optional variables
6. Include sensible defaults where applicable
7. Never include actual secret values

## Output Format
```env
# ============================================
# Database
# ============================================
# PostgreSQL connection string (required)
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Connection pool size (optional, default: 10)
# DB_POOL_SIZE=10

# ============================================
# Authentication
# ============================================
# JWT secret key - generate with: openssl rand -base64 32 (required)
JWT_SECRET=your-secret-key-here
```

Create the `.env.example` file in the project root.
