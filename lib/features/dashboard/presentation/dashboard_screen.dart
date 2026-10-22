import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../data/dashboard_sample_data.dart';
import 'dashboard_sections.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final overview = DashboardSampleData.overview;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.md,
                    AppSpacing.page,
                    AppSpacing.xl,
                  ),
                  sliver: SliverList.list(
                    children: [
                      _DashboardHeader(
                        onNotifications: () => _showNotImplemented(
                          context,
                          'Notifications are not available yet.',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Farm overview',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        'A sample overview for Eri and Bombyx mori rearing.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _SampleDataNotice(),
                      const SizedBox(height: AppSpacing.lg),
                      const DashboardSectionTitle(title: 'Key metrics'),
                      DashboardMetrics(metrics: overview.metrics),
                      const SizedBox(height: AppSpacing.lg),
                      const DashboardSectionTitle(title: "Today's tasks"),
                      DashboardTaskList(tasks: overview.tasks),
                      const SizedBox(height: AppSpacing.lg),
                      const DashboardSectionTitle(title: 'Alerts'),
                      DashboardAlertList(alerts: overview.alerts),
                      const SizedBox(height: AppSpacing.lg),
                      DashboardSectionTitle(
                        title: 'Active batches',
                        actionLabel: 'View all',
                        onAction: () => context.go('/batches'),
                      ),
                      DashboardBatchList(batches: overview.activeBatches),
                      const SizedBox(height: AppSpacing.md),
                      const DashboardSectionTitle(title: 'Quick actions'),
                      DashboardQuickActions(
                        onMortality: () => _showNotImplemented(
                          context,
                          'Mortality logging is not implemented. No record was saved.',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.onNotifications});

  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good morning', style: theme.textTheme.bodyLarge),
              Text(
                'Your rearing workspace',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Semantics(
          label: 'Notifications, not available yet',
          button: true,
          child: IconButton(
            tooltip: 'Notifications (not available yet)',
            onPressed: onNotifications,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded),
                Positioned(
                  right: -1,
                  top: -1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 1.5,
                      ),
                    ),
                    child: const SizedBox(width: 9, height: 9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SampleDataNotice extends StatelessWidget {
  const _SampleDataNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Illustrative sample values only · no farm records or sensors connected.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showNotImplemented(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
