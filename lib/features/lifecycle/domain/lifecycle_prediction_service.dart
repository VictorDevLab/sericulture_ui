import 'lifecycle_models.dart';
import 'lifecycle_schedules.dart';

/// Calculates deterministic calendar-date predictions from source schedules.
class LifecyclePredictionService {
  const LifecyclePredictionService();

  LifecyclePrediction predict({
    required SilkwormSpecies species,
    required DateTime cycleStartDate,
    DateTime? referenceDate,
  }) {
    final schedule = switch (species) {
      SilkwormSpecies.eri => LifecycleSchedules.eri,
      SilkwormSpecies.bombyxMori => LifecycleSchedules.bombyxMori,
    };
    final startDate = _dateOnly(cycleStartDate);
    final reference = _dateOnly(referenceDate ?? startDate);
    final predictionsById = <String, PredictedLifecycleEvent>{};
    final predictions = <PredictedLifecycleEvent>[];

    for (final definition in schedule.events) {
      final prediction = switch (definition.timing) {
        CumulativeDayTiming(:final window) => _predictCumulativeEvent(
          definition,
          window,
          startDate,
        ),
        RelativeDurationTiming timing => _predictRelativeEvent(
          definition,
          timing,
          predictionsById,
        ),
      };
      predictions.add(prediction);
      predictionsById[definition.id] = prediction;
    }

    final currentEvents = predictions
        .where((event) => event.isCurrentOn(reference))
        .toList(growable: false);
    final currentStages = <LifecycleStage>[];
    for (final event in currentEvents) {
      final stage = event.definition.stage;
      if (stage != null && !currentStages.contains(stage)) {
        currentStages.add(stage);
      }
    }

    final notes = <ScheduleNote>[
      ...schedule.notes,
      for (final event in schedule.events) ...event.notes,
    ];
    return LifecyclePrediction(
      schedule: schedule,
      cycleStartDate: startDate,
      referenceDate: reference,
      events: List.unmodifiable(predictions),
      currentEvents: List.unmodifiable(currentEvents),
      currentExpectedStages: List.unmodifiable(currentStages),
      currentMilestones: List.unmodifiable(
        currentEvents.where(_isMilestone).toList(growable: false),
      ),
      upcomingEvents: List.unmodifiable(
        predictions
            .where(
              (event) => event.possibleStartDates.earliest.isAfter(reference),
            )
            .toList(growable: false),
      ),
      feedingEvents: List.unmodifiable(
        predictions
            .where((event) => event.definition.feedingInstruction != null)
            .toList(growable: false),
      ),
      notes: List.unmodifiable(notes),
    );
  }

  static PredictedLifecycleEvent _predictCumulativeEvent(
    LifecycleEventDefinition definition,
    CumulativeDayWindow window,
    DateTime cycleStartDate,
  ) {
    final start = _dateForCycleDay(cycleStartDate, window.startDay);
    final earliestEnd = _dateForCycleDay(cycleStartDate, window.earliestEndDay);
    final latestEnd = _dateForCycleDay(cycleStartDate, window.latestEndDay);
    return PredictedLifecycleEvent(
      definition: definition,
      dates: PredictedDateRange(earliest: start, latest: latestEnd),
      possibleStartDates: PredictedDateRange(earliest: start, latest: start),
      possibleEndDates: PredictedDateRange(
        earliest: earliestEnd,
        latest: latestEnd,
      ),
    );
  }

  static PredictedLifecycleEvent _predictRelativeEvent(
    LifecycleEventDefinition definition,
    RelativeDurationTiming timing,
    Map<String, PredictedLifecycleEvent> predictionsById,
  ) {
    final anchor = predictionsById[timing.anchorEventId];
    if (anchor == null) {
      throw StateError(
        'Relative event ${definition.id} requires earlier anchor '
        '${timing.anchorEventId}.',
      );
    }

    // The relative duration begins the calendar day after anchor completion.
    final earliestStart = _addCalendarDays(anchor.possibleEndDates.earliest, 1);
    final latestStart = _addCalendarDays(anchor.possibleEndDates.latest, 1);
    final earliestEnd = _addCalendarDays(
      anchor.possibleEndDates.earliest,
      timing.minimumDays,
    );
    final latestEnd = _addCalendarDays(
      anchor.possibleEndDates.latest,
      timing.maximumDays,
    );
    return PredictedLifecycleEvent(
      definition: definition,
      dates: PredictedDateRange(earliest: earliestStart, latest: latestEnd),
      possibleStartDates: PredictedDateRange(
        earliest: earliestStart,
        latest: latestStart,
      ),
      possibleEndDates: PredictedDateRange(
        earliest: earliestEnd,
        latest: latestEnd,
      ),
      durationDays: DayNumberRange(
        earliest: timing.minimumDays,
        latest: timing.maximumDays,
      ),
    );
  }

  static bool _isMilestone(PredictedLifecycleEvent event) =>
      switch (event.definition.category) {
        LifecycleActivityCategory.cocoonMeasurement ||
        LifecycleActivityCategory.emergenceAndEggLaying ||
        LifecycleActivityCategory.harvest => true,
        _ => false,
      };

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _dateForCycleDay(DateTime cycleStartDate, int cycleDay) =>
      DateTime(
        cycleStartDate.year,
        cycleStartDate.month,
        cycleStartDate.day + cycleDay - 1,
      );

  static DateTime _addCalendarDays(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);
}
