// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sericulture_ui/app/app.dart';

void main() {
  testWidgets('app opens on dashboard with mobile navigation', (tester) async {
    await tester.pumpWidget(const SericultureApp());
    await tester.pumpAndSettle();

    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('Farm overview'), findsOneWidget);
    expect(find.text('Your rearing workspace'), findsOneWidget);
    expect(find.text('Key metrics'), findsOneWidget);
    expect(find.text('Active batches'), findsOneWidget);
    expect(
      find.textContaining('Illustrative sample values only'),
      findsOneWidget,
    );
    expect(find.text('12,480'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Batches'), findsOneWidget);
  });

  testWidgets('view all batches navigates to the batches screen', (
    tester,
  ) async {
    await tester.pumpWidget(const SericultureApp());
    await tester.pumpAndSettle();

    final viewAll = find.text('View all');
    await _scrollUntilFound(tester, viewAll);
    await tester.ensureVisible(viewAll);
    await tester.tap(viewAll);
    await tester.pumpAndSettle();

    expect(
      find.text('Manage each rearing cycle from egg to cocoon.'),
      findsOneWidget,
    );
  });

  testWidgets('mortality quick action is honest about unavailable workflow', (
    tester,
  ) async {
    await tester.pumpWidget(const SericultureApp());
    await tester.pumpAndSettle();

    final action = find.text('Record mortality');
    await _scrollUntilFound(tester, action);
    await tester.ensureVisible(action);
    await tester.tap(action);
    await tester.pump();

    expect(
      find.text('Mortality logging is not implemented. No record was saved.'),
      findsOneWidget,
    );
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

  testWidgets('batch create screen explains its in-memory-only behavior', (
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
      find.textContaining('stored in memory for the current app session only'),
      findsOneWidget,
    );
  });
}

Future<void> _scrollUntilFound(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    400,
    scrollable: find.byType(Scrollable).first,
    maxScrolls: 30,
  );
}
