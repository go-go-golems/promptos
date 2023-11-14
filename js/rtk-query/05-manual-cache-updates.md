# RTK Query Manual Cache Updates

Manual cache updates allow you to directly modify or add data within your application's cache. This is particularly useful when you need to reflect changes in the backend without relying on automated re-fetching mechanisms.

## When to Use Manual Cache Updates

Automated re-fetching is generally preferred for keeping your cache up-to-date. However, manual cache updates are necessary for scenarios like optimistic or pessimistic updates, or when you need to manage cache data lifecycle events.

### Updating Existing Cache Entries

#### Function: `updateQueryData`

The `updateQueryData` function is used to modify data in an existing cache entry. It requires a specific endpoint name and arguments to locate the cache entry and will not create new entries.

#### Use Cases

- Immediate user feedback on mutations
- Updating a single item in a cached list
- Debouncing multiple mutations for performance

```javascript
dispatch(api.util.updateQueryData('getPost', id, (draft) => {
  Object.assign(draft, patch)
}));
```

### Creating or Replacing Cache Entries

#### Function: `upsertQueryData`

The `upsertQueryData` function can either create a new cache entry or replace an existing one. Unlike `updateQueryData`, it does not patch but replaces the data entirely.

#### Use Cases

- Adding new data to the cache as it's received from the backend
- Replacing an entire cache entry with updated data

```javascript
dispatch(api.util.upsertQueryData('getPost', id, createdPost));
```

## Update Recipes

### Optimistic Updates

Optimistic updates assume a successful mutation and update the cache immediately, providing a seamless experience for the user. If the mutation fails, the update is rolled back or the cache is invalidated to fetch fresh data.

```typescript
api.util.updateQueryData('getPost', id, (draft) => {
  Object.assign(draft, patch)
});
```

### Pessimistic Updates

Pessimistic updates wait for the mutation to succeed before updating the cache. This ensures that the cache is only updated with confirmed data from the server.

```typescript
const { data: updatedPost } = await queryFulfilled;
dispatch(api.util.updateQueryData('getPost', id, (draft) => {
  Object.assign(draft, updatedPost)
}));
```

### General Updates

General updates can be performed anywhere in your application where you have access to the dispatch function. This allows for flexibility in managing cache data outside of mutation callbacks.

```tsx
dispatch(api.util.updateQueryData('getPosts', undefined, (draftPosts) => {
  draftPosts.push({ id: 1, name: 'Teddy' })
}));
```

This simplified documentation provides a clear and concise overview of manual cache updates, their use cases, and how to implement them with code examples. It is designed to be easily understood by new users without a technical background while covering all technical details and options.
