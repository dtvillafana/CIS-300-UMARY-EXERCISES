-- students
-- Cardinality:
--   major_id  -> departments   many students to one department  (N:1, optional)
--   mentor_id -> students      many mentees to one mentor       (N:1 self-ref)
--
-- Intentionally sparse:
--   Elena has no major (undeclared).
--   Grace is a CS major but will not enroll in any course.
--   Only some students have a mentor.

CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    major_id INTEGER,
    mentor_id INTEGER,
    FOREIGN KEY (major_id) REFERENCES departments (id),
    FOREIGN KEY (mentor_id) REFERENCES students (id)
);

INSERT INTO students (id, first_name, last_name, major_id, mentor_id) VALUES
    (1, 'Alice', 'Chen',     1,    NULL),
    (2, 'Bob',   'Martinez', 1,    1),
    (3, 'Carol', 'Singh',    2,    1),
    (4, 'Diego', 'Patel',    3,    NULL),
    (5, 'Elena', 'Rossi',    NULL, 4),
    (6, 'Farid', 'Hassan',   4,    NULL),
    (7, 'Grace', 'Kim',      1,    1),
    (8, 'Hiro',  'Tanaka',   5,    NULL);
