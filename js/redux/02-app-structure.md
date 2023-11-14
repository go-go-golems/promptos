# Redux App Structure

Redux Toolkit simplifies the process of setting up and managing the Redux state in your application. It provides tools that help you write less code and follow best practices by default.

### Creating the Redux Store

#### Configure Store

The Redux store is the central location where your application's state is stored. You can create a store using the `configureStore` function from Redux Toolkit, which sets up the store with sensible defaults and middleware for a good development experience.

```js
import { configureStore } from '@reduxjs/toolkit';
import rootReducer from './reducers';

const store = configureStore({
  reducer: rootReducer,
});
```

#### Redux Slices

A "slice" is a collection of Redux reducer logic and actions for a single feature in your app. Slices are defined in individual files and combine the reducers and actions related to a specific piece of state.

```js
import { createSlice } from '@reduxjs/toolkit';

const exampleSlice = createSlice({
  name: 'example',
  initialState: {},
  reducers: {
    // Reducer logic
  },
});

export default exampleSlice.reducer;
```

### Creating Slice Reducers and Actions

#### Reducers and Immutable Updates

Reducers are functions that determine how the state should change in response to an action. They must not mutate the original state but return a new, updated state.

```js
const exampleReducer = (state, action) => {
  return {
    ...state,
    property: action.payload,
  };
};
```

Redux Toolkit uses Immer to allow you to write reducers in a way that looks like direct state mutation while still producing immutable updates.

```js
const exampleSlice = createSlice({
  name: 'example',
  initialState: { value: 0 },
  reducers: {
    increment: state => {
      state.value += 1;
    },
  },
});
```

#### Writing Async Logic with Thunks

Thunks are functions that handle asynchronous logic. They can dispatch actions and access the current state.

```js
export const fetchUserData = userId => async dispatch => {
  const userData = await fetchUserApi(userId);
  dispatch(userLoaded(userData));
};
```

### The React Counter Component

#### Reading Data with `useSelector`

`useSelector` is a hook that allows you to access state values within your React components.

```jsx
const count = useSelector(state => state.counter.value);
```

#### Dispatching Actions with `useDispatch`

`useDispatch` provides the `dispatch` function from the Redux store, allowing you to dispatch actions in response to user interactions.

```jsx
const dispatch = useDispatch();
dispatch(increment());
```

#### Component State and Forms

Local component state should be used for data that doesn't need to be global or shared across the app.

```jsx
const [inputValue, setInputValue] = useState('');
```

### Providing the Store with `<Provider>`

The `<Provider>` component from React-Redux makes the Redux store available to any nested components that need to access the Redux state.

```jsx
import { Provider } from 'react-redux';

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
);
```

### Summary of Key Concepts

- Redux Toolkit streamlines Redux development.
- Configure the store with `configureStore`.
- Organize state logic into slices with `createSlice`.
- Reducers must not mutate state; use immutable updates.
- Handle async logic with thunks.
- Use `useSelector` and `useDispatch` to interact with Redux state in React components.
- Wrap your app with `<Provider>` to provide the Redux store.
