-- 7.8 Goal: know the data/problem, build clauses, validate multiplicity.
-- Requirement: recorded October 2026 line sales per customer, at least
-- $100, ordered by revenue descending and customer code for ties.
-- Step 1: FROM, output grain one line. Seven baseline rows.
SELECT c.CUS_CODE, i.INV_NUMBER, l.LINE_NUMBER, l.LINE_UNITS, l.LINE_PRICE
FROM customer AS c
JOIN invoice AS i ON i.CUS_CODE = c.CUS_CODE
JOIN line AS l ON l.INV_NUMBER = i.INV_NUMBER
ORDER BY i.INV_NUMBER, l.LINE_NUMBER;

-- Business question: Which recorded sales lines belong to October 2026?
-- TASK 7.8a: add WHERE for [2026-10-01,2026-11-01) (4 line rows).
-- Business question: How much recorded October line-sales revenue did each
--   customer with October sales generate?
-- TASK 7.8b: add GROUP BY customer identity, SUM(units*sale price) (1,170).
-- Business question: Which customers generated at least $100 in October
--   line sales, ranked by revenue descending and customer code for ties?
-- TASK 7.8c: add HAVING >=100; choose output columns/aliases; add ORDER BY.
--   Written: SELECT FROM WHERE GROUP BY HAVING ORDER BY.
--   Conceptual: FROM WHERE GROUP BY HAVING SELECT ORDER BY.
-- Business question: How many October invoices did every customer have,
--   counting empty invoices and showing zero for customers with none?
-- TASK 7.8d: include EVERY customer and count October invoices, including
--   empty invoices: (1,2),(2,1),(3,0),(4,0). Keep the date filter in ON.
-- Business question: Does joining customers to October sales lines inflate
--   their recorded account balances in a financial report?
-- TASK 7.8e: show why SUM(CUS_BALANCE) after the October line join yields
--   40 for customer 1, not 10; explain why SUM(DISTINCT balance) is not a
--   general fix for different customers sharing balances.
-- Business question: Are we reporting actual October revenue or what those
--   same quantities would sell for at today's catalog prices?
-- TASK 7.8f: compare historical sales (170) with repricing those same
--   lines at today's P_PRICE (190). Which answers the requirement?
-- CHECKLIST: define grain, source of prices, period boundaries, empty
--   invoice handling, NULL handling, row counts, aliases, deterministic
--   order. Clarify what "top customer" means before coding a report.
