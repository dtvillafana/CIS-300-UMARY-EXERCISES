-- Cardinality: one-to-one  (students 1 ── 1 id_cards)
--
-- UNIQUE(student_id) means a student has at most one card, and each
-- card belongs to one student. Joining never duplicates a student.
-- The relationship is optional: 3 of 8 students have no card.

.headers on
.mode column
.nullvalue NULL

SELECT COUNT(*) AS student_rows FROM students;
SELECT COUNT(*) AS card_rows FROM id_cards;

-- INNER JOIN: only the 5 students who have a card. Still 5 rows, not more.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.card_number,
    c.issued_on
FROM students AS s
INNER JOIN id_cards AS c
    ON c.student_id = s.id
ORDER BY student;

SELECT COUNT(*) AS inner_join_rows
FROM students AS s
INNER JOIN id_cards AS c
    ON c.student_id = s.id;

-- LEFT JOIN: all 8 students. Extra rows are unmatched, not duplicates.
SELECT
    s.first_name || ' ' || s.last_name AS student,
    c.card_number
FROM students AS s
LEFT JOIN id_cards AS c
    ON c.student_id = s.id
ORDER BY student;

SELECT COUNT(*) AS left_join_rows
FROM students AS s
LEFT JOIN id_cards AS c
    ON c.student_id = s.id;
