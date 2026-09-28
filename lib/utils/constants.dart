import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan sabitler, renk paleti ve metinler.
class AppConstants {
  static const String appTitle = 'İskat Hesaplama';
  static const String appSubtitle = 'Fidye ve Kefaret Hesap Yardımcısı';

  // Varsayılan katsayılar
  static const int defaultFemaleDeductionAge = 9;
  static const int defaultMaleDeductionAge = 12;
  static const int defaultNamazFactor = 180;
  static const int defaultOrucFactor = 61;
  static const int defaultYeminFactor = 10;
  static const int defaultPersonCount = 10;
  static const double defaultFitreAmount = 240.0;

  // Dini uyarı metni
  static const String disclaimerText =
      'Bu uygulama yalnızca matematiksel hesaplama yardımcısıdır. İskat, fidye ve '
      'kefaret uygulamalarının dini hükmü, kapsamı ve uygulanma şekli konusunda yetkili '
      'bir din görevlisine veya Din İşleri Yüksek Kuruluna danışınız.';

  // Renk Paleti (Koyu yeşil, Krem/Açık Bej, Altın tonları)
  static const Color primaryGreen = Color(0xFF0F4229);
  static const Color primaryGreenDark = Color(0xFF092A1A);
  static const Color primaryGreenLight = Color(0xFF1E5B3B);

  static const Color creamBackground = Color(0xFFFAF7F0);
  static const Color creamCard = Color(0xFFFFFFFF);
  static const Color creamBorder = Color(0xFFEADBCE);
  static const Color creamTint = Color(0xFFF3ECE0);

  static const Color goldAccent = Color(0xFFC79E47);
  static const Color goldAccentLight = Color(0xFFE8D39E);
  static const Color goldAccentDark = Color(0xFF8F6E26);

  static const Color textDark = Color(0xFF1D2620);
  static const Color textMuted = Color(0xFF5A665E);
  static const Color errorRed = Color(0xFFB3261E);
}
