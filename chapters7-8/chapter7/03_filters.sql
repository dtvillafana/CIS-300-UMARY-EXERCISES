-- 7.3 Goal: control membership and order; test endpoints and SQL UNKNOWN.
SELECT P_CODE, P_PRICE FROM product
WHERE P_PRICE >= 20 ORDER BY P_PRICE ASC, P_CODE DESC;
SELECT CUS_CODE, CUS_LNAME, CUS_FNAME, CUS_INITIAL FROM customer
ORDER BY CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_CODE;

-- Wrong NULL test intentionally returns no rows; NULL is not zero/blank.
SELECT P_CODE FROM product WHERE V_CODE = NULL;
SELECT P_CODE FROM product WHERE V_CODE IS NULL;

-- Business question: Which products fall at, below, above, or outside a
--   $30 price point, and does the boundary belong in each list?
-- TASK 7.3a: write six price filters (=,<,<=,>,>=,<>) against 30; compare
--   >= with > and <> with !=. Expected counts: 2,3,5,2,4,5.
-- Business question: Which suppliers are located in Tennessee?
-- TASK 7.3b: filter vendors by character value V_STATE='TN' (2).
-- Business question: Which products were received during October 2026?
-- TASK 7.3c: list October product receipts with >= '2026-10-01' and
--   < '2026-11-01' (4). Explain the half-open timestamp equivalent.
-- Business question: Which products from supplier 10 or 20 cost at least $30?
-- TASK 7.3d: use (V_CODE=10 OR V_CODE=20) AND P_PRICE>=30 (P2,P3,P6).
--   Remove parentheses and explain why P1 incorrectly qualifies.
-- Business question: Which products match each separate catalog search:
--   $20-$30 inclusive, supplier 10 or 30, 'saw' in the description,
--   or a two-character code beginning with P?
-- TASK 7.3e: demonstrate BETWEEN 20 AND 30 (P3,P5,P6), IN(10,30) (4),
--   LIKE '%saw%' (3 in SQLite), and LIKE 'P_' (6; _ is one character).
-- Business question: Which products fall outside those search criteria or
--   have assigned suppliers, and how can a non-10 supplier list also retain
--   products whose supplier is unknown?
-- TASK 7.3f: use NOT BETWEEN, NOT IN, NOT LIKE, and IS NOT NULL.
--   For V_CODE NOT IN(10,NULL), explain the empty result. NOT UNKNOWN is
--   UNKNOWN. Write a filter that includes NULL as well as non-10 vendors.
-- Business question: How do we ensure a product/supplier report contains
--   actual supplier assignments rather than invented pairings?
-- TASK 7.3g: reproduce the inner join using FROM product p, vendor v
--   WHERE p.V_CODE=v.V_CODE (6). Then count the missing-condition result
--   (28). Explain why explicit JOIN ON is easier to audit.
-- REFLECT: string ordering/case sensitivity depend on collation; typed
--   dates and ISO date text are not interchangeable across all DBMSs.
