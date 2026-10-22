import 'batch.dart';

/// Local-first batch operations. Future storage adapters can implement this
/// without changing presentation or lifecycle prediction code.
abstract interface class BatchRepository {
  Future<List<Batch>> getAll();

  Future<Batch?> getById(String id);

  Future<Batch> create(Batch batch);
}
