# Oracle-only companion labs

SQLite cannot teach Oracle sequences, PL/SQL, explicit cursors, or server
procedures by executing the same syntax. These companions cover those
slide topics directly. Use a **disposable Oracle schema**, never production.
If you don't have Oracle, write/trace the tasks and compare the answer key.

1. Inspect `setup.sql`; it creates `LAB_VENDOR`, `LAB_PRODUCT`,
   `LAB_CUSTOMER`, `LAB_PRICE_AUDIT` without dropping existing objects.
   If those names already exist, use a different disposable schema.
2. In SQL*Plus or SQLcl run `@setup.sql`, then `@01_dialects.sql` and
   `@02_plsql.sql`. In an IDE run SQL individually and PL/SQL blocks as
   complete units. `/` is a client delimiter, not part of PL/SQL itself.
3. Write the numbered tasks yourself; compare `../solutions/oracle.sql`.
   The answers run after setup and the worked companions, once per schema.
4. Schema authorization and GRANT/REVOKE are **write-and-explain tasks**:
   do not grant real permissions or create real accounts for this lab.

Oracle DDL implicitly commits surrounding work. Run DDL before transaction
experiments. Only the DML inside explicit pending transactions is rolled
back. Sequence values can be consumed even after rollback; NOCACHE does
not make IDs gapless. The local SQLite check does not validate Oracle syntax.
