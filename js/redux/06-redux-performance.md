# Simplified Framework Documentation

## 1. Performance Optimization

Memoization is a technique that caches the results of function calls to avoid unnecessary recalculations. In Redux, memoized selectors can prevent components from re-rendering when the state has not changed.

- **Use `createSelector`**: Redux Toolkit exports `createSelector` from Reselect, which creates memoized selectors.
  The `createSelector` function takes input selectors and an output selector. It only recalculates the output if the input values change, otherwise, it returns the cached output.
- **Avoid New References**: Ensure `useSelector` does not return new references on each call, as this will trigger re-renders.

```javascript
import { createSelector } from '@reduxjs/toolkit';

const selectUserData = createSelector(
  state => state.users.data,
  data => data.filter(user => user.isActive)
);
```

### Component Rendering Optimization

Optimizing how components render can significantly improve performance, especially for components that render lists or complex data.

- **React.memo**: Wrap components with `React.memo` to prevent re-renders if props have not changed.
- **Selector Comparison**: Use `useSelector` with a comparison function like `shallowEqual` to prevent re-renders when the actual data has not changed.
- **Optimized List Rendering**: For list components, select an array of item IDs and pass them to child components. Let each child component select its item by ID.

```javascript
import React, { memo } from 'react';
import { useSelector } from 'react-redux';
import { selectUserById } from './usersSlice';

const UserComponent = memo(({ userId }) => {
  const user = useSelector(state => selectUserById(state, userId));
  return <div>{user.name}</div>;
});
```

## 2. Data Normalization

### Normalized State Structure

Normalization is the process of structuring data to reduce redundancy and improve data lookup efficiency.

- **Lookup Table**: Store data in an object where item IDs are keys and items are values.
- **IDs Array**: Maintain an array of item IDs for ordering and reference.

```javascript
const normalizedData = {
  entities: {
    '1': { id: '1', name: 'John' },
    '2': { id: '2', name: 'Jane' }
  },
  ids: ['1', '2']
};
```

### Managing Normalized State with `createEntityAdapter`

`createEntityAdapter` from Redux Toolkit simplifies the management of normalized data.

- **Sorting**: Define a `sortComparer` to keep IDs sorted.
- **CRUD Operations**: Use generated reducer functions for adding, updating, and removing items.
- **Selectors**: Utilize generated selectors like `selectAll` and `selectById` for efficient data access.


`createEntityAdapter` provides a standardized way to store your data in a slice by normalizing the state shape. It automatically generates selectors and reducer functions for performing CRUD operations on the normalized data.

```javascript
import { createSlice, createEntityAdapter } from '@reduxjs/toolkit';

// Define the adapter
const usersAdapter = createEntityAdapter();

// Create the slice
const usersSlice = createSlice({
  name: 'users',
  initialState: usersAdapter.getInitialState(),
  reducers: {
    // Reducer logic
  },
  extraReducers: {
    // Handle async actions
  }
});

// Export the auto-generated selectors
export const {
  selectAll: selectAllUsers,
  selectById: selectUserById
} = usersAdapter.getSelectors(state => state.users);
```

## 3. ThunkAPI

`thunkAPI` is an object provided to thunk functions that contains several fields and methods useful for handling asynchronous logic and side effects in Redux. It is part of the `createAsyncThunk` API from Redux Toolkit.

Within a thunk, you can access the current state and dispatch actions using `thunkAPI.getState()` and `thunkAPI.dispatch()`, respectively. This allows you to perform conditional logic based on the current state and dispatch additional actions as needed.

Options of thunkAPI:
- `dispatch`: Allows the thunk to dispatch actions.
- `getState`: Returns the current state of the Redux store.
- `extra`: Contains the "extra argument" passed to the thunk middleware upon creation, which can be used for dependency injection.
- `requestId`: A unique string ID generated for each thunk action, useful for tracking the request's progress or for debugging.
- `signal`: An `AbortSignal` from an `AbortController` that can be used to cancel the request if needed.
- `rejectWithValue`: A utility function that allows the thunk to return a rejected action with a custom payload if the promise is rejected.
- `fulfillWithValue`: A utility function that allows the thunk to return a fulfilled action with a custom payload, bypassing the standard payload creator.
- `serializeError`: A utility function that takes an `Error` object and returns a plain object that can be safely serialized as part of the rejected action's payload.

```javascript
import { createAsyncThunk } from '@reduxjs/toolkit';

const fetchUserData = createAsyncThunk(
  'users/fetchByIdStatus',
  async (userId, thunkAPI) => {
    const response = await userAPI.fetchById(userId);
    // Access state
    const state = thunkAPI.getState();
    // Dispatch an action
    thunkAPI.dispatch(anotherAction());
    return response.data;
  }
);
```



