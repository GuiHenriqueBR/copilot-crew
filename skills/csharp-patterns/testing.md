# C# Testing Patterns

## xUnit Structure

```csharp
public class UserServiceTests
{
    private readonly IUserRepository _mockRepo;
    private readonly UserService _sut; // System Under Test

    public UserServiceTests()
    {
        _mockRepo = Substitute.For<IUserRepository>();
        _sut = new UserService(_mockRepo);
    }

    [Fact]
    public async Task GetByIdAsync_ReturnsUser_WhenFound()
    {
        // Arrange
        var expected = new User("1", "Alice", "alice@test.com");
        _mockRepo.FindByIdAsync("1", Arg.Any<CancellationToken>())
            .Returns(expected);

        // Act
        var result = await _sut.GetByIdAsync("1");

        // Assert
        result.Should().NotBeNull();
        result.Name.Should().Be("Alice");
    }

    [Fact]
    public async Task GetByIdAsync_ThrowsNotFound_WhenMissing()
    {
        _mockRepo.FindByIdAsync("999", Arg.Any<CancellationToken>())
            .Returns((User?)null);

        var act = () => _sut.GetByIdAsync("999");

        await act.Should().ThrowAsync<NotFoundException>()
            .WithMessage("*999*");
    }
}
```

## Theory (parameterized tests)

```csharp
[Theory]
[InlineData("alice@test.com", true)]
[InlineData("bob@example.org", true)]
[InlineData("invalid", false)]
[InlineData("", false)]
[InlineData("a@b", false)]
public void IsValidEmail_ReturnsExpected(string email, bool expected)
{
    EmailValidator.IsValid(email).Should().Be(expected);
}

[Theory]
[MemberData(nameof(InvalidRequests))]
public async Task Create_RejectsInvalidRequests(CreateUserRequest request, string expectedError)
{
    var act = () => _sut.CreateAsync(request);
    await act.Should().ThrowAsync<ValidationException>()
        .Where(e => e.Message.Contains(expectedError));
}

public static IEnumerable<object[]> InvalidRequests()
{
    yield return new object[] { new CreateUserRequest("", "a@t.com"), "name" };
    yield return new object[] { new CreateUserRequest("Al", "bad"), "email" };
}
```

## Integration Tests with WebApplicationFactory

```csharp
public class ApiIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public ApiIntegrationTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureServices(services =>
            {
                // Replace real DB with in-memory
                services.RemoveAll<DbContextOptions<AppDbContext>>();
                services.AddDbContext<AppDbContext>(o => o.UseInMemoryDatabase("test"));
            });
        }).CreateClient();
    }

    [Fact]
    public async Task GetUser_Returns200_WhenExists()
    {
        var response = await _client.GetAsync("/api/users/1");

        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var user = await response.Content.ReadFromJsonAsync<UserResponse>();
        user.Should().NotBeNull();
    }

    [Fact]
    public async Task CreateUser_Returns201_WithValidData()
    {
        var request = new CreateUserRequest("Alice", "alice@test.com");

        var response = await _client.PostAsJsonAsync("/api/users", request);

        response.StatusCode.Should().Be(HttpStatusCode.Created);
        response.Headers.Location.Should().NotBeNull();
    }
}
```

## NSubstitute (mocking)

```csharp
// Setup returns
_mockRepo.FindByIdAsync(Arg.Any<string>(), Arg.Any<CancellationToken>())
    .Returns(new User("1", "Alice", "a@t.com"));

// Verify calls
await _mockRepo.Received(1).SaveAsync(
    Arg.Is<User>(u => u.Name == "Alice" && u.Email == "alice@test.com"),
    Arg.Any<CancellationToken>()
);

// Verify no unexpected calls
await _mockRepo.DidNotReceive().DeleteAsync(Arg.Any<string>(), Arg.Any<CancellationToken>());
```

## FluentAssertions

```csharp
// Collections
users.Should().HaveCount(3)
    .And.OnlyContain(u => u.IsActive)
    .And.BeInAscendingOrder(u => u.Name);

// Objects
result.Should().BeEquivalentTo(expected, options =>
    options.Excluding(u => u.CreatedAt));

// Execution time
var act = () => service.ProcessAsync(data);
await act.Should().CompleteWithinAsync(TimeSpan.FromSeconds(5));
```
