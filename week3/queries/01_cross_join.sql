-- CROSS JOIN
-- Pair every row on the left with every row on the right.
-- There is no join condition, so the result is a cartesian product.
--
-- 8 students × 7 courses = 56 rows. Almost none of those pairs are real
-- enrollments. That is why INNER / OUTER joins need an ON clause.
--
-- You would almost never run this for answers. It is here to show every
-- possible student–course pairing, then contrast that 56-row dump with
-- the 14 real enrollments.

.headers on
.mode column
.nullvalue NULL

SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.code
FROM students AS s
CROSS JOIN courses AS c
ORDER BY student, c.code;

-- How many pairs the cartesian product produced (should be 8 × 7 = 56).
SELECT COUNT(*) AS cross_join_rows
FROM students
CROSS JOIN courses;

-- How many of those pairs are real enrollments (14). The gap is the point.
SELECT COUNT(*) AS real_enrollment_rows
FROM enrollments;

-- Old-style equivalent: a comma join with no WHERE is also a cross join.
-- Uncomment to compare:
-- SELECT s.last_name, c.code FROM students AS s, courses AS c;
