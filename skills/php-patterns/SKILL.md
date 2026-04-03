---
name: php-patterns
description: "PHP 8+ idioms, Laravel patterns, and testing with PHPUnit/Pest. Load for PHP code."
---

# PHP Patterns Skill

## Key Idioms

### Enums (PHP 8.1+)
```php
enum Status: string {
    case Active = 'active';
    case Inactive = 'inactive';
    case Suspended = 'suspended';
}
```

### Readonly Properties & Constructor Promotion
```php
class User {
    public function __construct(
        public readonly string $id,
        public readonly string $name,
        public readonly string $email,
    ) {}
}
```

### Named Arguments & Match Expression
```php
$label = match($status) {
    Status::Active => 'Online',
    Status::Inactive => 'Offline',
    Status::Suspended => 'Banned',
};

$user = new User(name: 'Alice', email: 'a@t.com', id: Str::uuid());
```

### Fibers (async-like, PHP 8.1+)
```php
$fiber = new Fiber(function (): void {
    $value = Fiber::suspend('paused');
    echo "Resumed with: $value";
});
$result = $fiber->start(); // 'paused'
$fiber->resume('hello');   // "Resumed with: hello"
```

## Laravel Patterns

### Eloquent: Query Scopes
```php
class User extends Model {
    public function scopeActive(Builder $query): Builder {
        return $query->where('status', Status::Active);
    }
}
// User::active()->where('role', 'admin')->get();
```

### Form Request Validation
```php
class CreateUserRequest extends FormRequest {
    public function rules(): array {
        return [
            'name' => ['required', 'string', 'max:100'],
            'email' => ['required', 'email', 'unique:users,email'],
        ];
    }
}
```

### Service Pattern
```php
class UserService {
    public function __construct(
        private readonly UserRepository $repo,
        private readonly EventDispatcher $events,
    ) {}

    public function create(CreateUserRequest $request): User {
        $user = $this->repo->create($request->validated());
        $this->events->dispatch(new UserCreated($user));
        return $user;
    }
}
```

## Testing (Pest)
```php
it('creates a user with valid data', function () {
    $response = $this->postJson('/api/users', [
        'name' => 'Alice',
        'email' => 'alice@test.com',
    ]);
    $response->assertCreated()
        ->assertJsonPath('data.name', 'Alice');
    $this->assertDatabaseHas('users', ['email' => 'alice@test.com']);
});

it('rejects duplicate emails', function () {
    User::factory()->create(['email' => 'alice@test.com']);
    $this->postJson('/api/users', ['name' => 'Bob', 'email' => 'alice@test.com'])
        ->assertUnprocessable();
});
```
