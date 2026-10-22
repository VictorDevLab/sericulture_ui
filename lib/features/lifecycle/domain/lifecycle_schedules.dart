import 'lifecycle_models.dart';

/// Auditable source-derived schedules. These definitions deliberately retain
/// source day ranges and ambiguities rather than imposing biological rules.
abstract final class LifecycleSchedules {
  static final eri = LifecycleScheduleDefinition(
    species: SilkwormSpecies.eri,
    sourceTitle: 'Predictive rearing days for Eri silkworm',
    notes: [
      ScheduleNote(
        kind: ScheduleNoteKind.ambiguity,
        text:
            'Day 25 is the cumulative day on which the pupae/spinning schedule begins; the source also lists stage-local days 8–10. Their relationship is unspecified, so stage-local days are metadata only.',
      ),
      ScheduleNote(
        kind: ScheduleNoteKind.ambiguity,
        text:
            'Cocoon measurement on cumulative day 32 does not define a cocoon-stage start or duration.',
      ),
      ScheduleNote(
        kind: ScheduleNoteKind.ambiguity,
        text:
            'Moth emergence and egg laying are listed at cumulative day 39 with stage-local days 1–4; the source does not map those four days to cumulative dates.',
      ),
      ScheduleNote(
        kind: ScheduleNoteKind.source,
        text:
            'No feeding instructions are specified after the day-25 instruction to continue feeding until all worms have spun.',
      ),
    ],
    events: [
      _eriFeeding(
        'eri-day-1',
        1,
        1,
        LifecycleStage.firstInstar,
        1,
        1,
        FeedingAction.feed,
        'Feeding.',
      ),
      _eriFeeding(
        'eri-day-2-3',
        2,
        3,
        LifecycleStage.firstInstar,
        2,
        3,
        FeedingAction.feed,
        'Feeding.',
      ),
      _eriFeeding(
        'eri-day-4',
        4,
        4,
        LifecycleStage.firstInstar,
        4,
        4,
        FeedingAction.noFeeding,
        'No feeding.',
      ),
      _eriFeeding(
        'eri-day-5',
        5,
        5,
        LifecycleStage.secondInstar,
        1,
        1,
        FeedingAction.lightMorningThenFullFeed,
        'Light feeding in the morning, then full feeding.',
      ),
      _eriFeeding(
        'eri-day-6',
        6,
        6,
        LifecycleStage.secondInstar,
        2,
        2,
        FeedingAction.feed,
        'Feeding.',
      ),
      _eriFeeding(
        'eri-day-7',
        7,
        7,
        LifecycleStage.secondInstar,
        3,
        3,
        FeedingAction.noFeeding,
        'No feeding.',
      ),
      _eriFeeding(
        'eri-day-8',
        8,
        8,
        LifecycleStage.thirdInstar,
        1,
        1,
        FeedingAction.lightMorningThenFullFeed,
        'Light feeding in the morning, then feeding.',
      ),
      _eriFeeding(
        'eri-day-9-10',
        9,
        10,
        LifecycleStage.thirdInstar,
        2,
        3,
        FeedingAction.feed,
        'Feeding.',
      ),
      _eriFeeding(
        'eri-day-11',
        11,
        11,
        LifecycleStage.thirdInstar,
        4,
        4,
        FeedingAction.noFeeding,
        'No feeding.',
      ),
      _eriFeeding(
        'eri-day-12',
        12,
        12,
        LifecycleStage.fourthInstar,
        1,
        1,
        FeedingAction.lightMorningThenFullFeed,
        'Light feeding in the morning, then feeding.',
      ),
      _eriFeeding(
        'eri-day-13-16',
        13,
        16,
        LifecycleStage.fourthInstar,
        2,
        5,
        FeedingAction.feed,
        'Feeding.',
      ),
      _eriFeeding(
        'eri-day-17',
        17,
        17,
        LifecycleStage.fourthInstar,
        6,
        6,
        FeedingAction.noFeeding,
        'No feeding.',
      ),
      _eriFeeding(
        'eri-day-18',
        18,
        18,
        LifecycleStage.fifthInstar,
        1,
        1,
        FeedingAction.lightMorningThenFullFeed,
        'Light feeding in the morning, then feeding.',
      ),
      _eriFeeding(
        'eri-day-19-24',
        19,
        24,
        LifecycleStage.fifthInstar,
        2,
        7,
        FeedingAction.feed,
        'Feeding.',
      ),
      LifecycleEventDefinition(
        id: 'eri-day-25-spinning',
        title: 'Pupae / spinning schedule begins',
        category: LifecycleActivityCategory.spinning,
        stage: LifecycleStage.pupaeAndSpinning,
        timing: CumulativeDayTiming(
          CumulativeDayWindow(
            startDay: 25,
            earliestEndDay: 25,
            latestEndDay: 25,
          ),
        ),
        stageDayRange: DayNumberRange(earliest: 8, latest: 10),
        feedingInstruction: FeedingInstruction(
          action: FeedingAction.continueUntil,
          description: 'Continue feeding until all worms have spun.',
        ),
      ),
      LifecycleEventDefinition(
        id: 'eri-day-32-cocoon-measurement',
        title: 'Record cocoon measurements',
        category: LifecycleActivityCategory.cocoonMeasurement,
        timing: CumulativeDayTiming(
          CumulativeDayWindow(
            startDay: 32,
            earliestEndDay: 32,
            latestEndDay: 32,
          ),
        ),
      ),
      LifecycleEventDefinition(
        id: 'eri-day-39-emergence-egg-laying',
        title: 'Moth emergence and egg laying schedule begins',
        category: LifecycleActivityCategory.emergenceAndEggLaying,
        stage: LifecycleStage.mothEmergenceAndEggLaying,
        timing: CumulativeDayTiming(
          CumulativeDayWindow(
            startDay: 39,
            earliestEndDay: 39,
            latestEndDay: 39,
          ),
        ),
        stageDayRange: DayNumberRange(earliest: 1, latest: 4),
        notes: [
          ScheduleNote(
            kind: ScheduleNoteKind.ambiguity,
            text:
                'Stage-local days 1–4 are retained as source metadata and are not converted into additional cumulative-day events.',
          ),
        ],
      ),
    ],
  );

  static final bombyxMori = LifecycleScheduleDefinition(
    species: SilkwormSpecies.bombyxMori,
    sourceTitle: 'Predictive Rearing cycle 01',
    notes: [
      ScheduleNote(
        kind: ScheduleNoteKind.ambiguity,
        text:
            'Incubation, hatching/brushing, and first-instar windows overlap in the source; they remain separate events.',
      ),
      ScheduleNote(
        kind: ScheduleNoteKind.ambiguity,
        text:
            'The source writes incubation as days 1–10/12 and fifth instar as days 27–32/33. These are represented as earliest/latest inclusive end-day bounds.',
      ),
      ScheduleNote(
        kind: ScheduleNoteKind.implementationConvention,
        text:
            'Cocoon formation is given as 3–5 days following mounting/spinning. For calculation, mounting/spinning is treated as completing on its final listed day (day 35); cocoon formation starts the next day (day 36) and lasts 3–5 inclusive calendar days, ending on cycle days 38–40. This is a date-boundary convention, not a source-defined biological transition.',
      ),
      ScheduleNote(
        kind: ScheduleNoteKind.source,
        text:
            'No feeding instructions are provided by this schedule, so none are predicted.',
      ),
    ],
    events: [
      LifecycleEventDefinition(
        id: 'bombyx-egg-incubation',
        title: 'Egg incubation',
        category: LifecycleActivityCategory.stage,
        stage: LifecycleStage.eggIncubation,
        timing: CumulativeDayTiming(
          CumulativeDayWindow(
            startDay: 1,
            earliestEndDay: 10,
            latestEndDay: 12,
          ),
        ),
      ),
      _bombyxWindow(
        'bombyx-hatching-brushing',
        'Hatching and brushing',
        LifecycleActivityCategory.stage,
        LifecycleStage.hatching,
        10,
        12,
      ),
      _bombyxWindow(
        'bombyx-first-instar',
        '1st instar',
        LifecycleActivityCategory.stage,
        LifecycleStage.firstInstar,
        11,
        14,
      ),
      _bombyxMoult('bombyx-first-moult', '1st moult', 14),
      _bombyxWindow(
        'bombyx-second-instar',
        '2nd instar',
        LifecycleActivityCategory.stage,
        LifecycleStage.secondInstar,
        15,
        18,
      ),
      _bombyxMoult('bombyx-second-moult', '2nd moult', 18),
      _bombyxWindow(
        'bombyx-third-instar',
        '3rd instar',
        LifecycleActivityCategory.stage,
        LifecycleStage.thirdInstar,
        19,
        22,
      ),
      _bombyxMoult('bombyx-third-moult', '3rd moult', 22),
      _bombyxWindow(
        'bombyx-fourth-instar',
        '4th instar',
        LifecycleActivityCategory.stage,
        LifecycleStage.fourthInstar,
        23,
        26,
      ),
      _bombyxMoult('bombyx-fourth-moult', '4th moult', 26),
      LifecycleEventDefinition(
        id: 'bombyx-fifth-instar',
        title: '5th instar',
        category: LifecycleActivityCategory.stage,
        stage: LifecycleStage.fifthInstar,
        timing: CumulativeDayTiming(
          CumulativeDayWindow(
            startDay: 27,
            earliestEndDay: 32,
            latestEndDay: 33,
          ),
        ),
      ),
      _bombyxWindow(
        'bombyx-mounting-spinning',
        'Mounting / spinning',
        LifecycleActivityCategory.spinning,
        LifecycleStage.pupaeAndSpinning,
        32,
        35,
      ),
      LifecycleEventDefinition(
        id: 'bombyx-cocoon-formation',
        title: 'Cocoon formation',
        category: LifecycleActivityCategory.cocoonFormation,
        stage: LifecycleStage.cocoonFormation,
        timing: RelativeDurationTiming(
          anchorEventId: 'bombyx-mounting-spinning',
          minimumDays: 3,
          maximumDays: 5,
        ),
      ),
      _bombyxWindow(
        'bombyx-harvest',
        'Harvest',
        LifecycleActivityCategory.harvest,
        LifecycleStage.cocoonFormation,
        38,
        40,
      ),
    ],
  );
}

LifecycleEventDefinition _eriFeeding(
  String id,
  int cumulativeStartDay,
  int cumulativeEndDay,
  LifecycleStage stage,
  int stageStartDay,
  int stageEndDay,
  FeedingAction action,
  String instruction,
) {
  final category = action == FeedingAction.noFeeding
      ? LifecycleActivityCategory.noFeeding
      : LifecycleActivityCategory.feeding;
  return LifecycleEventDefinition(
    id: id,
    title: instruction,
    category: category,
    stage: stage,
    timing: CumulativeDayTiming(
      CumulativeDayWindow(
        startDay: cumulativeStartDay,
        earliestEndDay: cumulativeEndDay,
        latestEndDay: cumulativeEndDay,
      ),
    ),
    stageDayRange: DayNumberRange(earliest: stageStartDay, latest: stageEndDay),
    feedingInstruction: FeedingInstruction(
      action: action,
      description: instruction,
    ),
  );
}

LifecycleEventDefinition _bombyxWindow(
  String id,
  String title,
  LifecycleActivityCategory category,
  LifecycleStage stage,
  int startDay,
  int endDay,
) => LifecycleEventDefinition(
  id: id,
  title: title,
  category: category,
  stage: stage,
  timing: CumulativeDayTiming(
    CumulativeDayWindow(
      startDay: startDay,
      earliestEndDay: endDay,
      latestEndDay: endDay,
    ),
  ),
);

LifecycleEventDefinition _bombyxMoult(String id, String title, int day) =>
    LifecycleEventDefinition(
      id: id,
      title: title,
      category: LifecycleActivityCategory.moult,
      timing: CumulativeDayTiming(
        CumulativeDayWindow(
          startDay: day,
          earliestEndDay: day,
          latestEndDay: day,
        ),
      ),
    );
