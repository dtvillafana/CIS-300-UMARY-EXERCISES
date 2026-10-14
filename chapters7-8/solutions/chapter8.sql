-- SQLite answer key: reset first. Worked lesson files need not run first.
PRAGMA foreign_keys = ON;
-- 8.1a: CREATE DDL; INSERT/SELECT DML; COMMIT TCL; GRANT DCL.
-- 8.1b
CREATE TABLE part (
    PART_CODE TEXT NOT NULL,
    PART_DESCRIPT TEXT NOT NULL,
    PART_PRICE NUMERIC(8, 2) NOT NULL DEFAULT 0,
    V_CODE INTEGER,
    CONSTRAINT part_pk PRIMARY KEY (PART_CODE),
    CONSTRAINT part_description UNIQUE (PART_DESCRIPT),
    CONSTRAINT part_price CHECK (PART_PRICE >= 0),
    CONSTRAINT part_vendor FOREIGN KEY (V_CODE) REFERENCES vendor (V_CODE)
);
INSERT INTO part (PART_CODE, PART_DESCRIPT, PART_PRICE, V_CODE)
VALUES ('A', 'Part A', 19.95, 10), ('B', 'Part B', 30, 20);
-- 8.1c: run errors individually, not as a batch:
-- INSERT INTO part VALUES ('A','Other',1,10);             -- duplicate PK
-- INSERT INTO part VALUES ('C','Part A',1,10);            -- UNIQUE
-- INSERT INTO part VALUES ('C',NULL,1,10);                -- NOT NULL
-- INSERT INTO part VALUES ('C','New',-1,10);              -- CHECK
-- INSERT INTO part VALUES ('C','New',1,999);              -- FK
-- CHECK accepts UNKNOWN, so CHECK alone doesn't imply NOT NULL.
-- 8.1d: part replaces the worked example's scratch table here.
CREATE UNIQUE INDEX part_description_idx ON part (PART_DESCRIPT);
EXPLAIN QUERY PLAN SELECT * FROM part WHERE PART_DESCRIPT = 'Part A';
DROP INDEX part_description_idx;
-- 8.1e
CREATE TABLE product_snapshot AS
SELECT P_CODE, P_PRICE FROM product WHERE P_PRICE > 20;
PRAGMA table_info(product_snapshot);
BEGIN TRANSACTION;
UPDATE product SET P_PRICE = 15 WHERE P_CODE = 'P2';
SELECT p.P_PRICE AS CurrentPrice, s.P_PRICE AS SnapshotPrice
FROM product AS p JOIN product_snapshot AS s USING (P_CODE) WHERE P_CODE = 'P2';
ROLLBACK;
-- 8.1f: codes VARCHAR, units INTEGER, state CHAR(2), date DATE,
-- price DECIMAL(p,s) in enforcing engines; Oracle NUMBER/VARCHAR2 are dialects.

-- 8.2a/b: scratch table has no incoming references/dependent objects.
ALTER TABLE part ADD COLUMN PART_DISCOUNT NUMERIC;
UPDATE part SET PART_DISCOUNT = 0;
SELECT COUNT(*) AS MissingDiscounts FROM part WHERE PART_DISCOUNT IS NULL;
BEGIN TRANSACTION;
CREATE TABLE part_new (
    PART_CODE TEXT NOT NULL PRIMARY KEY,
    PART_DESCRIPT TEXT NOT NULL UNIQUE,
    PART_PRICE NUMERIC(8, 2) NOT NULL DEFAULT 0 CHECK (PART_PRICE >= 0),
    V_CODE INTEGER REFERENCES vendor (V_CODE),
    PART_DISCOUNT NUMERIC NOT NULL DEFAULT 0 CHECK (PART_DISCOUNT BETWEEN 0 AND 1)
);
INSERT INTO part_new SELECT * FROM part;
SELECT COUNT(*) AS CopiedRows FROM part_new;
PRAGMA foreign_key_check(part_new);
DROP TABLE part;
ALTER TABLE part_new RENAME TO part;
COMMIT;
-- 8.2c: Oracle syntax in oracle.sql; SQLite can't ALTER ADD constraints.
-- 8.2d
CREATE TABLE scratch_product AS SELECT * FROM part;
ALTER TABLE scratch_product DROP COLUMN PART_DISCOUNT;
DROP TABLE scratch_product;

-- 8.3a
BEGIN TRANSACTION;
INSERT INTO product (P_CODE, P_DESCRIPT, P_INDATE, P_PRICE)
VALUES ('T1', 'Omitted defaults', '2026-10-14', 5);
INSERT INTO product (P_CODE, P_DESCRIPT, P_INDATE, P_PRICE, V_CODE)
VALUES ('T2', 'Explicit NULL', '2026-10-14', 5, NULL);
SELECT * FROM product WHERE P_CODE IN ('T1', 'T2');
ROLLBACK;
-- 8.3b
CREATE TABLE price_history (P_CODE TEXT NOT NULL, P_PRICE NUMERIC NOT NULL);
BEGIN TRANSACTION;
INSERT INTO price_history SELECT P_CODE, P_PRICE FROM product WHERE V_CODE = 20;
COMMIT;
-- 8.3c
BEGIN TRANSACTION;
UPDATE product SET P_PRICE = ROUND(P_PRICE * 1.1, 2), P_DISCOUNT = .05
WHERE V_CODE = 30;
SELECT changes() AS ChangedRows;
SELECT P_CODE, P_PRICE, P_DISCOUNT FROM product WHERE V_CODE = 30 ORDER BY P_CODE;
ROLLBACK;
-- 8.3d
BEGIN TRANSACTION;
DELETE FROM product WHERE P_CODE = '0012';
SELECT changes() AS DeletedRows;
ROLLBACK;
-- Run separately: DELETE FROM product WHERE P_CODE='P2'; -- FK error
-- 8.3e: commit success; failure rollback is covered in embedded.py/tests.
BEGIN TRANSACTION;
INSERT INTO invoice VALUES (1006, 1, '2026-10-14');
INSERT INTO line VALUES (1006, 1, 'P2', 1, 45), (1006, 2, 'P3', 2, 30);
UPDATE product SET P_QOH = P_QOH - 1 WHERE P_CODE = 'P2';
UPDATE product SET P_QOH = P_QOH - 2 WHERE P_CODE = 'P3';
COMMIT;

-- 8.4a
CREATE VIEW vendor_summary AS
SELECT V_CODE, COUNT(*) AS N, AVG(P_PRICE) AS MeanPrice FROM product GROUP BY V_CODE;
SELECT * FROM vendor_summary ORDER BY V_CODE;
-- 8.4b: a grouped row/UNION/DISTINCT has no unique base-row write target;
-- join-view updatability varies. Oracle CHECK OPTION answer in oracle.sql.
-- 8.4c
CREATE VIEW product_prices AS SELECT P_CODE, P_PRICE FROM product;
CREATE TRIGGER product_prices_update INSTEAD OF UPDATE OF P_PRICE ON product_prices
BEGIN
    UPDATE product SET P_PRICE = NEW.P_PRICE WHERE P_CODE = OLD.P_CODE;
END;
BEGIN TRANSACTION;
UPDATE product_prices SET P_PRICE = P_PRICE * 1.05
WHERE P_CODE IN (SELECT P_CODE FROM product WHERE V_CODE = 20);
SELECT P_CODE, P_PRICE FROM product WHERE V_CODE = 20;
ROLLBACK;
-- 8.4d
DROP VIEW product_prices;
SELECT COUNT(*) AS BaseRows FROM product;

-- 8.5a: AFTER timing, UPDATE event, FOR EACH ROW level, BEGIN/END action.
CREATE TABLE price_audit (
    AuditID INTEGER PRIMARY KEY, P_CODE TEXT NOT NULL,
    OldPrice NUMERIC, NewPrice NUMERIC, Action TEXT NOT NULL
);
CREATE TRIGGER price_audit_update AFTER UPDATE OF P_PRICE ON product
FOR EACH ROW WHEN OLD.P_PRICE <> NEW.P_PRICE
BEGIN
    INSERT INTO price_audit (P_CODE, OldPrice, NewPrice, Action)
    VALUES (NEW.P_CODE, OLD.P_PRICE, NEW.P_PRICE, 'UPDATE');
END;
-- 8.5b
CREATE TRIGGER price_audit_insert AFTER INSERT ON product
BEGIN
    INSERT INTO price_audit (P_CODE, NewPrice, Action)
    VALUES (NEW.P_CODE, NEW.P_PRICE, 'INSERT');
END;
CREATE TRIGGER price_audit_delete AFTER DELETE ON product
BEGIN
    INSERT INTO price_audit (P_CODE, OldPrice, Action)
    VALUES (OLD.P_CODE, OLD.P_PRICE, 'DELETE');
END;
BEGIN TRANSACTION;
INSERT INTO product (P_CODE, P_DESCRIPT, P_INDATE, P_PRICE)
VALUES ('T1', 'Trigger test', '2026-10-14', 5);
DELETE FROM product WHERE P_CODE = 'T1';
SELECT * FROM price_audit ORDER BY AuditID;
ROLLBACK;
-- 8.5c
BEGIN TRANSACTION;
UPDATE product SET P_PRICE = P_PRICE + 1;
SELECT COUNT(*) AS SevenUpdates FROM price_audit;
UPDATE product SET P_PRICE = P_PRICE WHERE P_CODE = 'P2';
SELECT COUNT(*) AS StillSeven FROM price_audit;
ROLLBACK;
-- 8.5d
DROP TRIGGER price_audit_update;
BEGIN TRANSACTION;
UPDATE product SET P_PRICE = 50 WHERE P_CODE = 'P2';
SELECT COUNT(*) AS NoAudit FROM price_audit;
ROLLBACK;
-- 8.5e: Oracle multi-event trigger in oracle.sql.
