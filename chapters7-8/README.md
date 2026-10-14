# Chapters 7–8: guided SQL exercises

Original exercises based on `Coronel_DatabaseSystems_13e_ch07.pptx` (40 slides)
and `Coronel_DatabaseSystems_13e_ch08.pptx` (32 slides), including their speaker
notes, in `../CIS-300-UMary/presentations/`. See [COVERAGE.md](COVERAGE.md)
for a slide-by-slide topic map. These are practice datasets, not copies of
the textbook's full sample database.

## Start here

Use **SQLite 3.39 or later** (RIGHT/FULL JOIN support). Work only in this
directory and in your own disposable lab database; do not run these files
against a work or production database. The existing `week3/` is untouched.

```sh
cd chapters7-8
sqlite3 lab.sqlite3 ".read load.sql"
sqlite3 lab.sqlite3 ".read chapter7/01_select.sql"
```

If SQLite is not installed, use `nix shell nixpkgs#sqlite -c sqlite3 ...`.
In a graphical SQL editor, execute `setup.sql` first, then individual SQL
statements from a lesson. `.read`, `.headers`, `.mode`, and `.nullvalue` are
SQLite CLI commands, not SQL; do not paste `load.sql` into another DBMS.
Enable `PRAGMA foreign_keys = ON` on **every SQLite connection**.

`load.sql` destroys and rebuilds only the lab's named objects. Rerun it before
each Chapter 8 lesson or answer-key file. Chapter 7 lessons are read-only.
Do not commit generated database files.

## How to practice

1. Read the goal and predict the worked example's result before running it.
2. Run the example; explain what one output row represents.
3. Write the numbered tasks in your own `.sql` file. The task comments are
   deliberately not executable blanks: each lesson can run unchanged.
4. Check the stated row counts, boundary cases, and NULL behavior.
5. Compare with `solutions/chapter7.sql` or `solutions/chapter8.sql` only
   after attempting the task. Oracle answers are in a separate file.

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
| Oracle A | Schemas, permissions, types/ALTER, ALL/ANY, sequences | 7:3–7,32,36; 8:3–10,15–16 |
| Oracle B | PL/SQL blocks, procedures, cursors, functions, triggers | 8:17–26 |
| 8.6 | Host variables, diagnostics, static/dynamic SQL | 8:27–30 |

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
`oracle/` is **Oracle SQL/PLSQL practice**, not SQLite-compatible code.
The Oracle tasks include setup instructions and worked syntax; execute
only in a disposable Oracle schema you are authorized to use, or trace
the results on paper if Oracle is unavailable. No Oracle execution is
claimed by the local checks.

- SQLite has no `CREATE SCHEMA AUTHORIZATION`, `GRANT`/`REVOKE`, independent
  sequences, `ALL`/`ANY`, or stored PL/SQL procedures/functions. Do the
  Oracle exercises rather than silently skipping these topics.
- SQLite supports ADD/DROP COLUMN but not Oracle MODIFY or general ALTER
  ADD/DROP CONSTRAINT. Lab 8.2 demonstrates a safe rebuild instead.
- SQLite views need INSTEAD OF triggers to be writable. Oracle's automatic
  view updatability and `WITH CHECK OPTION` are exercised separately.
- SQLite uses type affinity: `VARCHAR(n)` length and `NUMERIC(p,s)` precision
  are not enforced as in Oracle. Prices here are teaching values; a real
  SQLite financial application should use integer minor units or an
  explicit exact-decimal strategy. Round displayed totals, not assumptions.
- Precision counts decimal digits, not the sign/decimal point. SMALLINT
  ranges, CHAR padding, DATE storage, and date syntax are DBMS-specific.
- An ordinary index does not prevent duplicates; UNIQUE does. CTAS does
  not copy keys/defaults/constraints. A view is not a frozen snapshot.
- `^`/`**` are not portable exponentiation. Use `POWER` where available;
  the SQLite task uses multiplication and includes a dialect comparison.
- ROLLBACK cancels only pending changes, not past commits. Oracle DDL can
  implicitly commit, so never assume a DROP can be rolled back.
- A self-join retrieves one manager level, not an entire recursive tree.
  Logical clause/subquery evaluation is not a physical execution guarantee.
- Functions can be called from SQL when the DBMS's restrictions are met.
  Dynamic SQL and extra joins are not automatically slower: measure.

## Check the supplied examples and answers

```sh
python3 check.py
python3 -m unittest test_embedded.py
```

Checks use fresh in-memory databases, enable foreign keys, execute all
SQLite lessons and answer keys, and verify important expected results,
constraint failures, view/trigger behavior, and transaction rollback.
They do not execute Oracle SQL or grade arbitrary student submissions.
