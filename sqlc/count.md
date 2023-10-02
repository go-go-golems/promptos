## Overview
This documentation provides concise instructions on how to use the SQLC Golang package to generate count commands.

## SQLC Count Commands

### Count All Rows
- Use `SELECT count(*) FROM table_name` to count all rows.
- SQLC generates a function with the signature `(q *Queries) CountRows(ctx context.Context) (int, error)`.
- The function returns the count as an integer and an error if any.

### Count Rows by Group
- Use `SELECT column, count(*) FROM table_name GROUP BY column ORDER BY column` to count rows by group.
- SQLC generates a function with the signature `(q *Queries) CountRowsByGroup(ctx context.Context) ([]CountRowsByGroupRow, error)`.
- The function returns a slice of a struct and an error if any.
- The struct `CountRowsByGroupRow` contains fields corresponding to the columns selected in the SQL query.

## Usage

### Count All Rows
- Call `CountRows` function with context as argument.
- Example: `count, err := db.CountRows(ctx)`

### Count Rows by Group
- Call `CountRowsByGroup` function with context as argument.
- Example: `rows, err := db.CountRowsByGroup(ctx)`
- Each item in the returned slice represents a row in the result set. Access the count and group column values through the struct fields.
- Example: `for _, row := range rows { fmt.Println(row.Column, row.Count) }`


