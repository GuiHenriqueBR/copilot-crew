# Rust Testing

## Unit Tests

```rust
// Tests live in the same file, in a #[cfg(test)] module
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_valid_email() {
        let result = Email::parse("alice@example.com");
        assert!(result.is_ok());
        assert_eq!(result.unwrap().domain(), "example.com");
    }

    #[test]
    fn rejects_invalid_email() {
        let result = Email::parse("not-an-email");
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("invalid email"));
    }

    #[test]
    #[should_panic(expected = "index out of bounds")]
    fn panics_on_invalid_index() {
        let v: Vec<i32> = vec![];
        let _ = v[0];
    }
}
```

## Async Tests

```rust
#[tokio::test]
async fn fetches_user_from_api() {
    let mock_server = MockServer::start().await;
    Mock::given(method("GET"))
        .and(path("/users/1"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({"id": 1, "name": "Alice"})))
        .mount(&mock_server)
        .await;

    let client = ApiClient::new(&mock_server.uri());
    let user = client.get_user(1).await.unwrap();
    assert_eq!(user.name, "Alice");
}
```

## Integration Tests

```rust
// tests/api_test.rs — separate file, separate compilation
use myapp::create_app;

#[tokio::test]
async fn health_check_returns_200() {
    let app = create_app().await;
    let response = app.oneshot(
        Request::builder().uri("/health").body(Body::empty()).unwrap()
    ).await.unwrap();

    assert_eq!(response.status(), StatusCode::OK);
}
```

## Test Helpers & Fixtures

```rust
// Reusable test helper
fn make_user(name: &str) -> User {
    User {
        id: Uuid::new_v4(),
        name: name.to_owned(),
        email: format!("{name}@test.com"),
        created_at: Utc::now(),
    }
}

// Shared setup with once_cell
use once_cell::sync::Lazy;
static TEST_CONFIG: Lazy<Config> = Lazy::new(|| Config::test_default());
```

## Property-Based Testing (proptest)

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn roundtrip_serialization(name in "[a-zA-Z]{1,50}", age in 0u8..150) {
        let user = User { name: name.clone(), age };
        let json = serde_json::to_string(&user).unwrap();
        let decoded: User = serde_json::from_str(&json).unwrap();
        assert_eq!(decoded.name, name);
        assert_eq!(decoded.age, age);
    }

    #[test]
    fn email_parse_never_panics(s in "\\PC{0,100}") {
        let _ = Email::parse(&s); // Must not panic, errors are OK
    }
}
```

## Benchmarks (criterion)

```rust
// benches/my_benchmark.rs
use criterion::{criterion_group, criterion_main, Criterion, black_box};

fn bench_sort(c: &mut Criterion) {
    let data: Vec<u64> = (0..10_000).rev().collect();

    c.bench_function("sort 10k elements", |b| {
        b.iter(|| {
            let mut v = data.clone();
            v.sort_unstable();
            black_box(v)
        })
    });
}

criterion_group!(benches, bench_sort);
criterion_main!(benches);
```
