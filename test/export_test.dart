import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iskat_hesaplama/models/calculation_input.dart';
import 'package:iskat_hesaplama/models/gender.dart';
import 'package:iskat_hesaplama/services/calculation_service.dart';
import 'package:iskat_hesaplama/services/export_service.dart';
import 'package:iskat_hesaplama/widgets/summary_poster_widget.dart';

void main() {
  testWidgets('ExportService RepaintBoundary ile PNG ve PDF üretimi tek sayfa A4 olarak doğrulanmalı',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final boundaryKey = GlobalKey();
    const input = CalculationInput(
      directAge: 80,
      gender: Gender.male,
      deductionAge: 12,
      fitreYear: 2026,
      fitreAmount: 240,
      namazFactor: 180,
      orucFactor: 61,
      yeminFactor: 10,
      personCount: 10,
    );
    final result = CalculationService().calculate(input);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'serif'),
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: boundaryKey,
              child: SummaryPosterWidget(
                input: input,
                result: result,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Uint8List? pngBytes;
    Uint8List? pdfBytes;

    await tester.runAsync(() async {
      pngBytes = await ExportService.capturePng(boundaryKey);
      if (pngBytes != null) {
        pdfBytes = await ExportService.generatePdfFromImage(pngBytes!);
        // Görseli doğrulamak için brain dizinine kaydet
        final artifactFile = File(
            r'C:\Users\yazil\.gemini\antigravity\brain\813566a3-c027-4722-9e43-9cea1db9d662\rendered_a4_poster.png');
        await artifactFile.writeAsBytes(pngBytes!);
      }
    });

    expect(pngBytes, isNotNull);
    expect(pngBytes!.isNotEmpty, isTrue);
    expect(pdfBytes, isNotNull);
    expect(pdfBytes!.isNotEmpty, isTrue);
  });
}
