---
name: react-anti-patterns
description: "React anti-patterns, performance traps, and bad practices to avoid. Load when reviewing or writing React code. Triggers: React, component, hook, state, props, render, re-render, memo, useEffect."
---

# React Anti-Patterns

## State Management Anti-Patterns

### Prop Drilling (fix: Context, Zustand, or composition)
```tsx
// BAD: Passing props through 5 levels
<App user={user}>
  <Layout user={user}>
    <Sidebar user={user}>
      <UserMenu user={user}>
        <Avatar name={user.name} />  // Only consumer!

// GOOD: Context or state management
const UserContext = createContext<User | null>(null);
const useUser = () => {
  const user = useContext(UserContext);
  if (!user) throw new Error("useUser must be used within UserProvider");
  return user;
};
```

### Derived State in useState (fix: compute from props)
```tsx
// BAD: Duplicating props into state
function UserCard({ user }: { user: User }) {
  const [fullName, setFullName] = useState(`${user.first} ${user.last}`);
  // fullName gets stale when user prop changes!

// GOOD: Derive directly
function UserCard({ user }: { user: User }) {
  const fullName = `${user.first} ${user.last}`;
```

### God Component (fix: extract sub-components)
```tsx
// BAD: 500-line component with 20 useState calls
// Signs: file > 200 lines, > 5 useState, mixing data fetch + UI + logic

// GOOD: Split by responsibility
// UserDashboard.tsx → orchestrates layout
// useUserData.ts → custom hook for data
// UserStats.tsx → stats display
// UserActions.tsx → action buttons
```

## useEffect Anti-Patterns

### useEffect as onChange handler
```tsx
// BAD: useEffect to react to state changes
const [query, setQuery] = useState('');
const [results, setResults] = useState([]);
useEffect(() => {
  fetchResults(query).then(setResults);
}, [query]); // Race condition! No cleanup!

// GOOD: Event handler + abort controller
const handleSearch = async (query: string) => {
  const controller = new AbortController();
  const results = await fetchResults(query, { signal: controller.signal });
  setResults(results);
};

// Or use a data fetching library (TanStack Query, SWR)
const { data } = useQuery({ queryKey: ['search', query], queryFn: () => fetchResults(query) });
```

### Missing cleanup
```tsx
// BAD: Memory leak — no cleanup
useEffect(() => {
  const interval = setInterval(pollData, 5000);
  // Missing return!
}, []);

// GOOD: Always clean up
useEffect(() => {
  const interval = setInterval(pollData, 5000);
  return () => clearInterval(interval);
}, []);
```

## Performance Anti-Patterns

### Creating objects/arrays in render
```tsx
// BAD: New object every render → child always re-renders
<UserList style={{ margin: 10 }} config={{ pageSize: 20 }} />

// GOOD: Stable references
const style = useMemo(() => ({ margin: 10 }), []);
const config = useMemo(() => ({ pageSize: 20 }), []);
<UserList style={style} config={config} />
```

### Inline function props without memo
```tsx
// BAD: New function every render
<Button onClick={() => handleClick(item.id)} />

// GOOD: useCallback when the child is memoized
const handleClick = useCallback((id: string) => { /* ... */ }, []);
// Only use useCallback if Button is wrapped in React.memo
```

### Index as key
```tsx
// BAD: Index as key in dynamic lists
{items.map((item, index) => <Item key={index} data={item} />)}
// Causes incorrect reconciliation when items are reordered/deleted

// GOOD: Stable unique identifier
{items.map(item => <Item key={item.id} data={item} />)}
```

## Component Design Anti-Patterns

### Boolean prop explosion
```tsx
// BAD: Many boolean props
<Button primary large disabled loading outline rounded />

// GOOD: Variant + size props
<Button variant="primary" size="lg" state="loading" />
```

### Premature abstraction
```tsx
// BAD: Creating a "reusable" component used once
// GenericDataDisplayCardWithActionsV2.tsx

// GOOD: Start concrete, abstract when you have 3+ similar components
// UserCard.tsx → simple, specific
```
