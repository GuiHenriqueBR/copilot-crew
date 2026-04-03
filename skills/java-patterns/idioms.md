# Java Idioms (Java 17+)

## Records (immutable data carriers)

```java
// BAD: Verbose POJO with getters, equals, hashCode, toString
public class UserDTO {
    private final String id;
    private final String name;
    // 40+ lines of boilerplate...
}

// GOOD: Record — immutable, compact, auto-generated methods
public record UserDTO(String id, String name, String email) {
    // Compact constructor for validation
    public UserDTO {
        Objects.requireNonNull(id, "id must not be null");
        Objects.requireNonNull(email, "email must not be null");
    }
}
```

## Sealed Classes (restricted hierarchies)

```java
public sealed interface Shape permits Circle, Rectangle, Triangle {
    double area();
}

public record Circle(double radius) implements Shape {
    public double area() { return Math.PI * radius * radius; }
}
public record Rectangle(double w, double h) implements Shape {
    public double area() { return w * h; }
}
public record Triangle(double base, double height) implements Shape {
    public double area() { return 0.5 * base * height; }
}
```

## Pattern Matching (switch expressions)

```java
// Java 21+: exhaustive pattern matching
public String describe(Shape shape) {
    return switch (shape) {
        case Circle c when c.radius() > 100 -> "Large circle r=%s".formatted(c.radius());
        case Circle c -> "Circle r=%s".formatted(c.radius());
        case Rectangle r -> "Rectangle %sx%s".formatted(r.w(), r.h());
        case Triangle t -> "Triangle base=%s".formatted(t.base());
        // No default needed — sealed interface is exhaustive
    };
}

// instanceof pattern matching
if (obj instanceof String s && s.length() > 5) {
    System.out.println(s.toUpperCase());
}
```

## Optional (never return null)

```java
// BAD: Return null
public User findById(String id) {
    return userMap.get(id); // null if not found
}

// GOOD: Return Optional
public Optional<User> findById(String id) {
    return Optional.ofNullable(userMap.get(id));
}

// Usage — functional chaining, no null checks
String email = userService.findById(id)
    .map(User::email)
    .orElseThrow(() -> new UserNotFoundException(id));

// NEVER: Optional.get() without check — defeats the purpose
// NEVER: Optional as method parameter — use overloads instead
// NEVER: Optional for fields — use null with @Nullable
```

## Streams (declarative data processing)

```java
// Collect with downstream operations
Map<String, List<Order>> ordersByCustomer = orders.stream()
    .filter(o -> o.status() == Status.COMPLETED)
    .collect(Collectors.groupingBy(Order::customerId));

// Parallel streams — only for CPU-heavy, large datasets (>10K elements)
long count = hugeList.parallelStream()
    .filter(item -> expensiveCheck(item))
    .count();

// toList() shorthand (Java 16+)
List<String> names = users.stream()
    .map(User::name)
    .toList(); // Unmodifiable list
```

## Text Blocks

```java
String json = """
    {
        "id": "%s",
        "name": "%s",
        "email": "%s"
    }
    """.formatted(user.id(), user.name(), user.email());
```

## Try-with-Resources

```java
// ALWAYS use for AutoCloseable resources
try (var conn = dataSource.getConnection();
     var stmt = conn.prepareStatement(SQL);
     var rs = stmt.executeQuery()) {
    while (rs.next()) {
        results.add(mapRow(rs));
    }
}
// All three resources auto-closed in reverse order
```

## Null Safety Conventions

```java
// Use annotations to document nullability
public @NonNull User createUser(@NonNull CreateUserRequest request) { }

// Use Objects.requireNonNull at boundaries
public UserService(@NonNull UserRepository repo) {
    this.repo = Objects.requireNonNull(repo, "repo must not be null");
}
```
