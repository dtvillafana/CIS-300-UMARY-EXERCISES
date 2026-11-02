# Apartment Maintenance Requests

## Your client

A property manager oversees several apartment buildings. Staff need to record
maintenance problems, assign technicians, and monitor unresolved work.

## What the system must track

- Buildings, each with a name and address.
- Apartments within each building, with a unit number and bedroom count.
- Issue categories, such as plumbing, electrical, and heating.
- Technicians and their contact information.
- Maintenance requests, each concerning one apartment and one issue category,
  with a description, submission date, priority, and optional completion date.
- The reporting resident's name and contact information as supplied for that
  request, plus the technician assigned to it, if any.

## Scope and business rules

Unit numbers are unique within a building, not across all buildings. A request
may be unassigned or assigned to one technician. A technician may handle many
requests. No completion date means the request is still open. Resident details
are a snapshot supplied with the request, not a resident directory. Lease
management, technician teams, work logs, and parts inventory are outside scope.

## Suggested SQL reports

1. **Open work list:** Show open requests by building, including apartment,
   category, priority, submission date, and technician. Include unassigned requests.
2. **Resolution summary:** Show completed request counts and average elapsed days
   from submission to completion by technician and issue category.
3. **Building issue summary:** Count requests by building and category for a
   selected submission date range.

## Start here

Would unit number alone identify an apartment? How will an unassigned request
appear in a report that also displays technician information?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
