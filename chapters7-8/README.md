# Chapters 7–8: guided SQL exercises

## Start here

Use **DB Browser for SQLite** (`sqlitebrowser`) for these SQLite lessons,
with **SQLite 3.39 or later** (RIGHT/FULL JOIN support).
Install DB Browser for SQLite using the [student setup guide](../STUDENT_SETUP.md),
then open it from your application menu. Windows, macOS, and Linux are supported;
Downloading and extracting the github repository
ZIP is sufficient; Git is optional.

1. Click **New Database** and save it as `chapters7-8/lab.sqlite3`. Cancel
   the initial table-creation dialog; the setup script creates the tables.
2. In **Execute SQL**, open `chapters7-8/setup.sql` using **Open SQL file**
   and execute the entire script. Click **Write Changes** to save the setup.
3. Open `chapters7-8/chapter7/01_select.sql` in **Execute SQL**. Select one
   complete statement (including its semicolon) and execute the selection.
   Inspect the result grid before running the next example. **Browse Data**
   lets you inspect individual tables; **Database Structure** shows their definitions.
4. On every database open/reopen, with no pending transaction, execute:

   ```sql
   PRAGMA foreign_keys = ON;
   PRAGMA foreign_keys;
   SELECT sqlite_version();
   ```

   Run these individually: the foreign-key query must return `1`, and the
   version must be at least `3.39.0`. Enabling foreign keys inside an active
   transaction has no effect; finish or revert pending changes first.

Use `setup.sql`, **not `load.sql`**, in DB Browser. `.read`, `.headers`,
`.mode`, and `.nullvalue` are SQLite CLI commands, not SQL; the result grid
replaces CLI output formatting.

`setup.sql` destroys and rebuilds only the lab's named objects. Finish or
revert pending changes, then rerun the whole setup and click **Write Changes**
before each Chapter 8 lesson or answer-key file. Chapter 7 lessons are read-only.

## How to practice

1. Read the goal and each task's **Business question**. State what decision
   or operational need the result supports, then predict the worked example's
   result before running it. Schema and procedural tasks express the business
   rule or operational requirement to implement rather than a reporting query.
2. In **Execute SQL**, select and run each worked statement; explain what
   one row in the result grid represents. Run related transaction statements
   in order on the same connection.
3. Write the numbered tasks in your own `.sql` file. The task comments are
   deliberately not executable blanks: each lesson can run unchanged.
4. Check the stated row counts, boundary cases, and NULL behavior.
5. Compare with `solutions/chapter7.sql` or `solutions/chapter8.sql` only
    after attempting the task. PostgreSQL answers are in `solutions/postgres.sql`.

For transaction lessons, start with no pending GUI edits. Use the lesson's
SQL `BEGIN`, `COMMIT`, and `ROLLBACK` statements to control the experiment;
do not click **Write Changes** in the middle of a rollback demonstration.
If an expected error interrupts a transaction, run `ROLLBACK;` before resetting
or continuing. Execute commented-out failure examples individually, not as
part of a whole-file batch.

## Lesson order

| Lab | Guided practice | Slides |
| --- | --- | --- |
| 7.1 | Projection, aliases, expressions, arithmetic/date arithmetic, DISTINCT | 7:1–15 |
| 7.2 | All join forms, aliases, self-joins, ON versus WHERE | 7:16–21 |
| 7.3 | Ordering, comparisons, logic, special predicates, old-style joins | 7:22–27 |
| 7.4 | COUNT/MIN/MAX/SUM/AVG, GROUP BY, HAVING | 7:28–30 |
| 7.5 | Scalar/list/table/correlated subqueries, EXISTS | 7:31–33 |
| 7.6 | Date, numeric, string, conversion functions | 7:34 |
| 7.7 | UNION, UNION ALL, INTERSECT, EXCEPT/MINUS | 7:35–36 |
| 7.8 | Build and validate an end-to-end sales report | 7:37–40 |
| 8.1 | Types, CREATE TABLE, every constraint, CTAS, indexes | 8:3–7 |
| 8.2 | ALTER ADD/DROP, type/constraint migrations, DROP TABLE | 8:8–10 |
| 8.3 | INSERT variants, INSERT SELECT, UPDATE, DELETE, COMMIT/ROLLBACK | 8:11–12 |
| 8.4 | Views, snapshots, writable views, batch updates | 8:13–14 |
| 8.5 | Trigger timing/events/actions, OLD/NEW, DROP TRIGGER | 8:20–21 |
| Postgres A | Schemas, permissions, types/ALTER, ALL/ANY, sequences | 7:3–7,32,36; 8:3–10,15–16 |
| Postgres B | PL/pgSQL blocks, procedures, cursors, functions, triggers | 8:17–26 |

Chapters 7 and 8 are more than one class session: split the sequence at
aggregation, schema changes, and procedural SQL as needed.

## The practice model

```
customer 1 ──< invoice 1 ──< line >── 1 product >── 0..1 vendor
employee >── 0..1 employee (direct manager)
```

- `vendor`: one supplier; vendor 40 has no products.
- `product`: one current inventory item; P4 has no vendor. Prices/discounts
  describe the present, not old sales. Codes are text, including `0012`.
- `customer`: one customer; customer 4 has no invoices.
- `invoice`: one sale header; invoice 1005 is intentionally empty.
- `line`: one invoice line, keyed by `(INV_NUMBER, LINE_NUMBER)`;
  `LINE_PRICE` preserves the unit price at sale.
- `employee`: one employee, with an optional direct-manager reference.

Baseline counts: 4 vendors, 7 products, 4 customers, 5 invoices, 7 lines,
4 employees. The data include tied prices, exact range endpoints,
unmatched rows, NULLs, an empty invoice, multiple lines per invoice, and
sales on September 30, October 1/31, and November 1, 2026.

## SQL dialects and important corrections

The runnable core follows the existing repository's SQLite approach.
[`postgres/`](postgres/README.md) supplies **PostgreSQL/PL/pgSQL practice**,
not SQLite-compatible code. It replaces the Oracle companions with the same
guided concepts and data. Its README includes graphical and terminal setup,
checks, and a slide-syntax translation table. Only use a disposable database.
The slides' Oracle-specific spellings are compared, not required to run.
DB Browser for SQLite cannot run these companions; use their documented
PostgreSQL tools instead.

- SQLite has no `CREATE SCHEMA AUTHORIZATION`, `GRANT`/`REVOKE`, independent
  sequences, `ALL`/`ANY`, or stored procedures/functions. Do the PostgreSQL
  companions rather than silently skipping these topics.
- SQLite supports ADD/DROP COLUMN but not general ALTER ADD/DROP CONSTRAINT
  or ALTER COLUMN TYPE. Lab 8.2 demonstrates a safe rebuild; Postgres A
  exercises native ALTER (not the slides' Oracle `MODIFY`).
- SQLite views need INSTEAD OF triggers to be writable. PostgreSQL's automatic
  simple-view updatability and `WITH CHECK OPTION` are exercised separately.
- SQLite uses type affinity: `VARCHAR(n)` length and `NUMERIC(p,s)` precision
  are not enforced as in PostgreSQL. Prices here are teaching values; a real
  SQLite financial application should use integer minor units or an
  explicit exact-decimal strategy. Round displayed totals, not assumptions.
- Precision counts decimal digits, not the sign/decimal point. SMALLINT
  ranges, CHAR padding, DATE storage, and date syntax are DBMS-specific.
- An ordinary index does not prevent duplicates; UNIQUE does. CTAS does
  not copy keys/defaults/constraints. A view is not a frozen snapshot.
- `^`/`**` are not portable exponentiation. Use `POWER` where available;
  the SQLite task uses multiplication and includes a dialect comparison.
- ROLLBACK cancels only pending changes, not past commits. PostgreSQL's lab
  DDL is transactional, unlike Oracle's implicit DDL commits; sequence values
  still are not restored by rollback. `psql` needs explicit BEGIN for these tests.
- A self-join retrieves one manager level, not an entire recursive tree.
  Logical clause/subquery evaluation is not a physical execution guarantee.
- Functions can be called from SQL when the DBMS's restrictions are met.
  Dynamic SQL and extra joins are not automatically slower: measure.

## Check the supplied examples and answers

These optional automated checks run in a terminal, not the DB Browser SQL
editor. Install Python using the [student setup guide](../STUDENT_SETUP.md#optional-python-checks),
or use the optional Nix developer shell. From the repository root:

```sh
cd chapters7-8
python3 check.py
```

On Windows, use `py` instead of `python3`.

Checks use fresh in-memory databases, enable foreign keys, execute all
SQLite lessons and answer keys, and verify important expected results,
constraint failures, view/trigger behavior, and transaction rollback.
They do not execute PostgreSQL SQL or grade arbitrary student submissions.
For companion validation, run `postgres/check.sql` in a separate empty
PostgreSQL database as described in [postgres/README.md](postgres/README.md).
