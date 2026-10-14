-- 7.6 Goal: apply per-row functions without modifying stored data.
SELECT P_CODE, UPPER(TRIM(P_DESCRIPT)) AS CleanName,
       length(TRIM(P_DESCRIPT)) AS NameLength,
       substr(P_CODE, 1, 2) AS Prefix,
       ROUND(P_PRICE * (1 - P_DISCOUNT), 2) AS NetPrice
FROM product ORDER BY P_CODE;
SELECT ABS(-7) AS Magnitude, ROUND(19.956, 2) AS Rounded,
       CAST('19.95' AS NUMERIC) AS NumericPrice;

-- TASK 7.6a: return lowercase trimmed descriptions and replace 'saw'
--   with 'SAW'; concatenate code || ': ' || trimmed description.
-- TASK 7.6b: date/time functions: get receipt year/month with strftime,
--   add one month with date, and display a fixed timestamp with datetime.
--   Also run PostgreSQL EXTRACT(YEAR FROM P_INDATE) in Postgres A (PA4).
-- TASK 7.6c: CAST P_PRICE AS TEXT and inspect typeof before/after; cast
--   'not a number' AS NUMERIC (SQLite returns 0, not a validation error).
--   Why is casting not adequate input validation?
-- TASK 7.6d: compare date('2026-10-01','+10 days') with julianday date
--   subtraction (2026-10-11 and 10). Which returns a date versus a number?
-- REFLECT: the slide references textbook function tables without listing
--   every function; these tasks exercise all four shown families: date/time,
--   numeric, string, conversion. Names/arity/return types vary by DBMS.
