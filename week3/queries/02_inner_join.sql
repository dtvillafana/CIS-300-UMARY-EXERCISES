-- INNER JOIN
-- Keep only rows that have a match on both sides.
-- Unmatched rows disappear: Jordan (no dept), Music (no instructors),
-- Elena (no major) will not show up in these results.

.headers on
.mode column
.nullvalue NULL

-- N:1  instructors -> departments
-- Jordan is dropped because department_id is NULL.
SELECT
    i.first_name || ' ' || i.last_name AS instructor,
    d.name AS department
FROM instructors AS i
INNER JOIN departments AS d
    ON i.department_id = d.id
ORDER BY department, instructor;

-- 1:1  students -> id_cards
-- Elena, Farid, and Grace are dropped because they have no card.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.card_number
FROM students AS s
INNER JOIN id_cards AS c
    ON c.student_id = s.id
ORDER BY student;

-- M:N  students <-> courses, through the enrollments link table
-- Grace is dropped (no enrollments). MATH999 is dropped (no enrollments).
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.code,
    e.semester,
    e.grade
FROM students AS s
INNER JOIN enrollments AS e
    ON e.student_id = s.id
INNER JOIN courses AS c
    ON c.id = e.course_id
ORDER BY student, e.semester, c.code;
