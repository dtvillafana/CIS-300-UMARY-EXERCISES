-- View: unmatched rows  (anti-join)
-- A LEFT JOIN plus WHERE right.id IS NULL finds rows with no match.
-- This is how you ask "who has none of X?" — gaps such as missing
-- cards, students with no schedule, empty courses, idle instructors.

.headers on
.mode column
.nullvalue NULL

SELECT 'students with no id card' AS who;
SELECT s.first_name || ' ' || s.last_name AS student
FROM students AS s
LEFT JOIN id_cards AS c
    ON c.student_id = s.id
WHERE c.id IS NULL
ORDER BY student;

SELECT 'students with no enrollments' AS who;
SELECT s.first_name || ' ' || s.last_name AS student
FROM students AS s
LEFT JOIN enrollments AS e
    ON e.student_id = s.id
WHERE e.student_id IS NULL
ORDER BY student;

SELECT 'courses with no students' AS who;
SELECT c.code, c.title
FROM courses AS c
LEFT JOIN enrollments AS e
    ON e.course_id = c.id
WHERE e.course_id IS NULL
ORDER BY c.code;

SELECT 'instructors with no courses' AS who;
SELECT i.first_name || ' ' || i.last_name AS instructor
FROM instructors AS i
LEFT JOIN courses AS c
    ON c.instructor_id = i.id
WHERE c.id IS NULL
ORDER BY instructor;

SELECT 'departments with no instructors' AS who;
SELECT d.name AS department
FROM departments AS d
LEFT JOIN instructors AS i
    ON i.department_id = d.id
WHERE i.id IS NULL
ORDER BY department;
