# Python Async Patterns

## asyncio Fundamentals

```python
import asyncio
import httpx

async def fetch_user(client: httpx.AsyncClient, user_id: str) -> dict:
    response = await client.get(f"/api/users/{user_id}")
    response.raise_for_status()
    return response.json()

# Gather — run multiple coroutines concurrently
async def fetch_all_users(user_ids: list[str]) -> list[dict]:
    async with httpx.AsyncClient(base_url=API_URL) as client:
        tasks = [fetch_user(client, uid) for uid in user_ids]
        return await asyncio.gather(*tasks, return_exceptions=True)
```

## TaskGroup (Python 3.11+ — structured concurrency)

```python
async def process_batch(items: list[Item]) -> list[Result]:
    results = []
    async with asyncio.TaskGroup() as tg:
        for item in items:
            task = tg.create_task(process_item(item))
            results.append(task)
    # All tasks completed or one failed (exception propagates)
    return [t.result() for t in results]
```

## Semaphore (limit concurrency)

```python
async def fetch_with_limit(urls: list[str], max_concurrent: int = 10) -> list[str]:
    semaphore = asyncio.Semaphore(max_concurrent)

    async def limited_fetch(url: str) -> str:
        async with semaphore:
            async with httpx.AsyncClient() as client:
                resp = await client.get(url)
                return resp.text

    async with asyncio.TaskGroup() as tg:
        tasks = [tg.create_task(limited_fetch(url)) for url in urls]
    return [t.result() for t in tasks]
```

## Async Context Managers

```python
from contextlib import asynccontextmanager

@asynccontextmanager
async def managed_connection(dsn: str):
    conn = await asyncpg.connect(dsn)
    try:
        yield conn
    finally:
        await conn.close()

# Usage
async with managed_connection(DATABASE_URL) as conn:
    rows = await conn.fetch("SELECT * FROM users WHERE active = $1", True)
```

## Async Generators

```python
async def stream_logs(path: str):
    async with aiofiles.open(path) as f:
        async for line in f:
            if "ERROR" in line:
                yield line.strip()

# Consume
async for error_line in stream_logs("/var/log/app.log"):
    await notify(error_line)
```

## Common Pitfalls

```python
# BAD: Blocking call in async context — freezes event loop
async def bad():
    time.sleep(5)  # Blocks the entire loop!
    requests.get(url)  # Blocking HTTP!

# GOOD: Use async equivalents
async def good():
    await asyncio.sleep(5)
    async with httpx.AsyncClient() as client:
        await client.get(url)

# If you MUST call sync code:
result = await asyncio.to_thread(blocking_function, arg1, arg2)

# BAD: Fire-and-forget tasks (lost exceptions)
asyncio.create_task(risky_operation())  # Exception silently lost!

# GOOD: Track tasks
task = asyncio.create_task(risky_operation())
task.add_done_callback(lambda t: t.result() if not t.cancelled() else None)
```
