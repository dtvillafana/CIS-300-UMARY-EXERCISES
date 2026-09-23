-- View: class roster
-- For each course, who is enrolled and who teaches it.
-- Uses INNER JOIN for students (only real enrollments) and LEFT JOIN
-- for instructor so CS490 still appears if someone is in it.

.headers on
.mode column
.nullvalue NULL

SELECT
    c.code,
    c.title,
    s.first_name || ' ' || s.last_name AS student,
    e.semester,
    e.grade,
    i.last_name AS instructor
FROM courses AS c
INNER JOIN enrollments AS e
    ON e.course_id = c.id
INNER JOIN students AS s
    ON s.id = e.student_id
LEFT JOIN instructors AS i
    ON i.id = c.instructor_id
ORDER BY c.code, student;
