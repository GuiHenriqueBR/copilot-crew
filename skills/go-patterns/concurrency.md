# Go Concurrency Patterns

## Worker Pool

```go
func workerPool(ctx context.Context, jobs <-chan Job, numWorkers int) <-chan Result {
    results := make(chan Result, numWorkers)
    var wg sync.WaitGroup

    for range numWorkers {
        wg.Add(1)
        go func() {
            defer wg.Done()
            for {
                select {
                case job, ok := <-jobs:
                    if !ok { return }
                    results <- process(job)
                case <-ctx.Done():
                    return
                }
            }
        }()
    }

    go func() {
        wg.Wait()
        close(results)
    }()

    return results
}
```

## Fan-Out / Fan-In

```go
// Fan-out: multiple goroutines read from same channel
// Fan-in: merge multiple channels into one
func fanIn(ctx context.Context, channels ...<-chan Result) <-chan Result {
    merged := make(chan Result)
    var wg sync.WaitGroup

    for _, ch := range channels {
        wg.Add(1)
        go func(c <-chan Result) {
            defer wg.Done()
            for {
                select {
                case val, ok := <-c:
                    if !ok { return }
                    select {
                    case merged <- val:
                    case <-ctx.Done():
                        return
                    }
                case <-ctx.Done():
                    return
                }
            }
        }(ch)
    }

    go func() { wg.Wait(); close(merged) }()
    return merged
}
```

## errgroup for Parallel Tasks with Error Handling

```go
import "golang.org/x/sync/errgroup"

func fetchAllUsers(ctx context.Context, ids []string) ([]*User, error) {
    g, ctx := errgroup.WithContext(ctx)
    users := make([]*User, len(ids))

    for i, id := range ids {
        g.Go(func() error {
            user, err := fetchUser(ctx, id)
            if err != nil {
                return fmt.Errorf("fetch user %s: %w", id, err)
            }
            users[i] = user // Safe: each goroutine writes to unique index
            return nil
        })
    }

    if err := g.Wait(); err != nil {
        return nil, err
    }
    return users, nil
}
```

## Semaphore (Limit Concurrency)

```go
import "golang.org/x/sync/semaphore"

var sem = semaphore.NewWeighted(10) // Max 10 concurrent operations

func limitedProcess(ctx context.Context, item Item) error {
    if err := sem.Acquire(ctx, 1); err != nil {
        return fmt.Errorf("acquire semaphore: %w", err)
    }
    defer sem.Release(1)

    return process(item)
}
```

## sync.Once for Lazy Initialization

```go
type DBPool struct {
    once sync.Once
    pool *pgxpool.Pool
}

func (d *DBPool) Get(ctx context.Context) (*pgxpool.Pool, error) {
    var initErr error
    d.once.Do(func() {
        d.pool, initErr = pgxpool.New(ctx, os.Getenv("DATABASE_URL"))
    })
    if initErr != nil {
        return nil, fmt.Errorf("init db pool: %w", initErr)
    }
    return d.pool, nil
}
```

## Select with Timeout

```go
func fetchWithTimeout(ctx context.Context, url string) ([]byte, error) {
    ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
    defer cancel()

    ch := make(chan result, 1)
    go func() {
        data, err := http.Get(url)
        ch <- result{data, err}
    }()

    select {
    case r := <-ch:
        return r.data, r.err
    case <-ctx.Done():
        return nil, fmt.Errorf("fetch %s: %w", url, ctx.Err())
    }
}
```

## Channel Patterns Cheat Sheet

```go
// Signal channel (done/quit)
done := make(chan struct{})
close(done) // Broadcast to all receivers

// Generator
func gen(nums ...int) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for _, n := range nums { out <- n }
    }()
    return out
}

// Pipeline stage
func square(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for n := range in { out <- n * n }
    }()
    return out
}
```
