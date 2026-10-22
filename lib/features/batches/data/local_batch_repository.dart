import '../domain/batch.dart';
import '../domain/batch_repository.dart';
import 'batch_data_source.dart';

class LocalBatchRepository implements BatchRepository {
  const LocalBatchRepository(this.dataSource);

  final BatchDataSource dataSource;

  @override
  Future<List<Batch>> getAll() async {
    final batches = [...await dataSource.readAll()];
    batches.sort((left, right) => left.id.compareTo(right.id));
    return List.unmodifiable(batches);
  }

  @override
  Future<Batch?> getById(String id) => dataSource.readById(id.trim());

  @override
  Future<Batch> create(Batch batch) async {
    final normalized = batch.normalized();
    final errors = normalized.validate();
    if (errors.isNotEmpty) throw BatchValidationException(errors);
    if (await dataSource.readById(normalized.id) != null) {
      throw BatchAlreadyExistsException(normalized.id);
    }
    await dataSource.insert(normalized);
    return normalized;
  }
}
