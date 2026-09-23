-- ON vs WHERE with a LEFT JOIN
-- Filters in ON happen while matching. Filters in WHERE happen after
-- the join, and will throw away unmatched left rows (turning a LEFT
-- JOIN into an INNER JOIN by accident).

.headers on
.mode column
.nullvalue NULL

-- Filter in ON: every student, but only attach enrollments that earned an A.
-- Grace still appears (no enrollments). Bob's B in CS101 does not.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.code,
    e.grade
FROM students AS s
LEFT JOIN enrollments AS e
    ON e.student_id = s.id
    AND e.grade = 'A'
LEFT JOIN courses AS c
    ON c.id = e.course_id
ORDER BY student, c.code;

-- Filter in WHERE: only rows whose enrollment grade is A.
-- Grace disappears. Anyone whose only grades are B/C disappears too.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.code,
    e.grade
FROM students AS s
LEFT JOIN enrollments AS e
    ON e.student_id = s.id
LEFT JOIN courses AS c
    ON c.id = e.course_id
WHERE e.grade = 'A'
ORDER BY student, c.code;
