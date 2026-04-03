# Python Testing with pytest

## Test Structure

```python
# tests/test_user_service.py
import pytest
from unittest.mock import AsyncMock, MagicMock
from myapp.services.user import UserService
from myapp.models import User

class TestUserService:
    """Tests for UserService.create_user"""

    def test_creates_user_with_valid_data(self, user_service, mock_repo):
        mock_repo.save.return_value = User(id="1", name="Alice", email="a@t.com")

        result = user_service.create_user(name="Alice", email="a@t.com")

        assert result.name == "Alice"
        mock_repo.save.assert_called_once()

    def test_raises_on_duplicate_email(self, user_service, mock_repo):
        mock_repo.find_by_email.return_value = User(id="1", name="X", email="a@t.com")

        with pytest.raises(ValueError, match="already exists"):
            user_service.create_user(name="Bob", email="a@t.com")
```

## Fixtures

```python
# conftest.py — shared fixtures
@pytest.fixture
def mock_repo():
    return MagicMock()

@pytest.fixture
def user_service(mock_repo):
    return UserService(repository=mock_repo)

# Fixture with setup/teardown
@pytest.fixture
async def db_conn():
    conn = await asyncpg.connect(TEST_DSN)
    await conn.execute("BEGIN")
    yield conn
    await conn.execute("ROLLBACK")
    await conn.close()

# Factory fixture for flexible test data
@pytest.fixture
def make_user():
    def _make(name="Alice", email="alice@test.com", **kwargs):
        return User(id=str(uuid4()), name=name, email=email, **kwargs)
    return _make
```

## Parametrize

```python
@pytest.mark.parametrize("email,is_valid", [
    ("alice@test.com", True),
    ("bob@example.org", True),
    ("invalid", False),
    ("", False),
    ("@no-local.com", False),
    ("no-domain@", False),
])
def test_email_validation(email: str, is_valid: bool):
    assert validate_email(email) == is_valid

# Multiple parameters with ids for readability
@pytest.mark.parametrize("input_data,expected_error", [
    pytest.param({"name": ""}, "name required", id="empty-name"),
    pytest.param({"email": "bad"}, "invalid email", id="bad-email"),
])
def test_validation_errors(input_data, expected_error):
    with pytest.raises(ValidationError, match=expected_error):
        validate_user(input_data)
```

## Async Tests

```python
import pytest

@pytest.mark.asyncio
async def test_fetch_user(mock_client):
    mock_client.get.return_value = AsyncMock(
        status_code=200,
        json=AsyncMock(return_value={"id": "1", "name": "Alice"})
    )

    result = await fetch_user(mock_client, "1")

    assert result["name"] == "Alice"
```

## Mocking Best Practices

```python
from unittest.mock import patch, MagicMock

# Patch where it's USED, not where it's DEFINED
@patch("myapp.services.user.send_email")
def test_sends_welcome_email(mock_send, user_service):
    user_service.create_user(name="Alice", email="a@t.com")
    mock_send.assert_called_once_with(to="a@t.com", template="welcome")

# Use spec to catch typos in mock attributes
mock_repo = MagicMock(spec=UserRepository)
mock_repo.find_by_email.return_value = None  # OK
mock_repo.find_by_emial.return_value = None  # AttributeError!
```

## pytest.ini / pyproject.toml Config

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = "test_*.py"
python_classes = "Test*"
python_functions = "test_*"
asyncio_mode = "auto"
addopts = "-v --tb=short --strict-markers -x"
markers = [
    "slow: marks tests as slow",
    "integration: integration tests requiring external services",
]
```
