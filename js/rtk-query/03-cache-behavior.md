### RTK Query Cache Behaviour

##### Subscription and Serialization

When a component requests data from an API endpoint, RTK Query serializes the request parameters into a unique `queryCacheKey`. Any future requests with identical parameters will use the cached data associated with that key. This process is known as de-duplication and ensures that multiple components can share the same cached data.

##### Cache Lifetime

Cached data has a default lifetime determined by the number of active subscriptions to it. As long as there is at least one active subscription, the data remains in the cache. When the last subscription is removed, the data is scheduled for removal after a default period (60 seconds), which can be customized.

#### Manipulating Cache Behavior

##### Adjusting Cache Lifetime (`keepUnusedDataFor`)

You can control how long data stays in the cache after all subscriptions end by setting the `keepUnusedDataFor` option. This can be set globally for all endpoints or individually per endpoint.

```ts
// Global setting
createApi({
  keepUnusedDataFor: 30, // 30 seconds
  // ... other settings
})

// Per-endpoint setting
builder.query({
  keepUnusedDataFor: 5, // 5 seconds
  // ... other query settings
})
```

##### Forcing Data Re-fetch (`refetch` and `initiate`)

To manually trigger a data re-fetch, use the `refetch` method from a query hook or dispatch the `initiate` action with `forceRefetch: true`.

```tsx
// Using refetch from a hook
const { refetch } = useGetPostsQuery({ count: 5 });
refetch();

// Dispatching initiate action
dispatch(api.endpoints.getPosts.initiate({ count: 5 }, { forceRefetch: true }));
```

##### Encouraging Re-fetching (`refetchOnMountOrArgChange`)

You can encourage data to be re-fetched more frequently by setting `refetchOnMountOrArgChange` to `true` or a number of seconds. This can be set globally or per hook call.

```ts
// Global setting
createApi({
  refetchOnMountOrArgChange: 30, // 30 seconds
  // ... other settings
})

// Per hook call
useGetPostsQuery({ count: 5 }, { refetchOnMountOrArgChange: true })
```

##### Re-fetching on Window Focus (`refetchOnFocus`)

To automatically re-fetch data when the application window regains focus, set `refetchOnFocus` to `true`. This requires `setupListeners` to be called.

```ts
// Global setting
createApi({
  refetchOnFocus: true,
  // ... other settings
})

// Enable listener behavior
setupListeners(store.dispatch)
```

##### Re-fetching on Network Reconnection (`refetchOnReconnect`)

Similar to `refetchOnFocus`, `refetchOnReconnect` will trigger a re-fetch of all subscribed queries when the network connection is restored.

```ts
// Global setting
createApi({
  refetchOnReconnect: true,
  // ... other settings
})

// Enable listener behavior
setupListeners(store.dispatch)
```

##### Invalidating Cache Tags

RTK Query can automatically re-fetch queries when related data is mutated by using a system of cache tags. When a mutation occurs, any queries with matching tags will be refetched.

#### Tradeoffs and Considerations

RTK Query does not use a normalized cache to deduplicate identical items across requests. This design choice simplifies the cache management but means that identical data may be stored multiple times in the cache. However, using cache tags can help maintain consistency across queries.

#### Practical Examples

##### Cache Subscription Lifetime Demo

This interactive demo illustrates how the cache behaves with multiple components subscribing to the same data. It shows how the cache retains data based on active subscriptions and the `keepUnusedDataFor` setting.

```tsx
// Example components using the same query
function ComponentOne() {
  const { data } = useGetUserQuery(1);
  // ...
}

function ComponentTwo() {
  const { data } = useGetUserQuery(2);
  // ...
}
```

When both components are unmounted, the cached data will be removed after the time specified by `keepUnusedDataFor`.

