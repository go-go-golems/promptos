# Simplified Documentation for Automated Re-fetching with RTK Query

## Overview

Automated re-fetching in RTK Query is a mechanism that automatically updates the cache after certain actions, such as mutations, occur. It uses a system of tags to track and manage the cached data. When a mutation invalidates a tag, RTK Query re-fetches the data for that tag if it's currently being subscribed to by a component.

## Understanding Tags

### Definitions

Tags are labels attached to cached data, allowing RTK Query to know when to invalidate and re-fetch data. They are defined when creating an API service using `createApi` and can be a simple string or an object with a `type` and an optional `id`.

### Providing Tags

Queries can provide tags to the cache using the `providesTags` property. This property can be an array of strings or objects, or a function returning such an array. The function receives the result, error, and original argument of the query.

### Invalidating Tags

Mutations can invalidate tags in the cache using the `invalidatesTags` property. Similar to `providesTags`, this can be an array or a function that returns an array. The function is passed the result, error, and original argument of the mutation.

## Cache Tags and Their Usage

### Declaring Cache Tags

When defining an API with `createApi`, you specify `tagTypes` as an array of strings representing the different data entities in your application.

```typescript
const api = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: '/' }),
  tagTypes: ['Post', 'User'],
  endpoints: (build) => ({ /* ... */ }),
});
```

### Providing Cache Data

Each query endpoint can specify which tags it provides to the cache. This is done with the `providesTags` property on the endpoint definition.

```typescript
endpoints: (build) => ({
  getPosts: build.query<Post[], void>({
    query: () => '/posts',
    providesTags: (result) =>
      result ? result.map(({ id }) => ({ type: 'Post', id })) : ['Post'],
  }),
  // ...
}),
```

### Invalidating Cache Data

Mutation endpoints can specify which tags they invalidate in the cache using the `invalidatesTags` property.

```typescript
endpoints: (build) => ({
  addPost: build.mutation<Post, Partial<Post>>({
    query: (body) => ({
      url: 'post',
      method: 'POST',
      body,
    }),
    invalidatesTags: ['Post'],
  }),
  // ...
}),
```

## Tag Invalidation Behavior

Invalidating a general tag (e.g., 'Post') will invalidate all instances of that tag, while invalidating a specific tag (e.g., `{ type: 'Post', id: 1 }`) will only invalidate that particular instance.

## Practical Recipes

### Advanced Invalidation with Abstract Tag IDs

You can use abstract IDs like `'LIST'` to represent a collection of data. This allows you to invalidate all items in a list without affecting individual items.

```typescript
invalidatesTags: [{ type: 'Post', id: 'LIST' }],
```

### Providing Errors to the Cache

You can provide tags for errors, allowing you to re-fetch data when certain errors are resolved, such as after a user logs in.

```typescript
providesTags: (result, error) => (error ? ['UNAUTHORIZED'] : ['Post']),
```

### Abstracting Common Provides/Invalidates Usage

To reduce boilerplate, you can create helper functions to generate `providesTags` and `invalidatesTags` based on common patterns in your API.

```typescript
function providesList<R extends { id: string | number }[], T extends string>(
  resultsWithIds: R | undefined,
  tagType: T
) {
  // ...
}
```
