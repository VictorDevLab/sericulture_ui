import '../../lifecycle/domain/lifecycle_models.dart';

enum BatchStatus { active, mounting, cocooning, harvested, closed }

/// Immutable batch record, ready to be stored by an offline-first repository.
class Batch {
  const Batch({
    required this.id,
    required this.species,
    required this.strain,
    required this.startDate,
    required this.eggSource,
    required this.initialCount,
    required this.rearingLocation,
    required this.caretakerName,
    required this.feedingMaterial,
    required this.status,
  });

  final String id;
  final SilkwormSpecies species;
  final String strain;
  final DateTime startDate;
  final String eggSource;
  final int initialCount;
  final String rearingLocation;
  final String caretakerName;
  final String feedingMaterial;
  final BatchStatus status;

  Map<String, String> validate() => BatchValidation.validate(
    id: id,
    strain: strain,
    startDate: startDate,
    eggSource: eggSource,
    initialCount: initialCount,
    rearingLocation: rearingLocation,
    caretakerName: caretakerName,
    feedingMaterial: feedingMaterial,
  );

  Batch normalized() => Batch(
    id: id.trim(),
    species: species,
    strain: strain.trim(),
    startDate: DateTime(startDate.year, startDate.month, startDate.day),
    eggSource: eggSource.trim(),
    initialCount: initialCount,
    rearingLocation: rearingLocation.trim(),
    caretakerName: caretakerName.trim(),
    feedingMaterial: feedingMaterial.trim(),
    status: status,
  );
}

abstract final class BatchValidation {
  static Map<String, String> validate({
    required String id,
    required String strain,
    required DateTime startDate,
    required String eggSource,
    required int initialCount,
    required String rearingLocation,
    required String caretakerName,
    required String feedingMaterial,
  }) {
    final errors = <String, String>{};
    _required(errors, 'id', id, 'Enter a batch ID.');
    _required(errors, 'strain', strain, 'Enter a strain.');
    _required(errors, 'eggSource', eggSource, 'Enter an egg source.');
    _required(
      errors,
      'rearingLocation',
      rearingLocation,
      'Enter a rearing location.',
    );
    _required(
      errors,
      'caretakerName',
      caretakerName,
      'Enter a caretaker name.',
    );
    _required(
      errors,
      'feedingMaterial',
      feedingMaterial,
      'Enter a feeding material.',
    );
    if (initialCount <= 0) {
      errors['initialCount'] = 'Enter a positive whole-number count.';
    }
    if (startDate.year < 1 || !_isValidDate(startDate)) {
      errors['startDate'] = 'Choose a valid start date.';
    }
    return Map.unmodifiable(errors);
  }

  static void _required(
    Map<String, String> errors,
    String field,
    String value,
    String message,
  ) {
    if (value.trim().isEmpty) errors[field] = message;
  }

  static bool _isValidDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.year == date.year &&
        normalized.month == date.month &&
        normalized.day == date.day;
  }
}

class BatchAlreadyExistsException implements Exception {
  const BatchAlreadyExistsException(this.batchId);

  final String batchId;

  @override
  String toString() => 'A batch with ID "$batchId" already exists.';
}

class BatchValidationException implements Exception {
  const BatchValidationException(this.errors);

  final Map<String, String> errors;

  @override
  String toString() => 'Batch validation failed.';
}
