# Embedded SQL answer notes

For 8.6a–c/e/f, see the lesson's answer notes and `test_embedded.py`.
All six tests should pass. `record_sale` handles unknown products/insufficient
stock as `ValueError` and duplicate invoice/unknown customer as
`sqlite3.IntegrityError`. Both kinds trigger rollback. A driver error is not
the same as a query returning no row or a found SQL NULL.

For 8.6d, extend the existing dictionary:

```python
SORT_COLUMNS = {
    "code": "P_CODE",
    "price": "P_PRICE",
    "description": "P_DESCRIPT",
    "quantity": "P_QOH",
}
```

Test `list_products(connection, 'quantity', 0)` for code order
`P4, P2, 0012, P6, P5, P3, P1`. Keep the malicious-sort rejection test.
`ORDER BY ?` orders by a bound constant, not an identifier selected by name.
The dynamic query still binds its price value rather than interpolating it.

Runtime mismatch: database operations and host code have separate execution
contexts (SQLite is embedded in-process, while a remote RDBMS adds a network
boundary). Processing mismatch: a SQL result set needs a collection/iterator
mapping. Type mismatch: nullable values, exact decimals, and date/time types
require explicit host representations. For real currency use integer cents
or an exact-decimal strategy, not the demonstration's float annotations.
