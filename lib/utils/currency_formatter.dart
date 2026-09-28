import 'package:intl/intl.dart';

/// Para birimi ve sayı biçimlendirme işlemleri için yardımcı sınıf.
/// Kuruş bazlı tamsayı dönüşümleriyle ondalık hassasiyet kaybını önler.
class CurrencyFormatter {
  static final NumberFormat _integerFormat = NumberFormat('#,##0', 'tr_TR');
  static final NumberFormat _decimalFormat = NumberFormat('#,##0.00', 'tr_TR');

  /// TL tutarını kuruşa (tamsayı) dönüştürür. (240 TL -> 24000 kuruş)
  static int toKurus(double tl) {
    return (tl * 100).round();
  }

  /// Kuruşu TL (double) tutarına dönüştürür.
  static double fromKurus(int kurus) {
    return kurus / 100.0;
  }

  /// TL tutarını doğal Türkçe formatında döndürür.
  /// Örnekler:
  /// 240 -> "240 TL"
  /// 43200 -> "43.200 TL"
  /// 49155840 -> "49.155.840 TL"
  /// 240.5 -> "240,50 TL"
  static String formatTL(double amount, {bool forceDecimals = false}) {
    final int kurus = toKurus(amount);
    return formatKurus(kurus, forceDecimals: forceDecimals);
  }

  /// Kuruş değerini Türkçe TL formatında döndürür.
  static String formatKurus(int kurus, {bool forceDecimals = false}) {
    final bool hasDecimals = (kurus % 100) != 0;
    final double tl = kurus / 100.0;

    if (forceDecimals || hasDecimals) {
      return '${_decimalFormat.format(tl)} TL';
    } else {
      return '${_integerFormat.format(tl.toInt())} TL';
    }
  }

  /// Kullanıcının girdiği metinden TL tutarını ayrıştırır.
  /// "240", "240,50", "240.50", "240 TL" gibi girdileri destekler.
  static double? parseTL(String text) {
    final cleaned = text
        .replaceAll('TL', '')
        .replaceAll('tl', '')
        .replaceAll('₺', '')
        .trim();

    if (cleaned.isEmpty) return null;

    // Türkçe ondalık virgülünü standart noktaya dönüştür
    // Eğer hem nokta hem virgül varsa (örn. 1.250,50), noktaları sil virgülü nokta yap
    String normalized = cleaned;
    if (normalized.contains('.') && normalized.contains(',')) {
      normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
    } else if (normalized.contains(',')) {
      normalized = normalized.replaceAll(',', '.');
    }

    return double.tryParse(normalized);
  }
}
