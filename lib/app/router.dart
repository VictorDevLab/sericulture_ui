import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/batches/presentation/batch_details_screen.dart';
import '../features/batches/presentation/batches_screen.dart';
import '../features/batches/presentation/create_batch_screen.dart';
import '../features/care/presentation/care_hub_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/shared/presentation/feature_placeholder_screen.dart';
import '../features/shared/presentation/more_hub_screen.dart';
import 'app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/batches',
              builder: (context, state) => const BatchesScreen(),
              routes: [
                GoRoute(
                  path: 'create',
                  builder: (context, state) => const CreateBatchScreen(),
                ),
                GoRoute(
                  path: ':batchId',
                  builder: (context, state) => BatchDetailsScreen(
                    batchId: state.pathParameters['batchId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/care',
              builder: (context, state) => const CareHubScreen(),
              routes: [
                GoRoute(
                  path: 'feeding',
                  builder: (context, state) => const FeaturePlaceholderScreen(
                    title: 'Feeding logs',
                    description:
                        'A future home for feed schedules, quantities, and husbandry notes.',
                    icon: Icons.grass_rounded,
                  ),
                ),
                GoRoute(
                  path: 'lifecycle',
                  builder: (context, state) => const FeaturePlaceholderScreen(
                    title: 'Lifecycle calendar',
                    description:
                        'Plan and review lifecycle stages for each rearing batch.',
                    icon: Icons.calendar_month_rounded,
                  ),
                ),
                GoRoute(
                  path: 'environment',
                  builder: (context, state) => const FeaturePlaceholderScreen(
                    title: 'Environmental monitoring',
                    description:
                        'Capture conditions such as temperature and humidity.',
                    icon: Icons.thermostat_rounded,
                  ),
                ),
                GoRoute(
                  path: 'cocoons',
                  builder: (context, state) => const FeaturePlaceholderScreen(
                    title: 'Cocoon analysis',
                    description:
                        'A workspace for cocoon observations and quality assessments.',
                    icon: Icons.spa_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              builder: (context, state) => const MoreHubScreen(),
              routes: [
                GoRoute(
                  path: 'reports',
                  builder: (context, state) => const FeaturePlaceholderScreen(
                    title: 'Reports',
                    description:
                        'Summaries will be derived from verified local rearing records.',
                    icon: Icons.insert_chart_outlined_rounded,
                  ),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const FeaturePlaceholderScreen(
                    title: 'Settings',
                    description:
                        'Application preferences and workspace configuration.',
                    icon: Icons.settings_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  ],
  errorBuilder: (context, state) => FeaturePlaceholderScreen(
    title: 'Page unavailable',
    description: 'The requested page could not be found.',
    icon: Icons.explore_off_outlined,
  ),
);
