# RTK Query Overview

This page is a more succinct version of the [RTK Query documentation](https://redux-toolkit.js.org/rtk-query/overview) with some additional notes.

## What is RTK Query?

- RTK Query is a data fetching and caching tool included in Redux Toolkit.
- It simplifies loading data in web applications, removing the need to write fetching and caching logic manually.
- Built on top of Redux Toolkit's APIs, RTK Query is UI-agnostic and can be used with any UI layer.

## Motivation for RTK Query

### Challenges in Data Fetching and Caching

Web applications frequently interact with remote data sources, requiring developers to handle a variety of complex tasks:

- **Data Fetching**: Retrieving data from a server is a fundamental requirement for most web applications.
- **Loading State Management**: Users expect visual feedback (like spinners) to indicate that data is being loaded.
- **Request Deduplication**: Avoiding redundant requests for the same data to reduce network load and improve performance.
- **Optimistic Updates**: Applying updates to the UI before server confirmation to enhance perceived responsiveness.
- **Cache Synchronization**: Keeping the client-side cache in sync with server data to ensure data consistency.
- **Cache Management**: Deciding when to invalidate or refresh cached data based on user interactions or other criteria.

### Traditional Redux Approach

In a traditional Redux setup, developers need to write action creators, reducers, and selectors to handle the above concerns. This often results in a significant amount of boilerplate code and complex state management logic.

### How RTK Query Addresses These Challenges

RTK Query is designed to simplify the data fetching and caching process by providing a set of tools that abstract away the complexities:

- **Automated Data Fetching**: RTK Query auto-generates async thunks for data fetching, reducing the need to manually write fetching logic.
- **Built-in Loading State**: The library manages loading states internally, providing flags like `isLoading` to easily integrate loading indicators in the UI.
- **Request Deduplication**: RTK Query automatically deduplicates simultaneous requests for the same data, ensuring that only one request is made to the server.
- **Optimistic Updates**: Developers can configure optimistic updates with RTK Query, allowing the UI to react immediately to user actions while the server processes the request.
- **Cache Synchronization**: RTK Query maintains a normalized cache and provides automatic cache invalidation and refetching strategies, keeping the client data consistent with the server.
- **Intelligent Cache Management**: The library offers fine-grained control over cache lifetimes and invalidation, with features like `refetchOnMount` and `refetchOnReconnect`.
- **Seamless Integration with Redux**: RTK Query is built on top of Redux Toolkit, leveraging existing concepts like slices and thunks, making it a natural extension for Redux users.
- **TypeScript Support**: With TypeScript integration, RTK Query offers type safety and autocompletion, improving developer experience and reducing runtime errors.

## Key Features

- Defines "endpoints" for data retrieval and updates.
- Generates React hooks for data fetching and state management.
- Offers cache entry lifecycle options for advanced use cases.
- Written in TypeScript for excellent type support.

## Included APIs

- `createApi()`: Core function to define endpoints and configure fetching behavior.
- `fetchBaseQuery()`: Simplifies requests using the `fetch` API.
- `<ApiProvider />`: Alternative to Redux `Provider` for standalone use.
- `setupListeners()`: Enables automatic refetching under certain conditions.

## Bundle Size Impact

- Additional ~9kb if already using Redux Toolkit.
- ~17kb without Redux Toolkit (without React).
- ~19kb with React (excluding React-Redux as a peer dependency).

## Basic Usage

### Creating an API Slice

```ts
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react'

export const pokemonApi = createApi({
  reducerPath: 'pokemonApi',
  baseQuery: fetchBaseQuery({ baseUrl: 'https://pokeapi.co/api/v2/' }),
  endpoints: (builder) => ({
    getPokemonByName: builder.query<Pokemon, string>({
      query: (name) => `pokemon/${name}`,
    }),
  }),
})

export const { useGetPokemonByNameQuery } = pokemonApi
```

### Configuring the Store

```ts
import { configureStore } from '@reduxjs/toolkit'
import { setupListeners } from '@reduxjs/toolkit/query'
import { pokemonApi } from './services/pokemon'

export const store = configureStore({
  reducer: {
    [pokemonApi.reducerPath]: pokemonApi.reducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(pokemonApi.middleware),
})

setupListeners(store.dispatch)
```

### Using Hooks in Components

```ts
import React from 'react'
import { useGetPokemonByNameQuery } from './services/pokemon'

export default function App() {
  const { data, error, isLoading } = useGetPokemonByNameQuery('bulbasaur')
}
```

