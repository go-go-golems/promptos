## Overview
This guide provides concise instructions on how to use SQLC to generate Go functions from SQL queries, focusing on the SQLite syntax.

## Inserting Rows

- Define your SQL query with the `:exec` tag.
- Example:
```sql
-- name: CreateAuthor :exec
INSERT INTO authors (bio) VALUES (?);
```
- SQLC generates a function with the same name as the query tag.
- Function signature: `(q *Queries) CreateAuthor(ctx context.Context, bio string) error`

## Returning Columns from Inserted Rows

- Use the `RETURNING` statement in your SQL query.
- Tag the query with `:one`.
- Example:
```sql
-- name: CreateAuthor :one
INSERT INTO authors (name, bio) VALUES (?, ?)
RETURNING *;
```
- SQLC generates a function and a struct for the parameters.
- Function signature: `(q *Queries) CreateAuthor(ctx context.Context, arg CreateAuthorParams) (Author, error)`
- Struct: `CreateAuthorParams` with fields matching the query parameters.

## Using CopyFrom

### PostgreSQL

- PostgreSQL's COPY protocol can be used for faster row insertion.
- Tag the query with `:copyfrom`.
- Example:
```sql
-- name: CreateAuthors :copyfrom
INSERT INTO authors (name, bio) VALUES (?, ?);
```
- SQLC generates a function and a struct for the parameters.
- Function signature: `(q *Queries) CreateAuthors(ctx context.Context, arg []CreateAuthorsParams) (int64, error)`

### MySQL

- MySQL's LOAD DATA feature can be used for similar functionality.
- Tag the query with `:copyfrom`.
- Example:
```sql
-- name: InsertValues :copyfrom
INSERT INTO foo (a, b, c, d) VALUES (?, ?, ?, ?);
```
- SQLC generates a function and a struct for the parameters.
- Function signature: `(q *Queries) InsertValues(ctx context.Context, arg []InsertValuesParams) (int64, error)`

## Configuration

- SQLC requires a configuration file to specify the SQL engine, query files, and Go package details.
- Example:
```yaml
version: "2"
sql:
  - engine: "sqlite"
    queries: "query.sql"
    schema: "query.sql"
    gen:
      go:
        package: "db"
        out: "db"
```
- This configuration generates Go code in the "db" package and output directory, using the SQLite engine and the queries defined in "query.sql".

