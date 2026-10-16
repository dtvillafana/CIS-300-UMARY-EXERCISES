-- 7.4 Goal: state grouping grain and separate WHERE from HAVING.
SELECT COUNT(*) AS Products, COUNT(V_CODE) AS AssignedProducts,
       COUNT(DISTINCT V_CODE) AS Vendors,
       MIN(P_PRICE) AS Cheapest, MAX(P_PRICE) AS Dearest,
       SUM(P_PRICE) AS PriceSum, AVG(P_PRICE) AS MeanPrice
FROM product; -- 7,6,3,2,100,237,33.857142857...

SELECT V_CODE, COUNT(*) AS N, AVG(P_PRICE) AS MeanPrice
FROM product WHERE P_PRICE >= 10
GROUP BY V_CODE HAVING COUNT(*) >= 2
ORDER BY MeanPrice DESC, V_CODE; -- 20: 2/30, 30: 2/15.

-- Business question: How many products and what price statistics does each
--   supplier group have, including products without an assigned supplier?
-- TASK 7.4a: show count/min/max/sum/avg for each vendor code including NULL
--   (4 groups). Why can't an arbitrary P_DESCRIPT appear unaggregated?
-- Business question: How many products does every supplier provide,
--   including suppliers with zero products?
-- TASK 7.4b: use LEFT JOIN to show each vendor's product count, including
--   vendor 40 with zero. Compare COUNT(*) with COUNT(p.P_CODE).
-- Business question: What should a negative-price exception report show
--   when no products violate the pricing rule?
-- TASK 7.4c: get all five aggregates for P_PRICE<0 (COUNT=0, others=NULL).
--   Add GROUP BY V_CODE: why are there now zero rows, not one?
-- Business question: When one of three quoted prices is missing, how many
--   quotes are known and what average can purchasing legitimately report?
-- TASK 7.4d: summarize a derived input of prices 2,30,NULL. Compare
--   COUNT(*), COUNT(price), AVG(price), and SUM(price)/COUNT(*).
-- Business question: How many sales lines and distinct nonempty invoices
--   are recorded, and does this count include empty invoices?
-- TASK 7.4e: join invoice/line; compare COUNT(*) (7) and
--   COUNT(DISTINCT INV_NUMBER) (4). Explain the empty invoice's omission.
-- Business question: Which assigned suppliers have an average price of at
--   least $20 when products under $10 are excluded from the calculation?
-- TASK 7.4f: report assigned vendors with mean>=20 AFTER filtering price>=10
--   (10 and 20). Label each clause's input/output grain and explain why
--   WHERE AVG(P_PRICE)>=20 is invalid at this query level.
