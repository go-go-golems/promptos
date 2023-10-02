# Customizing Struct and Table Names with SQLC in Go

- SQLC uses `rename` mapping in its configuration file to customize struct field and table names.
- For struct fields, keys are column names, values are new struct field names.
```yaml
version: "2"
sql:
- schema: "sqlite/schema.sql"
  queries: "sqlite/query.sql"
  engine: "sqlite"
  gen:
    go: 
      package: "authors"
      out: "sqlite"
      rename:
        spotify_url: "SpotifyURL"
```
- For table structs, keys are generated struct names, values are new struct names.
```yaml
version: '1'
packages:
- path: db
  engine: sqlite
  schema: query.sql
  queries: query.sql
rename:
  author: Writer
```
- Rename mappings apply to the whole package.
- Same name for a column and a table can't have different rename values.

