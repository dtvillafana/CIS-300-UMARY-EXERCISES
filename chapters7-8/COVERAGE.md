# Slide-to-exercise coverage

Source: Coronel, *Database Systems*, 13th edition, Chapter 7/8 PowerPoints
in `../CIS-300-UMary/presentations/`. Slide numbers are PowerPoint slide
positions, including title and summary slides. Speaker-note examples and
dialect corrections are included. Function tables 7.10–7.13 are referenced
but not enumerated in the slides: the labs cover the four shown function
families, not an unseen textbook function catalog.

## Chapter 7 — Introduction to SQL (40 slides)

| Slides | Topics/syntax in the slides and notes | Exercise location |
| --- | --- | --- |
| 1–2 | Declarative SQL; retrieval, joins, restrictions, aggregation, subqueries, functions | 7.1–7.8; README model |
| 3 | DDL/DML/TCL/DCL; nonprocedural language; dialects | 7.1 reflection; 8.1a; Oracle OA1–2 |
| 4 | CREATE SCHEMA AUTHORIZATION, CREATE TABLE, NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, DEFAULT, CHECK, CREATE/DROP INDEX/VIEW, ALTER TABLE, CTAS, DROP TABLE | 8.1–8.2, 8.4; Oracle OA1/OA6 |
| 5 | COMMIT [WORK], ROLLBACK, GRANT, REVOKE | 8.3; Oracle OA2; README dialect notes |
| 6–7 | Character/numeric/date data; query/action; CUSTOMER→INVOICE→LINE→PRODUCT→VENDOR model, PK/FK/composite key/optionality | setup.sql; README model; 8.1f; 7.8 |
| 8 | SELECT/FROM/WHERE/GROUP BY/HAVING/ORDER BY; clause formatting and logical order | 7.4f; 7.8a–c |
| 9–12 | SELECT *, explicit column lists, projection, column/table aliases, quoted identifiers, result sets | 7.1a/b; 7.2; worked 7.1 |
| 13 | +, -, *, /, ^ or ** warning; precedence, computed columns, discounts, integer division | 7.1b/d; Oracle OA4 |
| 14–15 | Date arithmetic, DISTINCT, NULL/assigned vendor codes, tuple deduplication | 7.1c/e; 7.6d |
| 16–18 | Inner/outer/natural joins; USING, ON, common attribute names, qualified columns, foreign-key linking | 7.2a/b/g; worked 7.2 |
| 19 | Invoice-line/product join, equijoin, historical sale price, line grain | 7.2d; 7.8f |
| 20–21 | LEFT/RIGHT/FULL OUTER, CROSS/Cartesian product, aliases, self/“recursive” join; ON vs WHERE | 7.2a–g; README dialect corrections |
| 22–23 | ORDER BY ASC/DESC, cascading name order, ties | worked 7.3; 7.8c |
| 24–26 | WHERE, =/< /<=/>/>=/<>/!=, character/date restrictions, collation, NULL UNKNOWN, date endpoints | 7.3a–c; worked 7.3 |
| 27 | AND/OR/NOT, precedence, old-style comma joins, BETWEEN, IN, LIKE %/_, IS NULL, NOT IN NULL trap | 7.3d–g; 7.5f |
| 28–29 | COUNT(*), COUNT(column), COUNT(DISTINCT), MIN/MAX/SUM/AVG, GROUP BY, missing values, empty input, join duplication | 7.4a–e |
| 30 | HAVING, WHERE vs HAVING, logical sequence | worked 7.4; 7.4f; 7.8b/c |
| 31 | Inner/outer/nested queries, parentheses, scalar/list/table results | 7.5a–g |
| 32 | WHERE/IN/HAVING subqueries, ALL/ANY/SOME, empty/NULL semantics | 7.5a/b; Oracle OA3 |
| 33 | FROM/attribute-list/correlated subqueries, EXISTS/NOT EXISTS | 7.5c–g |
| 34 | Date/time, numeric, string, conversion functions; EXTRACT, ROUND, ABS, UPPER/TRIM, CAST | 7.6a–d; Oracle OA4 |
| 35 | UNION/UNION ALL/INTERSECT, compatibility, duplicates | 7.7a/b/e |
| 36 | EXCEPT/MINUS, directional difference, NOT EXISTS alternative | 7.7c/d; Oracle OA5 |
| 37–38 | Know data/problem/grain, build FROM→WHERE→GROUP BY→HAVING→SELECT→ORDER BY, sales report | 7.8a–f |
| 39–40 | Review categories, types, joins, predicates, aggregates, subqueries, functions, set operators; correct DDL mislabel and serial-execution claim | 7.1–7.8; README corrections |

## Chapter 8 — Advanced SQL (32 slides)

| Slides | Topics/syntax in the slides and notes | Exercise location |
| --- | --- | --- |
| 1–2 | Schema definition, manipulation, views, PL/SQL, embedded SQL objectives | 8.1–8.6; Oracle companions |
| 3–4 | Database/schema creation, types, normalized sales model, composite LINE key, historical prices | setup.sql; README model; 8.1a/f; Oracle OA1 |
| 5 | NUMBER/NUMERIC/DECIMAL(p,s), INTEGER/INT/SMALLINT, CHAR, VARCHAR/VARCHAR2, DATE; dialect limits | 8.1f; Oracle setup; README corrections |
| 6 | CREATE TABLE column/table-level/named constraints: PK/FK/NOT NULL/UNIQUE/DEFAULT/CHECK | 8.1b/c; setup.sql; constraint checks |
| 7 | CREATE TABLE AS SELECT, copied rows/constraints, CREATE [UNIQUE] INDEX, DROP INDEX | 8.1d/e |
| 8 | ALTER ADD/MODIFY/ALTER type/characteristics, backfill, NOT NULL warning | 8.2a/b/c; Oracle OA6 |
| 9 | ALTER ADD PK/FK/CHECK, existing-data audits | worked 8.2; 8.2c; Oracle OA6 |
| 10 | ALTER DROP COLUMN, DROP TABLE, destructive dependencies/recovery | 8.2d; Oracle OA6; README safety |
| 11 | INSERT VALUES/all columns, explicit NULL, omitted optional/default attributes, INSERT SELECT, COMMIT [WORK] | 8.3a/b/e |
| 12 | UPDATE SET multiple columns/expressions WHERE, DELETE WHERE, ROLLBACK, missing WHERE, transaction failure | 8.3c–e; embedded.py/tests |
| 13 | CREATE VIEW AS SELECT, base tables, metadata vs snapshots/security | worked 8.4; 8.4a/d |
| 14 | Updatable views, GROUP BY/aggregate/set/join restrictions, batch updates, WITH CHECK OPTION | 8.4b/c; Oracle OA7 |
| 15–16 | Independent sequences, START WITH/INCREMENT BY/NOCACHE, NEXTVAL/CURRVAL, USER_SEQUENCES, gaps/constraints | Oracle worked A and OA8 |
| 17–18 | Procedural SQL/PSM, shared routines, anonymous PL/SQL BEGIN/END, triggers/procedures/functions | Oracle worked B; OB1/2/5/6 |
| 19 | PL/SQL CHAR/VARCHAR2/NUMBER/DATE/%TYPE declarations | Oracle anonymous block; OB1 |
| 20–21 | Trigger timing/event/row vs statement/action, OLD/NEW, INSERTING/UPDATING/DELETING, DROP TRIGGER | 8.5a–e; Oracle OB6 |
| 22 | Named stored procedures, business operations, network/performance/code sharing, caller transaction ownership | Oracle procedure/OB2; embedded atomic sale |
| 23–25 | Implicit/explicit cursors, CURSOR IS, OPEN/FETCH INTO/CLOSE, %ROWCOUNT/%FOUND/%NOTFOUND/%ISOPEN | Oracle worked cursor; OB3/4; answer state table |
| 26 | Stored functions, RETURN, SQL invocation restrictions | Oracle worked function; OB5 |
| 27–28 | Embedded SQL/host language, runtime/processing/type mismatches, host variables, statement markers, communication area, NULL indicators | 8.6a/b/f; embedded.py |
| 29 | SQLCODE 0/+100/negative, SQLSTATE five-character class/subclass, success/no data/error, driver diagnostics | 8.6b/c; test_embedded.py |
| 30 | Static vs dynamic SQL, parameterization, runtime identifiers, allowlist, portability/performance | 8.6d; embedded.py/tests |
| 31–32 | Types, DDL/DML, views/security, sequences, procedures/functions/cursors, host integration summary | 8.1–8.6; Oracle companions |

## Deliverables and validation

- Each numbered SQL task has an answer in `solutions/chapter7.sql`,
  `solutions/chapter8.sql`, or `solutions/oracle.sql`. Conceptual answers
  appear in nearby comments and README dialect notes.
- Embedded tasks have worked code, tests, lesson notes, and
  `solutions/embedded_answers.md`.
- Expected failure statements are commented out; execute them individually.
  `check.py` tests SQLite integrity failures without breaking lesson batches.
- Oracle is clearly separate and is not claimed to have been executed locally.
