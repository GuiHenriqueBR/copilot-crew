---
name: kotlin-patterns
description: "Kotlin idioms, coroutines, Jetpack Compose, and testing patterns. Load for Kotlin code."
---

# Kotlin Patterns Skill

## Key Idioms

### Data Classes & Sealed Hierarchies
```kotlin
data class User(val id: String, val name: String, val email: String)

sealed interface Result<out T> {
    data class Success<T>(val data: T) : Result<T>
    data class Failure(val error: AppError) : Result<Nothing>
}

fun <T> Result<T>.getOrThrow(): T = when (this) {
    is Result.Success -> data
    is Result.Failure -> throw error.toException()
}
```

### Extension Functions & Scope Functions
```kotlin
fun String.isValidEmail(): Boolean = matches(Regex("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$"))

// let — transform nullable
val displayName = user?.name?.let { "Hello, $it" } ?: "Guest"

// apply — configure object
val config = HttpClientConfig().apply {
    timeout = 30.seconds
    retries = 3
    baseUrl = "https://api.example.com"
}

// also — side effect
val user = findUser(id).also { logger.info("Found user: ${it?.name}") }
```

### Coroutines
```kotlin
// Structured concurrency
suspend fun fetchUsers(): List<User> = coroutineScope {
    val users = async { api.getUsers() }
    val roles = async { api.getRoles() }
    mergeUsersWithRoles(users.await(), roles.await())
}

// Flow (reactive streams)
fun observeUsers(): Flow<List<User>> = flow {
    while (true) {
        emit(api.getUsers())
        delay(30.seconds)
    }
}.catch { e -> logger.error("Failed to fetch users", e) }
 .flowOn(Dispatchers.IO)
```

### Null Safety
```kotlin
// Elvis operator for defaults
val name = user?.name ?: "Unknown"

// Safe call chain
val city = user?.address?.city?.uppercase()

// require/check for preconditions
fun processOrder(order: Order) {
    require(order.items.isNotEmpty()) { "Order must have items" }
    check(order.status == Status.PENDING) { "Order must be pending" }
}
```

## Jetpack Compose
```kotlin
@Composable
fun UserCard(user: User, onTap: () -> Unit, modifier: Modifier = Modifier) {
    Card(modifier = modifier.clickable(onClick = onTap)) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(user.name, style = MaterialTheme.typography.titleMedium)
            Text(user.email, style = MaterialTheme.typography.bodySmall)
        }
    }
}
```

## Testing
```kotlin
class UserServiceTest {
    private val mockRepo = mockk<UserRepository>()
    private val service = UserService(mockRepo)

    @Test
    fun `returns user when found`() = runTest {
        coEvery { mockRepo.findById("1") } returns User("1", "Alice", "a@t.com")
        val result = service.findById("1")
        assertThat(result.name).isEqualTo("Alice")
        coVerify(exactly = 1) { mockRepo.findById("1") }
    }

    @Test
    fun `throws when user not found`() = runTest {
        coEvery { mockRepo.findById("999") } returns null
        assertFailsWith<NotFoundException> { service.findById("999") }
    }
}
```
