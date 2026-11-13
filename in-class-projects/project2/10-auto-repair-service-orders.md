# Auto Repair Service Orders — Authorized Estimates and Technician Work

Extend [Auto Repair Service Orders in Project 1](../project1/10-auto-repair-service-orders.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

Orders begin as editable labor estimates. Customers authorize a maximum amount
of work, and several mechanics may perform it. The shop needs to compare the
authorization with actual labor without losing the original estimate.

## Revised business rules

- Before work starts, the customer approves an itemized authorization showing
  the approval time, customer, vehicle/VIN, intake mileage, responsible lead,
  service descriptions, maximum labor hours, and agreed hourly rates. Approval
  must provide the customer and shop with matching copies; there is no separate
  paperwork step that can be forgotten. At least one service must be authorized.
  Later catalog or contact changes cannot rewrite the approved terms.
- Authorization cannot precede opening. Authorized hours must be positive,
  rates nonnegative, and mileage nonnegative. An order is authorized only once.
  Its vehicle, customer, lead, service membership, and agreed terms then lock.
  Vehicle ownership still does not change within this project.
- Record individual work entries against authorized service lines. Each entry
  identifies the performing mechanic, work date/time, and positive labor hours.
  Several mechanics or entries may contribute to one line. Work must be dated
  at or after authorization; combined hours may not exceed that line's maximum.
- Actual labor charges use each line's authorized rate. Unused authorized hours
  are not billed. Revised authorizations, parts, payments, and overtime rates
  are outside scope. Open-order entries may be corrected within the limits.
- Only authorized orders can close. Closing cannot precede authorization or any
  work entry, and every authorized service must have at least one work entry.
  Closing is final: terms and work entries cannot change, and no further work
  may be added. Authorized orders and their history cannot be deleted.

## Daily work

Service advisors and workshop supervisors share an authorized-work balance
listing: approved service and lead, maximum hours/value, actual hours/value,
remaining authorized hours, and order status. A mechanic's new work entry must
appear immediately, without a second balance update. Authorized services with
no work remain visible. Readers cannot use this access to change approved work.

## Required advanced SQL report

**Lead mechanic estimate realization:** For orders closed during a selected
period, show one row per historical lead mechanic: distinct closed orders,
authorized hours/value, actual hours/revenue, unused authorized value, percentage
of authorized value realized, distinct contributing mechanics, and number of
orders worked by more than one mechanic.

Attribute the entire order to its authorized lead, regardless of who performed
each entry. Count each authorization line once when totaling its budget, even
when several mechanics worked on it. Count a contributing mechanic once per
lead's group, not once per entry or order. This extends the original labor
performance report by reconciling contractual limits with actual work at a
different grain. Adapt the original reports to actual entries and authorized
rates, rather than treating estimated hours as performed work.

## Evidence to include

Include an order with multiple services, multiple entries by one mechanic, two
mechanics on one service, unused authorized hours, and an open authorization
with no work. Change a service description before a later authorization.
Reject cumulative excess hours, pre-authorization work, closing an unworked
service, duplicate authorization, and post-closing work edits.
