# Employee Training Tracker

## Your client

A company wants to track employee training participation and completion. Managers
need to see training hours and review session rosters.

## What the system must track

- Departments, each with a name.
- Employees and their contact information, each belonging to one current department.
- Courses, each with a title, description, and number of training hours.
- Instructors and their contact information, maintained separately from employees.
- Scheduled course sessions, each for one course with one instructor and a
  session date.
- Employee enrollments in sessions, with enrollment date, completion status, and
  a score when applicable.

## Scope and business rules

A course may have several sessions. Each session is a complete offering of the
course on one date. Employees may enroll in many sessions but only once in a
particular session. Only completed enrollments earn the course's training hours.
Scores range from 0 to 100 when recorded. Reports use employees' current
departments; department transfer history and instructor payroll are outside scope.

## Required analytical SQL report

**Department training outcomes:** For sessions occurring during a selected date
range, show one row per current department with its name, total enrollment count,
completed enrollment count, and total completed training hours. Sort by completed
training hours, highest first, to compare department training activity. Count hours
only for completed enrollments. Include only departments with enrollments in the
date range, displaying zero completed hours if none were completed. Sample data
must include completed and incomplete enrollments, a department with no completed
enrollments, and courses with different training-hour values.

## Additional SQL reports (Complete both)

1. **Employee training hours:** Show total completed training hours by employee
   and current department during a selected session date range.
2. **Session roster:** Show a session's course, instructor, enrolled employees,
   departments, completion statuses, and scores.

## Start here

Does a score describe an employee, a course, or a particular enrollment? How will
you distinguish an incomplete course from a completed course without a score?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
