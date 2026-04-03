# Go Idioms

## Error Handling — Always Wrap Context

```go
// BAD: Raw error propagation
result, err := db.Query(query)
if err != nil {
    return err // Caller has no idea what failed
}

// GOOD: Wrap with context using %w for error chain
result, err := db.Query(query)
if err != nil {
    return fmt.Errorf("query users by email %q: %w", email, err)
}
```

## Errors Are Values — Custom Error Types

```go
// Define sentinel errors for expected conditions
var (
    ErrNotFound     = errors.New("not found")
    ErrUnauthorized = errors.New("unauthorized")
)

// Custom error type for rich context
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation failed on %s: %s", e.Field, e.Message)
}

// Check with errors.Is / errors.As
if errors.Is(err, ErrNotFound) { /* handle 404 */ }

var validErr *ValidationError
if errors.As(err, &validErr) {
    log.Printf("invalid field: %s", validErr.Field)
}
```

## Accept Interfaces, Return Structs

```go
// BAD: Accept concrete type — tight coupling
func ProcessUser(repo *PostgresUserRepo) error { /* ... */ }

// GOOD: Accept interface — loose coupling
type UserReader interface {
    GetByID(ctx context.Context, id string) (*User, error)
}

func ProcessUser(repo UserReader) error { /* ... */ }
// Now works with any implementation: Postgres, Redis, mock, etc.

// Return concrete type — let caller decide interface
func NewUserService(repo UserReader) *UserService {
    return &UserService{repo: repo}
}
```

## Small Interfaces (1-2 methods)

```go
// Go convention: keep interfaces tiny
type Reader interface { Read(p []byte) (n int, err error) }
type Writer interface { Write(p []byte) (n int, err error) }
type Closer interface { Close() error }

// Compose when needed
type ReadWriteCloser interface {
    Reader
    Writer
    Closer
}
```

## Naming Conventions

```go
// Exported: PascalCase        | Unexported: camelCase
// Interfaces: -er suffix       | io.Reader, fmt.Stringer
// Getters: NO Get prefix      | user.Name() not user.GetName()
// Package: lowercase, single  | "user" not "userManager"
// Acronyms: all caps          | HTTPServer, XMLParser, userID
// Context: first param always | func Do(ctx context.Context, ...) error
```

## Functional Options Pattern

```go
type Server struct {
    port    int
    timeout time.Duration
    logger  *slog.Logger
}

type Option func(*Server)

func WithPort(port int) Option {
    return func(s *Server) { s.port = port }
}

func WithTimeout(d time.Duration) Option {
    return func(s *Server) { s.timeout = d }
}

func NewServer(opts ...Option) *Server {
    s := &Server{port: 8080, timeout: 30 * time.Second}
    for _, opt := range opts {
        opt(s)
    }
    return s
}

// Usage: clean, extensible, backward-compatible
srv := NewServer(WithPort(9090), WithTimeout(5*time.Second))
```

## Context Propagation

```go
// ALWAYS pass context as first parameter
func (s *UserService) GetByID(ctx context.Context, id string) (*User, error) {
    // Use context for cancellation, deadlines, and request-scoped values
    ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
    defer cancel()

    return s.repo.FindByID(ctx, id)
}
```

## Defer for Cleanup

```go
func processFile(path string) error {
    f, err := os.Open(path)
    if err != nil {
        return fmt.Errorf("open %s: %w", path, err)
    }
    defer f.Close() // Guaranteed cleanup

    // Process file...
    return nil
}
```
