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

-- TASK 7.4a: show count/min/max/sum/avg for each vendor code including NULL
--   (4 groups). Why can't an arbitrary P_DESCRIPT appear unaggregated?
-- TASK 7.4b: use LEFT JOIN to show each vendor's product count, including
--   vendor 40 with zero. Compare COUNT(*) with COUNT(p.P_CODE).
-- TASK 7.4c: get all five aggregates for P_PRICE<0 (COUNT=0, others=NULL).
--   Add GROUP BY V_CODE: why are there now zero rows, not one?
-- TASK 7.4d: summarize a derived input of prices 2,30,NULL. Compare
--   COUNT(*), COUNT(price), AVG(price), and SUM(price)/COUNT(*).
-- TASK 7.4e: join invoice/line; compare COUNT(*) (7) and
--   COUNT(DISTINCT INV_NUMBER) (4). Explain the empty invoice's omission.
-- TASK 7.4f: report assigned vendors with mean>=20 AFTER filtering price>=10
--   (10 and 20). Label each clause's input/output grain and explain why
--   WHERE AVG(P_PRICE)>=20 is invalid at this query level.
