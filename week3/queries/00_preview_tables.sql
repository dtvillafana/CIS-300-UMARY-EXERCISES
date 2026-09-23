-- Look at every table by itself before joining anything.
-- Run this first so the later join results make sense.
--
--   sqlite3 demo.sqlite3 ".read queries/00_preview_tables.sql"

.headers on
.mode column
.nullvalue NULL

SELECT '=== departments (5 rows; Music has no people/courses) ===' AS preview;
SELECT * FROM departments;

SELECT '=== instructors (6 rows; Jordan has no department) ===' AS preview;
SELECT * FROM instructors;

SELECT '=== students (8 rows; Elena undeclared, Grace never enrolls) ===' AS preview;
SELECT * FROM students;

SELECT '=== id_cards (5 rows; 1:1 with students, 3 students have none) ===' AS preview;
SELECT * FROM id_cards;

SELECT '=== courses (7 rows; CS490 has no instructor, MATH999 has no students) ===' AS preview;
SELECT * FROM courses;

SELECT '=== enrollments (14 rows; the M:N link table) ===' AS preview;
SELECT * FROM enrollments;
