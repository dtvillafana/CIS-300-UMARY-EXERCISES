# Small Online Bookstore — Dispatch Records and Returns

Extend [Small Online Bookstore in Project 1](../project1/04-small-online-bookstore.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

Orders may now be edited until dispatch, after which customers can return books.
The shop needs evidence of what was actually shipped, independent of its current
catalog. Physical returns are in scope; cash refunds and payment processing are not.

## Revised business rules

- Every dispatched order travels with a numbered packing document showing the
  dispatch time, customer, delivery address, and itemized ISBNs, titles,
  publishers, quantities, and agreed unit prices. The shop retains an identical
  copy for returns and customer disputes. Orders therefore need delivery addresses.
- An order ships once and in full; there are no partial shipments. Dispatch
  cannot precede order placement. Dispatched order terms and lines cannot be
  edited or deleted, and its status cannot return to an editable state.
- Current book, publisher, and customer records may change, but neither the
  customer's document nor the shop's copy may change with them. Positive
  whole-number quantities and nonnegative prices
  are required. Keep the one-book-per-order rule.
- Each return event concerns one dispatched book line and records a unique
  return reference, received time, and positive whole-number quantity. Several
  events may return copies from one line, but their combined quantity may not
  exceed copies shipped. A return cannot precede dispatch.
- Accepted return events are permanent. They cannot be edited, deleted, or
  moved to another shipment. Undispatched books cannot be returned. The value
  of returned copies uses their dispatched unit price, not today's price.

## Daily work

Returns staff and sales analysts share a shipped-book balance listing: the book
and publisher as shipped, copies shipped, returned and retained, and retained
sales value. It must show a newly accepted return immediately, without a separate
reconciliation job. Books with no returns still appear with zero returned copies.

## Required advanced SQL report

**Publisher retained-sales performance:** For orders dispatched in a selected
period, evaluate returns received through a supplied cutoff at or after that
period. Show one row per historical publisher: distinct dispatched orders,
copies shipped, gross sales value, copies returned, returned value, retained
sales value, quantity return percentage, and rank by retained sales value.
Publishers tied on value share a rank; document your ranking convention.

Include publishers with no returns. Do not count an order twice when it has
multiple books from that publisher, and do not multiply shipped value when a
line has multiple return events. Exclude returns after the cutoff. Explain that
this is a dispatch-cohort report, not a report of all returns received in the
period. Adapt Project 1 sales reports to use dispatched rather than draft orders.

## Evidence to include

Include two books from one publisher on an order, multiple returns against one
line, a book with no returns, and a return after the cutoff. Change a catalog
price/title after dispatch. Reject cumulative over-returns, early returns, and
attempts to alter dispatch or accepted return history.
