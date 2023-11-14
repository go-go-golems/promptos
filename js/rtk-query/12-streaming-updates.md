# RTK Query Streaming Updates

Streaming updates allow real-time synchronization of your application's state with server-side changes. By establishing a persistent connection, typically via WebSockets, RTK Query can apply live updates to the cached data as new information is pushed from the server. This feature is particularly useful for applications that require immediate reflection of data changes without the need to poll the server repeatedly.

## Applicability of Streaming Updates

Streaming updates are best used when:

- Dealing with frequent minor updates to large datasets.
- Requiring real-time, event-driven updates from external sources.

Ideal scenarios include GraphQL subscriptions, real-time chats, multiplayer games, and collaborative editing tools.

## Implementing `onCacheEntryAdded` Lifecycle

The `onCacheEntryAdded` lifecycle is a callback function that executes asynchronous logic when a new cache entry is added. It receives the subscription argument and an options object with lifecycle promises and utilities. Use `cacheDataLoaded` to wait for initial data, `updateCacheData` to apply updates, and `cacheEntryRemoved` to clean up connections.

## Code Example: Basic Websocket Chat API

```ts
// Define a type for the message
interface Message {
  id: number;
  channel: string;
  userName: string;
  text: string;
}

// Create the API with streaming updates
const api = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: '/' }),
  endpoints: (build) => ({
    getMessages: build.query<Message[], string>({
      query: (channel) => `messages/${channel}`,
      async onCacheEntryAdded(arg, { updateCachedData, cacheDataLoaded, cacheEntryRemoved }) {
        const ws = new WebSocket('ws://your-websocket-url');
        await cacheDataLoaded;
        ws.addEventListener('message', (event) => {
          const data = JSON.parse(event.data);
          if (data.channel === arg) {
            updateCachedData((draft) => {
              draft.push(data);
            });
          }
        });
        await cacheEntryRemoved;
        ws.close();
      },
    }),
  }),
});
```

## Code Example: Websocket Chat API with Transformed Response Shape

```ts
// Use createEntityAdapter for normalized state management
const messagesAdapter = createEntityAdapter<Message>();

const api = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: '/' }),
  endpoints: (build) => ({
    getMessages: build.query<EntityState<Message>, string>({
      query: (channel) => `messages/${channel}`,
      transformResponse: (response: Message[]) => messagesAdapter.addMany(messagesAdapter.getInitialState(), response),
      async onCacheEntryAdded(arg, { updateCachedData, cacheDataLoaded, cacheEntryRemoved }) {
        const ws = new WebSocket('ws://your-websocket-url');
        await cacheDataLoaded;
        ws.addEventListener('message', (event) => {
          const data = JSON.parse(event.data);
          if (data.channel === arg) {
            updateCachedData((draft) => {
              messagesAdapter.upsertOne(draft, data);
            });
          }
        });
        await cacheEntryRemoved;
        ws.close();
      },
    }),
  }),
});
```

## Key Considerations

- Ensure that the data shape used in `updateCachedData` matches the transformed response structure.
- Handle potential race conditions where `cacheEntryRemoved` may resolve before `cacheDataLoaded`.
- Properly manage WebSocket connections to prevent memory leaks or orphaned connections.

