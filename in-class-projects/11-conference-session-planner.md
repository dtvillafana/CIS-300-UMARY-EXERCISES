# Conference Session Planner

## Your client

A conference organizer needs to publish a schedule, register attendees for
sessions, and compare session enrollment with room capacity.

## What the system must track

- Speakers and their contact information.
- Rooms, each with a name and seating capacity.
- Sessions, each with a title, description, start date and time, end date and
  time, one room, and one primary speaker.
- Attendees and their contact information.
- Registrations connecting attendees to sessions, including registration date.

## Scope and business rules

This system manages one conference. A speaker may present several sessions, and a
room may host several sessions at different times. An attendee may register for
many sessions but only once for a particular session. Sessions in the same room
must not overlap. Registration cancellations, waitlists, payments, multiple
speakers per session, and attendee scheduling-conflict enforcement are outside
scope. Use capacity reports to identify full or overbooked sessions.

## Suggested SQL reports

1. **Personalized schedule:** Show a selected attendee's sessions in time order,
   including titles, start and end times, rooms, and speakers.
2. **Capacity review:** Show every session's speaker, room, capacity, registration
   count, and remaining seats, including sessions with no registrations. Negative
   remaining seats indicate overbooking.
3. **Speaker enrollment summary:** Show each speaker's session count and total
   session registrations. An attendee registered for two sessions counts twice
   in this registration total.

## Start here

Where does a registration date belong? How can your capacity report include a
session that has no registered attendees?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
