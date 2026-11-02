# Pet Grooming Appointments

## Your client

A pet grooming business needs to maintain customer and pet records, schedule
groomers, and track the services included in each appointment.

## What the system must track

- Customers and their contact information.
- Pets, each with a name, species, breed, and one owner from the customer records.
- Groomers and their contact information.
- Appointments, each for one pet with one groomer, including its date, time, and
  status, such as scheduled, completed, or canceled.
- A catalog of services, such as bathing, nail trimming, and haircuts, with a
  description and current standard price for each service.
- The services selected for each appointment and the agreed price for each.

## Scope and business rules

A customer may own several pets. An appointment may include multiple services,
but the same service appears at most once in that appointment. Preserve agreed
prices even if catalog prices change. For reports, count revenue only from
completed appointments. Retail products and payment processing are outside scope.

## Required analytical SQL report

**Groomer service performance:** For completed appointments during a selected
month, show one row per groomer and service combination with the groomer's name,
service name, number of times the service was performed, total revenue, and average
price charged. Sort by groomer and then revenue, highest first, to compare each
groomer's service mix. Use agreed appointment prices and exclude scheduled and
canceled appointments. Include both
completed and noncompleted appointments in your sample data.

## Additional SQL reports (Complete both)

1. **Daily groomer schedule:** Show appointment times, pets, owners and their
   contact information, groomers, and selected services for a chosen date.
2. **Pet appointment history:** List a selected pet's appointments, groomers,
   statuses, services, and agreed prices.

## Start here

Can a customer's name safely identify a pet's owner? Where should a service's
appointment-specific price be stored?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
