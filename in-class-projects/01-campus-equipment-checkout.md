# Campus Equipment Checkout

## Your client

A university equipment desk lends cameras, laptops, microphones, and other
equipment to students. Staff need to track who has each item and when it is due.

## What the system must track

- Students and their contact information.
- Employees who process checkouts.
- Equipment items, each with a unique asset number, model, purchase date, and one
  equipment category.
- Checkouts, each with one student, one processing employee, a checkout date, and
  a due date.
- The equipment items included in each checkout. One checkout may contain several
  items, and an item may appear in many checkouts over time.
- A separate return date for each item on a checkout, since students may return
  items at different times. An item not yet returned has no return date.

## Scope and business rules

An equipment item cannot be on two active checkouts at the same time. All items
on one checkout share its due date. Keep completed checkout history. Reservations,
fines, repairs, and purchasing workflows are outside scope.

## Required analytical SQL report

**Equipment demand by category:** For checkouts started during a selected date
range, show one row per equipment category with its name, total item loans, and
number of distinct students who borrowed from it. Sort by total item loans,
highest first, to identify the most-used categories. Count repeated loans of an
item separately, but count a student only once per category. Include at least one
student who borrows multiple
items from the same category in your sample data.

## Additional SQL reports (Complete both)

1. **Overdue equipment:** Show student name and contact information, equipment
   asset number and model, due date, and processing employee for unreturned items
   past their due date.
2. **Student borrowing history:** Show a selected student's checkouts, equipment,
   categories, due dates, and individual return dates.

## Start here

How will your design distinguish an equipment item from the event of borrowing
that item? Where does its return date belong?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
