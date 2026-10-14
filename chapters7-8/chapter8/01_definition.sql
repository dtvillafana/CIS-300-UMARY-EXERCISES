-- 8.1 Goal: create structures, validate domains, compare snapshots/indexes.
-- Reset with load.sql BEFORE running. Foreign keys are connection-local.
PRAGMA foreign_keys = ON;
CREATE TABLE scratch_product (
    Code VARCHAR(10) NOT NULL,
    Description VARCHAR(80) NOT NULL,
    Price DECIMAL(8, 2) NOT NULL DEFAULT 0,
    VendorID INTEGER,
    CONSTRAINT scratch_pk PRIMARY KEY (Code),
    CONSTRAINT scratch_description UNIQUE (Description),
    CONSTRAINT scratch_price CHECK (Price >= 0),
    CONSTRAINT scratch_vendor FOREIGN KEY (VendorID) REFERENCES vendor (V_CODE)
);
INSERT INTO scratch_product (Code, Description) VALUES ('S1', 'Sample');
SELECT * FROM scratch_product; -- Price 0; optional vendor NULL.
CREATE TABLE product_snapshot AS
SELECT P_CODE, P_PRICE FROM product WHERE P_PRICE > 20;
CREATE INDEX product_price_idx ON product (P_PRICE);
EXPLAIN QUERY PLAN SELECT P_CODE FROM product WHERE P_PRICE > 30;
DROP INDEX product_price_idx; -- Leaves seven products intact.

-- TASK 8.1a: classify CREATE/INSERT/SELECT/COMMIT/GRANT as DDL/DML/TCL/DCL.
--   In Oracle A create a schema/namespace and describe database vs schema.
-- TASK 8.1b: create part with text code PK, description NOT NULL UNIQUE,
--   price NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK >=0, and optional vendor FK.
--   Give the constraints names; reference vendor(V_CODE) explicitly.
-- TASK 8.1c: individually attempt duplicate PK, duplicate description,
--   NULL description, negative price, and unknown vendor. All must fail.
--   Why might CHECK(price>=0) alone accept NULL? Why must FK be enabled?
-- TASK 8.1d: create a UNIQUE INDEX on scratch_product.Description, inspect
--   its plan or metadata, then DROP INDEX. Contrast ordinary vs unique.
-- TASK 8.1e: inspect PRAGMA table_info(product_snapshot); demonstrate that
--   CTAS copied four rows but no PK. Inside a transaction, update P2 to 15
--   and compare snapshot P2=45 with current P2=15; ROLLBACK afterward.
-- TASK 8.1f: specify types for '0012', units, state, receipt date, price;
--   explain NUMBER/NUMERIC/DECIMAL precision & scale, INTEGER/SMALLINT,
--   CHAR vs VARCHAR/VARCHAR2, and Oracle DATE vs SQLite ISO text.
