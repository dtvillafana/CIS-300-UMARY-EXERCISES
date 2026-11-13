# Auto Repair Service Orders

## Your client

An auto repair shop needs to record service orders, preserve vehicle repair
history, and summarize mechanics' labor activity.

## What the system must track

- Customers and their contact information.
- Vehicles, each with a unique VIN, make, model, model year, and one current owner
  from the customer records.
- Mechanics and their contact information.
- A catalog of repair services, each with a name and description.
- Service orders, each for one vehicle and assigned to one lead mechanic, with
  an opening date, optional closing date, and mileage at intake.
- The services on each order, including labor hours and the hourly rate charged
  for each service.

## Scope and business rules

A vehicle may have many service orders. An order may include several services,
but each catalog service appears at most once per order. No closing date means
the order is open. Preserve recorded hours and rates for historical reporting.
Count labor revenue only for closed orders. Vehicle ownership does not change
during this project. Parts, taxes, payments, and additional mechanics per order
are outside scope.

## Required analytical SQL report

**Mechanic labor performance:** For service orders closed during a selected month,
show one row per lead mechanic with their name, number of distinct closed orders,
total labor hours, and total labor revenue. Sort by revenue, highest first, to
compare completed workload and labor sales. Calculate revenue by multiplying each
service entry's hours by its recorded hourly rate. Include an order with multiple
services and at least one
open order in your sample data. Count a closed order only once, and exclude open
orders from all measures.

## Additional SQL reports (Complete both)

1. **Vehicle service history:** Show a vehicle's owner, service order dates,
   lead mechanics, services, labor hours, and calculated labor charges.
2. **Open service orders:** Show open orders with customer contact information,
   vehicle details, lead mechanic, and opening date.

## Start here

Which facts describe a catalog service, and which describe work performed on one
vehicle? How will you calculate labor charges without storing redundant totals?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
