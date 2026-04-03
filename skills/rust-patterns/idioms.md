# Rust Idioms

## Ownership & Borrowing

```rust
// Prefer borrowing over ownership when you don't need to consume
fn process(data: &[u8]) -> Result<Output> { /* ... */ }

// Take ownership only when you need it (storing, moving to thread, etc.)
fn store(data: Vec<u8>) -> Result<()> {
    self.buffer = data; // Ownership transferred
    Ok(())
}

// Cow — clone on write (borrow when possible, own when needed)
use std::borrow::Cow;
fn normalize(input: &str) -> Cow<'_, str> {
    if input.contains(' ') {
        Cow::Owned(input.replace(' ', "_"))
    } else {
        Cow::Borrowed(input)
    }
}
```

## Iterators (zero-cost abstractions)

```rust
// Prefer iterator chains over manual loops
let active_emails: Vec<&str> = users.iter()
    .filter(|u| u.is_active)
    .map(|u| u.email.as_str())
    .collect();

// Chaining with error handling
let results: Result<Vec<Output>, Error> = items.iter()
    .map(|item| process(item))
    .collect(); // collect() on Result<Vec<T>> short-circuits on first error

// Custom iterator
struct Counter { count: u32, max: u32 }
impl Iterator for Counter {
    type Item = u32;
    fn next(&mut self) -> Option<u32> {
        (self.count < self.max).then(|| { self.count += 1; self.count })
    }
}
```

## Enums & Pattern Matching

```rust
// Use enums for state machines and variants
enum Command {
    Create { name: String, email: String },
    Delete { id: u64 },
    Update { id: u64, fields: HashMap<String, Value> },
}

fn handle(cmd: Command) -> Result<Response> {
    match cmd {
        Command::Create { name, email } => create_user(&name, &email),
        Command::Delete { id } => delete_user(id),
        Command::Update { id, fields } => update_user(id, &fields),
        // Exhaustive — compiler enforces all variants handled
    }
}

// if let for single-variant matching
if let Some(user) = find_user(id) {
    println!("Found: {}", user.name);
}

// let-else (Rust 1.65+)
let Some(user) = find_user(id) else {
    return Err(Error::NotFound(id));
};
```

## Traits

```rust
// Define behavior contracts
trait Repository {
    fn find_by_id(&self, id: u64) -> Result<Option<Entity>>;
    fn save(&self, entity: &Entity) -> Result<()>;

    // Default implementation
    fn exists(&self, id: u64) -> Result<bool> {
        Ok(self.find_by_id(id)?.is_some())
    }
}

// impl Trait for return types (opaque types)
fn create_handler() -> impl Fn(&Request) -> Response {
    |req| Response::ok(req.body())
}

// Trait objects for dynamic dispatch
fn get_repo(kind: &str) -> Box<dyn Repository> {
    match kind {
        "postgres" => Box::new(PostgresRepo::new()),
        "memory" => Box::new(InMemoryRepo::new()),
        _ => panic!("unknown repo kind: {kind}"),
    }
}
```

## Builder Pattern

```rust
#[derive(Default)]
struct RequestBuilder {
    url: String,
    method: Method,
    headers: HeaderMap,
    timeout: Option<Duration>,
}

impl RequestBuilder {
    fn new(url: impl Into<String>) -> Self {
        Self { url: url.into(), method: Method::GET, ..Default::default() }
    }
    fn method(mut self, method: Method) -> Self { self.method = method; self }
    fn header(mut self, key: &str, value: &str) -> Self {
        self.headers.insert(key.parse().unwrap(), value.parse().unwrap());
        self
    }
    fn timeout(mut self, duration: Duration) -> Self { self.timeout = Some(duration); self }
    fn build(self) -> Request { Request { /* ... */ } }
}

// Fluent usage
let req = RequestBuilder::new("https://api.example.com/users")
    .method(Method::POST)
    .header("Content-Type", "application/json")
    .timeout(Duration::from_secs(30))
    .build();
```

## Smart Pointers

```rust
// Arc<T> — shared ownership across threads
let shared_config = Arc::new(Config::load()?);
let config_clone = Arc::clone(&shared_config);
tokio::spawn(async move { use_config(&config_clone).await });

// Arc<Mutex<T>> — shared mutable state (use sparingly)
let state = Arc::new(Mutex::new(AppState::default()));

// Rc<T> — shared ownership, single thread
// Box<T> — heap allocation, single ownership
// Cow<T> — clone-on-write
```
