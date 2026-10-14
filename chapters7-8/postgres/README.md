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

### Graphical route (recommended for students)

No Nix or terminal is required. Install/connect using the
[student setup guide](../../STUDENT_SETUP.md#4-connect-pgadmin-to-postgresql),
then open **pgAdmin → cis300_lab → Query Tool**. This also works with an
instructor-hosted PostgreSQL server.

1. Check that the Query Tool is connected to your **empty disposable lab
   database**, not the maintenance database `postgres` or someone else's lab.
2. Set **Auto commit ON** and **Auto rollback OFF** in the Query Tool's
   execution options. Explicit `BEGIN`/`ROLLBACK` statements in the lessons
   control each experiment. Turn off automatic transaction wrapping if your
   editor offers it. Button names/locations vary with pgAdmin version.
3. Use **Open File** to open `postgres/setup.sql` from this exercise folder.
   Run that entire file once; it contains its own `BEGIN` and `COMMIT`.
   In hosted/browser pgAdmin, upload the SQL file through the file dialog
   if offered, or copy its contents into the editor. Local computer paths
   are not necessarily accessible to the hosted server.
4. Open `postgres/01_dialects.sql`. Select and execute **one complete SQL
   statement at a time** using **Execute script**, in order, inspecting the
   result grid each time.
5. Open `postgres/02_plpgsql.sql`. A `DO $$ ... $$;` block or a
   `CREATE ... AS $$ ... $$;` definition is **one complete statement**:
   select the entire block, not just the line the cursor is on. Notices
   appear in the **Messages** panel, not the result grid.
6. For rollback experiments, execute `BEGIN;`, then each statement, then
   `ROLLBACK;` in the **same Query Tool tab/connection**. Inspect the changes
   before rolling back. Do not execute the whole lesson/answer file as one
   GUI selection: that can change transaction boundaries or hide results.
7. Write your answers in a new `.sql` file. Only afterward, compare with
   `solutions/postgres.sql`, running its statements/blocks in order too.

After an intentional error inside a transaction, run `ROLLBACK;` separately
before continuing. To restart from baseline, create a new empty lab database
and run the setup and lessons once each. Setup does not reset an existing lab.

### Command-line alternative (optional)

If you already use PostgreSQL's command-line tools, run from `chapters7-8/`
with a server available. These single-line commands work in common Windows,
macOS, and Linux shells; use the host/user options required by your server.
On Windows, if the tools are not on PATH, use pgAdmin's **PSQL Tool** instead
(see the check instructions below) or stay with the graphical route.

```sh
createdb cis300_lab
psql -X -v ON_ERROR_STOP=1 -d cis300_lab -f postgres/setup.sql -f postgres/01_dialects.sql -f postgres/02_plpgsql.sql
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

## Validate the supplied PostgreSQL examples and answers

These checks are optional unless assigned. Use another **empty** disposable
database (not the one you practiced in). With command-line tools:

```sh
createdb cis300_check
psql -X -v ON_ERROR_STOP=1 -d cis300_check -f postgres/check.sql
```

Alternatively, create/select `cis300_check` in pgAdmin and choose
**Tools → PSQL Tool** if available. This opens a `psql` session, not the
graphical Query Tool. Enter the file's full path with forward slashes and
single quotes, for example on Windows:

```text
\i 'C:/Users/YourName/Documents/CIS-300-UMARY-EXERCISES/chapters7-8/postgres/check.sql'
```

On macOS/Linux, use your extracted folder's full path instead. Do **not**
paste `check.sql` into the graphical Query Tool: `\ir`, `\set`, and `\echo`
are `psql` commands, not SQL. In hosted/browser pgAdmin, PSQL Tool may be
disabled or its filesystem may be on the server; ask the instructor to run
the checks there rather than assuming your computer's file path will work.

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
