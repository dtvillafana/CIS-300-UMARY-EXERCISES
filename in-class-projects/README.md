# Database Design Projects

Choose one project below. Each project is designed for a database with **4–7
tables in third normal form (3NF)** and **3 SQL reports that join related
tables**. The descriptions specify business needs, not a finished schema: deciding
how to organize the data is part of your assignment.

## Project choices

1. [Campus Equipment Checkout](01-campus-equipment-checkout.md)
2. [Community Workshop Registration](02-community-workshop-registration.md)
3. [Pet Grooming Appointments](03-pet-grooming-appointments.md)
4. [Small Online Bookstore](04-small-online-bookstore.md)
5. [Apartment Maintenance Requests](05-apartment-maintenance-requests.md)
6. [Catering Order Management](06-catering-order-management.md)
7. [Employee Training Tracker](07-employee-training-tracker.md)
8. [Youth Sports League Registration](08-youth-sports-league-registration.md)
9. [Food Pantry Distribution Tracker](09-food-pantry-distribution-tracker.md)
10. [Auto Repair Service Orders](10-auto-repair-service-orders.md)
11. [Conference Session Planner](11-conference-session-planner.md)

## Your assignment

Read your project's description and follow these requirements. You do not need to
build a website or application interface; the deliverable is the database and its
SQL reports.

### 1. Design the database

- Identify the entities, attributes, and business rules.
- (Optional) Create an entity-relationship diagram (ERD) showing primary keys, foreign keys, relationship cardinalities, and optional relationships.
- Design **4–7 tables in 3NF**, resolving many-to-many relationships with junction
  tables where needed.
- Provide a data dictionary describing each column, its data type, and its
  constraints.
- Document any assumptions you make that determine how you design the schema. Keep them consistent with the project's stated scope.

### 2. Implement and populate the database

- Write a SQL script that creates the tables with appropriate primary keys,
  foreign keys, required fields, uniqueness rules, and value checks.
- Use the database system assigned by your instructor. For graphical setup
  instructions, see the [student setup guide](../STUDENT_SETUP.md).
- Insert fictional sample data into every table. Include enough variety to show
  one-to-many relationships, any many-to-many relationships, and meaningful report
  results. Include optional or incomplete records where the scenario allows them.
- Preserve historical transaction values, such as the price actually charged,
  separately from changeable catalog prices when the scenario requires it.
- Calculate report totals, counts, and similar derived values in queries rather
  than storing them as independent facts.

### 3. Write the reports

- Write **3 SQL report queries total**: your project's required analytical report
  and both suggested additional reports. You may propose alternatives for the
  additional reports, but the required analytical report must be included.
- Every report must join at least two tables, and at least one must join three or
  more tables.
- The required analytical report must answer the business question in your project
  description. Present the requested summary measures at the specified level of
  detail, rather than listing individual transactions. Keep different people,
  items, or organizations separate even if they share a name.
- Include sample data covering at least two of the entities or categories being
  compared, with multiple contributing records for at least one. Follow any
  additional sample-data requirements in your project description.
- Explain what the required report reveals and verify at least one summary's
  calculated results by hand against your sample data.
- Give output columns clear names and use an appropriate `ORDER BY`.
- Document any date range or other filter used by each report.
- Check that your joins do not accidentally duplicate totals. For reports about
  missing activity or unassigned records, consider whether a `LEFT JOIN` is needed.

### 4. Submit your work

- Your chosen project title and documented assumptions.
- Table-creation and sample-data SQL scripts.
- A SQL file containing your labeled report queries.
- Report results, either exported or captured in screenshots, with a brief
  explanation of what each report tells its intended user.
- Essentially, I should be able to reproduce your entire setup and run the reports from the scripts you submit

## Getting started

First underline the facts the organization needs to store. Then identify which
facts describe people, places, things, or events. Work out the relationships before
writing `CREATE TABLE` statements. Do not assume that every noun needs its own
table or that a report needs a separate stored table.
