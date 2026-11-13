# Project 2 — Changing Business Rules

Extend the same scenario you completed in [Project 1](../project1/README.md).
Each client now needs a small schema change with consequences for automation,
historical accuracy, and reporting. The briefs describe behavior, not a finished
schema: deciding where the new facts belong is part of your assignment.

## Project choices

1. [Campus Equipment Checkout](01-campus-equipment-checkout.md)
2. [Community Workshop Registration](02-community-workshop-registration.md)
3. [Pet Grooming Appointments](03-pet-grooming-appointments.md)
4. [Small Online Bookstore](04-small-online-bookstore.md)
5. [Apartment Maintenance Requests](05-apartment-maintenance-requests.md)
6. [Catering Order Management](06-catering-order-management.md)
7. [Employee Training Tracker](07-employee-training-tracker.md)
8. [Youth Sports League Registration](08-youth-sports-league-registration.md)
9. [Food Pantry Distribution Tracker](09-food-pantry-distribution-tracker.md)
10. [Auto Repair Service Orders](10-auto-repair-service-orders.md)
11. [Conference Session Planner](11-conference-session-planner.md)

## Your assignment

### 1. Evolve your design

- Keep your Project 1 entities and extend their relationships. Add **1–3 tables
  total**, not 1–3 tables per new feature. You may also add or alter columns,
  keys, and constraints in existing tables. Explain how each new table is needed.
- The extension's rules replace conflicting Project 1 rules; all other rules
  remain in effect. Do not add unrelated features to meet the table requirement.
- Keep operational data in 3NF. Deliberate snapshots of issued or completed
  business records are required historical evidence, not accidental duplication.
  Explain which values are copied and why references to current data alone fail.
- A generic change log is not a substitute for the historical business records
  requested in your brief. Preserve each record's identity, source, event time,
  and relevant terms, including its details when it contains multiple items.
- Use fictional data. Use your instructor's database system; see the
  [student setup guide](../../STUDENT_SETUP.md). Document any DBMS-specific syntax.

### 2. Make the business rules reliable

- Staff perform each business action once. Its required consequences must occur
  even when the action is recorded through direct SQL, without a separate
  follow-up command or reconciliation job. An action must not leave a partially
  issued document or an incomplete set of its details.
- Enforce historical immutability and cross-record rules in the database, not
  only in an application or in instructions to the user. Cover inserts, updates,
  deletes, and changes to referenced parents that could bypass a rule. Protect
  completed history from cascading deletion. Ordinary SQL must not allow someone
  to forge, replace, or add details to an already-issued record; explain your
  database enforcement and, where needed, privilege design. Administrator
  tampering is outside scope.
- Invalid dates, quantities, prices, statuses, duplicate business events, and
  broken relationships must be rejected by the database, regardless of which
  staff tool submits them. Explain which rules concern one record and which
  depend on other records.
- Staff need named, read-only SQL datasets for the daily work described in your
  brief. These must always show the applicable committed data, without a
  refresh job, manual export, or separate maintained copy. Document each dataset's
  row grain and columns, and query one in a submitted report. Historical
  documents must not silently change when current operational information does.
- Where the DBMS supports database accounts and privileges, give reporting staff
  access to those datasets without access to base tables or permission to change
  records. Otherwise demonstrate read-only dataset queries and document the
  DBMS's access-control limitation; a separate application is not required.
- Do not store independently maintained totals, percentages, or balances that queries
  can calculate. Frozen agreed terms and facts captured at a business event are
  different from a mutable summary. Document rounding and time conventions.

### 3. Extend the reports and prove the behavior

- Retain and adapt your **three Project 1 reports**, explaining any changed
  meaning under the new rules. Add the required advanced report in your brief,
  for **four reports total**. The new report must do more than add columns to
  the old report: combine historical and operational facts at different grains,
  compare periods, or analyze related events as specified.
- Use stable identifiers for grouping; names alone do not identify entities.
  Aggregate independent detail sets before joining them when needed to prevent
  multiplied totals. Include eligible groups with no activity where requested.
- State all date boundaries and filters. When comparing two date ranges, use
  consecutive, equal-length, nonoverlapping periods with inclusive starts and
  exclusive ends. Season and publication comparisons instead use the selections
  specified in their briefs. Treat a zero denominator as `NULL`/not applicable, not zero
  percent. Show percentage changes or percentage-point differences as labeled.
- Supply sample data that exercises every new rule and the brief's edge cases.
  Include multiple detail rows on one event wherever the design allows them.
  Show a source/template change after an event and prove the old record stays
  unchanged while a later event captures the new values.
- Supply labeled verification SQL: valid actions that cause automatic records,
  invalid actions that fail, and attempts to edit or delete historical records.
  Include bypass attempts through updates and parent changes, not just inserts.
  Isolate expected failures so they do not stop the main setup script.
- Verify at least one advanced-report result by hand, including its numerator,
  denominator, and treatment of repeated detail rows.

### 4. Submit your work

- An updated schema/data dictionary, assumptions, and a short explanation of the
  changed relationships and historical boundaries.
- A reproducible setup script creating the complete extended database, including
  its rule enforcement and reporting access, plus sample-data SQL. A separate
  migration from Project 1 is optional; if supplied, explain how existing rows
  are handled.
- Labeled SQL for all four reports and the verification cases, with outputs or
  screenshots and brief explanations. Document how to run everything in order.
- A mapping from each revised business rule to its database implementation.
  Explain transaction/concurrency assumptions for capacity or cumulative-limit
  checks; a multi-user design must prevent two simultaneous actions from both
  passing a limit they collectively exceed.
