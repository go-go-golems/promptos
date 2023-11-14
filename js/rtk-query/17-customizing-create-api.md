# Simplified Documentation Structure

`createApi` is a function provided by RTK Query that allows you to define a set of operations and requests to interact with your API. There are two main variants:

- **`createBaseApi`**: This is focused solely on Redux logic without any React-specific code.
- **`createApi`**: This includes everything in `createBaseApi` plus additional React hooks for use in React components.

Both variants can be customized to suit your application's needs.

## Customizing React-Redux Hooks

When using `createApi` with React, you might need to customize the hooks to work with a different Redux store context. This is useful if you're using a custom store setup. You can customize the hooks by providing your own versions of `useSelector` or `useDispatch`.

Here's how you can customize the hooks:

```ts
import * as React from 'react';
import { createDispatchHook, ReactReduxContextValue } from 'react-redux';
import { buildCreateApi, coreModule, reactHooksModule } from '@reduxjs/toolkit/query/react';

const MyContext = React.createContext<ReactReduxContextValue>(null as any);
const customCreateApi = buildCreateApi(
  coreModule(),
  reactHooksModule({ useDispatch: createDispatchHook(MyContext) })
);
```

In this example, `MyContext` is a custom context that you've created for your application. The `customCreateApi` function is then used to build your API with the customized hooks.

## Creating Your Own Module

To extend the functionality of RTK Query, you can create your own module. This involves defining a module that can add new properties or behaviors to your API endpoints.

Here's a simplified example of creating a custom module:

```ts
import { CoreModule } from '@internal/core/module';
import { BaseQueryFn, EndpointDefinitions, Api, Module, buildCreateApi, coreModule } from '@reduxjs/toolkit/query';

export const customModuleName = Symbol();
export type CustomModule = typeof customModuleName;

declare module '../apiTypes' {
  export interface ApiModules<BaseQuery extends BaseQueryFn, Definitions extends EndpointDefinitions, ReducerPath extends string, TagTypes extends string> {
    [customModuleName]: {
      endpoints: {
        [K in keyof Definitions]: {
          myEndpointProperty: string;
        };
      };
    };
  }
}

export const myModule = (): Module<CustomModule> => ({
  name: customModuleName,
  init(api, options, context) {
    // Initialization logic here

    return {
      injectEndpoint(endpoint, definition) {
        const anyApi = api as any as Api<any, Record<string, any>, string, string, CustomModule | CoreModule>;
        anyApi.endpoints[endpoint].myEndpointProperty = 'test';
      },
    };
  },
});

export const myCreateApi = buildCreateApi(coreModule(), myModule());
```

In this code, `customModuleName` is a unique symbol used to identify your module. The `myModule` function returns an object that conforms to the `Module` interface, which includes an `init` method for initialization and an `injectEndpoint` method to modify endpoints. Finally, `myCreateApi` is used to build the API with your custom module included.

