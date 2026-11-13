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

## Required analytical SQL report

**Monthly food demand:** For visits during a selected month, show one row per food
item with its name, category, distribution unit, total quantity distributed, and
number of distinct households receiving it. Sort by category and item name to help
staff review demand. Keep quantities in each item's defined unit; do not combine
cans, boxes, and bags into one total.
Include a household receiving the same item on multiple visits in your sample
data. Sum all its distributions, but count that household only once for that item.

## Additional SQL reports (Complete both)

1. **Household distribution history:** Show a selected household's visit dates,
   volunteers, food items, quantities, and units.
2. **Volunteer activity:** Show the number of visits handled and distinct
   households served by each volunteer during a selected date range.

## Start here

What distinguishes a food item from its distribution on a particular visit? How
will you count visits without counting one visit multiple times because of its items?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
