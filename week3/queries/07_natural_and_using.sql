-- NATURAL JOIN and JOIN ... USING
-- Both are inner joins that match on column *names* instead of an ON
-- clause. They are easy to get wrong, which is the point of this file.

.headers on
.mode column
.nullvalue NULL

-- USING (course_id): same grade list as an INNER JOIN, matching on a
-- shared column name instead of ON. We alias courses.id to course_id
-- so the names line up.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.code,
    e.grade
FROM enrollments AS e
INNER JOIN (
    SELECT id AS course_id, code, title
    FROM courses
) AS c USING (course_id)
INNER JOIN (
    SELECT id AS student_id, first_name, last_name
    FROM students
) AS s USING (student_id)
ORDER BY student, c.code;

-- NATURAL JOIN matches EVERY shared column name — a cautionary example,
-- not something you'd run for answers. students and instructors share
-- id, first_name, and last_name, so this only returns rows where all
-- three are equal — nobody. Empty on purpose.
SELECT
    s.id AS student_id,
    i.id AS instructor_id,
    s.first_name,
    s.last_name
FROM students AS s
NATURAL JOIN instructors AS i;

-- Same enrollment / grade list, with NATURAL JOIN after wrapping the
-- tables so the only shared name is the key you actually want.
SELECT
    student,
    code,
    grade
FROM (
    SELECT student_id, course_id, grade FROM enrollments
) AS e
NATURAL JOIN (
    SELECT id AS student_id, first_name || ' ' || last_name AS student
    FROM students
) AS s
NATURAL JOIN (
    SELECT id AS course_id, code FROM courses
) AS c
ORDER BY student, code;
