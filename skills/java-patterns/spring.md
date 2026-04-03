# Spring Boot Patterns

## Dependency Injection

```java
// GOOD: Constructor injection (preferred — immutable, testable)
@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    // Spring auto-injects — @Autowired not needed for single constructor
    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }
}

// BAD: Field injection — untestable, hidden dependencies
@Service
public class UserService {
    @Autowired private UserRepository userRepository; // Can't set in tests!
}
```

## REST Controller Pattern

```java
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getById(@PathVariable String id) {
        return userService.findById(id)
            .map(UserResponse::from)
            .map(ResponseEntity::ok)
            .orElseThrow(() -> new UserNotFoundException(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserResponse create(@Valid @RequestBody CreateUserRequest request) {
        return UserResponse.from(userService.create(request));
    }
}
```

## Global Error Handling

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(UserNotFoundException ex) {
        return ResponseEntity.status(404)
            .body(new ErrorResponse("USER_NOT_FOUND", ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        List<String> errors = ex.getBindingResult().getFieldErrors().stream()
            .map(e -> "%s: %s".formatted(e.getField(), e.getDefaultMessage()))
            .toList();
        return ResponseEntity.badRequest()
            .body(new ErrorResponse("VALIDATION_ERROR", "Invalid input", errors));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneric(Exception ex) {
        log.error("Unhandled exception", ex);
        return ResponseEntity.internalServerError()
            .body(new ErrorResponse("INTERNAL_ERROR", "An unexpected error occurred"));
    }
}

public record ErrorResponse(String code, String message, List<String> details) {
    public ErrorResponse(String code, String message) {
        this(code, message, List.of());
    }
}
```

## Configuration with @ConfigurationProperties

```java
@ConfigurationProperties(prefix = "app")
public record AppProperties(
    String name,
    @DurationUnit(ChronoUnit.SECONDS) Duration requestTimeout,
    DatabaseProperties database
) {
    public record DatabaseProperties(String url, int poolSize) {}
}

// application.yml
// app:
//   name: MyApp
//   request-timeout: 30
//   database:
//     url: jdbc:postgresql://localhost/mydb
//     pool-size: 10
```

## Profiles

```java
@Configuration
@Profile("production")
public class ProductionConfig {
    @Bean
    public DataSource dataSource(AppProperties props) {
        // Production-specific datasource with connection pooling
    }
}

@Configuration
@Profile("test")
public class TestConfig {
    @Bean
    public DataSource dataSource() {
        // In-memory H2 for tests
    }
}
```

## Transaction Management

```java
@Service
@Transactional(readOnly = true) // Default: read-only for queries
public class OrderService {
    
    @Transactional // Writable transaction for mutations
    public Order placeOrder(PlaceOrderRequest request) {
        var user = userRepository.findById(request.userId())
            .orElseThrow(() -> new UserNotFoundException(request.userId()));
        var order = Order.create(user, request.items());
        return orderRepository.save(order);
    }

    public List<Order> findByUser(String userId) {
        return orderRepository.findByUserId(userId); // Uses read-only tx
    }
}
```
