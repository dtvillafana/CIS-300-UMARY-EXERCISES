-- POSTGRES A: server features not available in SQLite.
-- Run after postgres/setup.sql in a disposable database.
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE > ALL (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 20)
ORDER BY P_CODE; -- P2,P4: greater than both 30s.
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE > ANY (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 10)
ORDER BY P_CODE; -- 0012,P2,P3,P4,P5,P6: greater than at least 2 or 45.
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE = ANY (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 20)
ORDER BY P_CODE; -- P3,P6. ANY/SOME permit = as well as >/<.

CREATE SEQUENCE LAB_CUS_CODE_SEQ START WITH 20010 INCREMENT BY 1 CACHE 1;
CREATE SEQUENCE LAB_INV_NUMBER_SEQ START WITH 4010 INCREMENT BY 1 CACHE 1;
SELECT sequencename, increment_by, cache_size, last_value
FROM pg_sequences WHERE schemaname = current_schema()
AND sequencename LIKE 'lab_%' ORDER BY sequencename;
SELECT nextval('lab_cus_code_seq'); -- 20010 consumed.
SELECT currval('lab_cus_code_seq'); -- same session's last value.

-- TASK PA1 (paper): CREATE SCHEMA lab_namespace AUTHORIZATION CURRENT_USER
--   with a CREATE TABLE statement; explain schema vs database vs role.
--   Unlike Oracle's user-owned namespace, PostgreSQL allows multiple schemas
--   per role/database. Compare a SQLite database file. No accounts to create.
-- TASK PA2 (paper): GRANT USAGE ON SCHEMA public and SELECT ON LAB_PRODUCT
--   to an_existing_analyst; REVOKE them. Explain inherited role/PUBLIC access
--   and least privilege. Do not change real permissions for this exercise.
-- TASK PA3: > ALL empty query (7 rows), > SOME empty query (0); compare
--   > ALL over (30,NULL): no TRUE results; > ANY over (30,NULL): P2,P4.
--   Explain TRUE/FALSE/UNKNOWN and why MAX/MIN rewrites need assumptions
--   about NULLs and empty sets. ALL is not restricted to inequality.
-- TASK PA4: return POWER(2,3), EXTRACT(YEAR FROM P_INDATE), P_INDATE+10,
--   DATE '2026-10-11'-DATE '2026-10-01', TO_CHAR(P_INDATE,'YYYY-MM-DD'),
--   TO_NUMBER('19.95','99.99'), and CAST('19.95' AS NUMERIC(8,2)).
--   Also return ABS(-7), ROUND(19.956,2), SIN(0), LN(1) (7,19.96,0,0).
-- TASK PA5: write the slides' MINUS example with PostgreSQL EXCEPT
--   (product codes from vendor 20 vs 10); reverse operands and compare.
-- TASK PA6: create LAB_PART without constraints; add PK/FK/CHECK using ALTER.
--   Add a column, ALTER COLUMN TYPE/SET DEFAULT/SET NOT NULL, DROP COLUMN,
--   DROP CONSTRAINT, DROP TABLE. Explain existing-data preflight checks.
-- TASK PA7: create a simple view and update it; add WITH CHECK OPTION and
--   try to move P2 below its >20 filter (must fail); ROLLBACK afterward.
-- TASK PA8: BEGIN; insert a customer using nextval (20011 in the first run),
--   ROLLBACK, then get nextval again (20012). Inspect pg_sequences.
--   Why does rollback not restore the consumed number? Why still need PK?
