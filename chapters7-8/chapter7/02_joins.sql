-- 7.2 Goal: match declared keys; predict preserved rows and output grain.
SELECT p.P_CODE, p.P_DESCRIPT, v.V_NAME
FROM product AS p INNER JOIN vendor AS v ON p.V_CODE = v.V_CODE
ORDER BY p.P_CODE; -- 6 product/vendor rows, not 3 vendor rows.

SELECT P_CODE, V_CODE, V_NAME FROM product JOIN vendor USING (V_CODE)
ORDER BY P_CODE;
SELECT P_CODE, V_CODE, V_NAME FROM product NATURAL JOIN vendor
ORDER BY P_CODE; -- Safe ONLY because V_CODE is the sole shared name.

SELECT p.P_CODE, v.V_CODE, v.V_NAME
FROM product AS p FULL OUTER JOIN vendor AS v ON p.V_CODE = v.V_CODE
ORDER BY p.P_CODE, v.V_CODE; -- 8: six matches + P4 + vendor 40.

SELECT e.EMP_NUM, e.EMP_LNAME, m.EMP_LNAME AS ManagerName
FROM employee AS e LEFT JOIN employee AS m ON e.EMP_MGR = m.EMP_NUM
ORDER BY e.EMP_NUM; -- 4, including the top-level manager.

-- TASK 7.2a: LEFT JOIN: list every product, with vendor contact, area code,
--   phone, and state where available (7 rows; P4 vendor fields NULL).
-- TASK 7.2b: RIGHT JOIN: preserve all vendors (7 rows, including vendor 40).
-- TASK 7.2c: CROSS JOIN products/vendors; predict count BEFORE running (28).
--   Compare NATURAL JOIN product/customer: no shared names, also 28 rows.
-- TASK 7.2d: join line/product ON their codes and show invoice, line number,
--   description, units, and sale price (7). Why not use current P_PRICE?
-- TASK 7.2e: change the self-join to INNER JOIN (3 rows). Find Dee's direct
--   manager; explain why this query does not also retrieve Ana as ancestor.
-- TASK 7.2f: compare a LEFT JOIN with v.V_STATE='TN' in ON (7) versus
--   WHERE (4). Which retains every product? Explain NULL-rejecting filters.
-- TASK 7.2g: use a derived vendor table renaming V_CODE to SupplierID;
--   join using ON. Why can't USING(V_CODE) work with that source?
-- REFLECT: if both tables acquired another same-named column, what would
--   NATURAL JOIN do? Which syntax records the intended linking attribute?
