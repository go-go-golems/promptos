# RTK Query Code Generation

Code generation in RTK Query is a process that allows developers to automatically create API slice definitions from API schemas. This is particularly useful when working with predefined API endpoints in OpenAPI or GraphQL formats. The tools for code generation are available as separate plugins and packages.

## GraphQL Code Generation
- **Plugin Overview**: The GraphQL Codegen plugin simplifies the process of generating API slice definitions from GraphQL schemas.
- **Example Project**: An example project demonstrates how to use the GraphQL Codegen plugin with RTK Query.

## OpenAPI Code Generation
- **Initial Setup**: Begin by creating an empty API service using the `createApi` function from RTK Query.
  ```typescript
  import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';

  export const emptySplitApi = createApi({
    baseQuery: fetchBaseQuery({ baseUrl: '/' }),
    endpoints: () => ({}),
  });
  ```
- **Configuration File Creation**: Define a configuration file specifying the schema, API file, and other options.
  ```typescript
  const config = {
    schemaFile: 'https://example.com/api/openapi.json',
    apiFile: './src/store/emptyApi.ts',
    outputFile: './src/store/api.ts',
    hooks: true,
  };
  ```
- **Code Generation Execution**: Run the code generator using the configuration file.
  ```bash
  npx @rtk-query/codegen-openapi config.ts
  ```
- **Generating Tags**: Optionally, use the `tag` option to automatically generate `providesTags` and `invalidatesTags` for operations.
- **Programmatic Usage**: Generate endpoints programmatically by calling the `generateEndpoints` function.
  ```typescript
  import { generateEndpoints } from '@rtk-query/codegen-openapi';

  const api = await generateEndpoints(config);
  ```

## Configuration File Options
- **Simple Usage**: Define basic options such as `apiFile`, `schemaFile`, and `outputFile`.
- **Filtering Endpoints**: Use `filterEndpoints` to include only specific endpoints in the generated code.
  ```typescript
  filterEndpoints: ['loginUser', /Order/],
  ```
- **Endpoint Overrides**: Override the default behavior for certain endpoints using `endpointOverrides`.
  ```typescript
  endpointOverrides: [
    { pattern: 'loginUser', type: 'mutation' },
  ],
  ```
- **Generating Hooks**: Control hook generation with the `hooks` option, which can be a boolean or an object for more granularity.
  ```typescript
  hooks: { queries: true, lazyQueries: false, mutations: true },
  ```
- **Multiple Output Files**: Specify different output files for different sets of endpoints.
  ```typescript
  outputFiles: {
    './src/store/user.ts': { filterEndpoints: [/user/i] },
    './src/store/order.ts': { filterEndpoints: [/order/i] },
  },
  ```

