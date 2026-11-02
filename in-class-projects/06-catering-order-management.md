# Catering Order Management

## Your client

A catering company prepares food for customer events. Staff need to track orders,
coordinate upcoming events, and summarize menu sales.

## What the system must track

- Customers and their contact information.
- Event coordinators and their contact information.
- Menu categories, such as entrée, side dish, and dessert.
- Menu items, each with a name, description, current standard price, and one
  category. Prices are per serving.
- Catering orders, each for one customer and assigned to one coordinator, with an
  order date, event date, delivery address, and expected guest count.
- The menu items on each order, with a quantity of servings and an agreed unit
  price for each item.

## Scope and business rules

An order represents one event and contains one or more menu items. Each menu item
appears at most once per order. Preserve agreed prices independently of current
menu prices. Orders are not canceled in this project. Ingredient inventory,
staff scheduling, taxes, delivery charges, and payment processing are outside scope.

## Required analytical SQL report

**Menu category sales performance:** For events occurring during a selected month,
show one row per menu category with its name, total servings ordered, number of
distinct event orders containing its items, and sales value. Sort by sales value,
highest first, to compare category demand. Calculate sales value from quantities
and agreed unit prices. Include an event order with two items from the same
category in your sample data; it must
count only once toward that category's event order count.

## Additional SQL reports (Complete both)

1. **Upcoming event preparation list:** Show events in a selected date range with
   customer, coordinator, delivery address, menu items, and required servings.
2. **Coordinator event summary:** Show event counts and total order value by
   coordinator for a selected event date range.

## Start here

Which information describes an entire event order, and which information depends
on an individual menu item within that order?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
