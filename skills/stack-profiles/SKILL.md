---
name: stack-profiles
description: "Pre-built technology stack profiles for common project types. Load when bootstrapping projects, choosing technologies, or advising on architecture decisions. Triggers: stack, boilerplate, scaffold, new project, tech choice."
---

# Stack Profiles

Curated technology stacks for common project types. Use as reference when bootstrapping or advising.

## SaaS Web App (Full-Stack)

```yaml
Frontend: Next.js 14+ (App Router), React, TypeScript, Tailwind CSS
Backend: Next.js API Routes / tRPC
Database: PostgreSQL + Drizzle ORM (or Prisma)
Auth: NextAuth.js or Clerk
Payments: Stripe
Hosting: Vercel (frontend) + Supabase (DB + Auth alt)
Testing: Vitest + Playwright
CI/CD: GitHub Actions
Monitoring: Sentry
```

## REST API (Microservice)

```yaml
Runtime: Node.js + Express/Fastify OR Go + Chi/Fiber
Database: PostgreSQL + raw SQL/sqlx
Cache: Redis
Auth: JWT + refresh tokens
Docs: OpenAPI/Swagger
Containerization: Docker + Docker Compose
Hosting: Fly.io / Railway / AWS ECS
Testing: Vitest/Jest (Node) OR go test (Go)
Observability: Prometheus + Grafana + structured logging
```

## Mobile App (Cross-Platform)

```yaml
Framework: React Native + Expo OR Flutter
State: Zustand (RN) / Riverpod (Flutter)
Navigation: Expo Router (RN) / GoRouter (Flutter)
Backend: Supabase or Firebase
Push Notifications: Expo Notifications / FCM
CI/CD: EAS Build (RN) / Codemagic (Flutter)
Testing: Jest + Detox (RN) / widget tests + integration_test (Flutter)
```

## CLI Tool

```yaml
Language: Go (cobra) OR Rust (clap) OR Node.js (commander)
Config: YAML/TOML loaded from ~/.config/toolname/
Distribution: Homebrew, npm, cargo, goreleaser
Testing: go test / cargo test / vitest
CI/CD: GitHub Actions + goreleaser/cargo-dist
```

## Data Pipeline / ETL

```yaml
Language: Python 3.11+
Orchestration: Airflow / Dagster / Prefect
Storage: PostgreSQL + S3 (data lake)
Processing: Pandas / Polars / DuckDB
Queue: Redis / RabbitMQ / Kafka
Monitoring: Prometheus + Grafana
Testing: pytest + Great Expectations
```

## Real-Time App (Chat, Collab)

```yaml
Frontend: React + TypeScript
Real-Time: WebSocket (Socket.io) OR SSE OR LiveKit
Backend: Node.js + Express OR Elixir + Phoenix
Database: PostgreSQL + Redis (pub/sub + cache)
File Storage: S3 / R2 + signed URLs
Auth: Clerk / Auth0
Hosting: Fly.io (global edge)
```

## E-Commerce

```yaml
Frontend: Next.js + Tailwind + Headless CMS
Backend: Medusa.js OR custom API
Database: PostgreSQL
Payments: Stripe
Search: Meilisearch / Algolia
Email: Resend / SendGrid
Hosting: Vercel + Railway
Analytics: PostHog / Plausible
```

## Game (2D/Indie)

```yaml
Engine: Godot (GDScript) OR Unity (C#) OR Phaser (JS)
Assets: Aseprite (pixel art), FMOD (audio)
Version Control: Git + LFS
Distribution: Steam (Steamworks SDK), itch.io
CI: GitHub Actions + build scripts
```

## AI/ML Application

```yaml
Language: Python 3.11+
Framework: FastAPI (API) + Streamlit (demo UI)
ML: PyTorch / HuggingFace Transformers
Vector DB: Pinecone / Qdrant / Chroma
LLM: OpenAI API / Anthropic / local (llama.cpp)
Orchestration: LangChain / LlamaIndex
Hosting: Modal / Replicate / AWS SageMaker
Monitoring: Weights & Biases / MLflow
```

## Static Site / Blog

```yaml
Framework: Astro OR Hugo OR 11ty
Styling: Tailwind CSS
CMS: MDX files OR Sanity OR Contentful
Search: Pagefind (static) / Algolia
Hosting: Vercel / Cloudflare Pages / Netlify
Analytics: Plausible / Fathom
Comments: Giscus (GitHub Discussions)
```
