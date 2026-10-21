import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_states.dart';
import '../../shared/presentation/feature_link.dart';

class BatchesScreen extends StatelessWidget {
  const BatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Batches',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Manage each rearing cycle from egg to cocoon.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: AppEmptyState(
              title: 'No batches yet',
              message:
                  'Batch records will be stored locally first when persistence is added.',
              icon: Icons.spa_outlined,
              action: AppPrimaryButton(
                label: 'Create a batch',
                icon: Icons.add_rounded,
                onPressed: () => context.go('/batches/create'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
