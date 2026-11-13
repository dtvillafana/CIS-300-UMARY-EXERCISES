# Apartment Maintenance Requests — Service Commitments and Work Visits

Extend [Apartment Maintenance Requests in Project 1](../project1/05-apartment-maintenance-requests.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

Issue categories now have a positive target resolution time in hours. Management
wants to preserve the service commitment made when a request arrives, record
technician visits, and issue a completion confirmation.

## Revised business rules

- On submission, the resident receives an acknowledgment identifying the
  building/unit, issue category, supplied resident contact, submission time, and
  promised resolution hours. Management retains the same acknowledgment for
  service complaints. The promise uses the category target at submission; later
  policy changes or renamed buildings cannot change what the resident was told.
  The request's apartment, category, submission time, and supplied resident
  details are fixed after submission; priority and assigned lead may change.
- A request may receive multiple work visits, each by one technician with a
  start time, end time, and notes. Different technicians may visit the same
  request. Visits must start at or after submission and end after they start.
  A technician's visits must not overlap, even on different requests.
- A resident must receive a completion confirmation when a request is closed,
  giving the completion time and responsible lead, or indicating that no lead
  was assigned. Management must retain it unchanged for service reviews.
  Completion cannot precede submission or the end of any recorded visit.
- Completion is final: the request cannot reopen, lose its confirmation, or have
  its completion time, assignment, or work visits changed. Do not add visits to
  completed requests. A request may close without a visit, including while
  unassigned. Open-request visits may be corrected while preserving all rules.
- The deadline is submission time plus the promised hours. Completion exactly
  at the deadline is on time. Technician payroll and parts remain outside scope.

## Daily work

Dispatchers and property managers share a service-status register: each request,
its original promise/deadline, current lead while open, closing lead and completion
time when finished, and total visit hours. Requests with no visits remain visible.
A reassignment or completed visit must be visible immediately, without maintaining
a second register by hand. Reporting staff cannot edit the underlying requests.

## Required advanced SQL report

**Building service reliability and effort:** For requests completed in a selected
period, show one row per historical building/category: completed count, on-time
count and percentage, average elapsed resolution hours, total technician visit
hours, distinct visiting technicians, and percentage of completed requests with
no visits. Include unassigned completions.

Evaluate deadlines using each request's original promise, not today's category
target. Sum actual visit duration, not elapsed request duration; two technicians
working concurrently contribute separate effort. Count each request once even
with several visits. This extends the original resolution report by relating
historical promises to both outcomes and independently recorded effort.

## Evidence to include

Include an open request, a late completion with multiple visits and technicians,
an on-time completion, and a completion without visits. Change a category target
between submissions. Reject overlapping visits for one technician, completion
before a visit ends, changes to commitments, and post-completion work edits.
