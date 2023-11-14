# RTK Query Polling

Polling is a technique used to periodically send requests to a server to fetch the most current data. It simulates a real-time experience by re-fetching data at regular intervals that you specify. This is particularly useful when you need to keep the displayed data updated without manual refreshes.

## Enabling Polling in Queries

To enable polling in a query when using React, you can pass a `pollingInterval` option to the `useQuery` hook. This option takes a value in milliseconds, defining how often the query should re-run.

```tsx
import { useQuery } from 'react-query-library';

const useDataWithPolling = (queryKey, queryFn) => {
  const { data, status, error } = useQuery(queryKey, queryFn, {
    pollingInterval: 3000, // Poll every 3 seconds
  });

  return { data, status, error };
};
```

## Enabling Polling with Action Creators

If you're not using React Hooks, you can still enable polling by using action creators. When dispatching an action, include `subscriptionOptions` with a `pollingInterval` in milliseconds.

```ts
import { store, endpoints } from 'your-api-library';

const initiatePolling = (id) => {
  const { data, status, error } = store.dispatch(
    endpoints.queryName.initiate(id, {
      subscriptionOptions: { pollingInterval: 3000 },
    })
  );

  return { data, status, error };
};
```

## Manual Polling without React Hooks

In scenarios where React Hooks are not utilized, such as with other frameworks or custom setups, you can manually control polling intervals. This is done by calling `updateSubscriptionOptions` on the query reference object with a new `pollingInterval`.

```ts
const queryRef = yourQueryFunction();

// Stop polling
queryRef.updateSubscriptionOptions({ pollingInterval: 0 });

// Start polling with a new interval
queryRef.updateSubscriptionOptions({ pollingInterval: 5000 });
```

