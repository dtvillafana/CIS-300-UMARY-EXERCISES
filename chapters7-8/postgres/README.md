# PostgreSQL companion labs

These replace the Oracle companions while retaining the Chapter 7–8 slide
topics. The core labs still use SQLite; **PostgreSQL 11+** runs independent
sequences, ALL/ANY, schemas/permissions, writable views, and server-side
procedures/functions/cursors/triggers. PL/pgSQL teaches the procedural
concepts, not literal Oracle PL/SQL syntax. See the translation table below.

## Run the guided exercises

Use an **empty disposable database** you own, never production. `setup.sql`
creates four `lab_*` tables without dropping anything; existing names cause
an error. It does not copy the entire SQLite model. Baseline: four vendors,
seven products, no customers or audit rows.

From `chapters7-8/`, with an authorized local PostgreSQL server available:

```sh
createdb cis300_lab
psql -X -v ON_ERROR_STOP=1 -d cis300_lab \
  -f postgres/setup.sql -f postgres/01_dialects.sql -f postgres/02_plpgsql.sql
```

Predict each example, run it, then write PA1–PA8 and PB1–PB6 yourself.
Compare `solutions/postgres.sql` only afterward. That answer file runs once
after setup and both worked companions:

```sh
psql -X -v ON_ERROR_STOP=1 -d cis300_lab -f solutions/postgres.sql
```

Sequence predictions assume a fresh database and exactly one run of each
file. `currval` requires an earlier `nextval` **in the same session**; the
worked file keeps them together. PA1/PA2 remain write-and-explain tasks:
do not create accounts or grant real permissions. Expected-error statements
are commented out; run each separately and finish with `ROLLBACK`.

## Optional private local server (no system service needed)

The repository's `nix develop` provides PostgreSQL server/client tools. To
start an isolated cluster with a private Unix socket and **no TCP listener**:

```sh
nix develop                       # from the repository root
cd chapters7-8
export PGHOST="$(mktemp -d /tmp/opencode/cis300-pg.XXXXXX)"
export PGDATA="$PGHOST/data"
initdb --auth-local=trust --auth-host=reject --no-locale --encoding=UTF8
pg_ctl -l "$PGHOST/server.log" -o "-k $PGHOST -c listen_addresses=''" start
createdb cis300_lab
# Now run the psql commands above.
```

The `mktemp` directory is private to your user; local trust is appropriate
only for this isolated lab. Outside this environment, choose an existing
private temporary parent instead of `/tmp/opencode`. When finished, stop
only this cluster with `pg_ctl stop`. Keep the directory to resume later;
for a fresh exercise, create a new disposable database or cluster rather
than rerunning setup over existing objects. Do not commit cluster files.

## Validate the supplied PostgreSQL examples and answers

Use another **empty** disposable database (not the one you practiced in):

```sh
createdb cis300_check
psql -X -v ON_ERROR_STOP=1 -d cis300_check -f postgres/check.sql
```

This executes setup, both companions, the answer key, and SQL assertions
for NULL/empty quantifiers, transactions, sequences, views, constraints,
procedures, functions, cursors, and trigger auditing. It leaves the lab
objects in that database and does not grade arbitrary student submissions.
`../check.py` validates only SQLite and does not connect to PostgreSQL.

## Follow the slides, translate the dialect

| Slide syntax/concept | PostgreSQL equivalent / important difference |
| --- | --- |
| `NUMBER`, `VARCHAR2`, Oracle `DATE` | `NUMERIC`, `VARCHAR`, `DATE` (date only; use `TIMESTAMP` for time of day) |
| `CREATE SCHEMA AUTHORIZATION` | Real namespace in a database; a role can own several schemas; schema `USAGE` and table privileges differ |
| `MODIFY` | `ALTER COLUMN ... TYPE / SET DEFAULT / SET NOT NULL` |
| `MINUS` | `EXCEPT` (same directional set-difference concept) |
| `NOCACHE`, `seq.NEXTVAL/CURRVAL`, `USER_SEQUENCES` | `CACHE 1`, `nextval/currval('seq')`, `pg_sequences`; consumed values are not rolled back |
| Anonymous `DECLARE/BEGIN/END`, `/`, `DBMS_OUTPUT` | `DO $$ DECLARE ... BEGIN ... END; $$;`, `RAISE NOTICE`; no SQL*Plus slash or output setting |
| `SELECT ... INTO` cardinality errors | `INTO STRICT` raises `NO_DATA_FOUND` / `TOO_MANY_ROWS`; non-STRICT behaves differently |
| `CURSOR name IS`, `%FOUND/%NOTFOUND` | `name CURSOR FOR`, block-local `FOUND` / `NOT FOUND` immediately after `FETCH` |
| Cursor `%ROWCOUNT/%ISOPEN` | Explicit successful-fetch counter / `pg_cursors`; no equivalent per-cursor attributes (PB3 compares both state tables) |
| Implicit `SQL%ROWCOUNT` | `GET DIAGNOSTICS n = ROW_COUNT` immediately after DML |
| Stored procedure/function | `CREATE PROCEDURE` + `CALL`; `CREATE FUNCTION ... RETURNS` + `RETURN`, callable from `SELECT` |
| `INSERTING/UPDATING/DELETING`, `:OLD/:NEW` | Trigger function `TG_OP`, `OLD/NEW`; separate `CREATE TRIGGER ... EXECUTE FUNCTION` |
| DDL and transactions | PostgreSQL table/view DDL generally rolls back inside `BEGIN`; Oracle DDL implicitly commits. Sequence allocation still does not roll back |

`psql` autocommits outside explicit `BEGIN`; every rollback experiment here
starts a transaction. A failed statement aborts that transaction until
rollback (or rollback to a savepoint). Functions cannot commit/roll back;
procedures have context-dependent transaction-control rules, but this lab
deliberately leaves all transaction control to the caller. SQL-invoked
functions are normal in PostgreSQL; volatility declarations must be honest.
