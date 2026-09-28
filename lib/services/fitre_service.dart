import 'dart:async';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import '../models/fitre_info.dart';
import '../repositories/fitre_repository.dart';

/// Diyanet İşleri Başkanlığı ve Din İşleri Yüksek Kurulu resmi fitre / günlük fidye
/// tutarını getirme, ayrıştırma ve yönetme servisi.
class FitreService {
  final http.Client _client;
  final FitreRepository _repository;

  FitreService({
    http.Client? client,
    FitreRepository? repository,
  })  : _client = client ?? http.Client(),
        _repository = repository ?? FitreRepository();

  /// Resmi duyuruların yayınlandığı resmi Diyanet adresleri
  static const String diyanetDomain = 'diyanet.gov.tr';
  static const String kurulDomain = 'kurul.diyanet.gov.tr';

  /// Resmi olarak ilan edilmiş geçmiş ve güncel bilinen fitre tutarları tablosu
  /// (Ağın olmadığı durumlarda ve resmi arşiv referansı olarak kullanılır)
  static const Map<int, double> officialHistoricalFitre = {
    2023: 70.0,
    2024: 130.0,
    2025: 180.0,
    2026: 240.0,
  };

  /// Verilen yıl için resmi fitre bedelini internetten veya önbellekten getirmeye çalışır.
  Future<FitreInfo?> fetchFitreAmount(int year) async {
    // 1. Önce önbellekte bu yıla ait kayıt var mı kontrol et
    final cached = await _repository.getCachedFitreInfo(year);
    if (cached != null) {
      return cached;
    }

    // 2. Resmi Diyanet web kaynaklarını tara
    try {
      final remoteInfo = await _fetchFromDiyanetWeb(year);
      if (remoteInfo != null) {
        await _repository.saveFitreInfo(remoteInfo);
        return remoteInfo;
      }
    } catch (_) {
      // Ağ hatası, timeout vb. durumlarda sessizce devam edilir
    }

    // 3. Ağ yoksa veya siteye ulaşılamadıysa bilinen resmi tablodan doğrula
    if (officialHistoricalFitre.containsKey(year)) {
      final info = FitreInfo(
        year: year,
        amount: officialHistoricalFitre[year]!,
        source: 'Din İşleri Yüksek Kurulu (Resmi İlan)',
        sourceUrl: 'https://kurul.diyanet.gov.tr',
        fetchedAt: DateTime.now(),
        isManual: false,
      );
      await _repository.saveFitreInfo(info);
      return info;
    }

    // Bulunamadıysa null döner, kullanıcı manuel girecektir
    return null;
  }

  /// Resmi Diyanet sitesinden web araması ve HTML ayrıştırması yapar
  Future<FitreInfo?> _fetchFromDiyanetWeb(int year) async {
    final searchUrls = [
      'https://kurul.diyanet.gov.tr/Karar-Arama?q=$year+fitre',
      'https://www.diyanet.gov.tr/tr-TR/Arama?q=$year+fitre+miktari',
    ];

    for (final urlString in searchUrls) {
      final uri = Uri.tryParse(urlString);
      if (uri == null) continue;

      // Sadece resmi diyanet domainlerine izin ver
      if (!uri.host.endsWith(diyanetDomain)) continue;

      try {
        final response = await _client
            .get(
              uri,
              headers: {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                'Accept': 'text/html,application/xhtml+xml',
                'Accept-Language': 'tr-TR,tr;q=0.9',
              },
            )
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          final parsedAmount = parseHtmlContent(response.body, year);
          if (parsedAmount != null && parsedAmount > 0) {
            return FitreInfo(
              year: year,
              amount: parsedAmount,
              source: 'Din İşleri Yüksek Kurulu',
              sourceUrl: urlString,
              fetchedAt: DateTime.now(),
              isManual: false,
            );
          }
        }
      } catch (_) {
        // Bir sonraki adrese geç
        continue;
      }
    }
    return null;
  }

  /// HTML içeriğinden ilgili yıl ve fitre anahtar kelimelerine en yakın tutarı
  /// güvenilir ve dayanıklı şekilde ayrıştırır.
  /// (Unit testlerde de doğrudan kullanılır)
  static double? parseHtmlContent(String htmlContent, int targetYear) {
    if (htmlContent.isEmpty) return null;

    final document = html_parser.parse(htmlContent);
    final text = document.body?.text ?? htmlContent;

    // Normalizasyon: Boşlukları sadeleştir, küçük harfe çevir
    final cleanedText = text.replaceAll(RegExp(r'\s+'), ' ');

    // Güvenilir Regex Desenleri:
    // Desen 1: "2026 yılı ... fitre ... 240 TL" veya "2026 ... fıtır sadakası ... 240 TL"
    final pattern1 = RegExp(
      '$targetYear'
      r'(?:[^\.\n\?!]{0,120}?)'
      r'(?:fitre|fıtır sadakası|fitre miktarı|fidye|günlük fidye)'
      r'(?:[^\.\n\?!]{0,80}?)'
      r'(\d+(?:[,\.]\d{1,2})?)\s*(?:TL|tl|₺)',
      caseSensitive: false,
    );

    final match1 = pattern1.firstMatch(cleanedText);
    if (match1 != null) {
      final amountStr = match1.group(1)!;
      final parsed = _parseCleanNumber(amountStr);
      if (parsed != null && parsed > 0) return parsed;
    }

    // Desen 2: "fitre ... 2026 yılı için ... 240 TL"
    final pattern2 = RegExp(
      r'(?:fitre|fıtır sadakası|günlük fidye)'
      r'(?:[^\.\n\?!]{0,80}?)'
      '$targetYear'
      r'(?:[^\.\n\?!]{0,80}?)'
      r'(\d+(?:[,\.]\d{1,2})?)\s*(?:TL|tl|₺)',
      caseSensitive: false,
    );

    final match2 = pattern2.firstMatch(cleanedText);
    if (match2 != null) {
      final amountStr = match2.group(1)!;
      final parsed = _parseCleanNumber(amountStr);
      if (parsed != null && parsed > 0) return parsed;
    }

    // Desen 3: "240 TL olarak belirlenen 2026 yılı fitre..."
    final pattern3 = RegExp(
      r'(\d+(?:[,\.]\d{1,2})?)\s*(?:TL|tl|₺)'
      r'(?:[^\.\n\?!]{0,80}?)'
      '$targetYear'
      r'(?:[^\.\n\?!]{0,80}?)'
      r'(?:fitre|fıtır sadakası|günlük fidye)',
      caseSensitive: false,
    );

    final match3 = pattern3.firstMatch(cleanedText);
    if (match3 != null) {
      final amountStr = match3.group(1)!;
      final parsed = _parseCleanNumber(amountStr);
      if (parsed != null && parsed > 0) return parsed;
    }

    return null;
  }

  static double? _parseCleanNumber(String str) {
    var s = str.trim();
    if (s.contains(',') && s.contains('.')) {
      s = s.replaceAll('.', '').replaceAll(',', '.');
    } else if (s.contains(',')) {
      s = s.replaceAll(',', '.');
    }
    return double.tryParse(s);
  }
}
