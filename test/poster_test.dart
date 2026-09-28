import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iskat_hesaplama/models/calculation_input.dart';
import 'package:iskat_hesaplama/models/gender.dart';
import 'package:iskat_hesaplama/services/calculation_service.dart';
import 'package:iskat_hesaplama/widgets/summary_poster_widget.dart';

void main() {
  testWidgets('SummaryPosterWidget A4 boyutlarında (595x842) hatasız ve sıfır taşma ile render edilmeli',
      (WidgetTester tester) async {
    // A4 boyutunu rahatça barındıracak test ekranı boyutu ayarla
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

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
        home: Scaffold(
          body: Center(
            child: SummaryPosterWidget(
              input: input,
              result: result,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Temel afiş öğelerini doğrula
    expect(find.text('İSKAT / FİDYE / KEFARET HESAP ÖZETİ'), findsOneWidget);
    expect(find.textContaining('Esas alınan fitre / günlük fidye bedeli:'), findsOneWidget);
    expect(find.textContaining('Vefat yaşı: 80'), findsOneWidget);
    expect(find.textContaining('Düşülen yaş: 12'), findsOneWidget);
    expect(find.textContaining('80 - 12 = 68 yıl'), findsOneWidget);
    expect(find.textContaining('68 × 12 = 816 ay'), findsOneWidget);
    expect(find.text('1 Aylık Esas Hesap'), findsOneWidget);
    expect(find.text('GENEL TOPLAM'), findsOneWidget);
    expect(find.textContaining('816 × 60.240 TL = 49.155.840 TL'), findsOneWidget);
    expect(find.textContaining('10 Kişi ile Devir Dağılımı'), findsOneWidget);
    expect(find.textContaining('Not: Bu görsel'), findsOneWidget);
  });
}
