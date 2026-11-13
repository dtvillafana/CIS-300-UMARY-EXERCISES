# Employee Training Tracker — Department History and Completion Certificates

Extend [Employee Training Tracker in Project 1](../project1/07-employee-training-tracker.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

Employees can transfer departments, and course hours can change for future
offerings. Managers need certificates that preserve earned credit and reports
that distinguish the department at training time from the current department.

## Revised business rules

- Maintain dated department assignments for each employee. Intervals include
  their start and exclude their end; an open-ended assignment has no end.
  Assignments may not overlap. Every enrollment must have exactly one covering
  assignment on its session date. Existing current-department information must
  agree with history, or be derived from it rather than maintained independently.
- A transfer must close the prior assignment and open the next without breaking
  coverage of existing enrollments. Assignment corrections must not change the
  historical department of certified training. Future-dated transfers are outside
  scope; document the reference date used to identify the current department.
- Completing training entitles the employee to a certificate immediately, without
  another application. It states employee, course, session date, instructor,
  department on the session date, credited hours, score if supplied, and date of
  issue. HR must be able to reproduce the same certificate after a transfer,
  course revision, or name change. Completion cannot precede the
  session. Use course hours in effect at completion; later edits do not change
  credit already awarded. Hours must be positive, scores 0–100 when present.
- A certificate is issued once per enrollment. Certified completion, score,
  employee/session identity, and relevant session details cannot be changed or
  deleted. A session with certified enrollments cannot change course, instructor,
  or date. Repeating a course in another session earns a separate certificate.

## Daily work

HR and department managers share a completed-training ledger showing each
certificate's original department and hours alongside the employee's current
department. Transfers and new completions must appear immediately without an
overnight refresh. Reporting access must not permit changes to personnel or
training records. A transfer moves current attribution, not earned credit.

## Required advanced SQL report

**Department training-credit movement:** For certificates whose session dates
fall in a selected period, show one row per department appearing either as a
training-time or current department: hours earned while in that department,
hours currently held by its employees, distinct certified employees under each
attribution, outgoing hours now held elsewhere, incoming hours earned elsewhere,
and net movement (incoming minus outgoing).

Show zeroes for a department appearing on only one side. An employee with several
certificates contributes all hours but counts once per department attribution.
Reconcile currently held hours to earned hours plus net movement. This extends
the original department totals by comparing two valid historical/current
attributions; it does not claim to identify every intervening transfer. Retain
the original reports' current-department grouping, but use certified hours rather
than today's course hours.

## Evidence to include

Include an employee with multiple certificates who transfers afterward, an
incomplete enrollment, a department appearing only on one attribution side, and
a later completion after course hours change. Reject overlapping assignments,
uncovered enrollment dates, duplicate certification, and history edits that
would invalidate a certificate's department.
