// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:sericulture_ui/app/app.dart';

void main() {
  testWidgets('app opens on dashboard with mobile navigation', (tester) async {
    await tester.pumpWidget(const SericultureApp());
    await tester.pumpAndSettle();

    expect(find.text('Sericulture'), findsOneWidget);
    expect(find.text('Your rearing workspace'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Batches'), findsOneWidget);
  });

  testWidgets('care navigation opens a placeholder feature', (tester) async {
    await tester.pumpWidget(const SericultureApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Care'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Feeding logs').first);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('No sample records or backend actions are included.'),
      findsOneWidget,
    );
  });

  testWidgets('batch create screen is reachable without fake saving', (
    tester,
  ) async {
    await tester.pumpWidget(const SericultureApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Batches').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create a batch'));
    await tester.pumpAndSettle();

    expect(find.text('Create batch'), findsOneWidget);
    expect(
      find.text('Saving is not enabled until local storage is implemented.'),
      findsOneWidget,
    );
  });
}
