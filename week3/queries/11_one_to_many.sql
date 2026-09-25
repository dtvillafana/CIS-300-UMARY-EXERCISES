-- Cardinality: one-to-many  (departments 1 ──< instructors)
--
-- Starting from the "one" side, a matching "many" fans a parent row
-- out into several result rows. CS has two instructors, so CS appears
-- twice. Music has zero, so a LEFT JOIN keeps it once with NULLs, and
-- an INNER JOIN drops it.

.headers on
.mode column
.nullvalue NULL

-- Table sizes before joining, so you can compare them to the fan-out below.
SELECT COUNT(*) AS department_rows FROM departments;
SELECT COUNT(*) AS instructor_rows FROM instructors;

-- Faculty roster by department (empty departments omitted).
-- INNER JOIN: 5 rows (not 6). Music is gone; Jordan is gone.
-- CS is listed twice — that is the 1:N fan-out.
SELECT
    d.name AS department,
    i.first_name || ' ' || i.last_name AS instructor
FROM departments AS d
INNER JOIN instructors AS i
    ON i.department_id = d.id
ORDER BY department, instructor;

-- Faculty roster by department, keeping empty departments.
-- LEFT JOIN: 6 rows. Music stays, with a NULL instructor.
-- Jordan still does not appear because we started from departments.
SELECT
    d.name AS department,
    i.first_name || ' ' || i.last_name AS instructor
FROM departments AS d
LEFT JOIN instructors AS i
    ON i.department_id = d.id
ORDER BY department, instructor;

-- Teaching assignments: what each instructor teaches, including people
-- with no courses. Emmy Noether teaches MATH210 and MATH999, so she
-- fans out to 2 rows. Jordan teaches none.
SELECT
    i.first_name || ' ' || i.last_name AS instructor,
    c.code
FROM instructors AS i
LEFT JOIN courses AS c
    ON c.instructor_id = i.id
ORDER BY instructor, c.code;
