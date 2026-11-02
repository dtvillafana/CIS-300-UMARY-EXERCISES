# Small Online Bookstore

## Your client

A small online bookstore needs to track its catalog and customer orders. Staff
want to review purchases and determine which publishers generate sales.

## What the system must track

- Customers and their contact information.
- Publishers, each with a name and contact information.
- Books, each with a unique ISBN, title, current selling price, and one publisher.
- Orders, each placed by one customer, with an order date and shipping status.
- The books included in each order, with the quantity and unit selling price at
  the time of purchase.

## Scope and business rules

A customer may place many orders, and an order contains one or more books. A book
appears at most once per order; multiple copies use a quantity. A catalog record
represents a particular book edition identified by its ISBN. Preserve order prices
when catalog prices change. Authors, inventory, refunds, taxes, shipping charges,
and payment processing are outside scope. Orders are not canceled in this project.

## Suggested SQL reports

1. **Order details:** Show a selected order's customer, books, publishers,
   quantities, unit prices, and calculated line totals.
2. **Publisher sales:** Show copies sold and sales revenue by publisher for orders
   placed during a selected date range.
3. **Customer purchase summary:** Show each purchasing customer's order count and
   total spending during a selected date range.

## Start here

How will you represent an order containing several different books without
creating repeating columns? How will historical prices remain accurate?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
