# Food Pantry Distribution Tracker — Finalized Distribution Authorizations

Extend [Food Pantry Distribution Tracker in Project 1](../project1/09-food-pantry-distribution-tracker.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

Each food item now has a positive whole-number allowance per household member
per visit. Staff prepare visits as drafts, then finalize the distribution. The
pantry must preserve the household size and allowance used for that visit.

## Revised business rules

- Before food leaves the desk, the household receives a distribution slip showing
  visit time, household/contact, household size used for eligibility, volunteer,
  and each item's name, category, unit, allowance per member, and quantity
  provided. The pantry retains the same slip for grant audits. Empty visits do
  not count as distributions and cannot be finalized.
- Drafts do not count as distributions. At finalization, each quantity must be a
  positive whole number no greater than household size multiplied by that item's
  allowance in effect when food is released. Household sizes are positive whole numbers.
  Each item still appears at most once per visit.
- Finalization happens once. Finalized household, volunteer, visit time, item
  membership, and quantities cannot be edited or deleted. Catalog allowance,
  name, or category changes and later household-size changes do not rewrite
  what the household received or was entitled to on that visit. A later visit
  uses the new values.
- An item's unit cannot change after its first finalized distribution; create a
  new catalog item for a different package/unit. Never combine unlike units as
  though they were the same quantity. Only the per-visit allowance is enforced;
  monthly household caps and inventory remain outside scope.

## Daily work

Desk supervisors and grant-reporting staff share a distribution ledger detailing
the household size, eligibility terms, quantity provided, and maximum allowance
for each item given out. Each released distribution must appear immediately,
without a manual export. Draft visits must stay out of grant totals, and
reporting staff must not be able to alter household or distribution records.

## Required advanced SQL report

**Item allowance utilization and changing household demand:** Compare two visit
periods. For every item distributed in either period, show its unit, distributed
quantity, distinct households, recipient person-visits, allowed quantity,
quantity per recipient person-visit, and allowance-utilization percentage for
each period, plus the percentage-point change in utilization.

A recipient person-visit is the captured household size for a visit containing
that item: a household of three receiving it on two visits contributes six, not
three. Sum each visit's own allowance limit; do not multiply all historical
household sizes by today's allowance. Count a household once per item per
period for the distinct-household measure. Include zero-activity sides, and do
not aggregate different items' units. This extends monthly demand analysis with
historical eligibility and a defined measure of population served. Adapt the
original reports to finalized visits only.

## Evidence to include

Include repeat visits by one household, a household-size change, an allowance
change, one distribution exactly at its limit, one below it, a draft visit, and
an item present in only one period. Reject above-limit quantities, repeat
finalization, unit changes after use, and edits to finalized distributions.
