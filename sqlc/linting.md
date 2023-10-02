# Using SQLC Linting and Rules in Golang

## Overview
This guide provides a concise walkthrough on how to use linting and rules in SQLC, a SQL compiler for Golang. 

## Defining Lint Rules in SQLC

1. Define rules in the SQLC configuration file.
2. Each rule consists of a name, message, and a Common Expression Language (CEL) expression.
3. If the CEL expression evaluates to `true`, SQLC will report an error using the given message.

Example:

```yaml
rules:
  - name: no-delete
    message: "don't use delete statements"
    rule: |
      query.sql.contains("DELETE")
```

## Using `EXPLAIN ...` Output in Rules

1. CEL expressions can access the output from running `EXPLAIN ...` on your query.
2. Use `postgresql.explain` and `mysql.explain` variables to access this output.

Example:

```yaml
rules:
- name: postgresql-query-too-costly
  message: "Query cost estimate is too high"
  rule: "postgresql.explain.plan.total_cost > 1.0"
```

## Built-in Rules

SQLC provides a built-in rule `sqlc/db-prepare` which prepares each of your queries against the connected database and reports any failures.

Example:

```yaml
sql:
  - rules:
      - sqlc/db-prepare
```

## Running Lint Rules

1. Add the name of a defined rule to the rules list for a SQL package.
2. SQLC will evaluate that rule against every query in the package.

Example:

```yaml
sql:
  - rules:
      - no-delete
```

## Opting-out of Lint Rules

Use the `@sqlc-vet-disable` query annotation to tell SQLC not to evaluate lint rules for a specific query.

Example:

```sql
/* name: GetAuthor :one */
/* @sqlc-vet-disable */
SELECT * FROM authors
WHERE id = ? LIMIT 1;
```
