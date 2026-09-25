-- RIGHT OUTER JOIN  (RIGHT JOIN)
-- Keep every row from the right table. If the left side has no match,
-- left-hand columns are NULL.
--
-- A RIGHT JOIN is just a LEFT JOIN with the tables swapped. SQLite
-- supports it; many people still write LEFT JOIN only.
-- You'd use this when the table you must keep is written on the right.

.headers on
.mode column
.nullvalue NULL

-- Faculty by department, including empty departments (Music).
-- Same question as the department-left query in 03_left_join.sql,
-- written from the other side.
SELECT
    i.first_name || ' ' || i.last_name AS instructor,
    d.name AS department
FROM instructors AS i
RIGHT JOIN departments AS d
    ON i.department_id = d.id
ORDER BY department, instructor;

-- Course catalog with who is in each class, including courses with
-- nobody enrolled (MATH999). CS490 appears with a student (Bob) but
-- that is coincidental; the right table is courses, so unmatched
-- courses still show up.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.code,
    e.grade
FROM enrollments AS e
RIGHT JOIN courses AS c
    ON e.course_id = c.id
LEFT JOIN students AS s
    ON s.id = e.student_id
ORDER BY c.code, student;

-- Equivalent LEFT JOIN (tables swapped). Uncomment and compare:
-- SELECT
--     i.first_name || ' ' || i.last_name AS instructor,
--     d.name AS department
-- FROM departments AS d
-- LEFT JOIN instructors AS i
--     ON i.department_id = d.id;
