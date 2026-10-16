-- View: student transcripts
-- Business question: What course, credits, semester, grade, major, and
-- instructor belong on each student's recorded transcript? Retain undeclared
-- students and missing instructors, but omit students with no enrollments.
-- One row per enrollment, with major, course, instructor, and grade.
-- LEFT JOIN major and instructor so undeclared students and CS490 still
-- print. Grace has no enrollments, so she is absent (inner on enrollments).

.headers on
.mode column
.nullvalue NULL

SELECT
    s.first_name || ' ' || s.last_name AS student,
    major.name AS major,
    c.code,
    c.title,
    c.credits,
    e.semester,
    e.grade,
    i.first_name || ' ' || i.last_name AS instructor
FROM students AS s
INNER JOIN enrollments AS e
    ON e.student_id = s.id
INNER JOIN courses AS c
    ON c.id = e.course_id
LEFT JOIN departments AS major
    ON major.id = s.major_id
LEFT JOIN instructors AS i
    ON i.id = c.instructor_id
ORDER BY student, e.semester, c.code;
