# Campus Equipment Checkout — Issued Lending Agreements

Extend [Campus Equipment Checkout in Project 1](../project1/01-campus-equipment-checkout.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

The university now charges for late equipment returns. Students receive a
lending agreement when collecting equipment and may dispute a charge months
later. The desk must be able to establish which equipment and terms the student
accepted, even if its catalog and charge schedule have since changed.

## Revised business rules

- Staff may prepare draft checkouts, but drafts do not reserve equipment. A
  student cannot leave with equipment without receiving a numbered agreement with the
  student's name/contact, employee name, due time, and an itemized list of asset
  numbers, models, categories, issue time, and agreed daily charges. Each category
  has a current daily charge; the applicable charge is the one in effect at issue.
- The student's copy and the desk's retained copy must continue to agree. Later
  catalog or charge changes cannot change an existing agreement. Each checkout
  has one agreement; issuing it twice must not create a second obligation.
- Only issued loans hold equipment. An item may not be issued again until its
  previous loan is returned. Changing a checkout or an item's identity must not
  bypass this rule. The due time must follow issue time; charges are nonnegative.
- Record returns separately for each issued item, never before issue time. A
  recorded return is final. Returns do not rewrite the agreement. Drafts may be
  edited or deleted; issued source terms and item membership are locked.
- A late day is any started 24-hour period after the due time. The desk wants
  calculated charge exposure, not payments or a fines collection workflow.

## Daily work

Desk staff and the university's reporting team use the same lending ledger to
look up the borrower, asset, agreed category/charge, and issue/due/return times
for each loaned item. A return must appear as soon as it is recorded; completed
loans remain available for disputes. The ledger is not a manually updated export.

## Required advanced SQL report

**Category demand and late-return exposure:** Compare two borrowing periods using
agreement issue times. As of a supplied cutoff at or after both periods, show one
row per category appearing in either period: item loans, distinct borrowers,
late loans, total late days, and total charge exposure for each period, plus the
change in exposure and percentage-point change in the late-loan rate.

For unreturned loans, measure lateness through the cutoff; treat returns after
the cutoff as not yet returned. Use each agreement's charge and category, not
today's values. A repeated borrower counts once per category per period, while
each loan contributes its own lateness. Include zero-activity sides of the
comparison. This extends the original demand report with historical terms and
time-dependent outcomes.

## Evidence to include

Include a multi-item agreement, repeated borrowing, a partial return, an on-time
return, an overdue unreturned item, and a category active in only one period.
Change a category charge between issues. Demonstrate rejection of double issue,
issuing an empty checkout, overlapping active loans, and edits to issued terms.
