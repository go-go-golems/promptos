# RTK Query queries

Queries are the primary method for fetching data in RTK Query. They should be used for GET requests that retrieve data without modifying it on the server. For data modifications, use [Mutations](./mutations). RTK Query includes `fetchBaseQuery`, a wrapper around the `fetch` API, to handle requests and responses. However, if `fetchBaseQuery` doesn't meet your needs, you can customize queries further.

```javascript
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query';

const api = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: '/api' }),
  endpoints: (builder) => ({
    getEntity: builder.query({
      query: (id) => `entity/${id}`,
    }),
  }),
});
```

## 2. Defining Query Endpoints

Query endpoints are specified within the `endpoints` field of `createApi`. Use `builder.query()` to define the endpoint's behavior, including the URL construction, response transformation, cache tagging, and lifecycle callbacks. When using TypeScript, define the expected return type and query argument type.

```typescript
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query';

interface Entity {
  id: number;
  name: string;
}

const api = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: '/api' }),
  endpoints: (builder) => ({
    getEntity: builder.query<Entity, number>({
      query: (id) => `entity/${id}`,
    }),
  }),
});
```

## 3. Performing Queries with React Hooks

RTK Query generates React hooks for each query endpoint, providing a seamless integration with your components. The primary hook, `useQuery`, triggers data fetching and subscribes to the cache. Other hooks like `useLazyQuery` offer manual control over fetching.

### Hook Types

- `useQuery`: The main hook for automatic fetching and caching.
- `useQuerySubscription`: Triggers fetches without returning the query state.
- `useQueryState`: Returns the query state without triggering fetches.
- `useLazyQuery`: Manually triggers fetches and returns the query state.
- `useLazyQuerySubscription`: Manually triggers fetches without returning the query state.

### Query Hook Options

Hooks accept options to control behavior, such as `skip`, `pollingInterval`, and `refetchOnMountOrArgChange`.

### Frequently Used Query Hook Return Values

- `data`: The latest result.
- `error`: Any error that occurred.
- `isLoading`: True when the query is loading for the first time.
- `isFetching`: True when the query is fetching, possibly with cached data.
- `isSuccess`: True when the query has successfully returned data.
- `isError`: True when the query is in an error state.
- `refetch`: A function to force refetch the query.

```tsx
import { useGetEntityQuery } from './api';

const EntityDetail = ({ id }) => {
  const { data: entity, isLoading } = useGetEntityQuery(id);
  if (isLoading) return <div>Loading...</div>;
  if (!entity) return <div>Entity not found.</div>;
  return <div>{entity.name}</div>;
};
```

## 4. Query Cache Keys

RTK Query uses `queryCacheKey` to uniquely identify and cache each query based on its parameters. This prevents duplicate requests and enables cache sharing across components.

## 5. Selecting Data from a Query Result

Use `selectFromResult` to extract specific data from a query result. This optimizes performance by preventing unnecessary component rerenders.

```tsx
const { post } = useGetPostsQuery(undefined, {
  selectFromResult: ({ data }) => ({
    post: data?.find((post) => post.id === id),
  }),
});
```

## 6. Avoiding Unnecessary Requests

RTK Query deduplicates identical queries by default. Use the `refetch` function from the hook's return values to force a refetch if needed.

