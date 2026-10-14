"""Executable checks for the host-language exercises."""

import sqlite3
import unittest

from embedded import connect_lab, find_vendor, list_products, record_sale


class EmbeddedTests(unittest.TestCase):
    def setUp(self) -> None:
        self.connection = connect_lab()
        self.addCleanup(self.connection.close)

    def test_null_missing_and_parameter_binding(self) -> None:
        self.assertEqual(find_vendor(self.connection, "P2"), (10,))
        self.assertEqual(find_vendor(self.connection, "P4"), (None,))
        self.assertIsNone(find_vendor(self.connection, "P9"))
        self.assertIsNone(find_vendor(self.connection, "P2' OR 1=1 --"))

    def test_dynamic_allowlist(self) -> None:
        self.assertEqual(
            [row[0] for row in list_products(self.connection, "price", 30)],
            ["P3", "P6", "P2", "P4"],
        )
        with self.assertRaises(ValueError):
            list_products(self.connection, "price; DROP TABLE product", 0)
        self.assertEqual(
            self.connection.execute("SELECT COUNT(*) FROM product").fetchone(), (7,)
        )

    def test_complete_sale(self) -> None:
        record_sale(self.connection, 1006, 1, [("P2", 1), ("P3", 2)])
        self.assertEqual(
            self.connection.execute(
                "SELECT COUNT(*) FROM line WHERE INV_NUMBER=1006"
            ).fetchone(),
            (2,),
        )
        self.assertEqual(
            self.connection.execute(
                "SELECT P_QOH FROM product WHERE P_CODE IN ('P2','P3') ORDER BY P_CODE"
            ).fetchall(),
            [(1,), (6,)],
        )
        self.assertFalse(self.connection.in_transaction)

    def test_partial_failure_rolls_back(self) -> None:
        for items in (
            [("P2", 1), ("MISSING", 1)],
            [("P2", 1), ("P3", 99)],
            [("P2", 0)],
        ):
            with self.subTest(items=items), self.assertRaises(ValueError):
                record_sale(self.connection, 1006, 1, items)
            self.assertEqual(
                self.connection.execute(
                    "SELECT COUNT(*) FROM invoice WHERE INV_NUMBER=1006"
                ).fetchone(),
                (0,),
            )
            self.assertEqual(
                self.connection.execute(
                    "SELECT COUNT(*) FROM line WHERE INV_NUMBER=1006"
                ).fetchone(),
                (0,),
            )
            self.assertEqual(
                self.connection.execute(
                    "SELECT P_QOH FROM product WHERE P_CODE='P2'"
                ).fetchone(),
                (2,),
            )
            self.assertFalse(self.connection.in_transaction)

    def test_integrity_diagnostics_and_rollback(self) -> None:
        for invoice, customer in ((1001, 1), (1006, 999)):
            with self.subTest(invoice=invoice, customer=customer):
                with self.assertRaises(sqlite3.IntegrityError) as caught:
                    record_sale(self.connection, invoice, customer, [("P2", 1)])
                self.assertTrue(
                    caught.exception.sqlite_errorname.startswith("SQLITE_CONSTRAINT")
                )
                self.assertFalse(self.connection.in_transaction)

    def test_transaction_ownership(self) -> None:
        self.connection.execute("BEGIN")
        with self.assertRaises(ValueError):
            record_sale(self.connection, 1006, 1, [("P2", 1)])
        self.assertTrue(self.connection.in_transaction)
        self.connection.rollback()


if __name__ == "__main__":
    unittest.main()
