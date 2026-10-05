-- Fan trap: two independent 1:N relationships share a parent.
--   students N >── 1 departments 1 ──< N courses
-- A student's major and a course's department do NOT establish enrollment.
-- Joining these branches pairs every major with every departmental course.
-- Fix: use the existing intermediary (junction) table, enrollments:
--   students 1 ──< enrollments >── 1 courses
-- No tables or data need to be changed.

.headers on
.mode column
.nullvalue NULL

-- WRONG for a roster: 9 purported CS enrollments (3 majors × 3 courses).
-- Grace appears in all three courses despite having no enrollments;
-- Alice appears in CS490 even though she never enrolled in it.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    d.name AS major,
    c.code AS assumed_course
FROM students AS s
INNER JOIN departments AS d
    ON d.id = s.major_id
INNER JOIN courses AS c
    ON c.department_id = d.id
WHERE d.name = 'Computer Science'
ORDER BY student, c.code;

-- CORRECT: join through enrollments to find actual student–course pairs.
-- Keep the same scope: CS majors enrolled in CS courses. Only 5 rows.
-- Grace is absent, and only Bob is enrolled in CS490.
-- DISTINCT on the wrong query cannot fix the invented relationships.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    d.name AS major,
    c.code AS enrolled_course,
    e.semester
FROM students AS s
INNER JOIN departments AS d
    ON d.id = s.major_id
INNER JOIN enrollments AS e
    ON e.student_id = s.id
INNER JOIN courses AS c
    ON c.id = e.course_id
WHERE d.name = 'Computer Science'
    AND c.department_id = d.id
ORDER BY student, c.code, e.semester;
