-- instructors
-- Cardinality: many instructors to one department  (N:1)
--              one department to many instructors  (1:N, the other direction)
--
-- department_id is nullable, so this N:1 is optional.
--
-- Intentionally sparse:
--   Jordan Lee has no department.
--   Music has no instructors.

CREATE TABLE instructors (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments (id)
);

INSERT INTO instructors (id, first_name, last_name, department_id) VALUES
    (1, 'Ada',     'Lovelace', 1),
    (2, 'Alan',    'Turing',   1),
    (3, 'Emmy',    'Noether',  2),
    (4, 'Maya',    'Angelou',  3),
    (5, 'Richard', 'Feynman',  5),
    (6, 'Jordan',  'Lee',      NULL);
