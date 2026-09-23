-- Cardinality: many-to-one  (instructors >── 1 departments)
--
-- This is the same relationship as 11_one_to_many.sql, read from the
-- child side. Each instructor contributes at most one row. The parent
-- value (department name) repeats when several children share it.

.headers on
.mode column
.nullvalue NULL

-- INNER JOIN: 5 instructors who have a department.
-- Computer Science repeats for Ada and Alan. Jordan is dropped.
SELECT
    i.first_name || ' ' || i.last_name AS instructor,
    d.name AS department,
    d.building
FROM instructors AS i
INNER JOIN departments AS d
    ON i.department_id = d.id
ORDER BY department, instructor;

-- LEFT JOIN: all 6 instructors. Jordan's department columns are NULL.
-- Row count stays 6 — N:1 does not fan out.
SELECT
    i.first_name || ' ' || i.last_name AS instructor,
    d.name AS department
FROM instructors AS i
LEFT JOIN departments AS d
    ON i.department_id = d.id
ORDER BY instructor;

SELECT COUNT(*) AS instructor_rows FROM instructors;

SELECT COUNT(*) AS left_join_rows
FROM instructors AS i
LEFT JOIN departments AS d
    ON i.department_id = d.id;

-- Another N:1: students to their major. Elena has none.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    d.name AS major
FROM students AS s
LEFT JOIN departments AS d
    ON s.major_id = d.id
ORDER BY student;
