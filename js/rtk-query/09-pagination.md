# RTK Query Pagination

Pagination is a technique used to divide large sets of data into manageable pages. RTK Query, a powerful data fetching and caching tool, does not come with built-in pagination features but provides a simple way to handle index-based pagination, which is commonly used in web applications.

### Setting up an Endpoint for Pagination

To work with paginated data, you first need to set up an API endpoint that accepts a page number as an argument. This allows you to request specific pages of data from your backend service.

```typescript
// Define a structure for the paginated response
interface ListResponse<T> {
  page: number;
  per_page: number;
  total: number;
  total_pages: number;
  data: T[];
}

// Set up the API slice with pagination support
export const api = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: '/' }),
  endpoints: (builder) => ({
    listItems: builder.query<ListResponse<ItemType>, number | void>({
      query: (page = 1) => `items?page=${page}`,
    }),
  }),
});
```

Replace `ItemType` with the type of data you're paginating, and adjust the query URL to match your API endpoint.

### Implementing Next and Previous Page Functionality

To navigate between pages, you can create a component with state to keep track of the current page. Increment or decrement this state to fetch the next or previous page of data.

```tsx
const ItemList = () => {
  const [page, setPage] = useState(1);
  const { data: items, isLoading, isFetching } = api.useListItemsQuery(page);

  if (isLoading) return <div>Loading...</div>;
  if (!items?.data) return <div>No items found.</div>;

  return (
    <>
      {items.data.map(item => <div key={item.id}>{item.name}</div>)}
      <button onClick={() => setPage(page - 1)} disabled={isFetching}>
        Previous
      </button>
      <button onClick={() => setPage(page + 1)} disabled={isFetching}>
        Next
      </button>
    </>
  );
};
```

Ensure you replace the map function's content with the appropriate HTML to display your items.

### Automated Re-fetching with Pagination

When using RTK Query's tag invalidation feature with paginated data, you may encounter issues with partial data updates. To ensure that all pages reflect the latest data, you should invalidate the paginated query whenever a mutation occurs that affects the data.

```typescript
export const api = createApi({
  // ... other api setup ...
  tagTypes: ['Items'],
  endpoints: (builder) => ({
    listItems: builder.query<ListResponse<ItemType>, number | void>({
      // ... query setup ...
      providesTags: (result) =>
        result ? [
          ...result.data.map(({ id }) => ({ type: 'Items', id })),
          { type: 'Items', id: 'PARTIAL-LIST' },
        ] : [{ type: 'Items', id: 'PARTIAL-LIST' }],
    }),
    deleteItem: builder.mutation<{ success: boolean; id: number }, number>({
      query(id) {
        // ... mutation setup ...
      },
      invalidatesTags: [{ type: 'Items', id: 'PARTIAL-LIST' }],
    }),
  }),
});
```

This code ensures that any mutation that deletes an item will cause the list of items to be re-fetched, keeping the pagination up to date.

