"""Run supplied SQLite examples and verify the labs' teaching invariants."""

import sqlite3
from collections.abc import Iterator
from contextlib import closing
from pathlib import Path

from embedded import ROOT, connect_lab


def statements(path: Path) -> Iterator[str]:
    """Use SQLite's parser boundary check, including BEGIN/END trigger bodies."""
    pending = ""
    for line in path.read_text().splitlines(keepends=True):
        pending += line
        if sqlite3.complete_statement(pending):
            yield pending
            pending = ""
    if any(
        line.strip() and not line.lstrip().startswith("--")
        for line in pending.splitlines()
    ):
        raise ValueError(f"Unterminated SQL in {path}")


def run_file(path: Path) -> int:
    with closing(connect_lab()) as connection:
        count = 0
        for statement in statements(path):
            connection.execute(statement).fetchall()
            count += 1
        assert not connection.in_transaction, f"Open transaction in {path}"
        assert not connection.execute("PRAGMA foreign_key_check").fetchall(), path
    return count


def expect_failure(connection: sqlite3.Connection, sql: str) -> None:
    try:
        connection.execute(sql)
    except sqlite3.IntegrityError:
        return
    raise AssertionError(f"Expected integrity rejection: {sql}")


def check_invariants() -> int:
    cases: list[tuple[str, list[tuple[object, ...]]]] = [
        ("SELECT COUNT(*) FROM product", [(7,)]),
        ("SELECT COUNT(*) FROM vendor", [(4,)]),
        ("SELECT COUNT(*) FROM customer", [(4,)]),
        ("SELECT COUNT(*) FROM invoice", [(5,)]),
        ("SELECT COUNT(*) FROM line", [(7,)]),
        ("SELECT COUNT(*) FROM employee", [(4,)]),
        ("SELECT COUNT(*) FROM product JOIN vendor USING(V_CODE)", [(6,)]),
        ("SELECT COUNT(*) FROM product LEFT JOIN vendor USING(V_CODE)", [(7,)]),
        ("SELECT COUNT(*) FROM product RIGHT JOIN vendor USING(V_CODE)", [(7,)]),
        ("SELECT COUNT(*) FROM product FULL JOIN vendor USING(V_CODE)", [(8,)]),
        ("SELECT COUNT(*) FROM product CROSS JOIN vendor", [(28,)]),
        ("SELECT COUNT(*) FROM product NATURAL JOIN customer", [(28,)]),
        ("SELECT COUNT(*) FROM product NATURAL JOIN vendor", [(6,)]),
        (
            "SELECT DISTINCT V_CODE FROM product ORDER BY V_CODE",
            [(None,), (10,), (20,), (30,)],
        ),
        ("SELECT P_CODE FROM product WHERE V_CODE IS NULL", [("P4",)]),
        ("SELECT P_CODE FROM product WHERE V_CODE = NULL", []),
        ("SELECT P_CODE FROM product WHERE V_CODE NOT IN (10,NULL)", []),
        (
            "SELECT P_CODE FROM product WHERE P_PRICE BETWEEN 20 AND 30 ORDER BY P_CODE",
            [("P3",), ("P5",), ("P6",)],
        ),
        (
            (
                "SELECT P_CODE FROM product WHERE P_INDATE >= '2026-10-01' "
                "AND P_INDATE < '2026-11-01' ORDER BY P_CODE"
            ),
            [("P2",), ("P3",), ("P4",), ("P6",)],
        ),
        (
            (
                "SELECT P_CODE FROM product WHERE P_PRICE > (SELECT AVG(P_PRICE) FROM product) "
                "ORDER BY P_CODE"
            ),
            [("P2",), ("P4",)],
        ),
        (
            (
                "SELECT p.P_CODE FROM product p WHERE p.P_PRICE > "
                "(SELECT AVG(q.P_PRICE) FROM product q WHERE q.V_CODE=p.V_CODE) ORDER BY p.P_CODE"
            ),
            [("P2",), ("P5",)],
        ),
        (
            (
                "SELECT v.V_CODE FROM vendor v WHERE NOT EXISTS "
                "(SELECT 1 FROM product p WHERE p.V_CODE=v.V_CODE)"
            ),
            [(40,)],
        ),
        (
            "SELECT V_CODE FROM vendor WHERE V_CODE NOT IN (SELECT V_CODE FROM product)",
            [],
        ),
        ("SELECT CUS_CODE FROM customer EXCEPT SELECT CUS_CODE FROM invoice", [(4,)]),
        (
            (
                "SELECT COUNT(*),COUNT(V_CODE),COUNT(DISTINCT V_CODE),MIN(P_PRICE),MAX(P_PRICE),"
                "SUM(P_PRICE) FROM product"
            ),
            [(7, 6, 3, 2, 100, 237)],
        ),
        (
            (
                "SELECT COUNT(*),MIN(P_PRICE),MAX(P_PRICE),SUM(P_PRICE),AVG(P_PRICE) "
                "FROM product WHERE P_PRICE<0"
            ),
            [(0, None, None, None, None)],
        ),
        (
            "SELECT COUNT(*),COUNT(DISTINCT INV_NUMBER) FROM invoice JOIN line USING(INV_NUMBER)",
            [(7, 4)],
        ),
        (
            (
                "SELECT SUM(l.LINE_UNITS*l.LINE_PRICE),SUM(l.LINE_UNITS*p.P_PRICE) "
                "FROM invoice i JOIN line l USING(INV_NUMBER) JOIN product p USING(P_CODE) "
                "WHERE i.INV_DATE >= '2026-10-01' AND i.INV_DATE < '2026-11-01'"
            ),
            [(170, 190)],
        ),
        (
            (
                "SELECT date(P_INDATE,'+30 days'),julianday('2026-10-11')-julianday(P_INDATE) "
                "FROM product WHERE P_CODE='P2'"
            ),
            [("2026-10-31", 10.0)],
        ),
        ("SELECT 10+2*3,(10+2)*3,7/2,7.0/2", [(16, 36, 3, 3.5)]),
    ]
    with closing(connect_lab()) as connection:
        for query, expected in cases:
            actual = connection.execute(query).fetchall()
            assert actual == expected, (query, expected, actual)
        for sql in (
            "INSERT INTO vendor VALUES (10,'Duplicate','X','701','555-9999','ND','Y')",
            "INSERT INTO vendor VALUES (99,'Acme Tools','X','701','555-9999','ND','Y')",
            "UPDATE product SET P_DESCRIPT=NULL WHERE P_CODE='P2'",
            "UPDATE product SET P_PRICE=-1 WHERE P_CODE='P2'",
            "UPDATE product SET P_PRICE=NULL WHERE P_CODE='P2'",
            "UPDATE product SET V_CODE=999 WHERE P_CODE='P2'",
            "DELETE FROM product WHERE P_CODE='P2'",
        ):
            expect_failure(connection, sql)
        connection.execute(
            "INSERT INTO product(P_CODE,P_DESCRIPT,P_INDATE,P_PRICE) VALUES('T1','Defaults','2026-10-14',5)"
        )
        assert connection.execute(
            "SELECT P_QOH,P_MIN,P_DISCOUNT,V_CODE FROM product WHERE P_CODE='T1'"
        ).fetchone() == (0, 0, 0, None)

    with closing(connect_lab()) as connection:
        connection.executescript((ROOT / "chapter8/04_views.sql").read_text())
        connection.execute("BEGIN")
        connection.execute("UPDATE product_prices SET P_PRICE=15 WHERE P_CODE='P2'")
        assert connection.execute(
            "SELECT P_PRICE FROM product WHERE P_CODE='P2'"
        ).fetchone() == (15,)
        assert connection.execute(
            "SELECT P_PRICE FROM product_snapshot WHERE P_CODE='P2'"
        ).fetchone() == (45,)
        assert connection.execute(
            "SELECT COUNT(*) FROM expensive_product"
        ).fetchone() == (3,)
        connection.rollback()
        assert connection.execute(
            "SELECT P_PRICE FROM product WHERE P_CODE='P2'"
        ).fetchone() == (45,)

    with closing(connect_lab()) as connection:
        connection.executescript((ROOT / "chapter8/05_triggers.sql").read_text())
        connection.execute("BEGIN")
        connection.execute("UPDATE product SET P_PRICE=P_PRICE+1 WHERE V_CODE=20")
        assert connection.execute("SELECT COUNT(*) FROM price_audit").fetchone() == (2,)
        connection.execute("UPDATE product SET P_PRICE=P_PRICE WHERE P_CODE='P3'")
        assert connection.execute("SELECT COUNT(*) FROM price_audit").fetchone() == (2,)
        connection.rollback()
        assert connection.execute("SELECT COUNT(*) FROM price_audit").fetchone() == (0,)
    return len(cases) + 7 + 1 + 4 + 3


def main() -> None:
    if sqlite3.sqlite_version_info < (3, 39, 0):
        raise SystemExit("SQLite 3.39+ is required for RIGHT/FULL JOIN")
    files = sorted(ROOT.glob("chapter[78]/*.sql")) + [
        ROOT / "solutions/chapter7.sql",
        ROOT / "solutions/chapter8.sql",
    ]
    statement_count = sum(run_file(path) for path in files)
    assertions = check_invariants()
    print(
        f"PASS: {len(files)} SQLite files, {statement_count} statements, {assertions} invariant checks."
    )
    print("PostgreSQL companions are checked separately with postgres/check.sql.")


if __name__ == "__main__":
    main()
