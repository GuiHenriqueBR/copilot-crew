---
description: "Gera Dockerfile + docker-compose otimizados para qualquer stack."
---

# Generate Dockerfile

Create a production-ready Docker setup for: **${input:description}**

- **Stack**: ${input:stack}

## Requirements
1. **Multi-stage build**: separate build and runtime stages
2. **Minimal base image**: `alpine` or `slim` variants
3. **Security**:
   - Run as non-root user
   - No secrets in the image
   - Pin base image versions (not `:latest`)
   - Use `.dockerignore`
4. **Performance**:
   - Layer caching optimization (copy dependency files first, then source)
   - Minimize layers
   - Use `--no-cache` for package managers
5. **Health check**: `HEALTHCHECK` instruction
6. **docker-compose.yml**: with all services, volumes, networks, environment variables
7. **`.dockerignore`**: exclude node_modules, .git, build artifacts, tests

## Output
- `Dockerfile` (multi-stage, production-ready)
- `docker-compose.yml` (dev environment with hot reload)
- `docker-compose.prod.yml` (production with proper restart policies)
- `.dockerignore`
