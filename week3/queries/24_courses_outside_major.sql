-- View: students taking a course outside their major
-- Join students to enrollments to courses, then compare the two
-- department keys. Elena is undeclared (major_id NULL) so she is
-- excluded by the WHERE clause.

.headers on
.mode column
.nullvalue NULL

SELECT
    s.first_name || ' ' || s.last_name AS student,
    major.name AS major,
    c.code,
    c.title,
    course_dept.name AS course_department
FROM students AS s
INNER JOIN enrollments AS e
    ON e.student_id = s.id
INNER JOIN courses AS c
    ON c.id = e.course_id
INNER JOIN departments AS major
    ON major.id = s.major_id
INNER JOIN departments AS course_dept
    ON course_dept.id = c.department_id
WHERE s.major_id <> c.department_id
ORDER BY student, c.code;
