-- enrollments
-- Cardinality: many-to-many between students and courses.
--
-- A junction / link table is how SQL stores M:N. Each row is one
-- pairing. The M:N is two 1:N relationships back to back:
--   students 1 ──< enrollments >── 1 courses
--
-- Intentionally sparse:
--   Grace has no rows (student with no courses).
--   MATH999 has no rows (course with no students).
--   Bob's CS490 grade is NULL (in progress).
--   Alice is in three courses; CS101 has three students.

CREATE TABLE enrollments (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    semester TEXT NOT NULL,
    grade TEXT,
    PRIMARY KEY (student_id, course_id, semester),
    FOREIGN KEY (student_id) REFERENCES students (id),
    FOREIGN KEY (course_id) REFERENCES courses (id)
);

INSERT INTO enrollments (student_id, course_id, semester, grade) VALUES
    (1, 1, 'Fall 2025',   'A'),
    (1, 2, 'Spring 2026', 'A'),
    (1, 3, 'Fall 2025',   'B'),
    (2, 1, 'Fall 2025',   'B'),
    (2, 2, 'Spring 2026', 'A'),
    (2, 6, 'Spring 2026', NULL),
    (3, 3, 'Fall 2025',   'A'),
    (3, 4, 'Spring 2026', 'A'),
    (4, 4, 'Spring 2026', 'B'),
    (5, 1, 'Fall 2025',   'C'),
    (5, 5, 'Spring 2026', 'B'),
    (6, 4, 'Spring 2026', 'A'),
    (8, 5, 'Fall 2025',   'A'),
    (8, 3, 'Spring 2026', 'B');
