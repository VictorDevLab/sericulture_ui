import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_states.dart';
import '../../shared/presentation/feature_link.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    AppSpacing.lg,
                    AppSpacing.page,
                    AppSpacing.xl,
                  ),
                  sliver: SliverList.list(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.forest,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.eco_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Sericulture',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Settings',
                            onPressed: () => context.go('/more/settings'),
                            icon: const Icon(Icons.settings_outlined),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'Good husbandry,\none healthy batch at a time.',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.14,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'A clear workspace for managing Eri and Bombyx mori rearing.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Your rearing workspace',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const AppEmptyState(
                              title: 'A fresh start',
                              message:
                                  'Create a batch when you are ready. Records will be connected to local storage in the next implementation phase.',
                              icon: Icons.spa_outlined,
                            ),
                            FilledButton.icon(
                              onPressed: () => context.go('/batches/create'),
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Prepare a batch'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'REARING TOOLS',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FeatureLinkList(
                        items: const [
                          FeatureLink(
                            title: 'Feeding logs',
                            description: 'Record feedings and observations',
                            path: '/care/feeding',
                            icon: Icons.grass_rounded,
                          ),
                          FeatureLink(
                            title: 'Environment',
                            description: 'Monitor rearing conditions',
                            path: '/care/environment',
                            icon: Icons.thermostat_rounded,
                          ),
                          FeatureLink(
                            title: 'Lifecycle calendar',
                            description: 'Plan stages and key dates',
                            path: '/care/lifecycle',
                            icon: Icons.calendar_month_rounded,
                          ),
                        ],
                      ),
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
