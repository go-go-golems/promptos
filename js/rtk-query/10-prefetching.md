# RTK Query Prefetching

Prefetching is a technique used to load data in advance of its use, improving user experience by reducing wait times. It's particularly useful in scenarios such as hovering over navigation elements or preparing data for components on an upcoming page.

## Using React Hooks for Prefetching

### `usePrefetch` Hook Signature

The `usePrefetch` hook is designed to fetch data before it's needed. It returns a trigger function and accepts an endpoint name and optional parameters to control the prefetching behavior.

```typescript
usePrefetch(endpointName, options?): (arg, options?) => void;
```

### Customizing Hook Behavior

The behavior of the `usePrefetch` hook can be customized with options such as `force` and `ifOlderThan`. These options determine when the prefetch should occur, with `force` ignoring the cache and `ifOlderThan` considering the age of the cached data.

### Trigger Function Behavior

The trigger function from `usePrefetch` always returns `void`. It follows specific rules based on the options provided, such as ignoring the cache if `force` is true or only fetching if the cache is outdated when `ifOlderThan` is set.

```tsx
function User() {
  const prefetchUser = usePrefetch('getUser');
  return (
    <div>
      <button onMouseEnter={() => prefetchUser(4, { ifOlderThan: 35 })}>
        Low priority
      </button>
      <button onMouseEnter={() => prefetchUser(4, { force: true })}>
        High priority
      </button>
    </div>
  );
}
```

## Prefetching Without React Hooks

You can also prefetch data without using the `usePrefetch` hook by dispatching a prefetch thunk or initiating a query action directly. This requires manual handling of the prefetch logic.

```typescript
store.dispatch(api.util.prefetch(endpointName, arg, { force: false, ifOlderThan: 10 }));
```

## Prefetching Strategies

### Basic Prefetching

Basic prefetching involves loading data when a user interacts with an element, such as hovering over a button. This can be done using the `usePrefetch` hook or by dispatching actions manually.

### Automatic Prefetching

Automatic prefetching loads the next set of data without user interaction, creating a seamless experience. This can be implemented by triggering prefetch actions based on the current state or user journey.

### Prefetching All Known Pages

For a more advanced strategy, you can prefetch all known pages or data after the initial load. This ensures that all potential data the user might need is fetched in advance, reducing loading times as they navigate.

```typescript
usePrefetchImmediately('getUser', 5);
```

