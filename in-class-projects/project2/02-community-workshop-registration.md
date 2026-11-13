# Community Workshop Registration — Published Offers and Attendance Receipts

Extend [Community Workshop Registration in Project 1](../project1/02-community-workshop-registration.md).
Follow the [Project 2 requirements](README.md#your-assignment).

## The client's change

Participants have complained that advertised workshop fees and room sizes changed
after they booked. The center now honors each published offer and gives attendees
receipts they can use to claim employer reimbursement.

## Revised business rules

- A session's first advertisement commits the center to its workshop title,
  scheduled date/times, instructor, room, seat capacity, and advertised fee. The
  center must retain the advertisement and when it was published. Publication
  happens once, before the session starts. Capacity must be positive, the fee
  nonnegative, and end time after start time.
- Staff may revise unpublished sessions, but advertised terms are binding for
  that session. Later workshop
  fee/title, instructor contact/name, or room catalog changes affect future
  offers, not existing ones. Catalog capacity changes do not resize old offers.
- Accept registrations only for published sessions and before their start time.
  Each participant may register once per session. Registrations cannot exceed
  offered seats. There are no cancellations or waitlists in this extension.
  Discounts are still allowed; the fee actually charged must be nonnegative.
- Every attendee is entitled to exactly one attendance receipt as soon as staff
  confirm attendance. It identifies the participant, advertised workshop and
  instructor, session date, actual fee charged, and date of issue. An old receipt
  must remain valid evidence even if names or catalog details later change.
  Attendance may be recorded only after the session ends. Once receipted,
  attendance and the registration's fee cannot be changed or deleted.

## Daily work

The front desk and program coordinators consult the same availability listing
for advertised details, offered seats, registrations, attendance, and remaining
places, including sessions with no bookings. It must reflect a new registration
immediately without a staff refresh or export; unpublished sessions stay private.

## Required advanced SQL report

**Workshop offered-seat yield:** Compare two session-date periods. For each
workshop with published sessions in either period, show offered sessions, offered
seats, registrations, attended registrations, fees charged, attendance percentage
of registrations, and charged fees per offered seat for each period. Also show
the change in fees per offered seat. Count fees for all registrations, whether
attended or not; this is not a payment-collection report.

Include empty sessions in offered seats and sessions, and workshops active in
only one period. Sum capacity once per session, not once per registration. Use
published workshop identities and capacities, and actual registration fees. This
extends registration performance to compare supply, attendance, and fee yield.

## Evidence to include

Include multiple sessions of one workshop, an empty session, a discounted fee,
attended and nonattended registrations, and a changed catalog fee between
publications. Reject over-capacity registration, duplicate attendance receipts,
premature attendance, and changes that would rewrite a published offer.
