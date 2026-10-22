/// Domain types for source-defined sericulture lifecycle schedules.
///
/// This library is independent of Flutter so schedules can be tested and reused
/// by presentation or persistence layers without widget dependencies.
enum SilkwormSpecies { eri, bombyxMori }

enum LifecycleStage {
  eggIncubation,
  hatching,
  firstInstar,
  secondInstar,
  thirdInstar,
  fourthInstar,
  fifthInstar,
  pupaeAndSpinning,
  cocoonFormation,
  mothEmergenceAndEggLaying,
}

enum LifecycleActivityCategory {
  stage,
  feeding,
  noFeeding,
  moult,
  spinning,
  cocoonMeasurement,
  emergenceAndEggLaying,
  cocoonFormation,
  harvest,
}

enum FeedingAction { feed, noFeeding, lightMorningThenFullFeed, continueUntil }

enum ScheduleNoteKind { source, ambiguity, implementationConvention }

class DayNumberRange {
  const DayNumberRange({required this.earliest, required this.latest})
    : assert(earliest >= 1),
      assert(latest >= earliest);

  final int earliest;
  final int latest;
}

/// An inclusive cumulative-day window, including uncertain end-day bounds.
///
/// For example, source notation "days 1–10/12" is startDay=1,
/// earliestEndDay=10, latestEndDay=12.
class CumulativeDayWindow {
  const CumulativeDayWindow({
    required this.startDay,
    required this.earliestEndDay,
    required this.latestEndDay,
  }) : assert(startDay >= 1),
       assert(earliestEndDay >= startDay),
       assert(latestEndDay >= earliestEndDay);

  final int startDay;
  final int earliestEndDay;
  final int latestEndDay;
}

sealed class LifecycleEventTiming {
  const LifecycleEventTiming();
}

class CumulativeDayTiming extends LifecycleEventTiming {
  const CumulativeDayTiming(this.window);

  final CumulativeDayWindow window;
}

/// A duration counted after the completion of another scheduled event.
class RelativeDurationTiming extends LifecycleEventTiming {
  const RelativeDurationTiming({
    required this.anchorEventId,
    required this.minimumDays,
    required this.maximumDays,
  }) : assert(minimumDays >= 1),
       assert(maximumDays >= minimumDays);

  final String anchorEventId;
  final int minimumDays;
  final int maximumDays;
}

class FeedingInstruction {
  const FeedingInstruction({required this.action, required this.description});

  final FeedingAction action;
  final String description;
}

class ScheduleNote {
  const ScheduleNote({required this.kind, required this.text});

  final ScheduleNoteKind kind;
  final String text;
}

class LifecycleEventDefinition {
  const LifecycleEventDefinition({
    required this.id,
    required this.title,
    required this.category,
    required this.timing,
    this.stage,
    this.stageDayRange,
    this.feedingInstruction,
    this.notes = const [],
  });

  final String id;
  final String title;
  final LifecycleActivityCategory category;
  final LifecycleEventTiming timing;
  final LifecycleStage? stage;

  /// Stage-local day numbers supplied separately from cumulative cycle days.
  /// This is descriptive only and does not affect date calculations.
  final DayNumberRange? stageDayRange;
  final FeedingInstruction? feedingInstruction;
  final List<ScheduleNote> notes;
}

class LifecycleScheduleDefinition {
  const LifecycleScheduleDefinition({
    required this.species,
    required this.sourceTitle,
    required this.events,
    this.notes = const [],
  });

  final SilkwormSpecies species;
  final String sourceTitle;
  final List<LifecycleEventDefinition> events;
  final List<ScheduleNote> notes;
}

/// Inclusive calendar-date interval; dates are normalized to local midnight.
class PredictedDateRange {
  const PredictedDateRange({required this.earliest, required this.latest});

  final DateTime earliest;
  final DateTime latest;

  bool contains(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return !day.isBefore(earliest) && !day.isAfter(latest);
  }
}

class PredictedLifecycleEvent {
  const PredictedLifecycleEvent({
    required this.definition,
    required this.dates,
    required this.possibleStartDates,
    required this.possibleEndDates,
    this.durationDays,
  });

  final LifecycleEventDefinition definition;

  /// Inclusive envelope of dates on which the event may be active.
  final PredictedDateRange dates;

  /// Date range in which this event may begin.
  final PredictedDateRange possibleStartDates;

  /// Date range in which this event may finish.
  final PredictedDateRange possibleEndDates;

  /// Populated for source events expressed as a relative duration.
  final DayNumberRange? durationDays;

  bool isCurrentOn(DateTime date) => dates.contains(date);
}

class LifecyclePrediction {
  const LifecyclePrediction({
    required this.schedule,
    required this.cycleStartDate,
    required this.referenceDate,
    required this.events,
    required this.currentEvents,
    required this.currentExpectedStages,
    required this.currentMilestones,
    required this.upcomingEvents,
    required this.feedingEvents,
    required this.notes,
  });

  final LifecycleScheduleDefinition schedule;
  final DateTime cycleStartDate;
  final DateTime referenceDate;
  final List<PredictedLifecycleEvent> events;
  final List<PredictedLifecycleEvent> currentEvents;
  final List<LifecycleStage> currentExpectedStages;
  final List<PredictedLifecycleEvent> currentMilestones;
  final List<PredictedLifecycleEvent> upcomingEvents;
  final List<PredictedLifecycleEvent> feedingEvents;
  final List<ScheduleNote> notes;
}
