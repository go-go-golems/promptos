### Simplified Redux Data Flow Documentation with Code Examples

#### Introduction to Redux Data Flow

Redux is a state management library that helps you manage the state of your application in a predictable way. It revolves around a strict unidirectional data flow, meaning that all data in an application follows the same lifecycle pattern, making the logic of your app more predictable and easier to understand.

Key Terms:
- **Actions**: Objects with a `type` property that describe a change. Example: `{ type: 'ADD_TODO', text: 'Learn Redux' }`
- **Reducers**: Functions that determine how the state changes in response to an action. Example: `(state, action) => newState`
- **Store**: The object that holds the application state and provides a `dispatch()` method to send actions to the store.
- **Dispatching**: The process of sending an action to the store to trigger a state update.

#### Core Principles of Redux Data Flow

1. **Single Source of Truth**: The state of the entire application is stored in an object tree within a single store.
   ```javascript
   const store = createStore(rootReducer);
   ```
2. **State is Read-Only**: The only way to change the state is to emit an action.
   ```javascript
   store.dispatch({ type: 'INCREMENT' });
   ```
3. **Changes are Made with Pure Functions**: Reducer functions must be pure, without side-effects, and they should not mutate the existing state.
   ```javascript
   function counter(state = 0, action) {
     switch (action.type) {
       case 'INCREMENT':
         return state + 1;
       case 'DECREMENT':
         return state - 1;
       default:
         return state;
     }
   }
   ```

#### Detailed Redux Data Flow Steps

1. **Dispatching an Action**: An action is dispatched to request a change in the state.
   ```javascript
   store.dispatch({ type: 'ADD_TODO', text: 'Use Redux' });
   ```
2. **Reducers Process Actions**: Reducers determine how the state should change in response to actions.
   ```javascript
   function todos(state = [], action) {
     switch (action.type) {
       case 'ADD_TODO':
         return [...state, { text: action.text, completed: false }];
       // handle other actions
       default:
         return state;
     }
   }
   ```
3. **Store Updates State**: The store updates the state by running the reducer with the previous state and the current action.
   ```javascript
   const store = createStore(todos);
   ```
4. **UI Reads Updated State**: UI components subscribe to the store and update when the state changes.
   ```javascript
   const TodoList = () => {
     const todos = useSelector(state => state.todos);
     // render the list of todos
   }
   ```

#### Using Redux with React

React components can interact with the Redux store using hooks provided by `react-redux`.

- **Reading State with `useSelector`**: Extracts data from the Redux store.
   ```jsx
   const counterValue = useSelector(state => state.counter);
   ```
- **Dispatching Actions with `useDispatch`**: Provides the `dispatch` function to send actions to the store.
   ```jsx
   const dispatch = useDispatch();
   const incrementCounter = () => dispatch({ type: 'INCREMENT' });
   ```

#### Summary

The Redux data flow starts with dispatching an action, which is processed by reducers to create a new state. The store then updates the state, and the UI components read this updated state. This cycle ensures that state changes are predictable and traceable.
