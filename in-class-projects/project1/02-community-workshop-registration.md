# Community Workshop Registration

## Your client

A community center offers workshops such as pottery, photography, and basic
programming. Staff need to schedule offerings, register participants, and review
attendance and fees.

## What the system must track

- Workshops, each with a title, description, and standard registration fee.
- Scheduled sessions of each workshop. A session has a date, start time, end time,
  one instructor, and one room.
- Instructors and their contact information.
- Rooms, each with a name and seating capacity.
- Participants and their contact information.
- Registrations connecting participants to sessions, including registration date,
  attendance status, and fee actually charged.

## Scope and business rules

A workshop may have many sessions. Participants may register for multiple sessions
but only once for a particular session. Each session is a single meeting, not a
series of meetings. Discounts may make a registration's fee different from the
workshop's current standard fee. Payment processing and instructor payroll are
outside scope.

## Required analytical SQL report

**Workshop registration performance:** For sessions occurring during a selected
month, show one row per workshop with its title, registration count, total fees
charged, and average fee per registration. Sort by registration count, highest
first, to compare workshop demand.
Include only workshops with registrations in that month. In your sample data,
include registrations across multiple sessions of the same workshop and at least
one discounted registration. Use fees actually charged, not current standard fees.

## Additional SQL reports (Complete both)

1. **Session roster:** List a selected session's workshop, instructor, room,
   participants, and attendance statuses.
2. **Room capacity review:** Show each session's workshop, room capacity,
   registration count, and remaining seats, including sessions with no registrations.

## Start here

What is the difference between a workshop and a scheduled session? Which facts
depend on the participant's registration rather than on the workshop itself?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
