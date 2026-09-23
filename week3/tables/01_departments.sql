-- departments
-- Parent table that other tables point at.
--
-- Cardinality (crow's foot):
--   departments 1 ──< instructors     one-to-many
--   departments 1 ──< students        one-to-many  (major)
--   departments 1 ──< courses         one-to-many
--   instructors 1 ──< courses         one-to-many
--   students    1 ── 1 id_cards       one-to-one
--   students    1 ──< students        one-to-many  (mentor / mentee)
--   students    M ──< enrollments >── N courses    many-to-many
--
-- Intentionally sparse:
--   Music has no instructors and no courses, so outer joins can
--   show a department that matches nothing.

CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    building TEXT NOT NULL
);

INSERT INTO departments (id, name, building) VALUES
    (1, 'Computer Science', 'Engineering Hall'),
    (2, 'Mathematics',      'Science Hall'),
    (3, 'English',          'Humanities Hall'),
    (4, 'Music',            'Fine Arts Building'),
    (5, 'Physics',          'Science Hall');
