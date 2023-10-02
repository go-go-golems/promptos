# Using Named and Nullable Parameters with sqlc

## Overview
This guide provides concise instructions on how to use named and nullable parameters with the sqlc package in Go.

## Named Parameters
- Use named parameters to control field names on the Params struct.
- Use `sqlc.arg()` or `@` to specify named parameters in your SQL query.
- Example:
```sql
-- name: UpsertAuthorName :one
UPDATE author
SET
  name = CASE WHEN @set_name::bool
    THEN @name::text
    ELSE name
    END
RETURNING *;
```
- Generated Params struct:
```go
type UpdateAuthorNameParams struct {
	SetName bool   `json:"set_name"`
	Name    string `json:"name"`
}
```

## Nullable Parameters
- Use `sqlc.narg()` to generate nullable parameters, overriding default nullability inference.
- No nullable equivalent for `@` syntax.
- Example:
```sql
-- name: UpdateAuthor :one
UPDATE author
SET
 name = coalesce(sqlc.narg('name'), name),
 bio = coalesce(sqlc.narg('bio'), bio)
WHERE id = sqlc.arg('id')
RETURNING *;
```
- Generated Params struct:
```go
type UpdateAuthorParams struct {
	Name sql.NullString
	Bio  sql.NullString
	ID   int64
}
```

## Summary
- Use `sqlc.arg()` or `@` for named parameters.
- Use `sqlc.narg()` for nullable parameters.
- Named and nullable parameters provide more control over the Params struct field names and nullability.

