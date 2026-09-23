-- FULL OUTER JOIN
-- Keep rows from both sides, whether they match or not.
-- Unmatched left rows get NULL on the right; unmatched right rows get
-- NULL on the left.
--
-- This data set has unmatched rows on BOTH sides of departments <->
-- instructors: Music has no instructor, Jordan has no department.

.headers on
.mode column
.nullvalue NULL

SELECT
    d.name AS department,
    i.first_name || ' ' || i.last_name AS instructor
FROM departments AS d
FULL OUTER JOIN instructors AS i
    ON i.department_id = d.id
ORDER BY department, instructor;

-- 1:1 with unmatched only on the student side (no orphan cards).
-- FULL OUTER JOIN here looks like a LEFT JOIN because every card
-- belongs to a student. That is still a valid 1:1 outer join.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.card_number
FROM students AS s
FULL OUTER JOIN id_cards AS c
    ON c.student_id = s.id
ORDER BY student;
