import '../domain/batch.dart';

/// Persistence boundary for batches. A Drift adapter can implement this
/// contract when the local schema and migration are introduced.
abstract interface class BatchDataSource {
  Future<List<Batch>> readAll();

  Future<Batch?> readById(String id);

  Future<void> insert(Batch batch);
}
