import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iskat_hesaplama/main.dart';
import 'package:iskat_hesaplama/utils/constants.dart';

void main() {
  testWidgets('Uygulama başarıyla başlatılmalı ve ana bileşenler ekranda görünmelidir',
      (WidgetTester tester) async {
    // Uygulama widget ağacını oluştur
    await tester.pumpWidget(const IskatApp());
    await tester.pumpAndSettle();

    // Başlık ve alt başlığı tekil olarak doğrula (çift başlık kaldırıldı)
    expect(find.text(AppConstants.appTitle), findsOneWidget);
    expect(find.text(AppConstants.appSubtitle), findsOneWidget);

    // Temel bölüm kartlarını doğrula
    expect(find.text('1. Yaş Bilgisi'), findsOneWidget);
    expect(find.text('2. Cinsiyet Seçimi'), findsOneWidget);
    expect(find.text('3. Düşülen Yaş'), findsOneWidget);
    expect(find.text('4. Fitre / Günlük Fidye Bedeli'), findsOneWidget);

    // Hesapla butonunu doğrula
    expect(find.text('HESAPLA'), findsOneWidget);

    // Genel Toplam alanını doğrula (varsayılan: 49.155.840 TL)
    expect(find.text('GENEL TOPLAM'), findsOneWidget);
    expect(find.text('49.155.840 TL'), findsWidgets);

    // Zorunlu uyarı metnini doğrula
    expect(
      find.text(AppConstants.disclaimerText),
      findsOneWidget,
    );
  });

  testWidgets('Masaüstü / Windows modunda 2 kolonlu grid düzeni aktif olmalıdır',
      (WidgetTester tester) async {
    // 1200x800 masaüstü pencere boyutu ayarla
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const IskatApp());
    await tester.pumpAndSettle();

    // Çift başlık olmamalı (AppBar'da sadece 1 kez görünmeli)
    expect(find.text(AppConstants.appTitle), findsOneWidget);
    expect(find.text(AppConstants.appSubtitle), findsOneWidget);

    // Masaüstü grid panel başlıklarını doğrula
    expect(find.text('HESAPLAMA GİRDİLERİ'), findsOneWidget);
    expect(find.text('HESAPLAMA SONUÇLARI'), findsOneWidget);

    // Sonuç kartlarının grid modunda yüklendiğini doğrula
    expect(find.text('A) Kişi Bilgileri & Süre'), findsOneWidget);
    expect(find.text('B) Fitre / Günlük Fidye'), findsOneWidget);
    expect(find.text('C) 1 Aylık Esas Hesap'), findsOneWidget);
    expect(find.text('GENEL TOPLAM'), findsOneWidget);
  });
}
