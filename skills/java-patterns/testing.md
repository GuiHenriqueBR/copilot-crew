# Java Testing Patterns

## JUnit 5 Structure

```java
@DisplayName("UserService")
class UserServiceTest {
    private UserRepository mockRepo;
    private UserService service;

    @BeforeEach
    void setUp() {
        mockRepo = mock(UserRepository.class);
        service = new UserService(mockRepo);
    }

    @Nested
    @DisplayName("findById")
    class FindById {
        @Test
        @DisplayName("should return user when found")
        void returnsUserWhenFound() {
            var expected = new User("1", "Alice", "alice@test.com");
            when(mockRepo.findById("1")).thenReturn(Optional.of(expected));

            var result = service.findById("1");

            assertThat(result).isPresent().contains(expected);
        }

        @Test
        @DisplayName("should return empty when not found")
        void returnsEmptyWhenNotFound() {
            when(mockRepo.findById("999")).thenReturn(Optional.empty());

            assertThat(service.findById("999")).isEmpty();
        }
    }
}
```

## Parameterized Tests

```java
@ParameterizedTest
@CsvSource({
    "alice@test.com, true",
    "bob@example.org, true",
    "invalid, false",
    "'', false",
    "a@b, false"
})
@DisplayName("should validate email format")
void validateEmail(String email, boolean expected) {
    assertThat(EmailValidator.isValid(email)).isEqualTo(expected);
}

@ParameterizedTest
@MethodSource("invalidRequests")
void shouldRejectInvalidRequests(CreateUserRequest request, String expectedError) {
    assertThatThrownBy(() -> service.create(request))
        .isInstanceOf(ValidationException.class)
        .hasMessageContaining(expectedError);
}

static Stream<Arguments> invalidRequests() {
    return Stream.of(
        arguments(new CreateUserRequest(null, "test@t.com"), "name"),
        arguments(new CreateUserRequest("Al", "invalid"), "email")
    );
}
```

## Mockito Best Practices

```java
// Verify behavior, not implementation
verify(mockRepo).save(argThat(user ->
    user.name().equals("Alice") && user.email().equals("alice@test.com")
));

// Verify no unexpected interactions
verifyNoMoreInteractions(mockRepo);

// Capture arguments for complex assertions
ArgumentCaptor<User> captor = ArgumentCaptor.forClass(User.class);
verify(mockRepo).save(captor.capture());
assertThat(captor.getValue().name()).isEqualTo("Alice");

// NEVER: Don't mock value objects (records, DTOs)
// NEVER: Don't mock types you don't own without integration test backup
```

## TestContainers (integration tests)

```java
@Testcontainers
@SpringBootTest
class UserRepositoryIntegrationTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine")
        .withDatabaseName("testdb");

    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }

    @Autowired
    private UserRepository repo;

    @Test
    void shouldPersistAndRetrieveUser() {
        var user = new User(null, "Alice", "alice@test.com");
        var saved = repo.save(user);

        assertThat(saved.id()).isNotNull();
        assertThat(repo.findById(saved.id())).isPresent()
            .get().extracting(User::name).isEqualTo("Alice");
    }
}
```

## AssertJ (prefer over JUnit assertions)

```java
// Rich, fluent assertions
assertThat(users)
    .hasSize(3)
    .extracting(User::name)
    .containsExactly("Alice", "Bob", "Charlie");

assertThat(result)
    .isNotNull()
    .satisfies(r -> {
        assertThat(r.status()).isEqualTo(Status.COMPLETED);
        assertThat(r.total()).isGreaterThan(0);
    });

// Exception assertions
assertThatThrownBy(() -> service.delete("nonexistent"))
    .isInstanceOf(UserNotFoundException.class)
    .hasMessageContaining("nonexistent");
```
