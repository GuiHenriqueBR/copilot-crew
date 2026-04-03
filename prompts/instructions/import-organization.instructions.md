---
description: "Use when writing or modifying any code. Enforces consistent import ordering by group."
applyTo: "**/*.{ts,tsx,js,jsx,py,go,rs,cs,java}"
---

# Import Organization

## Order (top to bottom, blank line between groups)

### TypeScript / JavaScript
```typescript
// 1. Node built-ins (node: prefix)
import { readFile } from 'node:fs/promises';

// 2. External packages (npm)
import React from 'react';
import { useQuery } from '@tanstack/react-query';

// 3. Internal aliases (@/ or ~/)
import { Button } from '@/components/Button';
import { useAuth } from '@/hooks/useAuth';

// 4. Relative imports (parent first, then siblings)
import { validate } from '../utils';
import { schema } from './schema';

// 5. Type-only imports (last)
import type { User } from '@/types';
```

### Python
```python
# 1. Standard library
import os
from pathlib import Path

# 2. Third-party
import requests
from fastapi import FastAPI

# 3. Local / project
from app.services import UserService
from .models import User
```

### Go
```go
import (
    // 1. Standard library
    "context"
    "fmt"

    // 2. External modules
    "github.com/gin-gonic/gin"

    // 3. Internal packages
    "myapp/internal/service"
)
```

## Rules
- ALWAYS separate groups with a blank line
- ALWAYS sort alphabetically within each group
- NEVER use wildcard imports (`import *`) unless framework requires it
- REMOVE unused imports immediately
- PREFER named imports over default imports (TypeScript)
- USE type-only imports (`import type`) when importing only types (TypeScript)
