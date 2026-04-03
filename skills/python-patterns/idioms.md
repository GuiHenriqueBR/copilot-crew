# Python Idioms (3.10+)

## Dataclasses & Attrs

```python
from dataclasses import dataclass, field

# Immutable data carrier (like Java records)
@dataclass(frozen=True, slots=True)
class User:
    id: str
    name: str
    email: str
    roles: list[str] = field(default_factory=list)

    def __post_init__(self):
        if not self.email or "@" not in self.email:
            raise ValueError(f"Invalid email: {self.email}")
```

## Structural Pattern Matching (3.10+)

```python
match command:
    case {"action": "create", "name": str(name), "email": str(email)}:
        create_user(name, email)
    case {"action": "delete", "id": str(user_id)}:
        delete_user(user_id)
    case {"action": action}:
        raise ValueError(f"Unknown action: {action}")
    case _:
        raise ValueError("Invalid command format")

# Match with guards
match response.status_code:
    case 200:
        return response.json()
    case 404:
        return None
    case status if 400 <= status < 500:
        raise ClientError(f"Client error: {status}")
    case status:
        raise ServerError(f"Server error: {status}")
```

## Context Managers

```python
from contextlib import contextmanager, asynccontextmanager

# Custom context manager
@contextmanager
def database_transaction(conn):
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise

# Usage
with database_transaction(conn) as tx:
    tx.execute("INSERT INTO users ...")
```

## Comprehensions (prefer over map/filter)

```python
# List comprehension
active_emails = [u.email for u in users if u.is_active]

# Dict comprehension
user_by_id = {u.id: u for u in users}

# Generator expression (lazy — for large datasets)
total = sum(order.total for order in orders if order.status == "completed")

# DON'T: Nested comprehensions deeper than 2 levels — use loops
# DON'T: Side effects inside comprehensions
```

## Decorators

```python
import functools
import time
import logging

def retry(max_attempts: int = 3, delay: float = 1.0):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            last_error = None
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    last_error = e
                    logging.warning(f"{func.__name__} attempt {attempt} failed: {e}")
                    if attempt < max_attempts:
                        time.sleep(delay * attempt)
            raise last_error
        return wrapper
    return decorator

@retry(max_attempts=3, delay=0.5)
def fetch_data(url: str) -> dict:
    return httpx.get(url).json()
```

## Enumeration

```python
from enum import Enum, auto, StrEnum

class Status(StrEnum):
    ACTIVE = auto()      # "active"
    INACTIVE = auto()    # "inactive"
    SUSPENDED = auto()   # "suspended"

# Exhaustive handling
def handle_status(status: Status) -> str:
    match status:
        case Status.ACTIVE: return "OK"
        case Status.INACTIVE: return "Dormant"
        case Status.SUSPENDED: return "Blocked"
```

## Walrus Operator

```python
# Assign and test in one expression
if (user := find_user(user_id)) is not None:
    send_notification(user)

# In comprehensions
results = [
    processed
    for item in data
    if (processed := expensive_transform(item)) is not None
]
```

## Path Handling

```python
from pathlib import Path

# ALWAYS use pathlib, never os.path
config_dir = Path.home() / ".config" / "myapp"
config_dir.mkdir(parents=True, exist_ok=True)

config_file = config_dir / "settings.json"
if config_file.exists():
    data = json.loads(config_file.read_text(encoding="utf-8"))
```
