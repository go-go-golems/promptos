# RTK Query Usage without React Hooks

RTK Query is a powerful data fetching and caching tool that is part of the Redux Toolkit. It is designed to work with any UI layer, not just React. This means you can use RTK Query with React class components or even outside of a React environment. The key feature of RTK Query is its cache behavior, which optimizes data fetching by reducing the number of network requests.

## Adding a Subscription

Cache subscriptions inform RTK Query when to fetch data for an endpoint. To add a subscription, dispatch the `initiate` action creator from your API service. This is similar to using a React hook, but without the need for React itself.

```typescript
// Example of adding a subscription
const { data, refetch } = dispatch(api.endpoints.getPosts.initiate());
```

## Removing a Subscription

To prevent memory leaks and optimize app performance, it's crucial to remove subscriptions when they're no longer needed. This is done by calling the `unsubscribe` method, which is available on the object returned by the `initiate` action creator.

```typescript
// Example of removing a subscription
const result = dispatch(api.endpoints.getPosts.initiate());
result.unsubscribe();
```

## Accessing Cached Data & Request Status

You can access the current state of the cache and the status of requests by using the `select` function provided by each endpoint. This function returns a selector that, when called with the Redux state, gives you the cached data and request status.

```typescript
// Example of accessing cached data and request status
const selectPosts = api.endpoints.getPosts.select();
const { data, status } = selectPosts(state);
```

## Performing Mutations

Mutations are operations that modify data on the server, such as POST or DELETE requests. To perform a mutation, dispatch the `initiate` action creator attached to a mutation endpoint.

```typescript
// Example of performing a mutation
dispatch(api.endpoints.addPost.initiate({ name: 'New Post' }));
```

