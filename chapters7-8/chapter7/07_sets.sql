-- 7.7 Goal: combine compatible result rows vertically, not by a join.
SELECT CUS_CODE FROM invoice WHERE INV_DATE < '2026-11-01'
UNION
SELECT CUS_CODE FROM invoice WHERE INV_DATE >= '2026-10-01'
ORDER BY CUS_CODE; -- 1,2,3 (deduplicated).

-- TASK 7.7a: use UNION ALL with the same branches; predict multiplicities
--   (8 rows: customer 1 four times, 2 three times, 3 once).
-- TASK 7.7b: INTERSECT customers with invoices before Oct 1 and in October
--   (customer 2; the empty invoice still counts as an invoice).
-- TASK 7.7c: EXCEPT all customer codes minus invoice customer codes (4).
--   Reverse the operands (no rows). Compare PostgreSQL EXCEPT with the
--   slides' Oracle MINUS spelling (Postgres A, PA5).
-- TASK 7.7d: reproduce 7.7c with correlated NOT EXISTS (4).
-- TASK 7.7e: combine two compatible two-column projections (code,price)
--   for vendor 10 and vendor 20. Explain column-count/type compatibility
--   by position, duplicate whole-row removal, and final ORDER BY placement.
-- REFLECT: a one-column query UNION a two-column query fails. Don't run
--   intentional errors as part of the entire lesson file.
