import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_page.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Sistem durum çubuğu ve gezinme çubuğu stil ayarları
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppConstants.creamBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const IskatApp());
}

/// İskat Hesaplama ana uygulama bileşeni.
class IskatApp extends StatelessWidget {
  const IskatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryGreen,
          primary: AppConstants.primaryGreen,
          secondary: AppConstants.goldAccent,
          surface: AppConstants.creamBackground,
          surfaceTint: Colors.transparent,
        ),
        scaffoldBackgroundColor: AppConstants.creamBackground,
        fontFamily: null, // Sistem varsayılan Türkçe karakter dostu font
        cardTheme: const CardThemeData(
          elevation: 0,
          color: AppConstants.creamCard,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppConstants.creamBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppConstants.creamBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppConstants.primaryGreen, width: 1.8),
          ),
          labelStyle: const TextStyle(
            color: AppConstants.textMuted,
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: AppConstants.textMuted.withValues(alpha: 0.6),
            fontSize: 13,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
