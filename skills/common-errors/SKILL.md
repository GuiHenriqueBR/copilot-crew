---
name: common-errors
description: "Database of common errors, their causes, and solutions across languages and frameworks. Load when debugging errors, investigating crashes, or explaining error messages."
---

# Common Errors Database

## JavaScript / TypeScript

| Error | Cause | Fix |
|-------|-------|-----|
| `TypeError: Cannot read properties of undefined` | Accessing property on null/undefined | Add optional chaining `?.` or null check |
| `ReferenceError: X is not defined` | Variable not declared or out of scope | Check imports, spelling, scope |
| `TypeError: X is not a function` | Calling non-function (often wrong import) | Check import is correct, not type-only |
| `SyntaxError: Unexpected token` | Invalid JSON, missing comma/bracket | Validate JSON, check syntax around error line |
| `ERR_MODULE_NOT_FOUND` | ESM import path missing extension | Add `.js` extension to import path |
| `Maximum call stack size exceeded` | Infinite recursion | Add base case, check for circular calls |
| `CORS error` | Cross-origin request blocked | Configure CORS headers on server |
| `ECONNREFUSED` | Target server not running | Start the server, check host:port |
| `EADDRINUSE` | Port already in use | Kill process on port or use different port |

## React

| Error | Cause | Fix |
|-------|-------|-----|
| `Too many re-renders` | setState inside render body | Move setState to useEffect or event handler |
| `Invalid hook call` | Hook outside component or conditional | Only call hooks at top level of components |
| `Can't perform state update on unmounted` | Async callback after unmount | Use cleanup in useEffect, AbortController |
| `Each child should have a unique key` | Missing or duplicate keys in list | Use stable unique id as key, not index |
| `Objects are not valid as React child` | Rendering object directly | Use JSON.stringify or access specific property |

## Python

| Error | Cause | Fix |
|-------|-------|-----|
| `ModuleNotFoundError` | Package not installed or wrong env | `pip install package`, check virtualenv |
| `IndentationError` | Mixed tabs/spaces | Configure editor for spaces, run `autopep8` |
| `AttributeError: 'NoneType'` | Method returned None unexpectedly | Check return values, add None guards |
| `RecursionError: maximum depth` | Infinite recursion | Add base case, increase `sys.setrecursionlimit` |
| `UnicodeDecodeError` | Reading binary file as text | Specify encoding: `open(f, encoding='utf-8')` |

## Java

| Error | Cause | Fix |
|-------|-------|-----|
| `NullPointerException` | Calling method on null | Use Optional, null checks, @NonNull |
| `ClassNotFoundException` | Class not on classpath | Check dependencies, Maven/Gradle config |
| `OutOfMemoryError: heap space` | Memory leak or insufficient heap | Increase -Xmx, profile with VisualVM |
| `ConcurrentModificationException` | Modifying collection during iteration | Use Iterator.remove() or CopyOnWriteArrayList |
| `StackOverflowError` | Infinite recursion | Add base case, convert to iterative |

## Database / SQL

| Error | Cause | Fix |
|-------|-------|-----|
| `deadlock detected` | Concurrent transactions lock same rows | Ensure consistent lock ordering |
| `unique constraint violation` | Duplicate value in unique column | Check before insert or use UPSERT |
| `relation does not exist` | Table not created, wrong schema | Run migrations, check schema prefix |
| `connection refused` | DB server down or wrong credentials | Verify connection string, server status |
| `timeout expired` | Slow query or connection pool exhausted | Optimize query, increase pool size |

## Docker / Containers

| Error | Cause | Fix |
|-------|-------|-----|
| `ENOENT: no such file or directory` | File not COPY'd into image | Add to Dockerfile COPY, check .dockerignore |
| `port already allocated` | Host port in use | `docker stop` old container or change port |
| `OOMKilled` | Container exceeded memory limit | Increase memory limit or optimize app |
| `exec format error` | ARM/x86 architecture mismatch | Use `--platform` flag or multi-arch build |

## Git

| Error | Cause | Fix |
|-------|-------|-----|
| `CONFLICT (content)` | Same file edited in both branches | Resolve manually, then `git add` + `git commit` |
| `rejected: non-fast-forward` | Remote has newer commits | `git pull --rebase` then push |
| `detached HEAD` | Checked out commit instead of branch | `git checkout -b new-branch` or `git switch main` |
| `fatal: refusing to merge unrelated histories` | Different root commits | `git pull --allow-unrelated-histories` |
