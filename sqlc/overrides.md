# Overriding Database Types in SQLC

## Overview
This guide provides a concise explanation on how to override default database type mappings in SQLC.

## Overriding Default Type Mappings

To override default type mappings, specify the required Go package in the `overrides` array in your SQLC configuration file. 

```yaml
version: "2"
sql:
- schema: "sqlite3/schema.sql"
  queries: "sqlite3/query.sql"
  engine: "sqlite3"
  gen:
    go: 
      package: "authors"
      out: "sqlite3"
      overrides:
        - db_type: "uuid"
          go_type: "github.com/gofrs/uuid.UUID"
```

## Override Configuration Keys

Each override mapping has the following keys:

- `db_type`: The SQLite type to override.
- `column`: To override a specific column of a table instead of a type. Format: `table.column`.
- `go_type`: A fully qualified name to a Go type to use in the generated code.
- `go_struct_tag`: A reflect-style struct tag to use in the generated code.
- `nullable`: If `true`, use this type when a column is nullable. Defaults to `false`.

## Overriding Nullable and Non-Nullable Columns

A single `db_type` override configuration applies to either nullable or non-nullable columns, but not both. To override a single `go_type` in both cases, specify two overrides.

## Overriding with Complex Import Paths

For complex import paths, the `go_type` can be an object with the following keys:

- `import`: The import path for the package where the type is defined.
- `package`: The package name where the type is defined.
- `type`: The type name itself, without any package prefix.
- `pointer`: If `true`, generated code will use pointers to the type rather than the type itself.
- `slice`: If `true`, generated code will use a slice of the type rather than the type itself.

Example:

```yaml
version: "2"
sql:
- schema: "sqlite3/schema.sql"
  queries: "sqlite3/query.sql"
  engine: "sqlite3"
  gen:
    go: 
      package: "authors"
      out: "sqlite3"
      overrides:
        - db_type: "uuid"
          go_type:
            import: "a/b/v2"
            package: "b"
            type: "MyType"
            pointer: true
```

## Priority of Overrides

When generating code, entries using the `column` key will always have preference over entries using the `db_type` key.

