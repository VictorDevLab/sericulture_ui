# Batch management slice

Batch records are immutable domain values in `lib/features/batches/domain/`. `BatchRepository` is the presentation-facing local-first contract; `BatchDataSource` is its persistence boundary. `LocalBatchRepository` validates and normalizes records before delegating to a source, so a future Drift adapter can replace the in-memory source without changing the screens. No database schema, network requests, authentication, MongoDB access, or sync behavior is implemented here.

The application router creates one repository instance for the app session. The default is an explicitly illustrative, in-memory demo repository with IDs that match the dashboard's sample links. User-created batches can be browsed during that process session, but records are lost when the app restarts. No sample records represent real farm data.

The batch species field uses `SilkwormSpecies` from the lifecycle domain. Batch status is independently typed as Active, Mounting, Cocooning, Harvested, or Closed; status is not automatically inferred from a predicted stage. Lifecycle dates and stages are estimates from the source schedule only. The selected start date is cycle day 1. No observed conditions, temperature/humidity adjustments, or undocumented transitions influence predictions.

The create flow validates required text, positive whole-number count, species, and start date. It reports duplicate IDs and keeps the entered form values on validation or repository errors. Successful creation means that the current in-memory repository accepted the entry, not that it was durably or remotely saved.
