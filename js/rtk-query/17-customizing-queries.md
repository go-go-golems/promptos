# Simplified Framework Documentation

## Customizing Queries with `baseQuery`

The `baseQuery` is a foundational function used in RTK Query's `createApi` to process requests. It takes the return value from an endpoint's `query` option and executes the actual data fetching logic. By default, RTK Query uses `fetchBaseQuery`, a wrapper around the native `fetch` API, but you can customize or replace it entirely.

A custom `baseQuery` must handle three arguments: `args`, `api`, and `extraOptions`. It should return an object with either a `data` or `error` property, or a promise that resolves to such an object. Errors must be caught and returned, not thrown.

```typescript
const customBaseQuery = async (args, { signal, dispatch, getState }, extraOptions) => {
  try {
    const response = await fetch(args.url, { signal });
    const data = await response.json();
    return { data };
  } catch (error) {
    return { error };
  }
};
```

The `baseQuery` function receives the following arguments:

- `args`: The arguments passed to the query/mutation.
- `api`: An object containing `{ signal, dispatch, getState }`.
- `extraOptions`: Any additional options passed to the query/mutation.

It should return an object with `data` on success or `error` on failure:

```typescript
// Success
return { data: YourData };

// Error
return { error: YourError };
```

The `fetchBaseQuery` function returns a promise with the following structure:

```typescript
// Success
return { data: YourData, meta: { request: Request, response: Response } };

// Error
return { error: { status: number, data: YourErrorData }, meta: { request: Request, response: Response } };
```

## Customizing Query Responses

The `transformResponse` property allows you to alter the data returned by a query before it is stored in the cache. It is called with the successful `baseQuery` return value.

```typescript
const api = createApi({
  // ...other settings
  endpoints: (builder) => ({
    getPost: builder.query<Post, number>({
      query: (id) => `post/${id}`,
      transformResponse: (response: { data: Post }) => response.data,
    }),
  }),
});
```

Similarly, `transformErrorResponse` lets you modify the error returned by a query before it is cached. It is called with the error from a failed `baseQuery`.

```typescript
const api = createApi({
  // ...other settings
  endpoints: (builder) => ({
    getPost: builder.query<Post, number>({
      query: (id) => `post/${id}`,
      transformErrorResponse: (error: { status: number, message: string }) => ({
        errorMessage: error.message,
      }),
    }),
  }),
});
```

## Advanced Query Customization with `queryFn`

The `queryFn` property allows for custom async logic beyond standard HTTP requests. It's useful for integrating with third-party SDKs, performing non-standard request/response patterns, or when the query itself is irrelevant.

A `queryFn` is similar to a `baseQuery` but is defined inline within an endpoint. It receives the same arguments and should return a result object with `data` or `error`.

```typescript
const api = createApi({
  // ...other settings
  endpoints: (builder) => ({
    getPost: builder.query<Post, number>({
      queryFn: async (postId, { signal }) => {
        try {
          const response = await fetch(`post/${postId}`, { signal });
          const data = await response.json();
          return { data };
        } catch (error) {
          return { error };
        }
      },
    }),
  }),
});
```

## Examples

### Axios `baseQuery`

```typescript
const axiosBaseQuery = ({ baseUrl } = { baseUrl: '' }) => async ({ url, method, data }) => {
  try {
    const result = await axios({ url: baseUrl + url, method, data });
    return { data: result.data };
  } catch (axiosError) {
    return { error: { status: axiosError.response?.status, data: axiosError.response?.data } };
  }
};
```

### GraphQL `baseQuery`

```typescript
const graphqlBaseQuery = ({ baseUrl }) => async ({ body }) => {
  try {
    const result = await request(baseUrl, body);
    return { data: result };
  } catch (error) {
    return { error: { status: error.response.status, data: error } };
  }
};
```

### Extending `fetchBaseQuery` for Re-authorization

```typescript
const baseQueryWithReauth = async (args, api, extraOptions) => {
  let result = await fetchBaseQuery(args, api, extraOptions);
  if (result.error?.status === 401) {
    // Attempt to refresh token and retry the query...
  }
  return result;
};
```

### Automatic Retries with `retry`

```typescript
const retryBaseQuery = retry(fetchBaseQuery({ baseUrl: '/' }), { maxRetries: 5 });
```

### Adding Meta Information to Queries

```typescript
const metaBaseQuery = async (args, api, extraOptions) => {
  const baseResult = await fetchBaseQuery(args, api, extraOptions);
  const meta = { requestId: uuid(), timestamp: Date.now() };
  return { ...baseResult, meta };
};
```

### Dynamic Base URL Construction

```typescript
const dynamicBaseQuery = async (args, api, extraOptions) => {
  const projectId = selectProjectId(api.getState());
  const adjustedArgs = { ...args, url: `project/${projectId}/${args.url}` };
  return fetchBaseQuery(adjustedArgs, api, extraOptions);
};
```

## Transform Response Examples

### Unpacking Nested GraphQL Data

```typescript
const api = createApi({
  // ...other settings
  endpoints: (builder) => ({
    getPosts: builder.query<Post[], void>({
      query: () => ({
        body: gql`query { posts { data { id title } } }`,
      }),
      transformResponse: (response: { posts: { data: Post[] } }) => response.posts.data,
    }),
  }),
});
```

### Normalizing Data with `createEntityAdapter`

```typescript
const api = createApi({
  // ...other settings
  endpoints: (builder) => ({
    getPosts: builder.query<EntityState<Post>, void>({
      query: () => `posts`,
      transformResponse: (response: Post[]) => postsAdapter.addMany(postsAdapter.getInitialState(), response),
    }),
  }),
});
```

## Query Function Examples

### Third-Party SDK Integration

```typescript
const supabaseApi = createApi({
  // ...other settings
  endpoints: (builder) => ({
    getBlogs: builder.query({
      queryFn: async () => {
        const { data, error } = await supabase.from('blogs').select();
        return error ? { error } : { data };
      },
    }),
  }),
});
```

### No-op `queryFn` for Tag Invalidation

```typescript
const api = createApi({
  // ...other settings
  endpoints: (builder) => ({
    refetchPostsAndUsers: builder.mutation<null, void>({
      queryFn: () => ({ data: null }),
      invalidatesTags: ['Post', 'User'],
    }),
  }),
});
```

### Streaming Data Without an Initial Request

```typescript
const api = createApi({
  // ...other settings
  endpoints: (builder) => ({
    streamMessages: builder.query<Message[], void>({
      queryFn: () => ({ data: [] }),
      // ...streaming updates logic
    }),
  }),
});
```

### Multiple Requests Within a Single Query

```typescript
const api = createApi({
  ...other settings
  endpoints: (builder) => ({
    getRandomUserPosts: builder.query<Post[], void>({
      async queryFn(_arg, _queryApi, _extraOptions, fetchWithBQ) {
        // Fetch a random user
        const randomUserResult = await fetchWithBQ('users/random');
        if (randomUserResult.error) {
          return { error: randomUserResult.error as FetchBaseQueryError };
        }
        const user = randomUserResult.data as User;
        // Fetch posts for that user
        const postsResult = await fetchWithBQ(`user/${user.id}/posts`);
        return postsResult.data
          ? { data: postsResult.data as Post[] }
          : { error: postsResult.error as FetchBaseQueryError };
      },
    }),
  }),
});
```

In the example above, the `queryFn` is used to perform two sequential requests within a single query. Initially, it fetches a random user and then uses the user's ID to fetch their posts. This approach encapsulates the logic for multiple dependent requests within a single endpoint, simplifying the data fetching process in your components.

