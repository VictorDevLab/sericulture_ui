# Lifecycle prediction schedules

This document records the first deterministic domain representation of the supplied schedules. Schedule constants are maintained separately from the prediction calculation in `lib/features/lifecycle/domain/lifecycle_schedules.dart`.

## Supplied schedules

- **Eri** — “Predictive rearing days for Eri silkworm”: cumulative days 1–24 contain the listed instar and feeding entries; day 25 begins the pupae/spinning schedule, with stage-local days 8–10 noted; day 32 is the cocoon measurement milestone; day 39 begins the moth emergence and egg-laying schedule, with stage-local days 1–4 noted.
- **Bombyx mori** — “Predictive Rearing cycle 01”: incubation days 1–10/12; hatching and brushing days 10–12; instars and moults as listed through fifth instar days 27–32/33; mounting/spinning days 32–35; cocoon formation for 3–5 days; harvest days 38–40.

## Day counting and dates

Cycle day 1 is the supplied cycle start date itself. Therefore cycle day $n$ is the start date plus $n - 1$ calendar days. The date components are used, and time-of-day is discarded by normalizing input dates to local midnight. Calendar arithmetic uses `DateTime`, including normal month and year rollover.

Every cumulative-day window is inclusive. A source window with an uncertain end such as days 1–10/12 maps to an earliest-end date on day 10 and a latest-end date on day 12. The predicted event envelope is the earliest possible start through the latest possible end; possible start and end date ranges remain separately available. An event is current when the reference date falls inside that inclusive envelope. Upcoming events are those whose earliest possible start is later than the reference date. An omitted reference date defaults to the cycle start date, not the system clock.

The Bombyx cocoon formation duration is relative to the preceding mounting/spinning event. For implementation, mounting/spinning is treated as completing on its final listed day, cycle day 35. The relative duration begins the following calendar day (day 36); a 3–5 inclusive calendar-day duration therefore yields possible end dates on cycle days 38–40. This convention makes the provided relative duration calculable and aligns the resulting range with the separately documented harvest window, but is not an additional biological claim.

## Preserved ambiguity and overlap

- Eri day 25 is the cumulative day that the pupae/spinning schedule begins, while “8–10” is retained only as the source's stage-local day range. The source does not explain how these day systems relate. It is not shifted to cumulative days 32–34.
- Eri day 32 measurement and day 39 emergence/egg laying are discrete documented entries. No unprovided stage duration or feeding instructions are inferred between them. Eri “days 1–4” for emergence/egg laying is retained as metadata and is not projected to cumulative dates.
- Eri feeding after the day-25 instruction to continue until all worms have spun is not extrapolated.
- Bombyx incubation (days 1–10/12), hatching/brushing (10–12), and first instar (11–14) overlap. Each remains an independent schedule event; the engine does not force a single current stage.
- Source ranges are approximate windows. The engine preserves earliest/latest dates rather than selecting a single precise date.
- No Bombyx feeding rules are supplied, so predictions contain no Bombyx feeding instructions.

## Documented values vs. implementation choices

All species names, schedule titles, event names, cumulative day values/ranges, Eri stage-local values, Eri feeding text, and Bombyx cocoon duration are taken from the task's supplied source-derived schedules. The mapping from cycle day to calendar date, inclusive interval semantics, normalized date-only comparisons, reference-date default, and day-after-anchor boundary for relative duration are calculation conventions. No temperature, humidity, historical performance, or other biological adjustments are applied.
