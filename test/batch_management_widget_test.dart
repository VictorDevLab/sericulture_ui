import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sericulture_ui/app/app.dart';
import 'package:sericulture_ui/app/router.dart';
import 'package:sericulture_ui/features/batches/data/in_memory_batch_data_source.dart';
import 'package:sericulture_ui/features/batches/data/local_batch_repository.dart';
import 'package:sericulture_ui/features/batches/domain/batch.dart';
import 'package:sericulture_ui/features/lifecycle/domain/lifecycle_models.dart';

final _today = DateTime(2024, 3, 12);

void main() {
  setUp(() async {
    await TestWidgetsFlutterBinding.ensureInitialized().setSurfaceSize(
      const Size(800, 1100),
    );
  });

  tearDown(() async {
    await TestWidgetsFlutterBinding.ensureInitialized().setSurfaceSize(null);
  });

  testWidgets('batch list searches by strain and filters by species/status', (
    tester,
  ) async {
    final repository = LocalBatchRepository(
      InMemoryBatchDataSource(
        initialBatches: [
          _batch(
            id: 'ERI-A',
            strain: 'Blue strain',
            species: SilkwormSpecies.eri,
          ),
          _batch(
            id: 'BOM-B',
            strain: 'White strain',
            species: SilkwormSpecies.bombyxMori,
          ),
          _batch(
            id: 'ERI-C',
            strain: 'Green strain',
            species: SilkwormSpecies.eri,
            status: BatchStatus.mounting,
          ),
        ],
      ),
    );
    final router = createAppRouter(
      repository: repository,
      clock: () => _today,
      initialLocation: '/batches',
    );
    await tester.pumpWidget(SericultureApp(router: router));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('batchSearchField')), 'white');
    await tester.pumpAndSettle();
    expect(find.text('BOM-B'), findsOneWidget);
    expect(find.text('ERI-A'), findsNothing);

    await tester.enterText(find.byKey(const Key('batchSearchField')), '');
    await tester.pumpAndSettle();
    await _scrollIntoView(tester, find.byKey(const Key('speciesFilter')));
    await tester.tap(find.byKey(const Key('speciesFilter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eri (Samia ricini)').last);
    await tester.pumpAndSettle();
    await _scrollIntoView(tester, find.text('ERI-A'));
    expect(find.text('ERI-A'), findsOneWidget);
    await _scrollIntoView(tester, find.text('ERI-C'));
    expect(find.text('ERI-C'), findsOneWidget);
    expect(find.text('BOM-B'), findsNothing);

    await _scrollIntoView(tester, find.byKey(const Key('statusFilter')));
    await tester.tap(find.byKey(const Key('statusFilter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mounting').last);
    await tester.pumpAndSettle();
    await _scrollIntoView(tester, find.text('ERI-C'));
    expect(find.text('ERI-C'), findsOneWidget);
    expect(find.text('ERI-A'), findsNothing);
    expect(find.text('Clear filters'), findsOneWidget);
    router.dispose();
  });

  testWidgets('empty list state offers create batch', (tester) async {
    final router = createAppRouter(
      repository: LocalBatchRepository(InMemoryBatchDataSource()),
      clock: () => _today,
      initialLocation: '/batches',
    );
    await tester.pumpWidget(SericultureApp(router: router));
    await tester.pumpAndSettle();

    expect(find.text('No batches yet'), findsOneWidget);
    expect(find.byKey(const Key('createBatchAction')), findsOneWidget);
    router.dispose();
  });

  testWidgets('batch cards navigate to species-specific lifecycle details', (
    tester,
  ) async {
    final repository = LocalBatchRepository(
      InMemoryBatchDataSource(
        initialBatches: [
          _batch(id: 'ERI-1', species: SilkwormSpecies.eri),
          _batch(id: 'BOM-1', species: SilkwormSpecies.bombyxMori),
        ],
      ),
    );
    final router = createAppRouter(
      repository: repository,
      clock: () => _today,
      initialLocation: '/batches',
    );
    await tester.pumpWidget(SericultureApp(router: router));
    await tester.pumpAndSettle();

    final eriCard = find.byKey(const Key('batchCard-ERI-1'));
    await _scrollIntoView(tester, eriCard);
    await tester.tap(eriCard);
    await tester.pumpAndSettle();
    expect(find.text('ERI-1'), findsOneWidget);
    expect(find.text('Day 1'), findsOneWidget);
    await _scrollIntoView(
      tester,
      find.byKey(const Key('expectedCurrentStage')),
    );
    expect(find.text('1st instar'), findsOneWidget);
    expect(find.textContaining('Schedule-based estimate only'), findsOneWidget);
    expect(find.textContaining('Record cocoon measurements'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    final bomCard = find.byKey(const Key('batchCard-BOM-1'));
    await _scrollIntoView(tester, bomCard);
    await tester.tap(bomCard);
    await tester.pumpAndSettle();
    expect(find.text('Egg incubation'), findsOneWidget);
    expect(find.text('Hatching'), findsOneWidget);
    router.dispose();
  });

  testWidgets('unknown batch ID displays a not-found state', (tester) async {
    final router = createAppRouter(
      repository: LocalBatchRepository(InMemoryBatchDataSource()),
      clock: () => _today,
      initialLocation: '/batches/missing-id',
    );
    await tester.pumpWidget(SericultureApp(router: router));
    await tester.pumpAndSettle();

    expect(find.text('Batch not found'), findsOneWidget);
    expect(
      find.textContaining('not available in the current local session'),
      findsOneWidget,
    );
    router.dispose();
  });

  testWidgets('create form validates required fields and preserves input', (
    tester,
  ) async {
    final repository = LocalBatchRepository(InMemoryBatchDataSource());
    final router = createAppRouter(
      repository: repository,
      clock: () => _today,
      initialLocation: '/batches/create',
    );
    await tester.pumpWidget(SericultureApp(router: router));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('batchIdField')), 'KEEP-ME');
    await _enterText(tester, 'batchCountField', '0');
    final createButton = find.byKey(const Key('submitBatchButton'));
    await _scrollIntoView(tester, createButton);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(find.text('KEEP-ME'), findsOneWidget);
    expect(find.text('Enter a positive whole-number count.'), findsOneWidget);
    expect(await repository.getById('KEEP-ME'), isNull);
    router.dispose();
  });

  testWidgets('valid create form adds an in-memory batch and returns to list', (
    tester,
  ) async {
    final repository = LocalBatchRepository(InMemoryBatchDataSource());
    final router = createAppRouter(
      repository: repository,
      clock: () => _today,
      initialLocation: '/batches/create',
    );
    await tester.pumpWidget(SericultureApp(router: router));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('batchIdField')), 'NEW-ERI-1');
    await tester.tap(find.byKey(const Key('batchSpeciesField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eri (Samia ricini)').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('batchStrainField')),
      'Local strain',
    );

    await tester.tap(find.byKey(const Key('chooseBatchStartDate')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await _enterText(tester, 'batchCountField', '800');
    await _enterText(tester, 'batchEggSourceField', 'Local supplier');
    await _enterText(tester, 'batchLocationField', 'Rearing room A');
    await _enterText(tester, 'batchCaretakerField', 'Sample keeper');
    await _enterText(tester, 'batchFeedingMaterialField', 'Castor leaves');

    final createButton = find.byKey(const Key('submitBatchButton'));
    await _scrollIntoView(tester, createButton);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    final created = await repository.getById('NEW-ERI-1');
    expect(created, isNotNull);
    expect(created!.initialCount, 800);
    expect(created.species, SilkwormSpecies.eri);
    expect(find.text('Batches'), findsOneWidget);
    router.dispose();
  });
}

Future<void> _enterText(
  WidgetTester tester,
  String fieldKey,
  String value,
) async {
  final field = find.byKey(Key(fieldKey));
  await _scrollIntoView(tester, field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

Future<void> _scrollIntoView(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Batch _batch({
  required String id,
  SilkwormSpecies species = SilkwormSpecies.eri,
  String strain = 'Demo strain',
  BatchStatus status = BatchStatus.active,
}) => Batch(
  id: id,
  species: species,
  strain: strain,
  startDate: _today,
  eggSource: 'Demo source',
  initialCount: 1000,
  rearingLocation: 'Demo room',
  caretakerName: 'Demo caretaker',
  feedingMaterial: species == SilkwormSpecies.eri
      ? 'Castor leaves'
      : 'Mulberry leaves',
  status: status,
);
