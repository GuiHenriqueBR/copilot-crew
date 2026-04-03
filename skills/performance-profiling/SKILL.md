# Performance Profiling Skill

## Trigger Words
"optimize performance", "slow function", "profiling", "benchmark", "memory leak", "CPU usage", "latency", "throughput", "bottleneck"

## Workflow: Measure → Identify → Optimize → Validate

### Phase 1: Measure (Baseline)
Before ANY optimization, establish a measurable baseline:

**Frontend (Browser)**
```bash
# Lighthouse audit
npx lighthouse http://localhost:3000 --output=json --output-path=./lighthouse-report.json

# Bundle analysis
npx vite-bundle-visualizer
# or
npx webpack-bundle-analyzer stats.json
```

**Backend (Node.js)**
```javascript
// Built-in profiler
node --prof app.js
node --prof-process isolate-*.log > profile.txt

// Memory snapshot
node --inspect app.js
// Then open chrome://inspect → Take Heap Snapshot
```

**Backend (Python)**
```python
import cProfile
cProfile.run('main()', 'output.prof')

# Visualize
# pip install snakeviz
# snakeviz output.prof
```

**Database**
```sql
EXPLAIN ANALYZE SELECT ...;
-- Check for Seq Scan on large tables
-- Check for missing indexes
```

**Record baseline metrics:**
- Response time (p50, p95, p99)
- Memory usage (RSS, heap)
- CPU usage (%)
- Bundle size (KB)
- Core Web Vitals (LCP, FID, CLS)

### Phase 2: Identify Bottlenecks
Analyze baseline data. Common patterns:

| Symptom | Likely Cause | Investigation |
|---------|-------------|---------------|
| High LCP | Large images, render-blocking resources | Check network waterfall |
| High CLS | Dynamic content without dimensions | Check layout shifts |
| Slow API | N+1 queries, missing indexes | Check EXPLAIN ANALYZE |
| Memory growth | Event listener leaks, closure leaks | Heap snapshots over time |
| Large bundle | Unused dependencies, no code splitting | Bundle analyzer |
| Slow renders | Unnecessary re-renders | React DevTools Profiler |

### Phase 3: Optimize (One Change at a Time)

**Frontend Optimizations:**
```typescript
// 1. Code splitting with lazy loading
const HeavyComponent = React.lazy(() => import('./HeavyComponent'));

// 2. Memoization
const MemoizedComponent = React.memo(Component);
const expensiveValue = useMemo(() => compute(data), [data]);
const stableCallback = useCallback(() => handle(id), [id]);

// 3. Virtual lists for large datasets
import { useVirtualizer } from '@tanstack/react-virtual';

// 4. Image optimization
<img loading="lazy" decoding="async" srcSet="..." sizes="..." />

// 5. Debounce expensive operations
const debouncedSearch = useMemo(() => debounce(search, 300), []);
```

**Backend Optimizations:**
```typescript
// 1. Batch database queries (fix N+1)
const users = await db.query('SELECT * FROM users WHERE id = ANY($1)', [ids]);

// 2. Add database indexes
CREATE INDEX CONCURRENTLY idx_orders_user_id ON orders(user_id);

// 3. Caching
const cached = await redis.get(key);
if (cached) return JSON.parse(cached);
const fresh = await db.query(...);
await redis.set(key, JSON.stringify(fresh), 'EX', 300);

// 4. Connection pooling
const pool = new Pool({ max: 20, idleTimeoutMillis: 30000 });

// 5. Pagination
SELECT * FROM items ORDER BY id LIMIT 20 OFFSET 0;
-- Better: cursor-based
SELECT * FROM items WHERE id > $cursor ORDER BY id LIMIT 20;
```

### Phase 4: Validate
After EACH optimization:
1. Re-run the SAME benchmarks from Phase 1
2. Compare metrics side-by-side
3. Verify no regressions in other areas
4. Document the improvement

```markdown
## Performance Improvement Report
| Metric | Before | After | Change |
|--------|--------|-------|--------|
| LCP | 3.2s | 1.8s | -43.7% |
| Bundle | 485KB | 312KB | -35.7% |
| API p95 | 850ms | 120ms | -85.9% |
```

## Rules
- NEVER optimize without measuring first
- NEVER optimize multiple things simultaneously
- ALWAYS validate improvements with benchmarks
- PREFER algorithmic improvements over micro-optimizations
- AVOID premature optimization — profile first, then decide
- DOCUMENT every optimization: what, why, and measured impact
