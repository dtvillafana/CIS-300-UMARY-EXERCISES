-- 7.5 Goal: choose scalar/list/table results and recognize correlation.
SELECT P_CODE, P_PRICE FROM product
WHERE P_PRICE > (SELECT AVG(P_PRICE) FROM product)
ORDER BY P_CODE; -- P2,P4; scalar mean 237/7.
SELECT v.V_CODE, v.V_NAME FROM vendor AS v
WHERE EXISTS (SELECT 1 FROM product AS p WHERE p.V_CODE = v.V_CODE)
ORDER BY v.V_CODE; -- 10,20,30 once each.

-- TASK 7.5a: IN subquery: products whose vendors are in TN (4).
-- TASK 7.5b: HAVING subquery: vendor groups with mean above overall mean
--   (only NULL group, mean 100). Why does V_CODE=10 fail at 23.5?
-- TASK 7.5c: FROM subquery: derive vendor/count/mean, then filter mean>20
--   (NULL,10,20). Give the derived table an alias.
-- TASK 7.5d: attribute-list subquery: display every price minus overall
--   mean, rounded to two places (P2 difference 11.14).
-- TASK 7.5e: correlated subquery: products above THEIR vendor's mean
--   (P2,P5). Explain why NULL vendor P4 does not match q.V_CODE=p.V_CODE.
-- TASK 7.5f: NOT EXISTS: vendors with no products (40). Compare with
--   NOT IN(SELECT V_CODE FROM product): NULL makes that return no rows.
-- TASK 7.5g: demonstrate zero-row scalar result (NULL). In Oracle, a
--   multirow scalar is an error; SQLite instead takes its first row.
--   Why must portable scalar queries guarantee at most one row?
-- DIALECT TASK: complete oracle/01_dialects.sql for > ALL, > ANY/SOME,
--   = ANY, empty sets, and NULLs. SQLite has no ALL/ANY comparison syntax.
-- REFLECT: "inner query first"/"once per row" are reasoning models, not
--   promises about the optimizer's physical execution order.
