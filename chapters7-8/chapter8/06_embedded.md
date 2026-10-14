# 8.6 — SQL in a host language

**Goal:** bridge SQL rows, host variables, NULLs, diagnostics, and transaction
boundaries. Unlike the SQL-only lessons, this lesson runs Python in a terminal,
not in DB Browser's **Execute SQL** tab. Install Python using the
[student setup guide](../../STUDENT_SETUP.md#optional-python-lab); Nix is
optional. From the repository root:

```sh
cd chapters7-8
python3 -m unittest test_embedded.py
```

On Windows, use `py -m unittest test_embedded.py` instead.

Read `embedded.py`. The examples use Python's built-in SQLite driver and fresh
in-memory databases; they do not require a server or modify the `lab.sqlite3`
file open in DB Browser. Inspect the equivalent SQL in DB Browser if helpful,
but do not paste Python or the C example below into its SQL editor.

## Worked example

```python
from embedded import connect_lab, find_vendor, list_products

with connect_lab() as connection:
    print(find_vendor(connection, 'P4'))  # (None,): found row, NULL vendor
    print(find_vendor(connection, 'P9'))  # None: no row
    print(list_products(connection, 'price', 30))
```

A fixed query with `?` parameters is **static SQL**: the statement's structure
does not change when a product code changes. A user-selected sort column is
**dynamic SQL**: the statement's structure changes. Values are always bound;
identifiers come only from an allowlist. A placeholder cannot substitute for
an SQL column name or keyword.

Traditional precompiled C embedded SQL marks statements and host variables:

```c
EXEC SQL BEGIN DECLARE SECTION;
char code[11];
double price;           /* Teaching example; prefer exact-decimal mapping. */
short price_indicator;
EXEC SQL END DECLARE SECTION;
EXEC SQL SELECT P_PRICE INTO :price :price_indicator
    FROM PRODUCT WHERE P_CODE = :code;
```

This is framework/precompiler syntax, not runnable Python or ordinary SQL.
The indicator communicates SQL NULL separately from the host value; a
communication area (often SQLCA) reports status. Modern drivers expose
result objects, exceptions, and row counts instead.

## Tasks

**8.6a — Host variables and runtime mismatch.** Identify the host language,
SQL statement marker, bound input, output, and NULL indicator in the C
example. Explain client/server memory and execution boundaries, set-based
SQL versus row iteration, and date/decimal/NULL type mismatches.

**8.6b — Success versus no data versus error.** Call `find_vendor` for P2,
P4, P9, and the literal `P2' OR 1=1 --`. Expected: `(10,)`, `(None,)`, `None`,
`None`. Why are a found NULL and an absent row different? Attempt to insert
a duplicate product and inspect `sqlite_errorname` on `IntegrityError`.
Do not log secrets or full user data in diagnostics.

**8.6c — Status codes.** Match success, no data, and constraint failure to
SQLSTATE `00000`, `02000`, and class `23`. Explain class/subclass in a
five-character `XXYYY` code. Legacy SQLCODE often uses 0, +100, and negative
numbers, but `-999` is not one universal error value and zero affected rows
on UPDATE do not universally mean +100. SQLite's driver does not provide
standard SQLSTATE; don't invent a mapping from its error integers.

**8.6d — Safe dynamic SQL.** Add a supported sort key `quantity` mapped to
`P_QOH`. Test accepted keys and rejection of `price; DROP TABLE product`.
Why does `ORDER BY ?` not choose a column? Compare static and dynamic query
shapes without claiming dynamic SQL is always slower.

**8.6e — Atomic writes.** Call `record_sale` with invoice 1006, customer 1,
and P2/1 then P3/2. Verify two lines and quantities 1/6. Reset and use
P2/1 then MISSING/1; verify rollback leaves no invoice 1006 and P2 quantity
2. Try too much stock, zero units, an unknown customer, and duplicate
invoice number. Explain why the caller must not commit half a sale.

**8.6f — Result and type handling.** Iterate products from `list_products`;
distinguish one returned row from the whole set. Explain why NUMERIC affinity
in SQLite is not exact DECIMAL enforcement, how you'd use integer cents
for real financial values, and why date strings need explicit parsing.

## Answer notes

- C's `EXEC SQL` marks SQL; `:code` is input, `:price` is output, and
  `:price_indicator` represents missingness. Python uses `?` plus a tuple.
- Binding the injection-looking code searches for that exact string; it
  does not change the WHERE clause. Dynamic identifiers need validation.
- `record_sale` owns its transaction and rejects an already-active one;
  it commits only complete sales and rolls back on every exception.
- Use the supplied tests as starting checks for the additional cases.
  `solutions/embedded_answers.md` includes the quantity-sort extension.
