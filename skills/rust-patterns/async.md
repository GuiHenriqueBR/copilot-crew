# Rust Async Patterns (tokio)

## Basic async/await

```rust
use tokio;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let result = fetch_data("https://api.example.com").await?;
    println!("{result}");
    Ok(())
}

async fn fetch_data(url: &str) -> anyhow::Result<String> {
    let response = reqwest::get(url).await?.text().await?;
    Ok(response)
}
```

## Spawning Tasks

```rust
// Spawn independent concurrent tasks
let handle = tokio::spawn(async {
    expensive_computation().await
});
let result = handle.await?; // JoinError if task panics

// JoinSet — manage multiple tasks
use tokio::task::JoinSet;

let mut set = JoinSet::new();
for url in urls {
    set.spawn(async move { fetch(url).await });
}
while let Some(result) = set.join_next().await {
    match result? {
        Ok(data) => process(data),
        Err(e) => eprintln!("fetch failed: {e}"),
    }
}
```

## Channels

```rust
use tokio::sync::{mpsc, oneshot, broadcast};

// mpsc — multiple producers, single consumer
let (tx, mut rx) = mpsc::channel::<Message>(100);

tokio::spawn(async move {
    while let Some(msg) = rx.recv().await {
        handle_message(msg).await;
    }
});

tx.send(Message::new("hello")).await?;

// oneshot — single response (request/reply pattern)
let (reply_tx, reply_rx) = oneshot::channel();
tx.send(Request { payload: data, reply: reply_tx }).await?;
let response = reply_rx.await?;

// broadcast — multiple consumers
let (tx, _) = broadcast::channel::<Event>(100);
let mut rx1 = tx.subscribe();
let mut rx2 = tx.subscribe();
```

## select! (race multiple futures)

```rust
use tokio::select;
use tokio::time::{sleep, Duration};

async fn fetch_with_timeout(url: &str) -> Result<String> {
    select! {
        result = reqwest::get(url) => {
            Ok(result?.text().await?)
        }
        _ = sleep(Duration::from_secs(10)) => {
            Err(anyhow::anyhow!("request timed out after 10s"))
        }
    }
}

// Graceful shutdown
async fn run_server(mut shutdown: tokio::sync::watch::Receiver<bool>) {
    loop {
        select! {
            conn = listener.accept() => { handle_conn(conn?).await; }
            _ = shutdown.changed() => { break; }
        }
    }
}
```

## Shared State

```rust
use std::sync::Arc;
use tokio::sync::RwLock;

type SharedState = Arc<RwLock<AppState>>;

async fn read_state(state: &SharedState) -> String {
    let guard = state.read().await; // Multiple readers OK
    guard.status.clone()
}

async fn update_state(state: &SharedState, new_status: String) {
    let mut guard = state.write().await; // Exclusive access
    guard.status = new_status;
}
// Prefer RwLock over Mutex when reads >> writes
// Prefer DashMap for concurrent HashMaps
```

## Streams

```rust
use tokio_stream::{StreamExt, wrappers::ReceiverStream};

let stream = ReceiverStream::new(rx);

stream
    .filter(|msg| msg.is_important())
    .map(|msg| process(msg))
    .for_each(|result| async { save(result).await })
    .await;
```
