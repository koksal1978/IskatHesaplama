import 'package:flutter/material.dart';
import '../models/calculation_input.dart';
import '../models/calculation_result.dart';
import '../models/fitre_info.dart';
import '../models/gender.dart';
import '../services/calculation_service.dart';
import '../services/fitre_service.dart';
import '../utils/constants.dart';
import '../utils/currency_formatter.dart';

/// İskat ve fidye uygulamasının ana durum yöneticisi (State Controller).
class CalculationController extends ChangeNotifier {
  final CalculationService _calculationService;
  final FitreService _fitreService;

  // Form girdileri için TextEditingController'lar
  final TextEditingController birthYearController = TextEditingController();
  final TextEditingController deathYearController = TextEditingController();
  final TextEditingController directAgeController =
      TextEditingController(text: '80');
  final TextEditingController deductionAgeController =
      TextEditingController(text: '${AppConstants.defaultMaleDeductionAge}');
  final TextEditingController fitreYearController =
      TextEditingController(text: '${DateTime.now().year}');
  final TextEditingController fitreAmountController =
      TextEditingController(text: '240');
  final TextEditingController personCountController =
      TextEditingController(text: '${AppConstants.defaultPersonCount}');
  final TextEditingController namazFactorController =
      TextEditingController(text: '${AppConstants.defaultNamazFactor}');
  final TextEditingController orucFactorController =
      TextEditingController(text: '${AppConstants.defaultOrucFactor}');
  final TextEditingController yeminFactorController =
      TextEditingController(text: '${AppConstants.defaultYeminFactor}');

  // Mevcut durum değişkenleri
  AgeCalculationMode _ageMode = AgeCalculationMode.directAge;
  Gender _gender = Gender.male;
  bool _isFetchingFitre = false;
  String? _fitreStatusMessage;
  FitreInfo? _currentFitreInfo;
  late CalculationResult _result;

  CalculationController({
    CalculationService? calculationService,
    FitreService? fitreService,
  })  : _calculationService = calculationService ?? CalculationService(),
        _fitreService = fitreService ?? FitreService() {
    // Başlangıç fitre bilgisi (Varsayılan 240 TL)
    _currentFitreInfo = FitreInfo(
      year: DateTime.now().year,
      amount: AppConstants.defaultFitreAmount,
      source: 'Din İşleri Yüksek Kurulu (Varsayılan)',
      sourceUrl: 'https://kurul.diyanet.gov.tr',
      fetchedAt: DateTime.now(),
      isManual: false,
    );

    // İlk hesaplamayı çalıştır
    _executeCalculation();
  }

  // Getters
  AgeCalculationMode get ageMode => _ageMode;
  Gender get gender => _gender;
  bool get isFetchingFitre => _isFetchingFitre;
  String? get fitreStatusMessage => _fitreStatusMessage;
  FitreInfo? get currentFitreInfo => _currentFitreInfo;
  CalculationResult get result => _result;

  /// Aktif girdi nesnesini üretir
  CalculationInput get currentInput {
    final int? birth = int.tryParse(birthYearController.text.trim());
    final int? death = int.tryParse(deathYearController.text.trim());
    final int? directAge = int.tryParse(directAgeController.text.trim());
    final int deductionAge =
        int.tryParse(deductionAgeController.text.trim()) ??
            getDefaultDeductionAge(_gender);
    final int fitreYear =
        int.tryParse(fitreYearController.text.trim()) ?? DateTime.now().year;
    final double fitreAmount =
        CurrencyFormatter.parseTL(fitreAmountController.text.trim()) ?? 0.0;
    final int namazFactor =
        int.tryParse(namazFactorController.text.trim()) ??
            AppConstants.defaultNamazFactor;
    final int orucFactor =
        int.tryParse(orucFactorController.text.trim()) ??
            AppConstants.defaultOrucFactor;
    final int yeminFactor =
        int.tryParse(yeminFactorController.text.trim()) ??
            AppConstants.defaultYeminFactor;
    final int personCount =
        int.tryParse(personCountController.text.trim()) ??
            AppConstants.defaultPersonCount;

    return CalculationInput(
      ageMode: _ageMode,
      birthYear: birth,
      deathYear: death,
      directAge: directAge,
      gender: _gender,
      deductionAge: deductionAge,
      fitreYear: fitreYear,
      fitreAmount: fitreAmount,
      namazFactor: namazFactor,
      orucFactor: orucFactor,
      yeminFactor: yeminFactor,
      personCount: personCount,
    );
  }

  /// Hesaplamayı anında yeniler
  void recalculate() {
    _executeCalculation();
    notifyListeners();
  }

  void _executeCalculation() {
    _result = _calculationService.calculate(currentInput);
  }

  /// Yaş hesaplama modunu değiştirir (Doğum/Ölüm veya Direkt Yaş)
  void setAgeMode(AgeCalculationMode mode) {
    if (_ageMode == mode) return;
    _ageMode = mode;
    recalculate();
  }

  /// Cinsiyet değiştirildiğinde varsayılan düşülen yaş atanır, kullanıcı sonradan değiştirebilir
  void setGender(Gender newGender) {
    _gender = newGender;
    final defaultDed = getDefaultDeductionAge(newGender);
    deductionAgeController.text = '$defaultDed';
    recalculate();
  }

  /// Düşülen yaşı mevcut cinsiyetin varsayılan değerine geri yükler
  void resetDeductionAgeToDefault() {
    final defaultDed = getDefaultDeductionAge(_gender);
    deductionAgeController.text = '$defaultDed';
    recalculate();
  }

  /// Gelişmiş katsayıları varsayılanlara (180, 61, 10) döndürür
  void resetFactorsToDefault() {
    namazFactorController.text = '${AppConstants.defaultNamazFactor}';
    orucFactorController.text = '${AppConstants.defaultOrucFactor}';
    yeminFactorController.text = '${AppConstants.defaultYeminFactor}';
    recalculate();
  }

  /// Kullanıcı fitre bedelini elle değiştirdiğinde çağrılır
  void onFitreAmountManualChanged(String value) {
    if (fitreAmountController.text != value) {
      fitreAmountController.text = value;
    }
    final parsed = CurrencyFormatter.parseTL(value);
    if (parsed != null && parsed > 0) {
      final year =
          int.tryParse(fitreYearController.text.trim()) ?? DateTime.now().year;
      _currentFitreInfo = FitreInfo(
        year: year,
        amount: parsed,
        source: 'Manuel Giriş',
        sourceUrl: null,
        fetchedAt: DateTime.now(),
        isManual: true,
      );
      _fitreStatusMessage = null;
    }
    recalculate();
  }

  /// İnternetten resmi fitre tutarını getirme işlemi
  Future<void> fetchFitreFromInternet() async {
    final int year =
        int.tryParse(fitreYearController.text.trim()) ?? DateTime.now().year;

    _isFetchingFitre = true;
    _fitreStatusMessage = 'Resmi kaynaklar taranıyor...';
    notifyListeners();

    try {
      final info = await _fitreService.fetchFitreAmount(year);
      if (info != null) {
        _currentFitreInfo = info;
        fitreAmountController.text = info.amount % 1 == 0
            ? '${info.amount.toInt()}'
            : info.amount.toStringAsFixed(2);
        _fitreStatusMessage = info.source.contains('Önbellek')
            ? 'Daha önce kaydedilmiş değer kullanılıyor.'
            : 'Resmi değer bulundu (${info.source}).';
      } else {
        _fitreStatusMessage =
            'Seçilen yıl için resmi fitre bedeli otomatik olarak bulunamadı. Lütfen tutarı manuel olarak giriniz.';
      }
    } catch (_) {
      _fitreStatusMessage =
          'Bağlantı hatası oluştu. Lütfen tutarı manuel olarak giriniz.';
    } finally {
      _isFetchingFitre = false;
      recalculate();
    }
  }

  /// Tüm formu varsayılan başlangıç ayarlarına getirir
  void resetToDefaults() {
    _ageMode = AgeCalculationMode.directAge;
    _gender = Gender.male;
    birthYearController.clear();
    deathYearController.clear();
    directAgeController.text = '80';
    deductionAgeController.text = '${AppConstants.defaultMaleDeductionAge}';
    fitreYearController.text = '${DateTime.now().year}';
    fitreAmountController.text = '240';
    personCountController.text = '${AppConstants.defaultPersonCount}';
    resetFactorsToDefault();
    _currentFitreInfo = FitreInfo(
      year: DateTime.now().year,
      amount: AppConstants.defaultFitreAmount,
      source: 'Din İşleri Yüksek Kurulu (Varsayılan)',
      sourceUrl: 'https://kurul.diyanet.gov.tr',
      fetchedAt: DateTime.now(),
      isManual: false,
    );
    _fitreStatusMessage = null;
    recalculate();
  }

  /// Tüm hesap giriş alanlarını temizler
  void clearAll() {
    birthYearController.clear();
    deathYearController.clear();
    directAgeController.clear();
    deductionAgeController.text = '0';
    fitreAmountController.clear();
    _currentFitreInfo = null;
    _fitreStatusMessage = null;
    recalculate();
  }

  @override
  void dispose() {
    birthYearController.dispose();
    deathYearController.dispose();
    directAgeController.dispose();
    deductionAgeController.dispose();
    fitreYearController.dispose();
    fitreAmountController.dispose();
    personCountController.dispose();
    namazFactorController.dispose();
    orucFactorController.dispose();
    yeminFactorController.dispose();
    super.dispose();
  }
}
