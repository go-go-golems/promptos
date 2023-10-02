Here is how you can use the SQLC Go package for executing Update SQL queries with single and multiple parameters:

For single parameter SQL queries:

```go
// Define your SQL query in a SQL file
// SQLC will generate a Go method with a single parameter
// Example Go method:
func (q *Queries) UpdateAuthorBios(ctx context.Context, bio string) error {
    _, err := q.db.ExecContext(ctx, "UPDATE authors SET bio = ?", bio)
    return err
}
```

For multiple parameters SQL queries:

```go
// Define your SQL query with multiple parameters in SQL file
// SQLC will generate a Go method accepting a Params struct
// Example Params struct:
type UpdateAuthorParams struct {
    ID  int32
    Bio string
}

// Example Go method:
func (q *Queries) UpdateAuthor(ctx context.Context, arg UpdateAuthorParams) error {
    _, err := q.db.ExecContext(ctx, "UPDATE authors SET bio = ? WHERE id = ?", arg.Bio, arg.ID)
    return err
}
```

