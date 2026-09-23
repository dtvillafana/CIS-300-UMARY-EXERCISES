-- Self-join
-- Join a table to itself. Needed when a row points at another row in
-- the same table.
--
-- Cardinality here: one mentor to many mentees  (1:N on students).
-- Alice mentors Bob, Carol, and Grace. Diego mentors Elena.
-- The other students have no mentor.

.headers on
.mode column
.nullvalue NULL

-- INNER JOIN: only students who have a mentor.
SELECT
    mentee.first_name || ' ' || mentee.last_name AS mentee,
    mentor.first_name || ' ' || mentor.last_name AS mentor
FROM students AS mentee
INNER JOIN students AS mentor
    ON mentee.mentor_id = mentor.id
ORDER BY mentor, mentee;

-- LEFT JOIN: every student, including those with no mentor.
SELECT
    mentee.first_name || ' ' || mentee.last_name AS student,
    mentor.first_name || ' ' || mentor.last_name AS mentor
FROM students AS mentee
LEFT JOIN students AS mentor
    ON mentee.mentor_id = mentor.id
ORDER BY student;

-- Flip it: each mentor with their mentees (1:N fan-out).
-- Students who are not mentors disappear on an INNER JOIN.
SELECT
    mentor.first_name || ' ' || mentor.last_name AS mentor,
    mentee.first_name || ' ' || mentee.last_name AS mentee
FROM students AS mentor
INNER JOIN students AS mentee
    ON mentee.mentor_id = mentor.id
ORDER BY mentor, mentee;
