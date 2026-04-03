# C# Idioms (C# 11+)

## Records (immutable data)

```csharp
// Immutable, value equality, with expression for copies
public record User(string Id, string Name, string Email);

var user = new User("1", "Alice", "alice@test.com");
var updated = user with { Name = "Alice Smith" }; // Non-destructive copy

// Record struct (stack-allocated)
public readonly record struct Point(double X, double Y);
```

## Pattern Matching

```csharp
// Switch expressions with patterns
public decimal CalculateDiscount(Order order) => order switch
{
    { Total: > 1000, Customer.IsPremium: true } => order.Total * 0.20m,
    { Total: > 500 } => order.Total * 0.10m,
    { Items.Count: > 10 } => order.Total * 0.05m,
    _ => 0m,
};

// List patterns (C# 11)
int[] numbers = [1, 2, 3, 4, 5];
var result = numbers switch
{
    [1, .., 5] => "starts with 1, ends with 5",
    [_, _, 3, ..] => "third element is 3",
    { Length: 0 } => "empty",
    _ => "other",
};

// is pattern with and/or
if (obj is string { Length: > 0 and < 100 } name)
{
    Console.WriteLine(name.ToUpper());
}
```

## Nullable Reference Types

```csharp
// Enable in .csproj: <Nullable>enable</Nullable>

public User? FindById(string id) // Explicitly nullable return
{
    return _users.GetValueOrDefault(id);
}

// Null checks
var user = FindById(id) ?? throw new NotFoundException($"User {id} not found");

// Null-conditional + null-coalescing
string displayName = user?.Profile?.DisplayName ?? user?.Name ?? "Anonymous";
```

## LINQ

```csharp
// Prefer method syntax for complex queries
var activeAdmins = users
    .Where(u => u.IsActive && u.Roles.Contains("admin"))
    .OrderBy(u => u.Name)
    .Select(u => new UserDto(u.Id, u.Name, u.Email))
    .ToList();

// GroupBy
var ordersByStatus = orders
    .GroupBy(o => o.Status)
    .ToDictionary(g => g.Key, g => g.ToList());

// Aggregate
decimal total = items.Sum(i => i.Price * i.Quantity);
```

## Collection Expressions (C# 12)

```csharp
// Unified syntax for all collections
int[] numbers = [1, 2, 3, 4, 5];
List<string> names = ["Alice", "Bob"];
Span<byte> buffer = [0x00, 0xFF];

// Spread operator
int[] combined = [..first, ..second, 99];
```

## Raw String Literals

```csharp
var json = """
    {
        "id": "1",
        "name": "Alice",
        "email": "alice@test.com"
    }
    """;

// Interpolated raw strings
var query = $$"""
    SELECT * FROM users
    WHERE id = '{{userId}}'
    AND status = 'active'
    """;
```

## Async/Await

```csharp
// ALWAYS use Async suffix and CancellationToken
public async Task<User> GetUserAsync(string id, CancellationToken ct = default)
{
    var response = await _httpClient.GetAsync($"/users/{id}", ct);
    response.EnsureSuccessStatusCode();
    return await response.Content.ReadFromJsonAsync<User>(ct)
        ?? throw new InvalidOperationException("Null response body");
}

// Parallel async
var tasks = userIds.Select(id => GetUserAsync(id, ct));
var users = await Task.WhenAll(tasks);

// NEVER: .Result or .Wait() — deadlock risk
// NEVER: async void (except event handlers)
// ALWAYS: ConfigureAwait(false) in library code
```

## Span<T> (zero-allocation slicing)

```csharp
// Parse without string allocations
ReadOnlySpan<char> input = "2024-01-15".AsSpan();
var year = int.Parse(input[..4]);
var month = int.Parse(input[5..7]);
var day = int.Parse(input[8..10]);
```

## Primary Constructors (C# 12)

```csharp
public class UserService(IUserRepository repo, ILogger<UserService> logger)
{
    public async Task<User> GetByIdAsync(string id, CancellationToken ct)
    {
        logger.LogInformation("Fetching user {UserId}", id);
        return await repo.FindByIdAsync(id, ct)
            ?? throw new NotFoundException($"User {id} not found");
    }
}
```
