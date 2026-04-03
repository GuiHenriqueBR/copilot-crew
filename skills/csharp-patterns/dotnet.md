# ASP.NET Core & EF Core Patterns

## Minimal API

```csharp
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddDbContext<AppDbContext>(o => o.UseNpgsql(connectionString));

var app = builder.Build();

app.MapGet("/api/users/{id}", async (string id, IUserService service, CancellationToken ct) =>
{
    var user = await service.GetByIdAsync(id, ct);
    return user is not null ? Results.Ok(user) : Results.NotFound();
});

app.MapPost("/api/users", async (CreateUserRequest req, IUserService service, CancellationToken ct) =>
{
    var user = await service.CreateAsync(req, ct);
    return Results.Created($"/api/users/{user.Id}", user);
}).WithValidation<CreateUserRequest>();

app.Run();
```

## Dependency Injection

```csharp
// Register services by lifetime
builder.Services.AddSingleton<ICacheService, RedisCacheService>();   // One instance
builder.Services.AddScoped<IUserService, UserService>();             // Per request
builder.Services.AddTransient<IEmailSender, SmtpEmailSender>();      // Always new

// Options pattern for configuration
builder.Services.Configure<SmtpOptions>(
    builder.Configuration.GetSection("Smtp"));

public class SmtpEmailSender(IOptions<SmtpOptions> options)
{
    private readonly SmtpOptions _options = options.Value;
}
```

## Middleware

```csharp
// Custom exception handling middleware
app.UseExceptionHandler(handler =>
{
    handler.Run(async context =>
    {
        var exception = context.Features.Get<IExceptionHandlerFeature>()?.Error;
        var (statusCode, errorCode) = exception switch
        {
            NotFoundException => (404, "NOT_FOUND"),
            ValidationException => (400, "VALIDATION_ERROR"),
            _ => (500, "INTERNAL_ERROR")
        };

        context.Response.StatusCode = statusCode;
        await context.Response.WriteAsJsonAsync(new
        {
            error = new { code = errorCode, message = exception?.Message }
        });
    });
});
```

## Entity Framework Core

```csharp
public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();
    public DbSet<Order> Orders => Set<Order>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>(e =>
        {
            e.HasKey(u => u.Id);
            e.HasIndex(u => u.Email).IsUnique();
            e.Property(u => u.Name).HasMaxLength(100).IsRequired();
            e.HasMany(u => u.Orders).WithOne(o => o.User).HasForeignKey(o => o.UserId);
        });
    }
}

// Repository pattern
public class UserRepository(AppDbContext db) : IUserRepository
{
    public async Task<User?> FindByIdAsync(string id, CancellationToken ct)
        => await db.Users.AsNoTracking().FirstOrDefaultAsync(u => u.Id == id, ct);

    public async Task<User> SaveAsync(User user, CancellationToken ct)
    {
        db.Users.Add(user);
        await db.SaveChangesAsync(ct);
        return user;
    }
}
```

## Configuration (strongly typed)

```csharp
public record AppSettings
{
    public required string DatabaseUrl { get; init; }
    public int MaxRetries { get; init; } = 3;
    public TimeSpan RequestTimeout { get; init; } = TimeSpan.FromSeconds(30);
}

// In Program.cs
builder.Services.AddOptions<AppSettings>()
    .BindConfiguration("App")
    .ValidateDataAnnotations()
    .ValidateOnStart();
```

## Health Checks

```csharp
builder.Services.AddHealthChecks()
    .AddNpgSql(connectionString, name: "database")
    .AddRedis(redisConnectionString, name: "cache");

app.MapHealthChecks("/health", new HealthCheckOptions
{
    ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
});
```
