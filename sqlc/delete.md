# Deleting Rows Using SQLC in Go

## Overview
This documentation provides a concise guide on how to use SQLC to delete rows in a SQLite database in Go.

## SQL Input
- Write your SQL query for deleting rows. 
- Use the `DELETE FROM` statement followed by the table name.
- Specify the condition for the rows to be deleted using the `WHERE` clause.
- Use `?` for bound arguments in SQLite.

Example:
```sql
DELETE FROM authors WHERE id = ?
```

## SQLC Generated Function

Example:
```go
func (q *Queries) DeleteAuthor(ctx context.Context, id int) error {
	_, err := q.db.ExecContext(ctx, deleteAuthor, id)
	return err
}
```
