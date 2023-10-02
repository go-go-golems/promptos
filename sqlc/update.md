## Overview
This guide provides concise instructions on how to use the SQLC Go package for executing Update SQL queries with single and multiple parameters.

## Single Parameter SQL Queries

- Define your SQL query with a single parameter in SQL file.
- Example SQL query:
```sql
-- name: UpdateAuthorBios :exec
UPDATE authors SET bio = ?;
```
- SQLC generates a Go method with a single parameter.
- Example Go method:
```go
func (q *Queries) UpdateAuthorBios(ctx context.Context, bio string) error
```

## Multiple Parameters SQL Queries

- Define your SQL query with multiple parameters in SQL file.
- Example SQL query:
```sql
-- name: UpdateAuthor :exec
UPDATE authors SET bio = ?
WHERE id = ?;
```
- SQLC generates a Go method accepting a `Params` struct.
- Example `Params` struct:
```go
type UpdateAuthorParams struct {
	ID  int32
	Bio string
}
```
- Example Go method:
```go
func (q *Queries) UpdateAuthor(ctx context.Context, arg UpdateAuthorParams) error
```
