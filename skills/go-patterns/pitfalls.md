# Go Pitfalls

## Goroutine Leaks

```go
// BAD: Goroutine blocks forever on unbuffered channel
func fetchAll(urls []string) {
    ch := make(chan string)
    for _, url := range urls {
        go func(u string) {
            ch <- fetch(u) // Blocks if nobody reads
        }(url)
    }
    // Only read first result — other goroutines leak!
    result := <-ch
}

// GOOD: Use context cancellation or buffered channel
func fetchAll(ctx context.Context, urls []string) []string {
    ch := make(chan string, len(urls)) // Buffered: won't block
    for _, url := range urls {
        go func(u string) {
            select {
            case ch <- fetch(u):
            case <-ctx.Done():
                return
            }
        }(url)
    }
    results := make([]string, 0, len(urls))
    for range urls {
        results = append(results, <-ch)
    }
    return results
}
```

## Nil Map Write Panic

```go
// BAD: Writing to nil map panics
var m map[string]int
m["key"] = 1 // panic: assignment to entry in nil map

// GOOD: Always initialize
m := make(map[string]int)
m["key"] = 1

// GOOD: Reading from nil map is safe (returns zero value)
var m map[string]int
_ = m["key"] // Returns 0, no panic
```

## Nil Slice Gotchas

```go
// nil slice and empty slice behave differently with JSON
var nilSlice []string        // json.Marshal → "null"
emptySlice := []string{}     // json.Marshal → "[]"
emptySlice := make([]string, 0) // json.Marshal → "[]"

// RULE: For API responses, always initialize slices
type Response struct {
    Items []Item `json:"items"`
}
// In constructor: Items: make([]Item, 0)
```

## Loop Variable Capture (pre-Go 1.22)

```go
// BAD (Go < 1.22): All goroutines share the same variable
for _, item := range items {
    go func() {
        process(item) // All see the LAST item
    }()
}

// GOOD (Go < 1.22): Capture by parameter
for _, item := range items {
    go func(it Item) {
        process(it)
    }(item)
}

// Go 1.22+: Fixed! Each iteration gets its own variable.
// But still be explicit for clarity in concurrent code.
```

## Defer in Loops

```go
// BAD: Deferred calls accumulate, run only when function exits
for _, file := range files {
    f, err := os.Open(file)
    if err != nil { continue }
    defer f.Close() // All files stay open until function returns!
}

// GOOD: Use a closure or explicit close
for _, file := range files {
    if err := processFile(file); err != nil {
        log.Printf("error: %v", err)
    }
}

func processFile(path string) error {
    f, err := os.Open(path)
    if err != nil { return err }
    defer f.Close()
    // ...
    return nil
}
```

## Variable Shadowing

```go
// BAD: Accidentally shadowing err
err := doSomething()
if true {
    result, err := doOther() // NEW err variable, outer err unchanged
    _ = result
}
// err here is still from doSomething(), not doOther()

// GOOD: Use = not := for existing variables
err := doSomething()
if true {
    var result Result
    result, err = doOther() // Same err variable
    _ = result
}
```

## Struct Embedding Gotchas

```go
// Embedding exposes ALL methods — even ones you don't want
type MyServer struct {
    sync.Mutex // Exposes Lock() and Unlock() to users!
}

// GOOD: Use named field for internal use
type MyServer struct {
    mu sync.Mutex // Unexported, not exposed
}
```

## String Concatenation in Loops

```go
// BAD: O(n²) — creates new string each iteration
result := ""
for _, s := range items {
    result += s
}

// GOOD: O(n) — preallocated buffer
var b strings.Builder
for _, s := range items {
    b.WriteString(s)
}
result := b.String()
```
