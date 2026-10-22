import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_states.dart';
import '../../lifecycle/domain/lifecycle_models.dart';
import '../../lifecycle/domain/lifecycle_prediction_service.dart';
import '../domain/batch.dart';
import '../domain/batch_repository.dart';
import 'batch_labels.dart';

class BatchDetailsScreen extends StatefulWidget {
  const BatchDetailsScreen({
    required this.batchId,
    required this.repository,
    required this.referenceDate,
    super.key,
  });

  final String batchId;
  final BatchRepository repository;
  final DateTime Function() referenceDate;

  @override
  State<BatchDetailsScreen> createState() => _BatchDetailsScreenState();
}

class _BatchDetailsScreenState extends State<BatchDetailsScreen> {
  late Future<Batch?> _batchFuture;

  @override
  void initState() {
    super.initState();
    _batchFuture = widget.repository.getById(widget.batchId.trim());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Batch details')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: FutureBuilder<Batch?>(
            future: _batchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const AppLoadingState(message: 'Loading batch…');
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.page),
                  child: AppErrorState(
                    message: 'Batch details could not be loaded.',
                  ),
                );
              }
              final batch = snapshot.data;
              if (batch == null) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.page),
                  child: AppEmptyState(
                    title: 'Batch not found',
                    message:
                        'This batch ID is not available in the current local session.',
                    icon: Icons.search_off_rounded,
                  ),
                );
              }
              return _BatchDetailContent(
                batch: batch,
                referenceDate: widget.referenceDate(),
              );
            },
          ),
        ),
      ),
    ),
  );
}

class _BatchDetailContent extends StatelessWidget {
  const _BatchDetailContent({required this.batch, required this.referenceDate});

  final Batch batch;
  final DateTime referenceDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );
    final start = DateTime(
      batch.startDate.year,
      batch.startDate.month,
      batch.startDate.day,
    );
    final elapsedDay = today.difference(start).inDays + 1;
    LifecyclePrediction? prediction;
    String? predictionError;
    try {
      prediction = const LifecyclePredictionService().predict(
        species: batch.species,
        cycleStartDate: batch.startDate,
        referenceDate: today,
      );
    } catch (_) {
      predictionError = 'Lifecycle predictions are unavailable for this batch.';
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.page),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(batch.id, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                speciesLabel(batch.species),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  Chip(label: Text(statusLabel(batch.status))),
                  Chip(label: Text(batch.strain)),
                ],
              ),
              const Divider(height: AppSpacing.lg),
              _DetailRow(
                label: 'Start date',
                value: MaterialLocalizations.of(
                  context,
                ).formatMediumDate(start),
              ),
              _DetailRow(
                label: 'Cycle day',
                value: elapsedDay < 1
                    ? 'Not started · begins in ${1 - elapsedDay} ${1 - elapsedDay == 1 ? 'day' : 'days'}'
                    : 'Day $elapsedDay',
              ),
              _DetailRow(
                label: 'Initial eggs / larvae',
                value: '${batch.initialCount}',
              ),
              _DetailRow(label: 'Egg source', value: batch.eggSource),
              _DetailRow(
                label: 'Rearing location',
                value: batch.rearingLocation,
              ),
              _DetailRow(label: 'Caretaker', value: batch.caretakerName),
              _DetailRow(
                label: 'Feeding material',
                value: batch.feedingMaterial,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionTitle(title: 'Lifecycle prediction'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Schedule-based estimate only · not an observation of farm conditions.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (predictionError != null)
                AppErrorState(message: predictionError)
              else ...[
                Text('Expected now', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                if (prediction!.currentExpectedStages.isEmpty)
                  const Text('No expected stage is defined for this date.')
                else
                  Text(
                    prediction.currentExpectedStages
                        .map(stageLabel)
                        .join(' · '),
                    key: const Key('expectedCurrentStage'),
                    style: theme.textTheme.bodyLarge,
                  ),
                if (prediction.currentMilestones.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  for (final event in prediction.currentMilestones)
                    Text('Milestone: ${event.definition.title}'),
                ],
                const SizedBox(height: AppSpacing.md),
                Text('Upcoming events', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                if (prediction.upcomingEvents.isEmpty)
                  const Text(
                    'No later events are listed in the supplied schedule.',
                  )
                else
                  for (final event in prediction.upcomingEvents.take(6))
                    _EventLine(
                      title: event.definition.title,
                      dates: _formatRange(context, event.dates),
                    ),
                const SizedBox(height: AppSpacing.md),
                Text('Feeding instructions', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                ..._feedingEntries(prediction).map(
                  (event) => _EventLine(
                    title: event.definition.feedingInstruction!.description,
                    dates: _formatRange(context, event.dates),
                  ),
                ),
                if (_feedingEntries(prediction).isEmpty)
                  const Text(
                    'No feeding instruction is scheduled for this date.',
                  ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Source and uncertainty notes',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(prediction.schedule.sourceTitle),
                for (final note in prediction.notes)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      '• ${note.text}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionTitle(title: 'Related tools'),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _NavigationTile(
                icon: Icons.grass_rounded,
                label: 'Feeding logs',
                path: '/care/feeding',
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.calendar_month_rounded,
                label: 'Lifecycle calendar',
                path: '/care/lifecycle',
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Icons.thermostat_rounded,
                label: 'Environmental monitoring',
                path: '/care/environment',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  static List<PredictedLifecycleEvent> _feedingEntries(
    LifecyclePrediction prediction,
  ) => prediction.feedingEvents
      .where(
        (event) =>
            event.isCurrentOn(prediction.referenceDate) ||
            event.possibleStartDates.earliest.isAfter(prediction.referenceDate),
      )
      .take(5)
      .toList(growable: false);

  static String _formatRange(BuildContext context, PredictedDateRange range) {
    final localizations = MaterialLocalizations.of(context);
    final first = localizations.formatShortDate(range.earliest);
    if (range.earliest == range.latest) return first;
    return '$first – ${localizations.formatShortDate(range.latest)}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

class _EventLine extends StatelessWidget {
  const _EventLine({required this.title, required this.dates});

  final String title;
  final String dates;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.event_outlined, size: 18),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: Text(title)),
        const SizedBox(width: AppSpacing.sm),
        Text(dates, style: Theme.of(context).textTheme.labelMedium),
      ],
    ),
  );
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.icon,
    required this.label,
    required this.path,
  });

  final IconData icon;
  final String label;
  final String path;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(label),
    trailing: const Icon(Icons.chevron_right_rounded),
    onTap: () => context.go(path),
  );
}
