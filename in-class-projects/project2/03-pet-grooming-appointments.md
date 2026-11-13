# Pet Grooming Appointments — Completed Care Receipts

Extend [Pet Grooming Appointments in Project 1](../project1/03-pet-grooming-appointments.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

Customers now receive an itemized care receipt when an appointment is completed.
The business also wants to understand which services lead to repeat visits.

## Revised business rules

- A completed appointment must have at least one service. At completion, the
  owner receives one itemized receipt identifying the pet, owner/contact,
  groomer, completion time, services performed, and agreed prices. The business
  keeps an identical copy to answer customer disputes. Changing a pet's name,
  contact information, staff names, or service catalog must not rewrite that copy.
- Scheduled appointments may be edited or canceled. Completion and cancellation
  are terminal states; a completed appointment cannot be reopened, completed
  again, or deleted. Its pet, groomer, selected services, and agreed prices are
  locked. A canceled appointment cannot generate a receipt.
- Completion cannot precede the scheduled appointment time. A service may appear
  only once per appointment; all agreed prices must be nonnegative.
- The same pet may return for the same service in later appointments, possibly
  with a different groomer. A return visit is a distinct completed appointment,
  not another service line on the original appointment.

## Daily work

Reception and management share a completed-care ledger detailing the customer,
pet, groomer, service, price, and completion time shown on each receipt. Newly
completed work must appear immediately, with no daily export. Staff can consult
the ledger without permission to edit appointments or customer records.

## Required advanced SQL report

**Service repeat-visit performance:** For receipt completions in a selected
period, show one row per historical groomer/service identity: service count,
distinct pets, revenue, average price, number of those service occurrences
followed by the same pet receiving the same service within 30 days, and the
percentage of occurrences with such a follow-up.

Use a strictly later completion time, up to and including 30 days later. The
follow-up may be with any groomer and outside the selected period; attribute it
to the original groomer/service row. Require data complete through 30 days after
the period's end. Count each original occurrence at most once, even if it has
several qualifying follow-ups. Exclude canceled and scheduled appointments.
Unlike the original service sales report, this report must relate separate
historical visits without multiplying revenue.

## Evidence to include

Include a multi-service receipt, a pet with two qualifying follow-ups, a return
to a different groomer, a follow-up outside 30 days, and a canceled appointment.
Change a service description/price and an owner's contact details between
completions. Reject duplicate completion and edits to completed services.
