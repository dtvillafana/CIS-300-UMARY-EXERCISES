# Conference Session Planner — Published Schedule Releases

Extend [Conference Session Planner in Project 1](../project1/11-conference-session-planner.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

The organizer needs versioned schedule publications. Staff may edit a working
schedule, but attendees must see the latest published release, and older
releases must remain reproducible. Registration must now respect offered seats.

## Revised business rules

- Each published program has a release number and publication time and lists
  every session's title, description, start/end, speaker, room, and offered
  capacity. Attendees receive one coherent program, not a mixture of old and
  new session details. The organizer must retain an identical copy of each
  released program to answer questions about schedule changes.
- A release must be nonempty, its session times valid, and capacities positive.
  Sessions in the same room may not overlap within a release. An invalid program
  must not replace the last valid publication, even partially. Release numbers and times
  establish an unambiguous publication order; releases cannot be overwritten.
- Later working-schedule or catalog edits do not change any publication. A
  published session cannot be deleted, but its working details may change for a
  later release. New releases include all sessions, including previously
  published ones. Removing sessions or canceling registrations is outside scope.
- Accept registrations only into sessions in the latest release, before their
  published start, and while seats remain under its captured capacity. Use the
  published schedule, not unpublished edits, for admission. A later release may
  move a session or change its room, but cannot offer fewer seats than its
  existing registrations or move it into the past.
- Registrations are permanent and unique per attendee/session. Their database-
  recorded acceptance times cannot be backdated or edited; this allows accurate
  enrollment counts as of each publication. Existing registrations carry forward
  when a session moves. Attendee conflict enforcement remains outside scope.

## Daily work

The registration desk and program office share the public schedule showing the
latest released details, capacity, current registrations, and remaining seats,
including empty sessions. A booking must affect availability immediately without
republishing the program. Working edits remain private until publication, and
schedule readers cannot edit sessions. Earlier programs remain available for
answering attendee questions.

## Required advanced SQL report

**Publication-to-publication speaker capacity review:** Compare the latest
release with its immediate predecessor. For each speaker appearing in either,
show session count, offered seats, registrations as of publication, and overall
seat-fill percentage for each release, plus the change in offered seats and
percentage-point change in fill. If only one release exists, indicate that no
comparison is available rather than inventing a prior release.

Count registrations accepted at or before each release's publication time. Sum
offered seats once per published session; calculate overall fill from total
registrations divided by total seats, not the mean of session percentages.
Attribute each release's sessions to that release's captured speaker identity.
Include speakers appearing on only one side and empty sessions. This extends
the original capacity report with two historical schedules and time-qualified
registration totals. Adapt the original three reports to the latest publication;
their live registration counts may differ from counts at publication time.

## Evidence to include

Include two releases, a room/capacity change, a changed speaker assignment, a new
session, an empty session, and registrations before and between publications.
Show an unpublished edit remaining invisible to attendees. Reject overlapping
published room use, capacity reductions below enrollment, full-session admission,
backdated registrations, and edits or deletions of publication history.
