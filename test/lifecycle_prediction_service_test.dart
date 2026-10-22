import 'package:flutter_test/flutter_test.dart';
import 'package:sericulture_ui/features/lifecycle/domain/lifecycle_models.dart';
import 'package:sericulture_ui/features/lifecycle/domain/lifecycle_prediction_service.dart';

void main() {
  const service = LifecyclePredictionService();
  final start = DateTime(2024, 1, 31);

  group('cycle day and Eri schedule', () {
    test('cycle day 1 is the supplied start date', () {
      final prediction = service.predict(
        species: SilkwormSpecies.eri,
        cycleStartDate: start,
      );

      expect(
        _event(prediction, 'eri-day-1').dates.earliest,
        DateTime(2024, 1, 31),
      );
      expect(
        _event(prediction, 'eri-day-1').dates.latest,
        DateTime(2024, 1, 31),
      );
    });

    test('Eri cumulative days and instar boundaries match the schedule', () {
      final prediction = service.predict(
        species: SilkwormSpecies.eri,
        cycleStartDate: start,
      );
      final expected = <String, (LifecycleStage, int, int, DateTime, DateTime)>{
        'eri-day-1': (
          LifecycleStage.firstInstar,
          1,
          1,
          DateTime(2024, 1, 31),
          DateTime(2024, 1, 31),
        ),
        'eri-day-2-3': (
          LifecycleStage.firstInstar,
          2,
          3,
          DateTime(2024, 2, 1),
          DateTime(2024, 2, 2),
        ),
        'eri-day-5': (
          LifecycleStage.secondInstar,
          1,
          1,
          DateTime(2024, 2, 4),
          DateTime(2024, 2, 4),
        ),
        'eri-day-8': (
          LifecycleStage.thirdInstar,
          1,
          1,
          DateTime(2024, 2, 7),
          DateTime(2024, 2, 7),
        ),
        'eri-day-12': (
          LifecycleStage.fourthInstar,
          1,
          1,
          DateTime(2024, 2, 11),
          DateTime(2024, 2, 11),
        ),
        'eri-day-18': (
          LifecycleStage.fifthInstar,
          1,
          1,
          DateTime(2024, 2, 17),
          DateTime(2024, 2, 17),
        ),
      };

      for (final entry in expected.entries) {
        final event = _event(prediction, entry.key);
        expect(event.definition.stage, entry.value.$1, reason: entry.key);
        expect(event.definition.stageDayRange!.earliest, entry.value.$2);
        expect(event.definition.stageDayRange!.latest, entry.value.$3);
        expect(event.dates.earliest, entry.value.$4, reason: entry.key);
        expect(event.dates.latest, entry.value.$5, reason: entry.key);
      }
      expect(
        _event(prediction, 'eri-day-4').definition.stage,
        LifecycleStage.firstInstar,
      );
      expect(
        _event(prediction, 'eri-day-7').definition.stage,
        LifecycleStage.secondInstar,
      );
      expect(
        _event(prediction, 'eri-day-11').definition.stage,
        LifecycleStage.thirdInstar,
      );
      expect(
        _event(prediction, 'eri-day-17').definition.stage,
        LifecycleStage.fourthInstar,
      );
      expect(
        _event(prediction, 'eri-day-19-24').definition.stage,
        LifecycleStage.fifthInstar,
      );
    });

    test('Eri no-feeding and light-feeding instructions are explicit', () {
      final prediction = service.predict(
        species: SilkwormSpecies.eri,
        cycleStartDate: start,
      );
      for (final id in ['eri-day-4', 'eri-day-7', 'eri-day-11', 'eri-day-17']) {
        expect(
          _event(prediction, id).definition.feedingInstruction!.action,
          FeedingAction.noFeeding,
        );
      }
      for (final id in ['eri-day-5', 'eri-day-8', 'eri-day-12', 'eri-day-18']) {
        expect(
          _event(prediction, id).definition.feedingInstruction!.action,
          FeedingAction.lightMorningThenFullFeed,
        );
      }
      expect(
        _event(
          prediction,
          'eri-day-25-spinning',
        ).definition.feedingInstruction!.action,
        FeedingAction.continueUntil,
      );
    });

    test('Eri later documented milestones stay on cumulative days', () {
      final prediction = service.predict(
        species: SilkwormSpecies.eri,
        cycleStartDate: start,
      );
      expect(
        _event(prediction, 'eri-day-25-spinning').dates.earliest,
        DateTime(2024, 2, 24),
      );
      final spinning = _event(prediction, 'eri-day-25-spinning');
      expect(spinning.definition.stageDayRange!.earliest, 8);
      expect(spinning.definition.stageDayRange!.latest, 10);
      expect(
        _event(prediction, 'eri-day-32-cocoon-measurement').dates.earliest,
        DateTime(2024, 3, 2),
      );
      expect(
        _event(prediction, 'eri-day-39-emergence-egg-laying').dates.earliest,
        DateTime(2024, 3, 9),
      );
      final emergence = _event(prediction, 'eri-day-39-emergence-egg-laying');
      expect(emergence.definition.stageDayRange!.earliest, 1);
      expect(emergence.definition.stageDayRange!.latest, 4);
    });

    test('Eri does not invent a stage or feeding instruction after day 25', () {
      final prediction = service.predict(
        species: SilkwormSpecies.eri,
        cycleStartDate: start,
        referenceDate: DateTime(2024, 2, 25),
      );

      expect(prediction.currentExpectedStages, isEmpty);
      expect(prediction.feedingEvents.length, 15);
      expect(
        prediction.events
            .where((event) => event.definition.stage != null)
            .map((event) => event.definition.id),
        isNot(contains('eri-day-32-cocoon-measurement')),
      );
    });
  });

  group('Bombyx mori schedule', () {
    test('incubation and hatching windows are preserved inclusively', () {
      final prediction = service.predict(
        species: SilkwormSpecies.bombyxMori,
        cycleStartDate: start,
      );
      final incubation = _event(prediction, 'bombyx-egg-incubation');
      expect(incubation.dates.earliest, DateTime(2024, 1, 31));
      expect(incubation.dates.latest, DateTime(2024, 2, 11));
      expect(incubation.possibleEndDates.earliest, DateTime(2024, 2, 9));
      expect(incubation.possibleEndDates.latest, DateTime(2024, 2, 11));

      final hatching = _event(prediction, 'bombyx-hatching-brushing');
      expect(hatching.dates.earliest, DateTime(2024, 2, 9));
      expect(hatching.dates.latest, DateTime(2024, 2, 11));
    });

    test('all five instars and four moults retain source day numbers', () {
      final prediction = service.predict(
        species: SilkwormSpecies.bombyxMori,
        cycleStartDate: start,
      );
      final instars = <String, (int, int, int)>{
        'bombyx-first-instar': (11, 14, 14),
        'bombyx-second-instar': (15, 18, 18),
        'bombyx-third-instar': (19, 22, 22),
        'bombyx-fourth-instar': (23, 26, 26),
        'bombyx-fifth-instar': (27, 32, 33),
      };
      for (final entry in instars.entries) {
        final event = _event(prediction, entry.key);
        final timing = event.definition.timing as CumulativeDayTiming;
        expect(timing.window.startDay, entry.value.$1);
        expect(timing.window.earliestEndDay, entry.value.$2);
        expect(timing.window.latestEndDay, entry.value.$3);
      }

      for (final day in [14, 18, 22, 26]) {
        final event = prediction.events.singleWhere(
          (candidate) =>
              candidate.definition.category ==
                  LifecycleActivityCategory.moult &&
              candidate.definition.timing is CumulativeDayTiming &&
              (candidate.definition.timing as CumulativeDayTiming)
                      .window
                      .startDay ==
                  day,
        );
        expect(event.dates.earliest, DateTime(2024, 1, 31 + day - 1));
      }
    });

    test('mounting, relative cocoon duration, and harvest retain ranges', () {
      final prediction = service.predict(
        species: SilkwormSpecies.bombyxMori,
        cycleStartDate: start,
      );
      final mounting = _event(prediction, 'bombyx-mounting-spinning');
      expect(mounting.dates.earliest, DateTime(2024, 3, 2));
      expect(mounting.dates.latest, DateTime(2024, 3, 5));

      final cocoon = _event(prediction, 'bombyx-cocoon-formation');
      expect(cocoon.durationDays!.earliest, 3);
      expect(cocoon.durationDays!.latest, 5);
      expect(cocoon.possibleStartDates.earliest, DateTime(2024, 3, 6));
      expect(cocoon.possibleEndDates.earliest, DateTime(2024, 3, 8));
      expect(cocoon.possibleEndDates.latest, DateTime(2024, 3, 10));

      final harvest = _event(prediction, 'bombyx-harvest');
      expect(harvest.dates.earliest, DateTime(2024, 3, 8));
      expect(harvest.dates.latest, DateTime(2024, 3, 10));
    });

    test('overlapping source events remain current together', () {
      final prediction = service.predict(
        species: SilkwormSpecies.bombyxMori,
        cycleStartDate: start,
        referenceDate: DateTime(2024, 2, 10), // cycle day 11
      );

      expect(
        prediction.currentExpectedStages,
        containsAll([
          LifecycleStage.eggIncubation,
          LifecycleStage.hatching,
          LifecycleStage.firstInstar,
        ]),
      );
      expect(
        prediction.currentEvents.map((event) => event.definition.id),
        containsAll([
          'bombyx-egg-incubation',
          'bombyx-hatching-brushing',
          'bombyx-first-instar',
        ]),
      );
    });

    test('no feeding is predicted where the schedule supplies none', () {
      final prediction = service.predict(
        species: SilkwormSpecies.bombyxMori,
        cycleStartDate: start,
      );
      expect(prediction.feedingEvents, isEmpty);
    });
  });

  group('dates and reference dates', () {
    test('calendar arithmetic rolls over month and year boundaries', () {
      final yearEnd = service.predict(
        species: SilkwormSpecies.eri,
        cycleStartDate: DateTime(2024, 12, 31),
      );
      expect(
        _event(yearEnd, 'eri-day-1').dates.earliest,
        DateTime(2024, 12, 31),
      );
      expect(
        _event(yearEnd, 'eri-day-2-3').dates.earliest,
        DateTime(2025, 1, 1),
      );
      expect(
        _event(yearEnd, 'eri-day-39-emergence-egg-laying').dates.earliest,
        DateTime(2025, 2, 7),
      );
    });

    test(
      'reference dates before, during, and after the schedule are deterministic',
      () {
        final before = service.predict(
          species: SilkwormSpecies.eri,
          cycleStartDate: start,
          referenceDate: DateTime(2024, 1, 30),
        );
        expect(before.currentEvents, isEmpty);
        expect(before.upcomingEvents.first.definition.id, 'eri-day-1');

        final during = service.predict(
          species: SilkwormSpecies.eri,
          cycleStartDate: start,
          referenceDate: DateTime(2024, 2, 4), // cycle day 5
        );
        expect(during.currentExpectedStages, [LifecycleStage.secondInstar]);
        expect(during.currentEvents.single.definition.id, 'eri-day-5');
        expect(during.upcomingEvents.first.definition.id, 'eri-day-6');

        final after = service.predict(
          species: SilkwormSpecies.eri,
          cycleStartDate: start,
          referenceDate: DateTime(2024, 4, 1),
        );
        expect(after.currentEvents, isEmpty);
        expect(after.currentExpectedStages, isEmpty);
        expect(after.upcomingEvents, isEmpty);
      },
    );

    test('predicted ranges include both boundary dates', () {
      final range = PredictedDateRange(
        earliest: DateTime(2024, 2, 1),
        latest: DateTime(2024, 2, 3),
      );
      expect(range.contains(DateTime(2024, 2, 1)), isTrue);
      expect(range.contains(DateTime(2024, 2, 3)), isTrue);
      expect(range.contains(DateTime(2024, 1, 31)), isFalse);
      expect(range.contains(DateTime(2024, 2, 4)), isFalse);
    });

    test('source uncertainty notes remain available in prediction output', () {
      final eri = service.predict(
        species: SilkwormSpecies.eri,
        cycleStartDate: start,
      );
      final bombyx = service.predict(
        species: SilkwormSpecies.bombyxMori,
        cycleStartDate: start,
      );
      expect(
        eri.notes.any((note) => note.kind == ScheduleNoteKind.ambiguity),
        isTrue,
      );
      expect(
        eri.notes.any((note) => note.text.contains('stage-local days 8–10')),
        isTrue,
      );
      expect(bombyx.notes.any((note) => note.text.contains('overlap')), isTrue);
      expect(
        bombyx.notes.any(
          (note) => note.kind == ScheduleNoteKind.implementationConvention,
        ),
        isTrue,
      );
    });
  });
}

PredictedLifecycleEvent _event(LifecyclePrediction prediction, String id) =>
    prediction.events.singleWhere((event) => event.definition.id == id);
