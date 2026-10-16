-- 8.2 Goal: migrate existing data, not merely declare intended constraints.
-- Reset first. This scratch table has no incoming FK or dependent view.
PRAGMA foreign_keys = ON;
CREATE TABLE part (PART_CODE TEXT, PART_PRICE TEXT, V_CODE INTEGER);
INSERT INTO part VALUES ('A', '19.95', 10), ('B', '30.00', 20);
ALTER TABLE part ADD COLUMN PART_NOTE TEXT;
UPDATE part SET PART_NOTE = 'migrated';

-- Preflight: duplicates, missing key, negative prices, orphan references.
SELECT PART_CODE, COUNT(*) FROM part GROUP BY PART_CODE
HAVING COUNT(*) > 1 OR PART_CODE IS NULL;
SELECT p.* FROM part AS p LEFT JOIN vendor AS v ON p.V_CODE = v.V_CODE
WHERE p.V_CODE IS NOT NULL AND v.V_CODE IS NULL;
-- These casts are safe ONLY after validating the original text values.
-- SQLite would cast invalid 'N/A' to 0; real migrations must reject it.
BEGIN TRANSACTION;
CREATE TABLE part_new (
    PART_CODE TEXT NOT NULL PRIMARY KEY,
    PART_PRICE NUMERIC(8, 2) NOT NULL CHECK (PART_PRICE >= 0),
    V_CODE INTEGER REFERENCES vendor (V_CODE),
    PART_NOTE TEXT
);
INSERT INTO part_new SELECT PART_CODE, CAST(PART_PRICE AS NUMERIC), V_CODE,
                           PART_NOTE FROM part;
DROP TABLE part;
ALTER TABLE part_new RENAME TO part;
COMMIT;
SELECT * FROM part ORDER BY PART_CODE;
ALTER TABLE part DROP COLUMN PART_NOTE;

-- Business question: How can existing parts gain a discount field with every
--   current part initially receiving no discount?
-- TASK 8.2a: add nullable PART_DISCOUNT, backfill 0, verify no missing values.
-- Business question: How can we require valid discounts from 0% to 100%
--   without losing existing parts or weakening their other integrity rules?
-- TASK 8.2b: rebuild part with PART_DISCOUNT NOT NULL DEFAULT 0 CHECK 0..1;
--   retain PK/FK/price CHECK and both rows. Validate counts/FKs before COMMIT.
--   Do not disable foreign keys to hide errors. General parent-table rebuilds
--   also need a plan for incoming FKs, indexes, views, and triggers.
-- Business question: How can an existing PostgreSQL parts catalog adopt new
--   types and integrity rules without accepting or hiding invalid legacy data?
-- TASK 8.2c: write PostgreSQL ALTER COLUMN TYPE, ADD PRIMARY KEY,
--   ADD FOREIGN KEY, ADD CHECK, and DROP CONSTRAINT (Postgres A, PA6).
--   Profile duplicates, orphans, invalid numeric text, NULLs, and too-long
--   descriptions before changing a populated table's characteristics.
-- Business question: When retiring a catalog field or a temporary catalog,
--   which operation removes structure rather than just clearing records?
-- TASK 8.2d: create a disposable part copy, DROP one column, DROP the table.
--   Contrast DROP TABLE, DROP COLUMN, and DELETE FROM; which loses structure?
-- REFLECT: adding NOT NULL with a default may be legal; doing it without
--   backfill/default can fail. PostgreSQL lab DDL can roll back inside BEGIN;
--   Oracle DDL in the slides implicitly commits instead.
