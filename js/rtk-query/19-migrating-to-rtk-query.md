# RTK Query Migrating to RTK Query

## Migrating from Redux Toolkit to RTK Query

When migrating from Redux Toolkit's `createAsyncThunk` to RTK Query, you replace the manual setup of asynchronous logic with RTK Query's automated API slice. This change streamlines the process of fetching, caching, and managing server state.

Consider a scenario where you fetch data for a Pokémon from an API. Traditionally, you would use `createAsyncThunk` and `createSlice` to manage the data and its loading state. With RTK Query, you define an API slice that automatically generates hooks for data fetching.

## Using `createSlice` & `createAsyncThunk`

### Thunk Action Creator

```typescript
export const fetchPokemonByName = createAsyncThunk<Pokemon, string>(
  'pokemon/fetchByName',
  async (name, { rejectWithValue }) => {
    // Fetch data from API and handle response
  }
);
```

### Slice Logic

```typescript
const pokemonSlice = createSlice({
  name: 'pokemon',
  initialState: {},
  reducers: {},
  extraReducers: (builder) => {
    // Handle pending, fulfilled, and rejected states
  },
});
```

### Selectors

```typescript
export const selectStatusByName = (state, name) => state.pokemon.statusByName[name];
export const selectDataByName = (state, name) => state.pokemon.dataByName[name];
```

### Store Configuration

```typescript
export const store = configureStore({
  reducer: {
    pokemon: pokemonSlice.reducer,
  },
});
```

### Custom Hook

```typescript
export function useGetPokemonByNameQuery(name: string) {
  // Dispatch action and select data from the store
}
```

### Component Usage

```tsx
const { data, isError, isLoading } = useGetPokemonByNameQuery('bulbasaur');
```

## Converting to RTK Query

### API Slice File

```typescript
export const api = createApi({
  baseQuery: fetchBaseQuery({ baseUrl: 'https://pokeapi.co/api/v2/' }),
  endpoints: (build) => ({
    getPokemonByName: build.query<Pokemon, string>({
      query: (name) => `pokemon/${name}`,
    }),
  }),
});
```

### Store Integration

```typescript
export const store = configureStore({
  reducer: {
    [api.reducerPath]: api.reducer,
  },
  middleware: (getDefaultMiddleware) => getDefaultMiddleware().concat(api.middleware),
});
```

### Using the Auto-Generated Hook

```tsx
const { data, isError, isLoading } = useGetPokemonByNameQuery('bulbasaur');
```

### Cleaning Up Unused Code

Remove the old `createAsyncThunk`, `createSlice`, and custom hook implementations as they are no longer needed with RTK Query.

