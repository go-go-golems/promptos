### RTK Query Conditional Fetching

Conditional Fetching is a feature in RTK Query that allows you to control when data fetching should occur. It is particularly useful when you want to delay fetching until certain conditions are met, such as the availability of required data or user authentication.

#### Using the `skip` Parameter

To prevent a query from running automatically, you can use the `skip` parameter within a query hook. This parameter accepts a boolean value. When set to `true`, the query will not run. When the condition changes and `skip` is set to `false`, the query will execute.

Here's a generic example of how to use the `skip` parameter:

```javascript
import { useMyQuery } from './services/myApi';

function MyComponent({ userId }) {
  const { data, error, isLoading } = useMyQuery(userId, {
    skip: !userId, // The query will not run if `userId` is null or undefined
  });

  // Render your component based on the query state
}
```

#### Typescript and `skipToken`

For those using Typescript, `skipToken` is an alternative to the `skip` option. It allows you to skip the execution of a query while maintaining accurate endpoint types.

Here's how you can use `skipToken`:

```typescript
import { useMyQuery, skipToken } from './services/myApi';

function MyComponent({ userId }) {
  const { data, error, isLoading } = useMyQuery(userId ?? skipToken);

  // Render your component based on the query state
}
```
