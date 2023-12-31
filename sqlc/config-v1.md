# Configuration

The `sqlc` tool is configured via a `sqlc.yaml` or `sqlc.json` file. This
file must be in the directory where the `sqlc` command is run.

## Version 1

```yaml
version: "1"
packages:
  - name: "db"
    path: "internal/db"
    queries: "./sql/query/"
    schema: "./sql/schema/"
    engine: "postgresql"
    emit_db_tags: false
    emit_prepared_queries: true
    emit_interface: false
    emit_exact_table_names: false
    emit_empty_slices: false
    emit_exported_queries: false
    emit_json_tags: true
    emit_result_struct_pointers: false
    emit_params_struct_pointers: false
    emit_methods_with_db_argument: false
    emit_pointers_for_null_types: false
    emit_enum_valid_method: false
    emit_all_enum_values: false
    json_tags_case_style: "camel"
    omit_unused_structs: false
    output_batch_file_name: "batch.go"
    output_db_file_name: "db.go"
    output_models_file_name: "models.go"
    output_querier_file_name: "querier.go"
    output_copyfrom_file_name: "copyfrom.go"
    query_parameter_limit: 1
```

### packages

Each mapping in the `packages` collection has the following keys:

- `name`:
  - The package name to use for the generated code. Defaults to `path` basename.
- `path`:
  - Output directory for generated code.
- `queries`:
  - Directory of SQL queries or path to single SQL file; or a list of paths.
- `schema`:
  - Directory of SQL migrations or path to single SQL file; or a list of paths.
- `engine`:
  - Either `postgresql` or `mysql`. Defaults to `postgresql`.
- `sql_package`:
  - Either `pgx/v4`, `pgx/v5` or `database/sql`. Defaults to `database/sql`.
- `emit_db_tags`:
  - If true, add DB tags to generated structs. Defaults to `false`.
- `emit_prepared_queries`:
  - If true, include support for prepared queries. Defaults to `false`.
- `emit_interface`:
  - If true, output a `Querier` interface in the generated package. Defaults to `false`.
- `emit_exact_table_names`:
  - If true, struct names will mirror table names. Otherwise, sqlc attempts to singularize plural table names. Defaults to `false`.
- `emit_empty_slices`:
  - If true, slices returned by `:many` queries will be empty instead of `nil`. Defaults to `false`.
- `emit_exported_queries`:
  - If true, autogenerated SQL statement can be exported to be accessed by another package.
- `emit_json_tags`:
  - If true, add JSON tags to generated structs. Defaults to `false`.
- `emit_result_struct_pointers`:
  - If true, query results are returned as pointers to structs. Queries returning multiple results are returned as slices of pointers. Defaults to `false`.
- `emit_params_struct_pointers`:
  - If true, parameters are passed as pointers to structs. Defaults to `false`.
- `emit_methods_with_db_argument`:
  - If true, generated methods will accept a DBTX argument instead of storing a DBTX on the `*Queries` struct. Defaults to `false`.
- `emit_pointers_for_null_types`:
  - If true and `sql_package` is set to `pgx/v4` or `pgx/v5`, generated types for nullable columns are emitted as pointers (ie. `*string`) instead of `database/sql` null types (ie. `NullString`). Defaults to `false`.
- `emit_enum_valid_method`:
  - If true, generate a Valid method on enum types,
    indicating whether a string is a valid enum value.
- `emit_all_enum_values`:
  - If true, emit a function per enum type
    that returns all valid enum values.
- `json_tags_case_style`:
  - `camel` for camelCase, `pascal` for PascalCase, `snake` for snake_case or `none` to use the column name in the DB. Defaults to `none`.
- `omit_unused_structs`:
  - If `true`, sqlc won't generate table and enum structs that aren't used in queries for a given package. Defaults to `false`.
- `output_batch_file_name`:
  - Customize the name of the batch file. Defaults to `batch.go`.
- `output_db_file_name`:
  - Customize the name of the db file. Defaults to `db.go`.
- `output_models_file_name`:
  - Customize the name of the models file. Defaults to `models.go`.
- `output_querier_file_name`:
  - Customize the name of the querier file. Defaults to `querier.go`.
- `output_copyfrom_file_name`:
  - Customize the name of the copyfrom file. Defaults to `copyfrom.go`.
- `output_files_suffix`:
  - If specified the suffix will be added to the name of the generated files.
- `query_parameter_limit`:
  - Positional arguments that will be generated in Go functions (`>= 0`). To always emit a parameter struct, you would need to set it to `0`. Defaults to `1`.

### overrides

The default mapping of PostgreSQL/MySQL types to Go types only uses packages outside
the standard library when it must.

For example, the `uuid` PostgreSQL type is mapped to `github.com/google/uuid`.
If a different Go package for UUIDs is required, specify the package in the
`overrides` array. In this case, I'm going to use the `github.com/gofrs/uuid`
instead.

```yaml
version: "1"
packages: [...]
overrides:
  - go_type: "github.com/gofrs/uuid.UUID"
    db_type: "uuid"
```

Each override document has the following keys:

- `db_type`:
  - The PostgreSQL or MySQL type to override. Find the full list of supported types in [postgresql_type.go](https://github.com/sqlc-dev/sqlc/blob/main/internal/codegen/golang/postgresql_type.go#L12) or [mysql_type.go](https://github.com/sqlc-dev/sqlc/blob/main/internal/codegen/golang/mysql_type.go#L12). Note that for Postgres you must use the pg_catalog prefixed names where available.
- `go_type`:
  - A fully qualified name to a Go type to use in the generated code.
- `go_struct_tag`:
  - A reflect-style struct tag to use in the generated code, e.g. `a:"b" x:"y,z"`.
    If you want general json/db tags for all fields, use `emit_db_tags` and/or `emit_json_tags` instead.
- `nullable`:
  - If true, use this type when a column is nullable. Defaults to `false`.

Note that a single `db_type` override configuration applies to either nullable or non-nullable
columns, but not both. If you want a single `go_type` to override in both cases, you'll
need to specify two overrides.

For more complicated import paths, the `go_type` can also be an object.

```yaml
version: "1"
packages: [...]
overrides:
  - db_type: "uuid"
    go_type:
      import: "a/b/v2"
      package: "b"
      type: "MyType"
```

#### Per-Column Type Overrides

Sometimes you would like to override the Go type used in model or query generation for
a specific field of a table and not on a type basis as described in the previous section.

This may be configured by specifying the `column` property in the override definition. `column`
should be of the form `table.column` but you can be even more specific by specifying `schema.table.column`
or `catalog.schema.table.column`.

```yaml
version: "1"
packages: [...]
overrides:
  - column: "authors.id"
    go_type: "github.com/segmentio/ksuid.KSUID"
```

#### Package Level Overrides

Overrides can be configured globally, as demonstrated in the previous sections, or they can be configured per-package which
scopes the override behavior to just a single package:

```yaml
version: "1"
packages:
  - overrides: [...]
```

### rename

Struct field names are generated from column names using a simple algorithm:
split the column name on underscores and capitalize the first letter of each
part.

```
account     -> Account
spotify_url -> SpotifyUrl
app_id      -> AppID
```

If you're not happy with a field's generated name, use the `rename` mapping
to pick a new name. The keys are column names and the values are the struct
field name to use.

```yaml
version: "1"
packages: [...]
rename:
  spotify_url: "SpotifyURL"
```
