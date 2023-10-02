To insert rows with sqlc in Go, you need to define the SQL query with a specific comment to generate a database access method. Then, use the generated method to insert rows into the database. Here is a concise example:

```go
// Define SQL query
/* 
-- name: CreateAuthor :exec
INSERT INTO authors (bio, birth_year) VALUES (?, ?);
*/

// Use generated method
func (q *Queries) CreateAuthor(ctx context.Context, bio string, birthYear int) error {
	_, err := q.db.ExecContext(ctx, createAuthor, bio, birthYear)
	return err
}

// Usage
ctx := context.Background()
err := queries.CreateAuthor(ctx, "Bio text", 1980)
if err != nil {
    log.Fatal(err)
}
```

For passing a slice as a parameter to a query, you need to use the `sqlc.slice()` function to mark the placeholder insertion location. Then, use the generated method to select rows from the database. Here is a concise example:

```go
// Define SQL query
/* 
-- name: ListAuthorsByIDs :many
SELECT * FROM authors
WHERE id IN (sqlc.slice('ids'));
*/

// Use generated method
func (q *Queries) ListAuthorsByIDs(ctx context.Context, ids []int64) ([]Author, error) {
    // implementation...
}

// Usage
ctx := context.Background()
authors, err := queries.ListAuthorsByIDs(ctx, []int64{1, 2, 3})
if err != nil {
    log.Fatal(err)
}
