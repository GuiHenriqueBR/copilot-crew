---
description: "Gera migration SQL a partir de descrição em linguagem natural."
---

# Generate Migration

Create a database migration for: **${input:description}**

- **Database**: ${input:database}

## Rules
1. Generate both `up` and `down` (rollback) migration
2. Use `IF NOT EXISTS` / `IF EXISTS` for idempotency
3. Add appropriate indexes for foreign keys and commonly queried columns
4. Use `timestamptz` for timestamps (PostgreSQL)
5. Use `uuid` for primary keys (or `bigserial` if specified)
6. Add `created_at` and `updated_at` to new tables
7. Add proper `ON DELETE` behavior to foreign keys
8. Add `CHECK` constraints for data validation
9. Add comments explaining complex constraints
10. For PostgreSQL: use `CREATE INDEX CONCURRENTLY` for production-safe index creation
11. Consider existing schema — read migration files first to avoid conflicts

## Output
```sql
-- Migration: <name>
-- Description: <what this migration does>

-- UP
<SQL statements>

-- DOWN
<rollback SQL statements>
```

Number the migration file to follow the existing sequence.
