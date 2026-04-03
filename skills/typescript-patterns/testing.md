# TypeScript Testing Patterns

## Typed Test Factories (avoid hardcoded objects)

```typescript
// factories.ts — reusable across all tests
function createUser(overrides: Partial<User> = {}): User {
  return {
    id: crypto.randomUUID(),
    name: 'Test User',
    email: 'test@example.com',
    role: 'user',
    createdAt: new Date(),
    ...overrides,
  };
}

// Usage: only specify what matters for THIS test
const admin = createUser({ role: 'admin' });
const inactive = createUser({ role: 'user', deletedAt: new Date() });
```

## Typed Mocks with Vitest/Jest

```typescript
import { vi, type MockedFunction } from 'vitest';

// Mock a module
vi.mock('./userRepository');
import { getUserById } from './userRepository';
const mockGetUserById = getUserById as MockedFunction<typeof getUserById>;

// Setup typed return
mockGetUserById.mockResolvedValue(createUser({ name: 'Alice' }));

// Verify calls with type safety
expect(mockGetUserById).toHaveBeenCalledWith(expect.any(String));
```

## Testing Discriminated Unions Exhaustively

```typescript
describe('handleResult', () => {
  it('should return data on success', () => {
    const result: Result<User> = { status: 'success', data: createUser() };
    expect(handle(result)).toEqual(result.data);
  });

  it('should throw on error', () => {
    const result: Result<User> = { status: 'error', error: new Error('fail') };
    expect(() => handle(result)).toThrow('fail');
  });

  it('should return null on loading', () => {
    const result: Result<User> = { status: 'loading' };
    expect(handle(result)).toBeNull();
  });
});
```

## Testing Async Error Paths

```typescript
it('should throw ApiError when user not found', async () => {
  mockFetch.mockResolvedValue(new Response(null, { status: 404 }));

  await expect(fetchUser('nonexistent'))
    .rejects
    .toThrow(ApiError);

  await expect(fetchUser('nonexistent'))
    .rejects
    .toMatchObject({ statusCode: 404 });
});
```

## Type-Level Tests (compile-time assertions)

```typescript
import { expectTypeOf } from 'vitest';

test('UserSummary has only expected keys', () => {
  expectTypeOf<UserSummary>().toHaveProperty('id');
  expectTypeOf<UserSummary>().toHaveProperty('name');
  expectTypeOf<UserSummary>().not.toHaveProperty('password');
});

test('createUser returns User type', () => {
  expectTypeOf(createUser).returns.toEqualTypeOf<User>();
});
```

## MSW for API Mocking (prefer over fetch mocks)

```typescript
import { setupServer } from 'msw/node';
import { http, HttpResponse } from 'msw';

const server = setupServer(
  http.get('/api/users/:id', ({ params }) => {
    return HttpResponse.json(createUser({ id: params.id as string }));
  }),
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

it('fetches user by id', async () => {
  const user = await userService.getById('123');
  expect(user.id).toBe('123');
});

it('handles server error', async () => {
  server.use(
    http.get('/api/users/:id', () => HttpResponse.error()),
  );
  await expect(userService.getById('123')).rejects.toThrow();
});
```
