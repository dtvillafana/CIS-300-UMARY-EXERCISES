-- 8.3 Goal: write bounded DML and choose explicit transaction boundaries.
PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;
-- All-column VALUES, explicit NULL, and omitted optional/defaulted columns.
INSERT INTO product VALUES ('T1', 'Temporary', '2026-10-14', 0, 0, 5, 0, NULL);
INSERT INTO product (P_CODE, P_DESCRIPT, P_INDATE, P_PRICE)
VALUES ('T2', 'Default example', '2026-10-14', 10);
SELECT * FROM product WHERE P_CODE IN ('T1', 'T2');
ROLLBACK; -- Neither new product remains.

CREATE TABLE price_history (P_CODE TEXT NOT NULL, P_PRICE NUMERIC NOT NULL);
BEGIN TRANSACTION;
INSERT INTO price_history (P_CODE, P_PRICE) SELECT P_CODE, P_PRICE FROM product;
COMMIT; -- Seven history rows remain after future rollback.
BEGIN TRANSACTION;
SELECT P_CODE, P_PRICE FROM product WHERE V_CODE = 10; -- Preview same predicate.
UPDATE product SET P_PRICE = ROUND(P_PRICE * 1.05, 2), P_MIN = P_MIN + 1
WHERE V_CODE = 10;
DELETE FROM product WHERE P_CODE = '0012'; -- Not sold; permitted by FK.
SELECT changes() AS LastStatementAffectedRows; -- 1, not total transaction count.
ROLLBACK;

-- TASK 8.3a: add a product using a column list, an omitted vendor/defaults,
--   and a second with explicit NULL vendor; SELECT them then ROLLBACK.
-- TASK 8.3b: copy only vendor 20's two prices into price_history using
--   INSERT SELECT. COMMIT, then explain how this differs from CTAS.
-- TASK 8.3c: preview and increase vendor 30 prices by 10%, setting discount
--   to .05 in the same UPDATE; check affected count 2; ROLLBACK.
-- TASK 8.3d: delete the unsold product '0012', check count 1; ROLLBACK.
--   Separately attempt to delete sold P2: FK should reject it. Why is
--   deleting a product not the same as deleting its historical line?
-- TASK 8.3e: atomic sale: BEGIN, insert header 1006, insert two lines,
--   reduce stock, COMMIT. In a fresh reset, make the second line's product
--   invalid; explicitly ROLLBACK after error and verify no header/first
--   line/stock change remains. See embedded.py for safe error handling.
-- REFLECT: missing WHERE updates/deletes all rows; autocommit and error
--   handling matter. COMMIT WORK is dialect syntax; SQLite uses COMMIT.
