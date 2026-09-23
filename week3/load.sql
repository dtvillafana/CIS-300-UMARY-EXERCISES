-- Rebuild demo.sqlite3 from the table files.
-- Run this from the sqlite-demo directory:
--
--   sqlite3 demo.sqlite3 ".read load.sql"
--
-- Then run any query file the same way:
--
--   sqlite3 demo.sqlite3 ".read queries/02_inner_join.sql"
--
-- Join types live in queries/01 through 08.
-- Cardinalities live in queries/10 through 13.

PRAGMA foreign_keys = ON;

.read 00_reset.sql
.read tables/01_departments.sql
.read tables/02_instructors.sql
.read tables/03_students.sql
.read tables/04_id_cards.sql
.read tables/05_courses.sql
.read tables/06_enrollments.sql

.headers on
.mode column
.nullvalue NULL

SELECT 'departments' AS table_name, COUNT(*) AS rows FROM departments
UNION ALL
SELECT 'instructors', COUNT(*) FROM instructors
UNION ALL
SELECT 'students', COUNT(*) FROM students
UNION ALL
SELECT 'id_cards', COUNT(*) FROM id_cards
UNION ALL
SELECT 'courses', COUNT(*) FROM courses
UNION ALL
SELECT 'enrollments', COUNT(*) FROM enrollments;
