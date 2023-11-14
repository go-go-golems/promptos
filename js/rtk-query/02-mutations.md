### RTK Query Mutations

Mutations in RTK Query are operations that allow you to send data updates to a server. These updates can modify the local cache of data and may trigger re-fetching of data to keep the cache current.

#### Defining Mutation Endpoints

Mutation endpoints are specified within the `endpoints` field of `createApi`. Use `build.mutation()` to define the mutation's behavior, including its HTTP method, request body, and URL.

- **Query Callback**: Constructs the URL and request details. Accepts an argument for dynamic URL construction.
- **QueryFn Callback**: Allows for custom asynchronous logic.
- **TransformResponse**: Modifies the response before caching.
- **InvalidatesTags**: Specifies cache tags for invalidation.
- **Lifecycle Callbacks**: `onQueryStarted` and `onCacheEntryAdded` for additional logic.

**TypeScript Generics**: Define the expected return type and argument type for type safety.

##### Code Example: Defining a Mutation Endpoint

```typescript
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';

interface Post {
  id: number;
  name: string;
}

const api = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: '/' }),
  tagTypes: ['Post'],
  endpoints: (build) => ({
    updatePost: build.mutation<Post, Partial<Post> & Pick<Post, 'id'>>({
      query: ({ id, ...patch }) => ({
        url: `post/${id}`,
        method: 'PATCH',
        body: patch,
      }),
      transformResponse: (response: { data: Post }) => response.data,
      invalidatesTags: ['Post'],
    }),
  }),
});
```

#### Performing Mutations with React Hooks

**Mutation Hook Behavior**: `useMutation` returns a tuple with a trigger function and a result object.

- **Trigger Function**: Executes the mutation when called.
- **Result Object**: Contains properties like `status`, `error`, and `data`.

**Frequently Used Mutation Hook Return Values**:

- `data`: Data from the latest mutation response.
- `error`: Error from the mutation, if any.
- `isLoading`: Indicates if the mutation is in progress.
- `isSuccess`: Indicates if the last mutation was successful.
- `isError`: Indicates if the last mutation resulted in an error.
- `reset`: Resets the hook to its initial state.

**Shared Mutation Results**: Use `fixedCacheKey` to share results across hook instances.

##### Code Example: Using a Mutation Hook

```tsx
const [updatePost, { isLoading }] = useUpdatePostMutation();

// Execute the mutation with the provided arguments
updatePost({ id: 1, name: 'New Post Name' });
```

#### Advanced Mutations with Revalidation

Revalidation is the process of updating the local cache with fresh data from the server after a mutation.

- **Invalidation Strategy**: Configure in the API service definition.
- **CRUD Service Example**: Shows a full setup with invalidation after mutations.

##### Code Example: CRUD Service with Revalidation

```typescript
const postApi = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: '/' }),
  tagTypes: ['Posts'],
  endpoints: (build) => ({
    getPosts: build.query<Post[], void>({
      query: () => 'posts',
      providesTags: (result) =>
        result ? [...result.map(({ id }) => ({ type: 'Posts', id })), { type: 'Posts', id: 'LIST' }] : [{ type: 'Posts', id: 'LIST' }],
    }),
    addPost: build.mutation<Post, Partial<Post>>({
      query: (body) => ({
        url: 'post',
        method: 'POST',
        body,
      }),
      invalidatesTags: [{ type: 'Posts', id: 'LIST' }],
    }),
    // Other mutations...
  }),
});
```
