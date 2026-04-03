---
name: node-anti-patterns
description: "Node.js anti-patterns: callback hell, memory leaks, blocking the event loop, error handling mistakes. Load when reviewing or writing Node.js/Express/NestJS code."
---

# Node.js Anti-Patterns

## Event Loop Blocking

```javascript
// BAD: CPU-heavy work on main thread — blocks all requests
app.get('/report', (req, res) => {
  const result = generateHugeReport(); // Blocks for 10 seconds!
  res.json(result);
});

// GOOD: Offload to worker thread
import { Worker } from 'worker_threads';
app.get('/report', async (req, res) => {
  const result = await runInWorker('./workers/report.js', req.query);
  res.json(result);
});

// ALSO BAD: Sync file operations in request handlers
const data = fs.readFileSync(path); // Blocks!
// GOOD: Use async
const data = await fs.promises.readFile(path);
```

## Memory Leaks

```javascript
// BAD: Growing array with no limit (common in caches, loggers)
const cache = [];
app.get('/data', (req, res) => {
  const result = fetchData();
  cache.push(result); // Never cleared — memory grows forever
  res.json(result);
});

// GOOD: Use LRU cache with max size
import { LRUCache } from 'lru-cache';
const cache = new LRUCache({ max: 1000, ttl: 1000 * 60 * 5 });

// BAD: Event listener leak
class Emitter {
  init() {
    process.on('message', this.handler); // Never removed!
  }
}
// GOOD: Remove on cleanup
class Emitter {
  init() {
    process.on('message', this.handler);
  }
  destroy() {
    process.off('message', this.handler);
  }
}
```

## Error Handling

```javascript
// BAD: Unhandled promise rejection — crashes in Node 15+
app.get('/users', async (req, res) => {
  const users = await db.query('SELECT * FROM users');
  res.json(users);
  // If db.query rejects → UnhandledPromiseRejection → process crash
});

// GOOD: Try/catch or error middleware
app.get('/users', async (req, res, next) => {
  try {
    const users = await db.query('SELECT * FROM users');
    res.json(users);
  } catch (error) {
    next(error);
  }
});

// BETTER: Express error wrapper
const asyncHandler = (fn) => (req, res, next) =>
  Promise.resolve(fn(req, res, next)).catch(next);

app.get('/users', asyncHandler(async (req, res) => {
  const users = await db.query('SELECT * FROM users');
  res.json(users);
}));

// BAD: Swallowing errors
try { await riskyOperation(); } catch (e) { /* silently ignored */ }

// BAD: Logging but not handling
catch (e) { console.log(e); } // Request hangs or returns wrong data
```

## Security Anti-Patterns

```javascript
// BAD: SQL injection via string interpolation
const query = `SELECT * FROM users WHERE id = '${req.params.id}'`;

// GOOD: Parameterized queries
const query = 'SELECT * FROM users WHERE id = $1';
const result = await db.query(query, [req.params.id]);

// BAD: Exposing stack traces in production
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.stack }); // Leaks internals!
});

// GOOD: Generic error in production
app.use((err, req, res, next) => {
  logger.error('Unhandled error', { error: err, path: req.path });
  res.status(500).json({ error: { code: 'INTERNAL_ERROR', message: 'Something went wrong' } });
});

// BAD: No rate limiting on auth endpoints
// BAD: No input validation (trust req.body blindly)
// BAD: Storing secrets in code instead of env vars
```

## Dependency Anti-Patterns

```javascript
// BAD: require() inside functions (slow, hard to mock)
function getUser(id) {
  const db = require('./db'); // Cold require every call
  return db.findUser(id);
}

// GOOD: Import at module level
import { db } from './db';
function getUser(id) {
  return db.findUser(id);
}

// BAD: Not pinning dependency versions
// "express": "^4.0.0" — could break on minor update

// GOOD: Use lockfile, audit regularly
// npm audit, npm outdated
```

## Stream Anti-Patterns

```javascript
// BAD: Loading entire file into memory
const data = await fs.promises.readFile('huge-file.csv', 'utf-8');
const lines = data.split('\n'); // 2GB string in memory!

// GOOD: Stream processing
import { createReadStream } from 'fs';
import { createInterface } from 'readline';

const rl = createInterface({ input: createReadStream('huge-file.csv') });
for await (const line of rl) {
  await processLine(line);
}
```
