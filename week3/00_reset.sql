-- Wipe the demo tables so you can rebuild from scratch.
--
--   sqlite3 demo.sqlite3 ".read 00_reset.sql"
--
-- Foreign keys are turned off only while dropping, so the tables can
-- be removed in any order.

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS id_cards;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS departments;

PRAGMA foreign_keys = ON;
