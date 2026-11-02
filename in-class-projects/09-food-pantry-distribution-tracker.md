# Food Pantry Distribution Tracker

## Your client

A food pantry needs to record household visits and food distributions. Staff
want to review household service history and understand demand for food items.

## What the system must track

- Households, each with a primary contact name, contact information, and current
  household size.
- Volunteers and their contact information.
- Food categories, such as canned vegetables, grains, and dairy.
- Food items, each with a name, one category, and a distribution unit such as a
  can, box, or bag.
- Visits, each for one household on a recorded date and processed by one volunteer.
- Items distributed during each visit, with the quantity of each item provided.

## Scope and business rules

A household may visit many times. A visit may include several food items, but
each item appears at most once per visit. Quantities are positive whole numbers
of the item's defined unit. Do not add unlike units together into a single food
quantity. Purchasing, donations, inventory balances, individual household members,
and historical household sizes are outside scope. Use fictional household data.

## Suggested SQL reports

1. **Household distribution history:** Show a selected household's visit dates,
   volunteers, food items, quantities, and units.
2. **Monthly item distribution:** Show quantities distributed by item and category
   during a selected month, displaying each item's unit.
3. **Volunteer activity:** Show the number of visits handled and distinct
   households served by each volunteer during a selected date range.

## Start here

What distinguishes a food item from its distribution on a particular visit? How
will you count visits without counting one visit multiple times because of its items?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
