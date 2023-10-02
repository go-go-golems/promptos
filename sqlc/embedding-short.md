# TLDR: SQLC Embedding for Struct Reusability in Go

- Use SQLC embedding to reuse model structs in Go, reducing manual serialization.
- Embed model structs from multiple tables in your SQL queries using `sqlc.embed(TABLE_NAME)`.
  
  ```sql
  -- name: ScoreAndTests :many
  SELECT sqlc.embed(students), sqlc.embed(test_scores)
  FROM students
  JOIN test_scores ON test_scores.student_id = students.id
  WHERE students.id = ?;
  ```

- SQLC generates a struct incorporating the model structs for each embedded table.

  ```go
  type ScoreAndTestsRow struct {
    Student   Student
    TestScore TestScore
  }
  ```

- Use the generated struct like any other Go struct and access the fields of the embedded structs directly.

  ```go
  row := ScoreAndTestsRow{}
  fmt.Println(row.Student.Name)
  fmt.Println(row.TestScore.Score)
  ```

- SQLC embedding enhances code readability and maintainability by minimizing manual serialization work.

