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

CREATE TABLE instructors (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments (id)
);

INSERT INTO instructors (first_name, last_name, department_id)
VALUES
    ('Ada',     'Lovelace', 1),
    ('Alan',    'Turing',   1),
    ('Emmy',    'Noether',  2),
    ('Maya',    'Angelou',  3),
    ('Richard', 'Feynman',  5),
    ('Jordan',  'Lee',      NULL);
	
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
