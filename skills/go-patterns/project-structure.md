# Go Project Structure

## Standard Layout

```
myapp/
├── cmd/                    # Entry points (one per binary)
│   ├── api/
│   │   └── main.go         # API server entry
│   └── worker/
│       └── main.go         # Background worker entry
├── internal/               # Private application code (NOT importable)
│   ├── user/               # Domain: user
│   │   ├── handler.go      # HTTP handlers
│   │   ├── service.go      # Business logic
│   │   ├── repository.go   # Data access interface
│   │   ├── postgres.go     # Postgres implementation
│   │   └── model.go        # Domain types
│   ├── order/              # Domain: order
│   │   └── ...
│   ├── middleware/          # HTTP middleware
│   ├── config/             # App configuration
│   └── platform/           # Infrastructure (db, cache, queue)
│       ├── database/
│       ├── redis/
│       └── kafka/
├── pkg/                    # Public libraries (importable by other projects)
│   └── httputil/           # Only if genuinely reusable
├── migrations/             # SQL migrations
├── api/                    # OpenAPI specs, proto files
├── deployments/            # Docker, k8s manifests
├── go.mod
├── go.sum
├── Makefile
└── README.md
```

## Key Rules

1. **`internal/` is your friend**: Code here CANNOT be imported by other modules. Use it for all application code
2. **`cmd/` has minimal code**: Only wiring — parse config, create deps, start server
3. **`pkg/` is rare**: Only truly reusable, stable libraries go here. Most code belongs in `internal/`
4. **Domain-first grouping**: `internal/user/` not `internal/handlers/`, `internal/services/`
5. **Interface at consumer**: Define interfaces where they're used, not where implemented

## Minimal main.go

```go
// cmd/api/main.go
func main() {
    cfg, err := config.Load()
    if err != nil {
        log.Fatal("load config:", err)
    }

    db, err := database.Connect(cfg.DatabaseURL)
    if err != nil {
        log.Fatal("connect db:", err)
    }
    defer db.Close()

    userRepo := user.NewPostgresRepository(db)
    userSvc := user.NewService(userRepo)
    userHandler := user.NewHandler(userSvc)

    mux := http.NewServeMux()
    userHandler.RegisterRoutes(mux)

    srv := &http.Server{Addr: cfg.Addr(), Handler: mux}
    log.Printf("listening on %s", cfg.Addr())
    log.Fatal(srv.ListenAndServe())
}
```

## Makefile Targets

```makefile
.PHONY: build test lint run migrate

build:
	go build -o bin/api ./cmd/api

test:
	go test ./... -race -coverprofile=coverage.out

lint:
	golangci-lint run ./...

run:
	go run ./cmd/api

migrate:
	goose -dir migrations postgres "$(DATABASE_URL)" up
```
