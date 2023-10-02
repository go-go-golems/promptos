# TLDR: Deleting Rows Using SQLC in Go

- Write SQL query for deletion: `DELETE FROM authors WHERE id = ?`
- SQLC generates a function for deletion: 
```go
func (q *Queries) DeleteAuthor(ctx context.Context, id int) error {
	_, err := q.db.ExecContext(ctx, deleteAuthor, id)
	return err
}
```
- Use the generated function to delete rows, passing the context and id as arguments.
