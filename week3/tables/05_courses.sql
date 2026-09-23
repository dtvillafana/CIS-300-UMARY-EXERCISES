-- courses
-- Cardinality:
--   department_id -> departments   many courses to one department  (N:1, required)
--   instructor_id -> instructors   many courses to one instructor  (N:1, optional)
--
-- Intentionally sparse:
--   CS490 has no instructor yet.
--   MATH999 has an instructor but nobody will enroll.
--   Music still has no courses.
--   Emmy Noether teaches two courses (1:N from the instructor side).

CREATE TABLE courses (
    id INTEGER PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    credits INTEGER NOT NULL,
    department_id INTEGER NOT NULL,
    instructor_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments (id),
    FOREIGN KEY (instructor_id) REFERENCES instructors (id)
);

INSERT INTO courses (id, code, title, credits, department_id, instructor_id) VALUES
    (1, 'CS101',   'Intro to Programming', 3, 1, 1),
    (2, 'CS201',   'Data Structures',      3, 1, 2),
    (3, 'MATH210', 'Linear Algebra',       4, 2, 3),
    (4, 'ENG150',  'Creative Writing',     3, 3, 4),
    (5, 'PHYS101', 'Mechanics',            4, 5, 5),
    (6, 'CS490',   'Independent Study',    1, 1, NULL),
    (7, 'MATH999', 'Research Seminar',     1, 2, 3);
