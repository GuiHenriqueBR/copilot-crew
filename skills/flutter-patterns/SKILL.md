---
name: flutter-patterns
description: "Flutter/Dart idioms, Riverpod state management, and widget testing. Load for Flutter/Dart code."
---

# Flutter Patterns Skill

## Dart Idioms

### Null Safety & Records
```dart
// Records (Dart 3+)
(String name, int age) parseUser(String input) {
  final parts = input.split(',');
  return (parts[0].trim(), int.parse(parts[1].trim()));
}

// Patterns
switch (response) {
  case (statusCode: 200, body: final data):
    return User.fromJson(data);
  case (statusCode: 404, _):
    throw NotFoundException();
  case (statusCode: final code, _) when code >= 500:
    throw ServerException(code);
}
```

### Extension Types & Sealed Classes
```dart
sealed class Result<T> {
  const Result();
}
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}
class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}

// Exhaustive switch
String display(Result<User> result) => switch (result) {
  Success(:final data) => data.name,
  Failure(:final error) => 'Error: ${error.message}',
};
```

## Riverpod State Management

```dart
// Provider
final userProvider = FutureProvider.autoDispose.family<User, String>((ref, id) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getById(id);
});

// Notifier
@riverpod
class UserList extends _$UserList {
  @override
  Future<List<User>> build() => ref.watch(userRepositoryProvider).getAll();

  Future<void> addUser(CreateUserRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).create(request);
      return ref.read(userRepositoryProvider).getAll();
    });
  }
}
```

## Widget Patterns

```dart
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  const UserCard({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(user.name[0])),
        title: Text(user.name),
        subtitle: Text(user.email),
        onTap: onTap,
      ),
    );
  }
}
```

## Testing

```dart
// Widget test
testWidgets('UserCard displays name and email', (tester) async {
  final user = User(id: '1', name: 'Alice', email: 'alice@test.com');

  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: UserCard(user: user)),
  ));

  expect(find.text('Alice'), findsOneWidget);
  expect(find.text('alice@test.com'), findsOneWidget);
});

// Unit test with Riverpod
test('UserList loads users', () async {
  final container = ProviderContainer(overrides: [
    userRepositoryProvider.overrideWithValue(MockUserRepository()),
  ]);

  final users = await container.read(userListProvider.future);
  expect(users, hasLength(2));
});
```
