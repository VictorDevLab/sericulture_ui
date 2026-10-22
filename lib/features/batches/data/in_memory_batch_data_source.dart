import '../domain/batch.dart';
import 'batch_data_source.dart';

/// Instance-scoped in-memory adapter for demo use. Data is lost when the app
/// process is restarted; it does not emulate durable storage or synchronization.
class InMemoryBatchDataSource implements BatchDataSource {
  InMemoryBatchDataSource({Iterable<Batch> initialBatches = const []})
    : _batches = {for (final batch in initialBatches) batch.id: batch};

  final Map<String, Batch> _batches;

  @override
  Future<List<Batch>> readAll() async => List.unmodifiable(_batches.values);

  @override
  Future<Batch?> readById(String id) async => _batches[id];

  @override
  Future<void> insert(Batch batch) async {
    if (_batches.containsKey(batch.id)) {
      throw BatchAlreadyExistsException(batch.id);
    }
    _batches[batch.id] = batch;
  }
}
