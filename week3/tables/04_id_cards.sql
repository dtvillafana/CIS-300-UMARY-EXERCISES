-- id_cards
-- Cardinality: one student to one card  (1:1, optional)
--
-- Enforced by UNIQUE(student_id): a student can have at most one card,
-- and each card belongs to exactly one student.
--
-- Intentionally sparse:
--   Elena, Farid, and Grace have no card yet.
--   Joining students to id_cards therefore never duplicates a student;
--   unmatched students just get NULL card columns on a LEFT JOIN.

CREATE TABLE id_cards (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL UNIQUE,
    card_number TEXT NOT NULL UNIQUE,
    issued_on TEXT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students (id)
);

INSERT INTO id_cards (id, student_id, card_number, issued_on) VALUES
    (1, 1, 'W-1001', '2024-08-15'),
    (2, 2, 'W-1002', '2024-08-15'),
    (3, 3, 'W-1003', '2024-08-16'),
    (4, 4, 'W-1004', '2025-01-10'),
    (5, 8, 'W-1008', '2024-08-15');
