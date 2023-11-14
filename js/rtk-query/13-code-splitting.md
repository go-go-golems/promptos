# RTK Query Code Splitting 

## Introduction to Code Splitting

Code Splitting is a technique used to reduce the initial load time of an application by splitting the code into smaller chunks that can be loaded on demand. In the context of RTK Query, it allows for dynamic injection of additional API endpoints into your service definition, which is particularly useful for large applications with numerous endpoints.

## Setting Up the Initial API Service

To begin with, you need to set up an API service that will later receive additional endpoints. This is done using the `createApi` function from RTK Query, which initializes an empty API service.

```typescript
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';

export const apiService = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: '/' }),
  endpoints: () => ({}),
});
```

## Injecting Additional Endpoints

Once you have your initial API service, you can inject new endpoints using the `injectEndpoints` method. This method accepts an object with your new endpoints and an optional `overrideExisting` flag.

```typescript
import { apiService } from './apiService';

const extendedApi = apiService.injectEndpoints({
  endpoints: (builder) => ({
    getItems: builder.query({
      query: (id) => `items/${id}`,
    }),
  }),
  overrideExisting: false,
});
```

## Using Injected Endpoints

After injecting endpoints, you can use them in your application. The `injectEndpoints` method returns an API with the correct types for the newly added endpoints.

```typescript
export const { useGetItemsQuery } = extendedApi;
```

## Handling Endpoint Overrides

If you attempt to inject an endpoint with the same name as an existing one without setting `overrideExisting` to `true`, the new endpoint will not replace the existing one. In development mode, a warning will be issued.

```typescript
const extendedApi = apiService.injectEndpoints({
  endpoints: (builder) => ({
    getItems: builder.query({
      query: (id) => `items/${id}`,
    }),
  }),
  overrideExisting: true, // This will override the existing endpoint named 'getItems'
});
```

## Tips and Best Practices

- Always import endpoints from a file where they are injected to ensure they are available.
- Use the `overrideExisting` flag with caution to avoid unintentionally replacing existing endpoints.
- Organize your code by keeping the API service and endpoint injections in separate files for clarity and maintainability.
