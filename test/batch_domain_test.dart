import 'package:flutter_test/flutter_test.dart';
import 'package:sericulture_ui/features/batches/data/in_memory_batch_data_source.dart';
import 'package:sericulture_ui/features/batches/data/local_batch_repository.dart';
import 'package:sericulture_ui/features/batches/domain/batch.dart';
import 'package:sericulture_ui/features/lifecycle/domain/lifecycle_models.dart';

void main() {
  group('Batch domain', () {
    test('constructs a typed batch record', () {
      final batch = _validBatch();

      expect(batch.species, SilkwormSpecies.eri);
      expect(batch.status, BatchStatus.active);
      expect(batch.initialCount, 1200);
      expect(batch.validate(), isEmpty);
    });

    test('validates all required text fields', () {
      final errors = _validBatch(
        id: ' ',
        strain: '',
        eggSource: '  ',
        rearingLocation: '',
        caretakerName: ' ',
        feedingMaterial: '',
      ).validate();

      expect(
        errors.keys,
        containsAll([
          'id',
          'strain',
          'eggSource',
          'rearingLocation',
          'caretakerName',
          'feedingMaterial',
        ]),
      );
    });

    test('requires a positive integer count', () {
      expect(
        _validBatch(initialCount: 0).validate()['initialCount'],
        isNotNull,
      );
      expect(
        _validBatch(initialCount: -2).validate()['initialCount'],
        isNotNull,
      );
      expect(_validBatch(initialCount: 1).validate(), isEmpty);
    });

    test(
      'repository normalizes valid records and rejects duplicate IDs',
      () async {
        final repository = LocalBatchRepository(InMemoryBatchDataSource());
        final created = await repository.create(
          _validBatch(id: '  B-01  ', strain: ' Sample strain '),
        );

        expect(created.id, 'B-01');
        expect(created.strain, 'Sample strain');
        expect((await repository.getAll()).single, created);
        await expectLater(
          repository.create(_validBatch(id: 'B-01')),
          throwsA(isA<BatchAlreadyExistsException>()),
        );
      },
    );
  });
}

Batch _validBatch({
  String id = 'B-01',
  String strain = 'Sample strain',
  String eggSource = 'Source A',
  String rearingLocation = 'Room 1',
  String caretakerName = 'Care team',
  String feedingMaterial = 'Leaves',
  int initialCount = 1200,
}) => Batch(
  id: id,
  species: SilkwormSpecies.eri,
  strain: strain,
  startDate: DateTime(2024, 2, 29),
  eggSource: eggSource,
  initialCount: initialCount,
  rearingLocation: rearingLocation,
  caretakerName: caretakerName,
  feedingMaterial: feedingMaterial,
  status: BatchStatus.active,
);
