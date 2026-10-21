/// Persistence boundaries for repositories.
///
/// Application repositories should read from and write to [LocalDataSource]
/// first. They may consult [RemoteDataSource] when connectivity is available,
/// but remote availability must not block local record creation or editing.
/// Implementations and synchronization policy are intentionally deferred until
/// feature schemas and conflict requirements are defined.
abstract interface class LocalDataSource<T, Id> {
  Future<T?> findById(Id id);

  Future<List<T>> getAll();

  Future<void> upsert(T record);

  Future<void> delete(Id id);
}

/// REST-backed data access boundary; it must not be used as the only source of
/// truth for offline-capable application features.
abstract interface class RemoteDataSource<T, Id> {
  Future<T?> findById(Id id);

  Future<List<T>> getAll();

  Future<void> upsert(T record);

  Future<void> delete(Id id);
}
