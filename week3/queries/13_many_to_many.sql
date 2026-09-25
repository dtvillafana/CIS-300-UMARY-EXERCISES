-- Cardinality: many-to-many  (students M ──< enrollments >── N courses)
--
-- SQL has no direct M:N join. You store it as a link table and join
-- twice. Both sides can fan out:
--   Alice appears 3 times (three courses).
--   CS101 appears 3 times (three students).
--   Grace does not appear on INNER JOIN (no link rows).
--   MATH999 does not appear on INNER JOIN (no link rows).

.headers on
.mode column
.nullvalue NULL

-- Table sizes before joining. The inner M:N result should match enrollment_rows,
-- not student_rows × course_rows.
SELECT COUNT(*) AS student_rows FROM students;
SELECT COUNT(*) AS course_rows FROM courses;
SELECT COUNT(*) AS enrollment_rows FROM enrollments;

-- Who is enrolled in what: the actual student–course pairs. 14 rows.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.code,
    c.title,
    e.semester,
    e.grade
FROM students AS s
INNER JOIN enrollments AS e
    ON e.student_id = s.id
INNER JOIN courses AS c
    ON c.id = e.course_id
ORDER BY student, e.semester, c.code;

-- Each student's schedule, including students with none (Grace).
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

-- Each course's roster, including courses with nobody in them (MATH999).
SELECT
    c.code,
    s.first_name || ' ' || s.last_name AS student,
    e.grade
FROM courses AS c
LEFT JOIN enrollments AS e
    ON e.course_id = c.id
LEFT JOIN students AS s
    ON s.id = e.student_id
ORDER BY c.code, student;
