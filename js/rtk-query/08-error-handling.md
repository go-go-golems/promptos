# RTK Query Error Handling 

When interacting with APIs using RTK Query, errors may occur during queries or mutations. These errors are captured and made available in the `error` property of the hook used for the API call. Understanding how to handle these errors is crucial for providing a robust user experience.

## Displaying Errors
Errors can be displayed directly in your UI components. When an error occurs, the component will re-render, allowing you to show an appropriate message or UI element based on the error information.

**Query Error Example:**
```tsx
function PostsList() {
  const { data, error } = useGetPostsQuery()

  if (error) {
    return <div>Error: {error.status} - {JSON.stringify(error.data)}</div>;
  }

  // Render posts...
}
```

**Mutation Error Example:**
```tsx
function AddPost() {
  const [addPost, { error }] = useAddPostMutation()

  if (error) {
    return <div>Error: {error.status} - {JSON.stringify(error.data)}</div>;
  }

  // Render form...
}
```

## Accessing Error Payloads
To handle errors immediately after a mutation, chain `.unwrap()` to the mutation function. This will allow you to catch any errors and handle them accordingly.

**Using `.unwrap()` Example:**
```ts
addPost({ id: 1, name: 'Example' })
  .unwrap()
  .then(payload => console.log('fulfilled', payload))
  .catch(error => console.error('rejected', error));
```

## Selecting Errors Manually
You can also manually select error information using selectors provided by RTK Query.

**Manual Error Selection Example:**
```tsx
function PostsList() {
  const { error } = useSelector(api.endpoints.getPosts.select())

  if (error) {
    return <div>Error: {error.status} - {JSON.stringify(error.data)}</div>;
  }

  // Render posts...
}
```

## Custom `baseQuery` and Error Responses
The distinction between `data` and `error` responses is determined by the `baseQuery` used. It's essential to return the correct format from your `baseQuery`. For custom implementations, refer to the documentation on customizing queries.

## Macro-Level Error Handling
For global error management, you can use middleware to catch and respond to errors across all async requests. This is useful for displaying generic notifications for any error that occurs.

**Middleware Example:**
```ts
import { isRejectedWithValue } from '@reduxjs/toolkit'
import { toast } from 'your-cool-library'

export const rtkQueryErrorLogger = (api) => (next) => (action) => {
  if (isRejectedWithValue(action)) {
    console.warn('We got a rejected action!');
    toast.warn('Async error!', action.error.data.message);
  }

  return next(action);
}
```

