---
name: swift-patterns
description: "Swift idioms, SwiftUI patterns, and testing with XCTest. Load for Swift code."
---

# Swift Patterns Skill

## Key Idioms

### Enums with Associated Values
```swift
enum NetworkResult<T> {
    case success(T)
    case failure(NetworkError)
}

enum NetworkError: Error, LocalizedError {
    case notFound(id: String)
    case unauthorized
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .notFound(let id): "Resource \(id) not found"
        case .unauthorized: "Authentication required"
        case .serverError(let code): "Server error: \(code)"
        }
    }
}
```

### Protocols & Extensions
```swift
protocol Repository {
    associatedtype Entity
    func findById(_ id: String) async throws -> Entity?
    func save(_ entity: Entity) async throws -> Entity
}

extension Repository {
    func exists(_ id: String) async throws -> Bool {
        try await findById(id) != nil
    }
}
```

### Structured Concurrency
```swift
func fetchDashboard() async throws -> Dashboard {
    async let user = api.fetchUser(userId)
    async let orders = api.fetchOrders(userId)
    async let notifications = api.fetchNotifications(userId)
    
    return Dashboard(
        user: try await user,
        orders: try await orders,
        notifications: try await notifications
    )
}

// TaskGroup for dynamic concurrency
func fetchAllUsers(ids: [String]) async throws -> [User] {
    try await withThrowingTaskGroup(of: User.self) { group in
        for id in ids {
            group.addTask { try await api.fetchUser(id) }
        }
        return try await group.reduce(into: []) { $0.append($1) }
    }
}
```

### Property Wrappers
```swift
@propertyWrapper
struct Clamped<Value: Comparable> {
    var wrappedValue: Value { didSet { wrappedValue = min(max(wrappedValue, range.lowerBound), range.upperBound) } }
    let range: ClosedRange<Value>
    
    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.wrappedValue = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }
}

struct AudioSettings {
    @Clamped(0...100) var volume: Int = 50
}
```

## SwiftUI
```swift
struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.users) { user in
                NavigationLink(value: user) {
                    UserRow(user: user)
                }
            }
            .navigationTitle("Users")
            .task { await viewModel.loadUsers() }
            .refreshable { await viewModel.loadUsers() }
        }
    }
}

@Observable
class UserListViewModel {
    var users: [User] = []
    var error: Error?
    
    func loadUsers() async {
        do {
            users = try await UserService.shared.fetchAll()
        } catch {
            self.error = error
        }
    }
}
```

## Testing (XCTest)
```swift
final class UserServiceTests: XCTestCase {
    var mockRepo: MockUserRepository!
    var sut: UserService!
    
    override func setUp() {
        mockRepo = MockUserRepository()
        sut = UserService(repository: mockRepo)
    }
    
    func testFindById_returnsUser() async throws {
        mockRepo.stubbedUser = User(id: "1", name: "Alice")
        
        let result = try await sut.findById("1")
        
        XCTAssertEqual(result.name, "Alice")
        XCTAssertEqual(mockRepo.findByIdCallCount, 1)
    }
    
    func testFindById_throwsWhenNotFound() async {
        mockRepo.stubbedUser = nil
        
        do {
            _ = try await sut.findById("999")
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is UserNotFoundError)
        }
    }
}
```
