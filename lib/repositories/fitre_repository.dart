import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fitre_info.dart';

/// Fitre verilerinin yerel önbellek yönetimini sağlayan repository.
class FitreRepository {
  static const String _prefPrefix = 'fitre_cache_';

  /// Belirtilen yıl için fitre verisini SharedPreferences'a kaydeder.
  Future<void> saveFitreInfo(FitreInfo info) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_prefPrefix${info.year}';
      final jsonString = jsonEncode(info.toJson());
      await prefs.setString(key, jsonString);
    } catch (_) {
      // Hata durumunda sessizce devam edilir, uygulama kilitlenmez.
    }
  }

  /// Yalnızca istenen yıla ait önbellek kaydını getirir.
  /// Farklı bir yılın önbellek kaydını ASLA başka yıla vermez.
  Future<FitreInfo?> getCachedFitreInfo(int year) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_prefPrefix$year';
      final jsonString = prefs.getString(key);
      if (jsonString == null) return null;

      final Map<String, dynamic> jsonMap =
          jsonDecode(jsonString) as Map<String, dynamic>;
      final info = FitreInfo.fromJson(jsonMap);

      if (info.year == year) {
        return info;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Tüm fitre önbelleğini temizler.
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_prefPrefix));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (_) {}
  }
}
