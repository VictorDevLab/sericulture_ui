import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_states.dart';
import '../../lifecycle/domain/lifecycle_models.dart';
import '../../lifecycle/domain/lifecycle_prediction_service.dart';
import '../domain/batch.dart';
import '../domain/batch_repository.dart';
import 'batch_labels.dart';

class BatchesScreen extends StatefulWidget {
  const BatchesScreen({
    required this.repository,
    required this.referenceDate,
    super.key,
  });

  final BatchRepository repository;
  final DateTime Function() referenceDate;

  @override
  State<BatchesScreen> createState() => _BatchesScreenState();
}

class _BatchesScreenState extends State<BatchesScreen> {
  final _searchController = TextEditingController();
  late Future<List<Batch>> _batchesFuture;
  SilkwormSpecies? _speciesFilter;
  BatchStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _batchesFuture = widget.repository.getAll();
    _searchController.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onFilterChanged)
      ..dispose();
    super.dispose();
  }

  void _onFilterChanged() => setState(() {});

  void _refresh() => setState(() {
    _batchesFuture = widget.repository.getAll();
  });

  void _clearFilters() => setState(() {
    _searchController.clear();
    _speciesFilter = null;
    _statusFilter = null;
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Batches')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('createBatchAction'),
        onPressed: () async {
          await context.push('/batches/create');
          _refresh();
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create batch'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: FutureBuilder<List<Batch>>(
              future: _batchesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const AppLoadingState(message: 'Loading batches…');
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.page),
                    child: AppErrorState(
                      message: 'Batches could not be loaded. Please try again.',
                      onRetry: _refresh,
                    ),
                  );
                }
                final batches = snapshot.data ?? const <Batch>[];
                final filtered = _filter(batches);
                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.sm,
                    AppSpacing.page,
                    100,
                  ),
                  children: [
                    Text(
                      'Manage each rearing cycle from egg to cocoon.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Demo records are kept in memory only; they are not saved to disk or a server.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _filters(context),
                    const SizedBox(height: AppSpacing.md),
                    if (batches.isEmpty)
                      AppCard(
                        child: AppEmptyState(
                          title: 'No batches yet',
                          message:
                              'Create a batch to see its details and schedule-based lifecycle estimates.',
                          icon: Icons.spa_outlined,
                          action: AppPrimaryButton(
                            label: 'Create a batch',
                            icon: Icons.add_rounded,
                            onPressed: () => context.push('/batches/create'),
                          ),
                        ),
                      )
                    else if (filtered.isEmpty)
                      AppCard(
                        child: AppEmptyState(
                          title: 'No matching batches',
                          message: 'Try another search or clear the filters.',
                          icon: Icons.search_off_rounded,
                          action: TextButton.icon(
                            onPressed: _clearFilters,
                            icon: const Icon(Icons.filter_alt_off_outlined),
                            label: const Text('Clear filters'),
                          ),
                        ),
                      )
                    else ...[
                      Text(
                        '${filtered.length} ${filtered.length == 1 ? 'batch' : 'batches'}',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final batch in filtered) ...[
                        _BatchCard(
                          batch: batch,
                          referenceDate: widget.referenceDate(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _filters(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('batchSearchField'),
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Search by batch ID or strain',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: _searchController.clear,
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 440;
              final species = DropdownButtonFormField<SilkwormSpecies?>(
                key: const Key('speciesFilter'),
                initialValue: _speciesFilter,
                decoration: const InputDecoration(labelText: 'Species'),
                items: [
                  const DropdownMenuItem<SilkwormSpecies?>(
                    value: null,
                    child: Text('All species'),
                  ),
                  ...SilkwormSpecies.values.map(
                    (species) => DropdownMenuItem(
                      value: species,
                      child: Text(speciesLabel(species)),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _speciesFilter = value),
              );
              final status = DropdownButtonFormField<BatchStatus?>(
                key: const Key('statusFilter'),
                initialValue: _statusFilter,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  const DropdownMenuItem<BatchStatus?>(
                    value: null,
                    child: Text('All statuses'),
                  ),
                  ...BatchStatus.values.map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(statusLabel(value)),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _statusFilter = value),
              );
              if (compact) {
                return Column(
                  children: [
                    species,
                    const SizedBox(height: AppSpacing.sm),
                    status,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: species),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: status),
                ],
              );
            },
          ),
          if (_hasFilters) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.filter_alt_off_outlined),
                label: Text('Clear filters', style: theme.textTheme.labelLarge),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool get _hasFilters =>
      _searchController.text.isNotEmpty ||
      _speciesFilter != null ||
      _statusFilter != null;

  List<Batch> _filter(List<Batch> batches) {
    final query = _searchController.text.trim().toLowerCase();
    return batches
        .where((batch) {
          final textMatches =
              query.isEmpty ||
              batch.id.toLowerCase().contains(query) ||
              batch.strain.toLowerCase().contains(query);
          return textMatches &&
              (_speciesFilter == null || batch.species == _speciesFilter) &&
              (_statusFilter == null || batch.status == _statusFilter);
        })
        .toList(growable: false);
  }
}

class _BatchCard extends StatelessWidget {
  const _BatchCard({required this.batch, required this.referenceDate});

  final Batch batch;
  final DateTime referenceDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prediction = const LifecyclePredictionService().predict(
      species: batch.species,
      cycleStartDate: batch.startDate,
      referenceDate: referenceDate,
    );
    final stages = prediction.currentExpectedStages;
    final stageText = stages.isEmpty
        ? 'Stage unavailable for this date'
        : stages.map(stageLabel).join(' · ');

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        key: Key('batchCard-${batch.id}'),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: () => context.push('/batches/${Uri.encodeComponent(batch.id)}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      batch.id,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _StatusBadge(status: batch.status),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text('${speciesLabel(batch.species)} · ${batch.strain}'),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xs,
                children: [
                  _Metadata(
                    icon: Icons.calendar_today_outlined,
                    text:
                        'Started ${MaterialLocalizations.of(context).formatShortDate(batch.startDate)}',
                  ),
                  _Metadata(
                    icon: Icons.egg_alt_outlined,
                    text: '${batch.initialCount} eggs / larvae',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Expected: $stageText',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final BatchStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        child: Text(
          statusLabel(status),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.onSecondaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: AppSpacing.xxs),
      Text(text, style: Theme.of(context).textTheme.labelMedium),
    ],
  );
}
