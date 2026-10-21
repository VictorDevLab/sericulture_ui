import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../shared/presentation/feature_link.dart';

class CreateBatchScreen extends StatelessWidget {
  const CreateBatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Create batch',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Set up a rearing cycle',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Batch validation and local saving will be added with the batch domain and storage layer.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppCard(
            child: Column(
              children: [
                AppTextField(label: 'Batch name', hint: 'e.g. Monsoon rearing'),
                SizedBox(height: AppSpacing.md),
                _SpeciesSelector(),
                SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Start date',
                  hint: 'Choose a date',
                  prefixIcon: Icons.calendar_today_outlined,
                ),
                SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Starting quantity',
                  hint: 'Enter a count',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.numbers_rounded,
                ),
                SizedBox(height: AppSpacing.md),
                _SaveNotAvailableNote(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeciesSelector extends StatelessWidget {
  const _SpeciesSelector();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: null,
      decoration: const InputDecoration(labelText: 'Species'),
      hint: const Text('Select a species'),
      items: const [
        DropdownMenuItem(value: 'eri', child: Text('Eri (Samia ricini)')),
        DropdownMenuItem(value: 'bombyx', child: Text('Bombyx mori')),
      ],
      onChanged: null,
    );
  }
}

class _SaveNotAvailableNote extends StatelessWidget {
  const _SaveNotAvailableNote();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Saving is not enabled until local storage is implemented.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
