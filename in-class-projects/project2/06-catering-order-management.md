# Catering Order Management — Confirmed Event Agreements

Extend [Catering Order Management in Project 1](../project1/06-catering-order-management.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

Orders begin as editable event plans. Confirmation creates a binding agreement;
after delivery, staff record how many servings they actually supplied. Management
wants to identify shortfalls without rewriting what the customer ordered.

## Revised business rules

- An event is not confirmed until the customer has an itemized agreement showing
  the confirmation time, customer, coordinator, event date, delivery address,
  guest count, menu descriptions/categories, promised servings, and agreed unit
  prices. The company retains the same agreement to resolve delivery disputes.
  An agreement must include at least one menu item.
- Confirmation cannot precede order placement or follow the event date. Guest
  count and servings are positive whole numbers; prices are nonnegative.
  A confirmed event has one binding agreement. Its event terms and menu are then
  fixed; later catalog, customer, and coordinator changes cannot change what was
  promised to that customer.
- For each confirmed item, record actual servings supplied as a nonnegative
  whole number. Missing means not yet recorded, not zero. Actual servings may
  not exceed promised servings; extras and substitutions are outside scope.
- An order may be marked delivered only on or after its event date and only
  after every item has an actual count, including explicit zeros. Delivery is
  final: actual counts cannot then change, and the order cannot revert to draft
  or confirmed. Confirmed or delivered orders and agreements cannot be deleted.
- Shortfall value means unfulfilled servings multiplied by their agreed price;
  it is an operational measure, not a refund or payment balance.

## Daily work

Kitchen coordinators and account managers share a fulfillment listing showing
each agreed menu item, promised terms, actual servings, delivery status, and
shortfall servings/value. Counts recorded by the kitchen must be visible to
account managers immediately, without exporting a new spreadsheet. An unfinished
item whose count is not recorded must not look like a fully missed delivery.

## Required advanced SQL report

**Category fulfillment reliability:** Compare two event-date periods, considering
only delivered orders. For each historical menu category delivered in either
period, show distinct events, promised servings/value, actual servings/value,
shortfall value, percentage of promised servings fulfilled, and number of events
with any shortfall. Show the percentage-point change in fulfillment rate.

Value actual servings at their agreed unit prices. Count an event once per
category even if several of its items fell short; do not multiply the agreement
quantities when relating them to actual counts. Include a category present in
only one period. This extends menu sales analysis to compare contractual demand
with fulfillment. Adapt the original sales reports to confirmed agreements,
clearly distinguishing promised sales value from delivered value.

## Evidence to include

Include an event with two items from one category, a fully fulfilled event, an
item supplied as zero, a partly recorded undelivered event, and a changed menu
price/category label between confirmations. Reject premature delivery, missing
actual counts at delivery, over-fulfillment, and edits to historical promises.
