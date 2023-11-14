## Introduction to Redux

Redux is a library for managing and updating application state using events called "actions". It's useful for handling "global" state which is shared across many parts of your application. Redux ensures state updates are predictable and helps you write applications that behave consistently.

### When to Use Redux

Consider Redux if:

- Your app has a large amount of state that is needed in many places.
- The state is updated frequently.
- The logic to update that state is complex.
- Your codebase is medium to large and may be worked on by many people.

### Tools and Libraries

- **React-Redux**: Connects Redux with React applications.
- **Redux Toolkit**: Simplifies Redux application development.
- **Redux DevTools Extension**: Provides powerful debugging tools.

## Core Concepts

### State Management

Redux creates a centralized "store" for your application's state, allowing components to access and update state as needed.

### Immutability

Redux requires that state updates are done immutably, meaning you do not modify the original state directly but create copies of it with the necessary changes.

### Actions

Actions are plain objects with a `type` field and describe "what happened" in the app. They can also have a `payload` field to pass any additional information.

```js
const addAction = {
  type: 'ADD',
  payload: { value: 1 }
}
```

### Action Creators

Functions that return action objects, making it easier to dispatch actions without creating them by hand.

```js
const createAction = payload => ({
  type: 'CREATE',
  payload
})
```

### Reducers

Reducers are functions that determine how the state should change in response to an action. They must be pure functions—given the same input, they should always return the same output without side effects.

```js
const initialState = { count: 0 }

function counterReducer(state = initialState, action) {
  switch (action.type) {
    case 'INCREMENT':
      return { ...state, count: state.count + 1 }
    default:
      return state
  }
}
```

### Store

The store holds the state of your application. You can access the current state, dispatch actions, and subscribe to changes.

```js
import { createStore } from 'redux'

const store = createStore(counterReducer)
```

### Dispatch

Dispatching is the process of sending actions to the store to update the state.

```js
store.dispatch({ type: 'INCREMENT' })
```

### Selectors

Selectors are functions that extract and return a part of the state from the store.

```js
const selectCount = state => state.count

const currentCount = selectCount(store.getState())
```

## Data Flow in Redux

1. Store is created with a root reducer.
2. UI components access state from the store and subscribe to updates.
3. Events in the app dispatch actions to the store.
4. Store runs reducers with the current state and dispatched action.
5. Reducers compute a new state and the store is updated.
6. Store notifies subscribed UI components.
7. UI re-renders with the new state.
