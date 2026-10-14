-- 7.1 Goal: distinguish projection, filtering, aliases, and derived values.
-- Predict: both SELECTs return seven rows; the second has four columns.
SELECT * FROM product;
SELECT P_CODE, P_DESCRIPT AS DESCRIPTION, P_PRICE AS "Unit Price", P_QOH AS QTY
FROM product;

-- Parentheses encode the business rule, not just presentation.
SELECT P_CODE, P_PRICE * P_QOH AS InventoryValue,
       ROUND(P_PRICE * (1 - P_DISCOUNT), 2) AS DiscountedPrice
FROM product
ORDER BY P_CODE;
SELECT 10 + 2 * 3 AS NormalPrecedence, (10 + 2) * 3 AS WithParentheses,
       7 / 2 AS IntegerDivision, 7.0 / 2 AS RealDivision;

-- SQLite temporal arithmetic; dates here are ISO YYYY-MM-DD text.
SELECT P_CODE, date(P_INDATE, '+7 days') AS ReviewDate,
       julianday('2026-11-01') - julianday(P_INDATE) AS DaysToNovember
FROM product ORDER BY P_CODE;
SELECT DISTINCT V_CODE FROM product ORDER BY V_CODE;

-- TASK 7.1a: return code, description, price only, sorted by code (7 rows).
-- TASK 7.1b: use +, -, *, / and parentheses to return each product's
--   stock gap (P_MIN - P_QOH), restock target (P_MIN + 2), inventory value,
--   and 10% discounted price using (100 - 10) / 100.0. Do not update values.
-- TASK 7.1c: return distinct assigned vendor codes, excluding NULL (10,20,30).
--   Then add P_PRICE: why does DISTINCT now yield five vendor/price pairs?
-- TASK 7.1d: compute 2 cubed by multiplication; compare the written
--   POWER(2,3) function in PostgreSQL. Explain why ^ and ** are not portable.
-- TASK 7.1e: find P2's receipt date plus 30 days and days from its receipt
--   to 2026-10-11 (2026-10-31 and 10). Do not subtract ISO strings directly.
-- REFLECT: SELECT is DML here; CREATE is DDL, COMMIT is TCL, GRANT is DCL.
--   Which requests describe desired results instead of an execution loop?
