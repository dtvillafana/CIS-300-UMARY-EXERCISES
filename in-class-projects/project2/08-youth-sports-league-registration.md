# Youth Sports League Registration — Seasonal Team Offerings

Extend [Youth Sports League Registration in Project 1](../project1/08-youth-sports-league-registration.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

The league now runs recurring seasons. Teams may return with new coaches or age
rules, but families must be able to rely on the team and eligibility terms
advertised for the season they joined.

## Revised business rules

- Each season has a unique label, registration opening/closing times, playing
  start/end dates, and an age-reference date. Registration closes no later than
  play starts; all intervals must be valid. Seasons may overlap.
- When the league opens a team for a season, families are promised its team name,
  coach, division, and minimum/maximum ages under the rules in force that day.
  Opening the team is one staff action; there must not be a period when families
  can enroll but the promised terms are missing. A team opens once per season.
- The published terms remain binding even before the first registration. Later
  team renaming, coach assignments, or division age changes apply to newly opened
  offerings, not ones already advertised. The league must retain previous seasons'
  terms to answer eligibility disputes. Season dates/reference dates cannot change after its first
  offering. No offering or season containing one may be deleted.
- Register players into seasonal offerings, not an undated team. A player may
  join at most one team per season, but may return in other seasons. Jersey
  numbers are unique within a seasonal offering and may be reused next season.
- Accept registration only within that season's registration window. Age on its
  reference date must satisfy the offering's captured inclusive age bounds.
  Fees are nonnegative and payment status remains fully paid or unpaid.
  No transfers or cancellations are in scope. Registered player identity,
  birth date, offering, fee, and jersey number are fixed; payment status may change.

## Daily work

Coaches and registration staff consult the same season roster for advertised
team/division/coach details, player and guardian contacts, jersey, charged fee,
and current payment status. A payment update must be visible immediately without
reissuing a roster spreadsheet. Looking up a prior season must never display
next season's team assignment. Roster readers cannot alter registrations.

## Required advanced SQL report

**Division renewal and fee collection:** Select a season and a preceding season
explicitly. For each division offered in either, show offered team count,
registered players, charged fees, paid fees, and fee-collection percentage for
each season, plus current-season returning player count and returning-player
percentage of current registrations. A returning player was registered anywhere
in the selected prior season, even in a different division.

Group by stable captured division identity, not its mutable name; label the two
seasons' historical names separately if they differ. Show empty offerings and
divisions present in only one season. Relate players across seasons without
multiplying their fees, and do not treat a sibling as the same player. Collection
means payment status as of running the report, not status at a past cutoff.
This extends the original team summary to analyze returning participants across
season-specific structures. Add a season filter to the original three reports.

## Evidence to include

Include two seasons, a team whose template coach/label changes between them,
a player changing divisions, a new player, an empty offering, and paid/unpaid
fees. Reject duplicate player-season registration across different teams,
duplicate jerseys within one offering, ineligible ages, and late registration.
