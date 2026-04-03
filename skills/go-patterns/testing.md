# Go Testing Patterns

## Table-Driven Tests

```go
func TestParseAmount(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    int64
        wantErr bool
    }{
        {name: "valid integer", input: "100", want: 100},
        {name: "valid decimal", input: "10.50", want: 1050},
        {name: "zero", input: "0", want: 0},
        {name: "negative", input: "-5", want: -500},
        {name: "empty string", input: "", wantErr: true},
        {name: "non-numeric", input: "abc", wantErr: true},
        {name: "overflow", input: "99999999999999999999", wantErr: true},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := ParseAmount(tt.input)
            if tt.wantErr {
                require.Error(t, err)
                return
            }
            require.NoError(t, err)
            assert.Equal(t, tt.want, got)
        })
    }
}
```

## Testify (assert + require)

```go
import (
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)

func TestUserService(t *testing.T) {
    // require: stops test on failure (for preconditions)
    user, err := svc.Create(ctx, input)
    require.NoError(t, err)
    require.NotNil(t, user)

    // assert: continues test on failure (for validations)
    assert.Equal(t, "alice@test.com", user.Email)
    assert.NotEmpty(t, user.ID)
    assert.WithinDuration(t, time.Now(), user.CreatedAt, time.Second)
}
```

## HTTP Handler Testing

```go
func TestGetUserHandler(t *testing.T) {
    // Arrange
    repo := &mockUserRepo{
        users: map[string]*User{"123": {ID: "123", Name: "Alice"}},
    }
    handler := NewUserHandler(repo)

    // Act
    req := httptest.NewRequest(http.MethodGet, "/users/123", nil)
    req.SetPathValue("id", "123") // Go 1.22+ routing
    rec := httptest.NewRecorder()
    handler.GetByID(rec, req)

    // Assert
    require.Equal(t, http.StatusOK, rec.Code)

    var user User
    err := json.NewDecoder(rec.Body).Decode(&user)
    require.NoError(t, err)
    assert.Equal(t, "Alice", user.Name)
}
```

## Benchmarks

```go
func BenchmarkParseAmount(b *testing.B) {
    for b.Loop() {
        ParseAmount("123.45")
    }
}

// Run: go test -bench=. -benchmem
// Output: BenchmarkParseAmount-8  5000000  234 ns/op  48 B/op  2 allocs/op
```

## TestMain for Setup/Teardown

```go
func TestMain(m *testing.M) {
    // Setup: start test database, seed data, etc.
    db := setupTestDB()

    code := m.Run()

    // Teardown
    db.Close()
    os.Exit(code)
}
```

## Mock Interfaces

```go
// Define interface in consumer package (not producer)
type UserRepository interface {
    FindByID(ctx context.Context, id string) (*User, error)
    Save(ctx context.Context, user *User) error
}

// Mock in test file
type mockUserRepo struct {
    users map[string]*User
    err   error
}

func (m *mockUserRepo) FindByID(_ context.Context, id string) (*User, error) {
    if m.err != nil { return nil, m.err }
    user, ok := m.users[id]
    if !ok { return nil, ErrNotFound }
    return user, nil
}

func (m *mockUserRepo) Save(_ context.Context, user *User) error {
    if m.err != nil { return m.err }
    m.users[user.ID] = user
    return nil
}
```

## t.Parallel() for Independent Tests

```go
func TestConcurrentSafe(t *testing.T) {
    tests := []struct{ name, input string }{
        {"case1", "a"}, {"case2", "b"}, {"case3", "c"},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel() // Runs subtests concurrently
            got := process(tt.input)
            assert.NotEmpty(t, got)
        })
    }
}
```
