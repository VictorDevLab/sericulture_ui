import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

class FeatureLink {
  const FeatureLink({
    required this.title,
    required this.description,
    required this.path,
    required this.icon,
  });

  final String title;
  final String description;
  final String path;
  final IconData icon;
}

class FeatureLinkList extends StatelessWidget {
  const FeatureLinkList({required this.items, super.key});

  final List<FeatureLink> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        for (final item in items) ...[
          AppCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              minVerticalPadding: 16,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              leading: CircleAvatar(
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.onPrimaryContainer,
                child: Icon(item.icon),
              ),
              title: Text(item.title),
              subtitle: Text(item.description),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.go(item.path),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class FeaturePage extends StatelessWidget {
  const FeaturePage({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.page),
              child: SingleChildScrollView(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
