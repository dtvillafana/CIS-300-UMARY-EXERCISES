-- ORACLE A: all unsupported syntax is explicit, not masquerading as SQLite.
-- Run after oracle/setup.sql in a disposable schema.
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE > ALL (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 20)
ORDER BY P_CODE; -- P2,P4: greater than both 30s.
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE > ANY (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 10)
ORDER BY P_CODE; -- 0012,P2,P3,P4,P5,P6: greater than at least 2 or 45.
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE = ANY (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 20)
ORDER BY P_CODE; -- P3,P6. ANY/SOME permit = as well as >/<.

CREATE SEQUENCE LAB_CUS_CODE_SEQ START WITH 20010 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE LAB_INV_NUMBER_SEQ START WITH 4010 INCREMENT BY 1 NOCACHE;
SELECT SEQUENCE_NAME, INCREMENT_BY, CACHE_SIZE, LAST_NUMBER
FROM USER_SEQUENCES WHERE SEQUENCE_NAME LIKE 'LAB_%' ORDER BY SEQUENCE_NAME;
SELECT LAB_CUS_CODE_SEQ.NEXTVAL FROM DUAL; -- 20010 consumed.
SELECT LAB_CUS_CODE_SEQ.CURRVAL FROM DUAL; -- same session's last value.

-- TASK OA1 (paper): CREATE SCHEMA AUTHORIZATION your_existing_user with a
--   CREATE TABLE statement; explain schema ownership vs database creation.
--   Oracle CREATE SCHEMA groups object creation in an existing user's
--   schema; it does not create that user. Compare a SQLite database file.
-- TASK OA2 (paper): GRANT SELECT ON LAB_PRODUCT TO an_existing_analyst;
--   REVOKE it. Explain inherited role access and least privilege.
-- TASK OA3: > ALL empty query (7 rows), > SOME empty query (0); compare
--   > ALL over (30,NULL): no TRUE results; > ANY over (30,NULL): P2,P4.
--   Explain TRUE/FALSE/UNKNOWN and why MAX/MIN rewrites need assumptions
--   about NULLs and empty sets. ALL is not restricted to inequality.
-- TASK OA4: return POWER(2,3), EXTRACT(YEAR FROM P_INDATE), P_INDATE+10,
--   DATE '2026-10-11'-DATE '2026-10-01', and TO_CHAR(P_INDATE,'YYYY-MM-DD').
--   Use TO_NUMBER('19.95','99D99','NLS_NUMERIC_CHARACTERS=''.,''') and CAST.
--   Numeric function families: also return ABS(-7), ROUND(19.956,2),
--   SIN(0), and LN(1) (7,19.96,0,0): algebraic, trigonometric, logarithmic.
-- TASK OA5: translate a product-code EXCEPT query to MINUS (vendor 20 vs 10).
-- TASK OA6: create LAB_PART without constraints; add PK/FK/CHECK using ALTER.
--   Add a column, MODIFY type/length and default/nullability, DROP COLUMN,
--   DROP CONSTRAINT, DROP TABLE. Explain existing-data preflight checks.
-- TASK OA7: create a simple view and update it; add WITH CHECK OPTION and
--   try to move P2 below its >20 filter (must fail); ROLLBACK afterward.
-- TASK OA8: insert a customer using NEXTVAL (20011 in the first run),
--   ROLLBACK, then get NEXTVAL again (20012). Inspect USER_SEQUENCES.
--   Why does rollback not restore the consumed number? Why still need PK?
