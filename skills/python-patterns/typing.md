# Python Type Hints & Pydantic

## Modern Type Hints (3.10+)

```python
# Built-in generics — no need for typing.List, typing.Dict
def process(items: list[str]) -> dict[str, int]:
    return {item: len(item) for item in items}

# Union with | syntax
def find_user(user_id: str) -> User | None:
    return db.get(user_id)

# TypeAlias
type UserId = str
type UserMap = dict[UserId, User]

# TypeVar for generics
from typing import TypeVar
T = TypeVar("T")

def first(items: list[T]) -> T | None:
    return items[0] if items else None
```

## Protocol (structural typing)

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Repository(Protocol):
    """Any class with these methods satisfies this Protocol."""
    def find_by_id(self, entity_id: str) -> dict | None: ...
    def save(self, entity: dict) -> dict: ...
    def delete(self, entity_id: str) -> bool: ...

# No explicit inheritance needed — just implement the methods
class PostgresUserRepo:
    def find_by_id(self, entity_id: str) -> dict | None:
        return self.conn.fetchrow("SELECT * FROM users WHERE id=$1", entity_id)
    def save(self, entity: dict) -> dict:
        # ...
    def delete(self, entity_id: str) -> bool:
        # ...

# Type checker verifies PostgresUserRepo satisfies Repository
def get_service(repo: Repository) -> UserService:
    return UserService(repo)
```

## Pydantic v2 (data validation)

```python
from pydantic import BaseModel, Field, field_validator, EmailStr
from datetime import datetime

class CreateUserRequest(BaseModel):
    model_config = {"strict": True}

    name: str = Field(min_length=2, max_length=100)
    email: EmailStr
    age: int = Field(ge=13, le=150)
    tags: list[str] = Field(default_factory=list, max_length=10)

    @field_validator("name")
    @classmethod
    def name_must_not_be_empty(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("name must not be blank")
        return v.strip()

class UserResponse(BaseModel):
    id: str
    name: str
    email: str
    created_at: datetime

    @classmethod
    def from_entity(cls, user: User) -> "UserResponse":
        return cls(id=user.id, name=user.name, email=user.email, created_at=user.created_at)

# Validation
try:
    req = CreateUserRequest(name="Alice", email="alice@test.com", age=25)
except ValidationError as e:
    print(e.json())  # Structured error details
```

## TypedDict (for unstructured dicts)

```python
from typing import TypedDict, NotRequired

class UserDict(TypedDict):
    id: str
    name: str
    email: str
    avatar_url: NotRequired[str]

def process_user(user: UserDict) -> str:
    return user["name"]  # Type-safe key access
```

## Callable Types

```python
from collections.abc import Callable, Awaitable

# Sync callback
type EventHandler = Callable[[str, dict], None]

# Async callback
type AsyncHandler = Callable[[str, dict], Awaitable[None]]

def register_handler(event: str, handler: EventHandler) -> None:
    handlers[event] = handler
```

## Mypy / Pyright Config

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_any_generics = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false
```
