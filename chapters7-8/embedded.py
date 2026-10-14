"""Chapter 8 host-language SQL examples; all writes use a disposable lab DB."""

import sqlite3
from collections.abc import Sequence
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SORT_COLUMNS = {"code": "P_CODE", "price": "P_PRICE", "description": "P_DESCRIPT"}


def connect_lab() -> sqlite3.Connection:
    """Create a fresh lab; callers close the connection when finished."""
    connection = sqlite3.connect(":memory:", isolation_level=None)
    connection.executescript((ROOT / "setup.sql").read_text())
    return connection


def find_vendor(connection: sqlite3.Connection, code: str) -> tuple[int | None] | None:
    """None = absent row; (None,) = found product with a NULL vendor."""
    return connection.execute(
        "SELECT V_CODE FROM product WHERE P_CODE = ?", (code,)
    ).fetchone()


def list_products(
    connection: sqlite3.Connection, sort_key: str, minimum_price: float
) -> list[tuple[str, str, float]]:
    """Allowlist SQL identifiers; bind values even in a dynamic statement."""
    try:
        sort_column = SORT_COLUMNS[sort_key]
    except KeyError as error:
        raise ValueError("Unsupported sort key") from error
    return connection.execute(
        f"SELECT P_CODE, P_DESCRIPT, P_PRICE FROM product "
        f"WHERE P_PRICE >= ? ORDER BY {sort_column}, P_CODE",
        (minimum_price,),
    ).fetchall()


def record_sale(
    connection: sqlite3.Connection,
    invoice_number: int,
    customer_code: int,
    items: Sequence[tuple[str, int]],
) -> None:
    """Own one transaction; either commit the entire sale or roll it all back."""
    if connection.in_transaction:
        raise ValueError("Caller transaction already active")
    if not items:
        raise ValueError("A sale needs at least one item")
    connection.execute("BEGIN IMMEDIATE")
    try:
        connection.execute(
            "INSERT INTO invoice (INV_NUMBER, CUS_CODE, INV_DATE) VALUES (?, ?, ?)",
            (invoice_number, customer_code, "2026-10-14"),
        )
        for line_number, (code, units) in enumerate(items, start=1):
            if isinstance(units, bool) or not isinstance(units, int) or units <= 0:
                raise ValueError("Units must be a positive integer")
            row = connection.execute(
                "SELECT P_QOH, P_PRICE FROM product WHERE P_CODE = ?", (code,)
            ).fetchone()
            if row is None:
                raise ValueError("Unknown product")
            quantity, price = row
            if quantity < units:
                raise ValueError("Insufficient stock")
            connection.execute(
                "INSERT INTO line VALUES (?, ?, ?, ?, ?)",
                (invoice_number, line_number, code, units, price),
            )
            connection.execute(
                "UPDATE product SET P_QOH = P_QOH - ? WHERE P_CODE = ?", (units, code)
            )
        connection.commit()
    except BaseException:
        # Include interruption: never leave a partially written transaction.
        connection.rollback()
        raise
