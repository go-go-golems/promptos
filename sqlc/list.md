# Inserting Rows

To insert rows into a SQLite database using sqlc, you can use the following approach:

## Step 1: Define the SQL Query

Define the SQL query for inserting rows in your SQLite database. Annotate the query with a specific comment to generate a database access method.

```sql
CREATE TABLE authors (
  id         INTEGER PRIMARY KEY,
  bio        TEXT   NOT NULL,
  birth_year INTEGER NOT NULL
);

-- name: CreateAuthor :exec
INSERT INTO authors (bio, birth_year) VALUES (?, ?);
```

## Step 2: Use the Generated Method

The sqlc tool generates a method for the annotated query. This method can be used to insert rows into the database.

```go
package db

import (
	"context"
	"database/sql"
)

type Author struct {
	ID        int
	Bio       string
	BirthYear int
}

type DBTX interface {
	ExecContext(context.Context, string, ...interface{}) (sql.Result, error)
}

func New(db DBTX) *Queries {
	return &Queries{db: db}
}

type Queries struct {
	db DBTX
}

const createAuthor = `-- name: CreateAuthor :exec
INSERT INTO authors (bio, birth_year) VALUES (?, ?)
`

func (q *Queries) CreateAuthor(ctx context.Context, bio string, birthYear int) error {
	_, err := q.db.ExecContext(ctx, createAuthor, bio, birthYear)
	return err
}
```

## Usage

To use the `CreateAuthor` method, pass the required parameters (bio and birth_year) along with a context.

```go
ctx := context.Background()
err := queries.CreateAuthor(ctx, "Bio text", 1980)
if err != nil {
    log.Fatal(err)
}
```

This will insert a new row into the `authors` table with the provided bio and birth_year.

# Passing a Slice as a Parameter to a Query

SQLite differs from PostgreSQL in that placeholders must be generated based on the number of elements in the slice you pass in. The passed in slice must not be nil or empty or an error will be returned.

## Step 1: Define the SQL Query

Define the SQL query for selecting rows in your SQLite database. Use the `sqlc.slice()` function to mark the placeholder insertion location.

```sql
CREATE TABLE authors (
  id         INTEGER PRIMARY KEY,
  bio        TEXT   NOT NULL,
  birth_year INTEGER NOT NULL
);

-- name: ListAuthorsByIDs :many
SELECT * FROM authors
WHERE id IN (sqlc.slice('ids'));
```

## Step 2: Use the Generated Method

The sqlc tool generates a method for the annotated query. This method can be used to select rows from the database.

```go
package db

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
)

type Author struct {
	ID        int
	Bio       string
	BirthYear int
}

type DBTX interface {
	QueryContext(context.Context, string, ...interface{}) (*sql.Rows, error)
}

func New(db DBTX) *Queries {
	return &Queries{db: db}
}

type Queries struct {
	db DBTX
}

const listAuthorsByIDs = `-- name: ListAuthorsByIDs :many
SELECT id, bio, birth_year FROM authors
WHERE id IN (/*SLICE:ids*/?)
`

func (q *Queries) ListAuthorsByIDs(ctx context.Context, ids []int64) ([]Author, error) {
	sql := listAuthorsByIDs
	var queryParams []interface{}
	if len(ids) == 0 {
		return nil, errors.Errorf("slice ids must have at least one element")
	}
	for _, v := range ids {
		queryParams = append(queryParams, v)
	}
	sql = strings.Replace(sql, "/*SLICE:ids*/?", strings.Repeat(",?", len(ids))[1:], 1)
	rows, err := q.db.QueryContext(ctx, sql, queryParams...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Author
	for rows.Next() {
		var i Author
		if err := rows.Scan(&i.ID, &i.Bio, &i.BirthYear); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
```

## Usage

To use the `ListAuthorsByIDs` method, pass a slice of IDs along with a context.

```go
ctx := context.Background()
authors, err := queries.ListAuthorsByIDs(ctx, []int64{1, 2, 3})
if err != nil {
    log.Fatal(err)
}
```

This will return a slice of `Author` structs for the authors with the provided IDs.
