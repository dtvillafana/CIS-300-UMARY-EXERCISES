-- LEFT OUTER JOIN  (LEFT JOIN)
-- Keep every row from the left table. If the right side has no match,
-- right-hand columns are NULL.
--
-- Compare with 02_inner_join.sql: the extra rows here are the unmatched
-- left rows (Jordan, Elena, Grace, Music, MATH999, ...).

.headers on
.mode column
.nullvalue NULL

-- N:1 optional: full instructor directory, including people not yet
-- assigned to a department (Jordan).
SELECT
    i.first_name || ' ' || i.last_name AS instructor,
    d.name AS department
FROM instructors AS i
LEFT JOIN departments AS d
    ON i.department_id = d.id
ORDER BY instructor;

-- 1:N: faculty by department, including empty departments (Music).
-- CS appears twice because it has two instructors (the 1:N fan-out).
SELECT
    d.name AS department,
    i.first_name || ' ' || i.last_name AS instructor
FROM departments AS d
LEFT JOIN instructors AS i
    ON i.department_id = d.id
ORDER BY department, instructor;

-- 1:1 optional: ID-card status for every student.
-- NULL card columns mean that student still needs a card.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.card_number
FROM students AS s
LEFT JOIN id_cards AS c
    ON c.student_id = s.id
ORDER BY student;

-- 1:N into the link table: each student's courses, including students
-- who have not enrolled (Grace).
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
