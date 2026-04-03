# Java Performance

## Virtual Threads (Java 21+)

```java
// BAD: Platform thread per request — limited to ~2000 concurrent
ExecutorService executor = Executors.newFixedThreadPool(200);

// GOOD: Virtual threads — millions of concurrent tasks
ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();

// In Spring Boot 3.2+:
// application.properties: spring.threads.virtual.enabled=true
// All request handling automatically uses virtual threads

// Use virtual threads for I/O-bound work (HTTP calls, DB queries)
// Use platform threads for CPU-bound work (computation, crypto)
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    List<Future<Response>> futures = urls.stream()
        .map(url -> executor.submit(() -> httpClient.send(url)))
        .toList();
}
```

## JVM Tuning Flags

```bash
# Modern GC (Java 17+): ZGC for low latency
java -XX:+UseZGC -XX:+ZGenerational -Xmx4g -jar app.jar

# G1 GC (default): good for most workloads
java -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Xmx4g -jar app.jar

# Container-aware settings
java -XX:+UseContainerSupport \
     -XX:MaxRAMPercentage=75.0 \
     -XX:InitialRAMPercentage=50.0 \
     -jar app.jar

# Debug/Profile flags
java -XX:+HeapDumpOnOutOfMemoryError \
     -XX:HeapDumpPath=/tmp/heapdump.hprof \
     -jar app.jar
```

## Connection Pool Sizing (HikariCP)

```yaml
# Formula: connections = (core_count * 2) + effective_spindle_count
# For SSD: connections ≈ core_count * 2
spring:
  datasource:
    hikari:
      maximum-pool-size: 10      # Don't go higher than 20
      minimum-idle: 5
      idle-timeout: 300000       # 5 minutes
      connection-timeout: 20000  # 20 seconds
      max-lifetime: 1800000      # 30 minutes
```

## Caching with Spring Cache

```java
@Service
@CacheConfig(cacheNames = "users")
public class UserService {
    @Cacheable(key = "#id")
    public User findById(String id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new UserNotFoundException(id));
    }

    @CacheEvict(key = "#user.id")
    public User update(User user) {
        return userRepository.save(user);
    }

    @CacheEvict(allEntries = true)
    @Scheduled(fixedRate = 3600000) // Clear cache every hour
    public void evictAllCache() {}
}
```

## Avoid Common Performance Traps

```java
// BAD: String concatenation in loop — O(n²)
String result = "";
for (String s : items) { result += s; }

// GOOD: StringBuilder — O(n)
StringBuilder sb = new StringBuilder();
for (String s : items) { sb.append(s); }

// BAD: Autoboxing in hot loop
for (int i = 0; i < 1_000_000; i++) {
    Long value = (long) i; // Autoboxing creates object each time
}

// BAD: Creating Date/DateTimeFormatter in loop
for (...) {
    DateTimeFormatter.ofPattern("yyyy-MM-dd"); // Reuse!
}
// GOOD: Static final constant
private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
```
