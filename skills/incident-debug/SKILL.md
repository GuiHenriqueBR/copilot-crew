# Incident Debug Skill

## Trigger Words
"production bug", "incident", "outage", "crash in prod", "500 error", "debugging production", "post-mortem", "root cause analysis", "RCA"

## Workflow: Triage → Logs → Hypothesis → Reproduce → Fix → Post-mortem

### Phase 1: Triage (First 5 minutes)
**Severity Assessment:**

| Level | Criteria | Response |
|-------|----------|----------|
| SEV-1 | Full outage, data loss, security breach | All hands, immediate |
| SEV-2 | Major feature broken, >10% users affected | Team lead + on-call |
| SEV-3 | Minor feature broken, workaround exists | Next business hours |
| SEV-4 | Cosmetic, edge case | Normal sprint |

**Immediate Questions:**
1. What changed? (recent deploys, config changes, dependency updates)
2. Who is affected? (all users, specific region, specific plan)
3. When did it start? (correlate with deploy timestamps)
4. What is the blast radius? (one endpoint, one service, everything)
5. Is there a rollback option? (feature flag, previous version)

### Phase 2: Log Analysis

**Structured Log Search:**
```bash
# Recent errors (last 30 minutes)
# Adapt to your logging platform (Datadog, CloudWatch, etc.)

# Pattern: Look for error spikes
grep -c "ERROR" app.log | sort -t: -k2 -rn | head -20

# Pattern: Find first occurrence
grep "ERROR" app.log | head -1

# Pattern: Correlate with request ID
grep "req_id_12345" app.log

# Pattern: Check error rate
# Before incident
grep -c "ERROR" app.log.2024-01-15
# During incident  
grep -c "ERROR" app.log.2024-01-16
```

**Database Diagnostics:**
```sql
-- Active queries (PostgreSQL)
SELECT pid, now() - pg_stat_activity.query_start AS duration, query, state
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY duration DESC;

-- Lock contention
SELECT blocked.pid, blocked.query, blocking.pid AS blocking_pid, blocking.query AS blocking_query
FROM pg_stat_activity blocked
JOIN pg_locks bl ON bl.pid = blocked.pid
JOIN pg_locks kl ON kl.transactionid = bl.transactionid AND kl.pid != bl.pid
JOIN pg_stat_activity blocking ON blocking.pid = kl.pid;

-- Connection pool status
SELECT count(*), state FROM pg_stat_activity GROUP BY state;
```

**Infrastructure Checks:**
```bash
# Memory / CPU / Disk
free -h
df -h
top -bn1 | head -20

# Network
curl -o /dev/null -s -w "%{http_code} %{time_total}s\n" http://localhost:3000/health

# DNS resolution
dig api.example.com

# Container status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### Phase 3: Hypothesis Formation

**Build a hypothesis tree:**
```markdown
## Symptoms
- 500 errors on /api/orders since 14:32 UTC
- Error rate: 45% of requests

## Hypotheses (ordered by likelihood)
1. [HIGH] Database connection pool exhausted
   - Evidence: Connection count at max, slow queries in logs
   - Test: Check pg_stat_activity, connection pool metrics
   
2. [MEDIUM] Recent deploy introduced regression
   - Evidence: Deploy at 14:28, errors at 14:32
   - Test: Compare code diff, check for schema mismatch
   
3. [LOW] External dependency timeout
   - Evidence: None yet
   - Test: Check external service status pages
```

### Phase 4: Reproduce

**Reproduction Checklist:**
```markdown
- [ ] Identify exact request that fails (method, path, headers, body)
- [ ] Reproduce in staging/local with same data
- [ ] Confirm error message matches production
- [ ] Identify minimum reproduction case
- [ ] Document reproduction steps
```

**Safe Production Debugging:**
```bash
# NEVER run destructive queries in production
# ALWAYS use read replicas when possible
# ALWAYS add LIMIT to queries
# ALWAYS use transactions for any writes

# Safe: Read-only investigation
curl -H "Authorization: Bearer $TOKEN" https://api.example.com/health

# Safe: Log tailing (read-only)
tail -f /var/log/app/error.log | grep "OrderService"

# DANGEROUS — DO NOT in production:
# DELETE FROM ..., UPDATE ... without WHERE, DROP ..., TRUNCATE ...
```

### Phase 5: Fix & Deploy

```markdown
## Fix Checklist
- [ ] Root cause identified and documented
- [ ] Fix implemented with test covering the exact scenario
- [ ] Fix reviewed by at least one other engineer
- [ ] Fix deployed to staging and verified
- [ ] Fix deployed to production with monitoring
- [ ] Error rate returned to baseline
- [ ] Affected users notified (if applicable)
```

### Phase 6: Post-mortem

**Template:**
```markdown
# Incident Post-mortem: [Title]

## Summary
One-paragraph description of what happened.

## Timeline (UTC)
| Time | Event |
|------|-------|
| 14:28 | Deploy v2.3.1 to production |
| 14:32 | Error rate spikes to 45% |
| 14:35 | Alert fired, on-call paged |
| 14:42 | Root cause identified |
| 14:48 | Fix deployed |
| 14:50 | Error rate returns to baseline |

## Root Cause
Detailed technical explanation.

## Impact
- Duration: 18 minutes
- Users affected: ~2,300
- Revenue impact: $X,XXX estimated

## What Went Well
- Alert fired within 3 minutes
- Root cause identified quickly

## What Went Wrong
- No staging test for this scenario
- Missing index not caught in review

## Action Items
| Action | Owner | Due Date |
|--------|-------|----------|
| Add integration test for order flow | @dev | 2024-01-20 |
| Add index on orders.user_id | @dba | 2024-01-18 |
| Update deploy checklist | @lead | 2024-01-22 |
```

## Rules
- NEVER guess the root cause — follow the evidence
- NEVER apply untested fixes to production
- ALWAYS document the investigation trail
- ALWAYS write a post-mortem for SEV-1 and SEV-2
- PREFER rollback over hotfix when possible
- COMMUNICATE status updates every 15 minutes during active incidents
- BLAMELESS post-mortems — focus on systems, not individuals
