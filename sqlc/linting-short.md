# TLDR: Using SQLC Linting and Rules in Golang

- Define lint rules in SQLC configuration file with a name, message, and a Common Expression Language (CEL) expression.
```yaml
rules:
  - name: no-delete
    message: "don't use delete statements"
    rule: |
      query.sql.contains("DELETE")
```
- Use `EXPLAIN ...` output in rules with `postgresql.explain` and `mysql.explain` variables.
```yaml
rules:
- name: postgresql-query-too-costly
  message: "Query cost estimate is too high"
  rule: "postgresql.explain.plan.total_cost > 1.0"
```
- Use built-in rule `sqlc/db-prepare` to prepare queries against the connected database.
```yaml
sql:
  - rules:
      - sqlc/db-prepare
```
- Run lint rules by adding the rule name to the rules list for a SQL package.
```yaml
sql:
  - rules:
      - no-delete
```
- Opt-out of lint rules for a specific query with `@sqlc-vet-disable` query annotation.
```sql
/* name: GetAuthor :one */
/* @sqlc-vet-disable */
SELECT * FROM authors
WHERE id = ? LIMIT 1;
```
