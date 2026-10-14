-- Run only in a disposable lab DB, from chapters7-8/.
.bail on
.read setup.sql
.headers on
.mode column
.nullvalue NULL
SELECT 'vendor' AS table_name, COUNT(*) AS rows FROM vendor
UNION ALL SELECT 'product', COUNT(*) FROM product
UNION ALL SELECT 'customer', COUNT(*) FROM customer
UNION ALL SELECT 'invoice', COUNT(*) FROM invoice
UNION ALL SELECT 'line', COUNT(*) FROM line
UNION ALL SELECT 'employee', COUNT(*) FROM employee;
