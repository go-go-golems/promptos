# SQLC Embedding for Struct Reusability in Go

## Overview
Leverage SQLC embedding to reuse existing model structs in Go, minimizing manual serialization work.

## SQLC Embedding

- Utilize SQLC embedding to include model structs from multiple tables in your queries.
- Apply `sqlc.embed(TABLE_NAME)` in your SQL query to embed a table's model struct.

## Query Example

```sql
-- name: ScoreAndTests :many
SELECT sqlc.embed(students), sqlc.embed(test_scores)
FROM students
JOIN test_scores ON test_scores.student_id = students.id
WHERE students.id = ?;
```

## Generated Structs

- SQLC produces a struct that incorporates the model structs for each embedded table.
- The resulting struct is not a flattened list of columns, but a composition of the model structs.

```go
type ScoreAndTestsRow struct {
	Student   Student
	TestScore TestScore
}
```

## Usage

- Employ the generated struct as you would any other struct in Go.
- Access the fields of the embedded structs directly.

```go
row := ScoreAndTestsRow{}
fmt.Println(row.Student.Name)
fmt.Println(row.TestScore.Score)
```

## Conclusion

- SQLC embedding offers a concise method to reuse model structs in Go.
- It reduces manual serialization work and enhances the readability and maintainability of your code.
