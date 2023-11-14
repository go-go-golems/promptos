# Simplified Documentation Structure

Server Side Rendering (SSR) is a technique used to render web pages on the server instead of in the browser. This approach can improve performance and is beneficial for SEO. RTK Query supports SSR, allowing you to pre-fetch data on the server and send a fully rendered page to the client.

## SSR with Next.js

### Setting up `next-redux-wrapper`

To enable SSR with Next.js, you'll need to integrate `next-redux-wrapper`. This library connects Next.js with Redux, allowing your Redux store to be used during server-side rendering.

### Fetching Data in `getStaticProps` or `getServerSideProps`

Within Next.js's data fetching methods (`getStaticProps` or `getServerSideProps`), dispatch the `initiate` action from your API service to pre-fetch the necessary data:

```javascript
store.dispatch(api.endpoints.YourEndpoint.initiate(params));
```

Then, ensure all queries are completed before continuing:

```javascript
await Promise.all(dispatch(api.util.getRunningQueriesThunk()));
```

### Configuring Rehydration

When configuring your API service with `createApi`, use the `extractRehydrationInfo` option to set up rehydration. This process allows the server-rendered state to be used on the client-side seamlessly.

```javascript
const api = createApi({
  // ...other options
  extractRehydrationInfo: (action, { reducerPath }) => {
    // Your rehydration logic here
  },
});
```

### Tips for Next.js SSR

- To prevent memory leaks, consider dispatching `resetApiState` after rendering:

```javascript
store.dispatch(api.util.resetApiState());
```

- To avoid serving stale data with Static Site Generation (SSG), set `refetchOnMountOrArgChange` to a value like 900 seconds:

```javascript
const api = createApi({
  // ...other options
  refetchOnMountOrArgChange: 900,
});
```

## SSR with Other Frameworks

If you're not using Next.js, you can still implement SSR by creating a custom version of `createApi` that allows for asynchronous work during the render process.

### Custom `createApi` for Async Work

Create a custom `createApi` that includes logic for handling side effects during rendering:

```javascript
const api = createApi({
  // ...other options
  unstable__sideEffectsInRender: true,
});
```

### Fetching Data Before Render Cycles

Ensure all queries are finished before proceeding with the next render cycle:

```javascript
await Promise.all(dispatch(api.util.getRunningQueriesThunk()));
```

## Code Examples

### Example for Next.js SSR Setup

```javascript
// Set up next-redux-wrapper and create a store
const { store } = createStore();

// In getStaticProps or getServerSideProps
export async function getStaticProps(context) {
  // Dispatch initiate action for pre-fetching
  store.dispatch(api.endpoints.YourEndpoint.initiate(params));

  // Wait for queries to finish
  await Promise.all(store.dispatch(api.util.getRunningQueriesThunk()));

  // Return props
  return { props: { /* your props here */ } };
}

// Configure rehydration in your createApi call
const api = createApi({
  // ...other options
  extractRehydrationInfo: (action, { reducerPath }) => {
    // Rehydration logic here
  },
});
```

### Example for SSR with Other Frameworks

```javascript
// Create a custom createApi for async work during render
const api = createApi({
  // ...other options
  unstable__sideEffectsInRender: true,
});

// Before performing the next render cycle
await Promise.all(store.dispatch(api.util.getRunningQueriesThunk()));

// Render your application
```

