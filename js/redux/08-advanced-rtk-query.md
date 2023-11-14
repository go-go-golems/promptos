## 1. Cache Invalidation and Refetching

RTK Query uses tags to manage cache invalidation and refetching. Tags represent units of data that can be invalidated or refetched as a group. When a mutation occurs, associated tags can be invalidated, triggering a refetch of queries that provide those tags.

- Tags are defined in the `tagTypes` array when creating the API slice.
- Queries and mutations can `provide` and `invalidate` tags, respectively.
- When a tag is invalidated, all queries providing that tag are refetched.

### Code Example

```javascript
const apiSlice = createApi({
  // ...other options...
  tagTypes: ['Post'],
  endpoints: builder => ({
    getPosts: builder.query({
      query: () => '/posts',
      providesTags: ['Post']
    }),
    addPost: builder.mutation({
      query: post => ({
        url: '/posts',
        method: 'POST',
        body: post
      }),
      invalidatesTags: ['Post']
    }),
  }),
});
```

## 2. Cache Data Subscription and Lifetimes

RTK Query automatically manages the lifetime of cache data based on component subscriptions. When a component subscribes to a query, the data is fetched and cached. If the component unmounts, RTK Query starts a timer to potentially remove the data from the cache, unless a new subscription is added.

- Cache entries are reference-counted based on active subscriptions.
- Unused data is removed from the cache after a default time of 60 seconds, configurable via `keepUnusedDataFor`.

### Code Example

```javascript
const { useGetPostQuery } = apiSlice;
const PostComponent = ({ postId }) => {
  const { data: post } = useGetPostQuery(postId);
  // Component logic
};
```

## 3. Invalidating Specific Items

To invalidate specific items, RTK Query allows the use of detailed tags with IDs. This enables selective invalidation of cache entries, such as a single item or a list, without affecting unrelated data.

- Specific tags are objects with a `type` and `id` property.
- Use specific tags to target individual items for invalidation.
- Invalidating a tag refetches all queries that provide that tag.

### Code Example

```javascript
const apiSlice = createApi({
  // ...other options...
  endpoints: builder => ({
    getPost: builder.query({
      query: postId => `/posts/${postId}`,
      providesTags: (result, error, arg) => [{ type: 'Post', id: arg }]
    }),
    editPost: builder.mutation({
      query: post => ({
        url: `/posts/${post.id}`,
        method: 'PATCH',
        body: post
      }),
      invalidatesTags: (result, error, arg) => [{ type: 'Post', id: arg.id }]
    }),
  }),
});
```

## 4. Managing Data Outside React

RTK Query's core API can be used outside of React components. This is useful for pre-fetching data or interacting with the cache in non-component code.

- Dispatch `initiate` thunks to start queries outside of React.
- Use `select` functions to create selectors for retrieving cached data.

### Code Example

```javascript
store.dispatch(apiSlice.endpoints.getUsers.initiate());
```

## 5. Transforming Response Data

RTK Query allows for the transformation of response data before it is stored in the cache. This can be done using the `transformResponse` option in the endpoint definition.

- `transformResponse` can modify or extract data from the server response.
- The transformed data is what gets cached and used by the application.

### Code Example

```javascript
const apiSlice = createApi({
  // ...other options...
  endpoints: builder => ({
    getUsers: builder.query({
      query: () => '/users',
      transformResponse: responseData => normalize(responseData, [User])
    }),
  }),
});
```

## 6. Advanced Cache Updates

RTK Query provides lifecycle events such as `onQueryStarted` and `onCacheEntryAdded` for advanced cache manipulation. These can be used for optimistic updates or streaming updates.

- `onQueryStarted` is triggered when a mutation is initiated.
- `onCacheEntryAdded` is triggered when a query is first subscribed to.

### Code Example

```javascript
const apiSlice = createApi({
  // ...other options...
  endpoints: builder => ({
    addReaction: builder.mutation({
      query: ({ postId, reaction }) => ({
        url: `posts/${postId}/reactions`,
        method: 'POST',
        body: { reaction }
      }),
      onQueryStarted: async ({ postId, reaction }, { dispatch, queryFulfilled }) => {
        // Optimistic update logic
      },
    }),
  }),
});
```

## 7. Optimistic Updates

Optimistic updates allow for immediate cache updates based on expected changes from a mutation, providing a responsive user experience.

- Use `updateQueryData` to apply optimistic updates to the cache.
- Revert optimistic updates if the mutation fails using `patchResult.undo()`.

### Code Example

```javascript
onQueryStarted: async ({ postId, reaction }, { dispatch, queryFulfilled }) => {
  const patchResult = dispatch(
    apiSlice.util.updateQueryData('getPosts', undefined, draft => {
      const post = draft.find(post => post.id === postId);
      if (post) {
        post.reactions[reaction]++;
      }
    })
  );
  try {
    await queryFulfilled;
  } catch {
    patchResult.undo();
  }
},
```

## 8. Streaming Updates

Streaming updates involve updating the cache with new data over time, typically through a real-time connection like WebSockets.

- Use `onCacheEntryAdded` to establish a persistent connection for updates.
- Update the cache with new data as it arrives using `updateCachedData`.

### Code Example

```javascript
onCacheEntryAdded: async (
  arg,
  { updateCachedData, cacheDataLoaded, cacheEntryRemoved }
) => {
  const ws = new WebSocket('ws://localhost');
  try {
    await cacheDataLoaded;
    ws.onmessage = event => {
      const message = JSON.parse(event.data);
      if (message.type === 'newData') {
        updateCachedData(draft => {
          // Update cache with new data
        });
      }
    };
  } finally {
    await cacheEntryRemoved;
    ws.close();
  }
},
```
