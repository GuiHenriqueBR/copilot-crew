# Rust Error Handling

## thiserror (library crates)

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("user {id} not found")]
    UserNotFound { id: u64 },

    #[error("validation failed: {0}")]
    Validation(String),

    #[error("database error")]
    Database(#[from] sqlx::Error),

    #[error("configuration error")]
    Config(#[from] config::ConfigError),

    #[error("IO error: {context}")]
    Io {
        context: String,
        #[source]
        source: std::io::Error,
    },
}

// Usage
fn find_user(id: u64) -> Result<User, AppError> {
    let user = db.query_one("SELECT ...", &[&id])
        .map_err(|e| AppError::Io {
            context: format!("querying user {id}"),
            source: e,
        })?;
    Ok(user)
}
```

## anyhow (application code)

```rust
use anyhow::{Context, Result, bail, ensure};

fn load_config(path: &Path) -> Result<Config> {
    let content = fs::read_to_string(path)
        .with_context(|| format!("failed to read config from {}", path.display()))?;

    let config: Config = toml::from_str(&content)
        .context("failed to parse config")?;

    ensure!(!config.database_url.is_empty(), "database_url must not be empty");

    if config.port == 0 {
        bail!("port must be > 0, got {}", config.port);
    }

    Ok(config)
}
```

## Result Chaining

```rust
// Chain operations with ?
fn process_order(order_id: u64) -> Result<Receipt> {
    let order = find_order(order_id)?;
    let user = find_user(order.user_id)?;
    let payment = charge_payment(&user, order.total)?;
    let receipt = generate_receipt(&order, &payment)?;
    send_email(&user.email, &receipt)?;
    Ok(receipt)
}

// and_then for conditional chaining
fn parse_and_validate(input: &str) -> Result<User> {
    serde_json::from_str::<User>(input)
        .map_err(|e| AppError::Validation(e.to_string()))
        .and_then(|user| validate_user(user))
}

// map_err for error conversion
fn fetch(url: &str) -> Result<Response, AppError> {
    reqwest::blocking::get(url)
        .map_err(|e| AppError::Network { url: url.to_owned(), source: e })
}
```

## Custom Error Types Pattern

```rust
// For libraries: use thiserror + specific variants
// For applications: use anyhow for ad-hoc errors
// For HTTP APIs: map to status codes

impl AppError {
    pub fn status_code(&self) -> StatusCode {
        match self {
            Self::UserNotFound { .. } => StatusCode::NOT_FOUND,
            Self::Validation(_) => StatusCode::BAD_REQUEST,
            Self::Database(_) | Self::Io { .. } => StatusCode::INTERNAL_SERVER_ERROR,
            Self::Config(_) => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }
}

// In Axum handler
impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let status = self.status_code();
        let body = json!({ "error": self.to_string() });
        (status, Json(body)).into_response()
    }
}
```
