To use SQLC to insert data.

1. Define SQL queries in a `.sql` file with tags like `:exec`, `:one`, or `:copyfrom` for different operations.
2. Use `RETURNING` statement in SQL query to return columns from inserted rows.
3. For bulk insertions, use `:copyfrom` tag and leverage PostgreSQL's COPY protocol or MySQL's LOAD DATA feature.
4. Create a configuration file specifying the SQL engine, query files, and Go package details.
5. SQLC generates Go functions and structs based on the SQL queries and configuration.

Example:
```sql
-- name: CreateAuthor :exec
INSERT INTO authors (bio) VALUES (?);
```
Generates:
```go
(q *Queries) CreateAuthor(ctx context.Context, bio string) error
```

Configuration:
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
