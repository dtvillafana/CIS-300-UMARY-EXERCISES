-- LEFT OUTER JOIN  (LEFT JOIN)
-- Keep every row from the left table. If the right side has no match,
-- right-hand columns are NULL.
--
-- Compare with 02_inner_join.sql: the extra rows here are the unmatched
-- left rows (Jordan, Elena, Grace, Music, MATH999, ...).

.headers on
.mode column
.nullvalue NULL

-- N:1 optional: every instructor, even Jordan who has no department.
SELECT
    i.first_name || ' ' || i.last_name AS instructor,
    d.name AS department
FROM instructors AS i
LEFT JOIN departments AS d
    ON i.department_id = d.id
ORDER BY instructor;

-- 1:N: every department, even Music which has no instructors.
-- CS appears twice because it has two instructors (the 1:N fan-out).
SELECT
    d.name AS department,
    i.first_name || ' ' || i.last_name AS instructor
FROM departments AS d
LEFT JOIN instructors AS i
    ON i.department_id = d.id
ORDER BY department, instructor;

-- 1:1 optional: every student, with NULL card columns when none exists.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.card_number
FROM students AS s
LEFT JOIN id_cards AS c
    ON c.student_id = s.id
ORDER BY student;

-- 1:N into the link table: every student, including Grace (no courses).
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.code,
    e.grade
FROM students AS s
LEFT JOIN enrollments AS e
    ON e.student_id = s.id
LEFT JOIN courses AS c
    ON c.id = e.course_id
ORDER BY student, c.code;
