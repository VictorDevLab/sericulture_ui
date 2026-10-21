import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_states.dart';
import '../../shared/presentation/feature_link.dart';

class BatchDetailsScreen extends StatelessWidget {
  const BatchDetailsScreen({required this.batchId, super.key});

  final String batchId;

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Batch details',
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Batch reference',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            SelectableText(
              batchId,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            const AppEmptyState(
              title: 'Details will appear here',
              message:
                  'Batch data is not connected yet. This screen does not fabricate a batch record.',
              icon: Icons.description_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
