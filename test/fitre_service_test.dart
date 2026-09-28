import 'package:flutter_test/flutter_test.dart';
import 'package:iskat_hesaplama/services/fitre_service.dart';

void main() {
  group('Fitre HTML Parser Testleri (Madde 29)', () {
    test('2026 yılı fitre miktarı 240 TL ayrıştırma', () {
      const html = '''
        <html>
          <body>
            <div class="announcement">
              <h1>Din İşleri Yüksek Kurulu Duyurusu</h1>
              <p>Kurulumuzca yapılan değerlendirmeler neticesinde 2026 yılı fitre miktarı 240 TL olarak belirlenmiştir.</p>
            </div>
          </body>
        </html>
      ''';

      final amount = FitreService.parseHtmlContent(html, 2026);
      expect(amount, equals(240.0));
    });

    test('2025 yılı fitre miktarı 180 TL ayrıştırma', () {
      const html = '''
        <div>
          <p>2025 yılı fitre miktarı 180 TL olarak kamuoyuna ilan edilmiştir.</p>
        </div>
      ''';

      final amount = FitreService.parseHtmlContent(html, 2025);
      expect(amount, equals(180.0));
    });

    test('Farklı TL tutarları varken doğru tutarı seçme (500 TL yerine 240 TL)', () {
      const html = '''
        <html>
          <body>
            <div>
              <h3>Zekat ve Bağış Kampanyası</h3>
              <p>Yetim projesi için asgari bağış 500 TL olarak tavsiye edilmektedir.</p>
              <article>
                <h2>2026 Yılı Ramazan Ayı</h2>
                <p>Din İşleri Yüksek Kurulu kararıyla 2026 yılı için belirlenen fitre miktarı 240 TL olarak açıklanmıştır.</p>
                <p>Yardım fonuna ayrıca 1000 TL aktarılmıştır.</p>
              </article>
            </div>
          </body>
        </html>
      ''';

      final amount = FitreService.parseHtmlContent(html, 2026);
      expect(amount, equals(240.0));
    });

    test('Kuruşlu (ondalıklı virgüllü) tutar ayrıştırma (240,50 TL)', () {
      const html = '''
        <p>2026 yılı günlük fidye ve fitre bedeli 240,50 TL olarak tespit edilmiştir.</p>
      ''';

      final amount = FitreService.parseHtmlContent(html, 2026);
      expect(amount, equals(240.50));
    });

    test('Eşleşmeyen yıl için null dönme', () {
      const html = '''
        <p>2024 yılı fitre miktarı 130 TL olarak ilan edilmiştir.</p>
      ''';

      final amount = FitreService.parseHtmlContent(html, 2026);
      expect(amount, isNull);
    });

    test('Boş veya ilgisiz HTML için güvenli ve null dönme', () {
      expect(FitreService.parseHtmlContent('', 2026), isNull);
      expect(
        FitreService.parseHtmlContent('<html><body>Merhaba Dünya</body></html>', 2026),
        isNull,
      );
    });
  });
}
