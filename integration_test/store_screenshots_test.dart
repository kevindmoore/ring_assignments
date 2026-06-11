import 'dart:io' show Platform;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ring_assignments/assignment_store.dart';
import 'package:ring_assignments/main.dart' as app;

Future<void> _settleBriefly(WidgetTester tester) async {
  for (var i = 0; i < 12; i += 1) {
    await tester.pump(const Duration(milliseconds: 250));
  }
}

Future<void> _captureTab(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
  String tabLabel,
  String screenshotName,
) async {
  await tester.tap(find.text(tabLabel).last);
  await _settleBriefly(tester);
  await binding.takeScreenshot(screenshotName);
}

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture store screenshots', (WidgetTester tester) async {
    competitorsSignal.value = parseCompetitorsCsv(
      await rootBundle.loadString('sample_competitors.csv'),
    );
    judgesSignal.value = parseJudgesCsv(
      await rootBundle.loadString('sample_judges.csv'),
    );
    generatedManualAssignmentsSignal.value = const [];

    app.main();
    await _settleBriefly(tester);

    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
      await _settleBriefly(tester);
    }

    await binding.takeScreenshot('01_competitors');
    await _captureTab(tester, binding, 'Judges', '02_judges');
    await _captureTab(tester, binding, 'Rings', '03_rings');
    await tester.tap(find.text('Assignments').last);
    await _settleBriefly(tester);
    await tester.tap(find.text('Generate Assignments'));
    await _settleBriefly(tester);
    await binding.takeScreenshot('04_assignments');
    await tester.tap(find.byTooltip('Display round'));
    await _settleBriefly(tester);
    await binding.takeScreenshot('05_ring_display');
  });
}
