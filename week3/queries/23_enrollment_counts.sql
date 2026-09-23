-- View: counts that depend on join cardinality
-- LEFT JOIN + GROUP BY keeps zeros. INNER JOIN + GROUP BY hides them.

.headers on
.mode column
.nullvalue NULL

-- Students per course, including MATH999 with 0.
SELECT
    c.code,
    c.title,
    COUNT(e.student_id) AS enrolled
FROM courses AS c
LEFT JOIN enrollments AS e
    ON e.course_id = c.id
GROUP BY c.id, c.code, c.title
ORDER BY enrolled DESC, c.code;

-- Courses per student, including Grace with 0.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    COUNT(e.course_id) AS courses
FROM students AS s
LEFT JOIN enrollments AS e
    ON e.student_id = s.id
GROUP BY s.id, s.first_name, s.last_name
ORDER BY courses DESC, student;

-- Instructors per department, including Music with 0.
SELECT
    d.name AS department,
    COUNT(i.id) AS instructors
FROM departments AS d
LEFT JOIN instructors AS i
    ON i.department_id = d.id
GROUP BY d.id, d.name
ORDER BY instructors DESC, department;

-- Same count with INNER JOIN: Music disappears instead of showing 0.
SELECT
    d.name AS department,
    COUNT(i.id) AS instructors
FROM departments AS d
INNER JOIN instructors AS i
    ON i.department_id = d.id
GROUP BY d.id, d.name
ORDER BY instructors DESC, department;
