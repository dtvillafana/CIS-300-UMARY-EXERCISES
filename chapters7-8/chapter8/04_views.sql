-- 8.4 Goal: compare saved queries/snapshots and define writable mappings.
PRAGMA foreign_keys = ON;
CREATE VIEW expensive_product AS
SELECT P_CODE, P_DESCRIPT, P_PRICE FROM product WHERE P_PRICE > 20;
CREATE TABLE product_snapshot AS SELECT * FROM expensive_product;
BEGIN TRANSACTION;
UPDATE product SET P_PRICE = 15 WHERE P_CODE = 'P2';
SELECT * FROM expensive_product ORDER BY P_CODE; -- Three rows, no P2.
SELECT * FROM product_snapshot ORDER BY P_CODE; -- Four; P2 still 45.
ROLLBACK;

CREATE VIEW product_prices AS SELECT P_CODE, P_PRICE FROM product;
-- SQLite views are read-only without explicit INSTEAD OF triggers.
CREATE TRIGGER product_prices_update
INSTEAD OF UPDATE OF P_PRICE ON product_prices
BEGIN
    UPDATE product SET P_PRICE = NEW.P_PRICE WHERE P_CODE = OLD.P_CODE;
END;
BEGIN TRANSACTION;
UPDATE product_prices SET P_PRICE = 50 WHERE P_CODE = 'P2';
SELECT P_PRICE FROM product WHERE P_CODE = 'P2'; -- 50, base table changed.
ROLLBACK;

-- TASK 8.4a: create vendor_summary with count and mean by V_CODE (4 rows).
--   Why can't its averages be mapped automatically to one base product?
-- TASK 8.4b: compare restrictions from GROUP BY/aggregates, DISTINCT,
--   UNION, and JOIN. Run PostgreSQL WITH CHECK OPTION practice (Postgres A).
-- TASK 8.4c: use one UPDATE to increase all vendor 20 prices by 5% in a
--   transaction via product_prices; both become 31.50; ROLLBACK.
--   This is a batch update, not a guarantee of atomicity without a transaction.
-- TASK 8.4d: DROP VIEW product_prices and confirm seven base products
--   remain; its INSTEAD OF trigger is also removed in SQLite.
-- REFLECT: a view definition lives in metadata, not a second stored copy;
--   limiting output columns is not itself an access-control boundary.
