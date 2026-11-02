# Youth Sports League Registration

## Your client

A youth sports league needs team rosters and a way to track registration fees
for a single season.

## What the system must track

- Age divisions, each with a name and minimum and maximum ages.
- Coaches and their contact information.
- Teams, each with a name, one age division, and one head coach.
- Guardians and their contact information.
- Players, each with a name, date of birth, and one primary guardian. A guardian
  may be responsible for multiple players.
- Registrations, each connecting one player to one team and recording registration
  date, jersey number, fee charged, and payment status.

## Scope and business rules

A coach may lead multiple teams. Each registered player has exactly one team for
this season. Jersey numbers must be unique within a team, but may repeat across
teams. Fees are either fully paid or unpaid; partial payments are outside scope.
Also exclude multiple seasons, game schedules, assistant coaches, and multiple
guardians per player. Document the reference date used to determine player ages.

## Suggested SQL reports

1. **Team roster:** Show a team's division, coach, players, jersey numbers, and
   primary guardian contact information.
2. **Outstanding fees:** Show unpaid registration counts and amounts owed by team
   and age division.
3. **Guardian registration summary:** Show a selected guardian's players, teams,
   fees charged, and payment statuses.

## Start here

How will you avoid repeating a guardian's contact information for siblings? Which
constraints can prevent a player from joining two teams in the same season?

Follow the [shared assignment and submission requirements](README.md#your-assignment).
