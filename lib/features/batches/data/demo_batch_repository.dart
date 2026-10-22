import '../../lifecycle/domain/lifecycle_models.dart';
import '../domain/batch.dart';
import 'in_memory_batch_data_source.dart';
import 'local_batch_repository.dart';

/// Builds an explicitly labelled, instance-scoped demo repository.
///
/// The generated entries exist only to exercise list/details navigation. They
/// are not real farm records and are not durable across process restarts.
class DemoBatchRepository extends LocalBatchRepository {
  DemoBatchRepository({DateTime? referenceDate})
    : super(
        InMemoryBatchDataSource(
          initialBatches: _demoBatches(referenceDate ?? DateTime.now()),
        ),
      );

  static List<Batch> _demoBatches(DateTime referenceDate) {
    final today = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );
    return [
      Batch(
        id: 'DEMO-ERI-01',
        species: SilkwormSpecies.eri,
        strain: 'Eri · sample strain A',
        startDate: _cycleStart(today, 12),
        eggSource: 'Illustrative local sample',
        initialCount: 3500,
        rearingLocation: 'Sample rearing room 1',
        caretakerName: 'Demo caretaker',
        feedingMaterial: 'Castor leaves',
        status: BatchStatus.active,
      ),
      Batch(
        id: 'DEMO-BOM-02',
        species: SilkwormSpecies.bombyxMori,
        strain: 'Bombyx · sample strain B',
        startDate: _cycleStart(today, 18),
        eggSource: 'Illustrative local sample',
        initialCount: 4200,
        rearingLocation: 'Sample rearing room 2',
        caretakerName: 'Demo caretaker',
        feedingMaterial: 'Mulberry leaves',
        status: BatchStatus.active,
      ),
      Batch(
        id: 'DEMO-ERI-03',
        species: SilkwormSpecies.eri,
        strain: 'Eri · sample strain C',
        startDate: _cycleStart(today, 24),
        eggSource: 'Illustrative local sample',
        initialCount: 2900,
        rearingLocation: 'Sample rearing room 1',
        caretakerName: 'Demo caretaker',
        feedingMaterial: 'Castor leaves',
        status: BatchStatus.mounting,
      ),
    ];
  }

  static DateTime _cycleStart(DateTime date, int cycleDay) =>
      DateTime(date.year, date.month, date.day - cycleDay + 1);
}
