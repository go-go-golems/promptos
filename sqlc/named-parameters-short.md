# TLDR: Using Named and Nullable Parameters with sqlc in Go

- Use `sqlc.arg()` or `@` for named parameters in SQL queries.
  ```sql
  -- name: UpsertAuthorName :one
  UPDATE author SET name = CASE WHEN @set_name::bool THEN @name::text ELSE name END RETURNING *;
  ```
- Named parameters control Params struct field names.
  ```go
  type UpdateAuthorNameParams struct {
	SetName bool   `json:"set_name"`
	Name    string `json:"name"`
  }
  ```
- Use `sqlc.narg()` for nullable parameters in SQL queries.
  ```sql
  -- name: UpdateAuthor :one
  UPDATE author SET name = coalesce(sqlc.narg('name'), name), bio = coalesce(sqlc.narg('bio'), bio) WHERE id = sqlc.arg('id') RETURNING *;
  ```
- Nullable parameters override default nullability inference.
  ```go
  type UpdateAuthorParams struct {
	Name sql.NullString
	Bio  sql.NullString
	ID   int64
  }
  ```
