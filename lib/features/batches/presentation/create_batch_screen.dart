import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../lifecycle/domain/lifecycle_models.dart';
import '../domain/batch.dart';
import '../domain/batch_repository.dart';
import 'batch_labels.dart';

class CreateBatchScreen extends StatefulWidget {
  const CreateBatchScreen({
    required this.repository,
    required this.today,
    super.key,
  });

  final BatchRepository repository;
  final DateTime Function() today;

  @override
  State<CreateBatchScreen> createState() => _CreateBatchScreenState();
}

class _CreateBatchScreenState extends State<CreateBatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _strainController = TextEditingController();
  final _countController = TextEditingController();
  final _sourceController = TextEditingController();
  final _locationController = TextEditingController();
  final _caretakerController = TextEditingController();
  final _feedingController = TextEditingController();
  SilkwormSpecies? _species;
  BatchStatus _status = BatchStatus.active;
  DateTime? _startDate;
  bool _submitting = false;

  @override
  void dispose() {
    _idController.dispose();
    _strainController.dispose();
    _countController.dispose();
    _sourceController.dispose();
    _locationController.dispose();
    _caretakerController.dispose();
    _feedingController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final today = widget.today();
    final value = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime(today.year, today.month, today.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Select cycle start date',
    );
    if (value != null) setState(() => _startDate = value);
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (_species == null) {
      setState(() {});
      return;
    }
    if (_startDate == null) {
      setState(() {});
      return;
    }
    if (!isValid) return;

    final count = int.tryParse(_countController.text.trim());
    if (count == null || count <= 0) return;
    setState(() => _submitting = true);
    try {
      final batch = await widget.repository.create(
        Batch(
          id: _idController.text,
          species: _species!,
          strain: _strainController.text,
          startDate: _startDate!,
          eggSource: _sourceController.text,
          initialCount: count,
          rearingLocation: _locationController.text,
          caretakerName: _caretakerController.text,
          feedingMaterial: _feedingController.text,
          status: _status,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Batch added to this in-memory session only; it is not saved to disk or a server.',
          ),
        ),
      );
      if (context.canPop()) {
        context.pop(batch);
      } else {
        context.go('/batches');
      }
    } on BatchAlreadyExistsException {
      _formKey.currentState!.validate();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('That batch ID is already in use.')),
        );
      }
    } on BatchValidationException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.errors.values.first)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The batch could not be added. Try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Create batch')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.page),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Set up a rearing cycle',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Required fields are marked with *. The selected start date is cycle day 1.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _FormSectionTitle(title: 'Basic information'),
                    AppCard(
                      child: Column(
                        children: [
                          _textField(
                            controller: _idController,
                            label: 'Batch ID *',
                            hint: 'e.g. ERI-2026-01',
                            keyName: 'batchIdField',
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          DropdownButtonFormField<SilkwormSpecies>(
                            key: const Key('batchSpeciesField'),
                            initialValue: _species,
                            decoration: const InputDecoration(
                              labelText: 'Species *',
                            ),
                            hint: const Text('Select a species'),
                            items: SilkwormSpecies.values
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(speciesLabel(value)),
                                  ),
                                )
                                .toList(),
                            validator: (value) =>
                                value == null ? 'Select a species.' : null,
                            onChanged: (value) =>
                                setState(() => _species = value),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _textField(
                            controller: _strainController,
                            label: 'Strain *',
                            keyName: 'batchStrainField',
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          FormField<DateTime>(
                            key: const Key('batchStartDateField'),
                            initialValue: _startDate,
                            validator: (value) => value == null
                                ? 'Choose a valid start date.'
                                : null,
                            builder: (field) => InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Start date *',
                                errorText: field.errorText,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.xs,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      _startDate == null
                                          ? 'Choose cycle start date'
                                          : MaterialLocalizations.of(
                                              context,
                                            ).formatMediumDate(_startDate!),
                                    ),
                                  ),
                                  TextButton(
                                    key: const Key('chooseBatchStartDate'),
                                    onPressed: () async {
                                      await _selectStartDate();
                                      field.didChange(_startDate);
                                    },
                                    child: Text(
                                      _startDate == null ? 'Choose' : 'Change',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _FormSectionTitle(title: 'Stock and sourcing'),
                    AppCard(
                      child: Column(
                        children: [
                          _textField(
                            controller: _countController,
                            label: 'Initial egg or larva count *',
                            hint: 'Whole number greater than zero',
                            keyName: 'batchCountField',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              final count = int.tryParse(value?.trim() ?? '');
                              return count == null || count <= 0
                                  ? 'Enter a positive whole-number count.'
                                  : null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _textField(
                            controller: _sourceController,
                            label: 'Egg source *',
                            keyName: 'batchEggSourceField',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _FormSectionTitle(title: 'Rearing details'),
                    AppCard(
                      child: Column(
                        children: [
                          _textField(
                            controller: _locationController,
                            label: 'Rearing house / location *',
                            keyName: 'batchLocationField',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _textField(
                            controller: _caretakerController,
                            label: 'Caretaker name *',
                            keyName: 'batchCaretakerField',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _textField(
                            controller: _feedingController,
                            label: 'Feeding material *',
                            keyName: 'batchFeedingMaterialField',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          DropdownButtonFormField<BatchStatus>(
                            key: const Key('batchStatusField'),
                            initialValue: _status,
                            decoration: const InputDecoration(
                              labelText: 'Batch status',
                            ),
                            items: BatchStatus.values
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(statusLabel(value)),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null)
                                setState(() => _status = value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        'This demo stores records in memory for the current app session only. Local durable storage and server sync are not implemented.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppPrimaryButton(
                      key: const Key('submitBatchButton'),
                      label: 'Create batch',
                      icon: Icons.add_rounded,
                      isLoading: _submitting,
                      onPressed: _submitting ? null : _submit,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String keyName,
    String? hint,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) => TextFormField(
    key: Key(keyName),
    controller: controller,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    validator:
        validator ??
        (value) => value == null || value.trim().isEmpty
            ? 'This field is required.'
            : null,
    decoration: InputDecoration(labelText: label, hintText: hint),
  );
}

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
  );
}
