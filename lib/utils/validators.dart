import '../models/calculation_input.dart';
import 'currency_formatter.dart';

/// Form ve girdi doğrulama kuralları.
/// Kullanıcı dostu Türkçe hata mesajları üretir.
class Validators {
  /// Doğum ve ölüm yılı doğrulaması
  static String? validateYears({required int? birthYear, required int? deathYear}) {
    if (birthYear == null) {
      return 'Doğum yılı girilmelidir.';
    }
    if (birthYear < 1850 || birthYear > 2200) {
      return 'Lütfen geçerli bir doğum yılı giriniz (1850-2200).';
    }
    if (deathYear == null) {
      return 'Ölüm yılı girilmelidir.';
    }
    if (deathYear < 1850 || deathYear > 2200) {
      return 'Lütfen geçerli bir ölüm yılı giriniz (1850-2200).';
    }
    if (deathYear < birthYear) {
      return 'Ölüm yılı doğum yılından küçük olamaz.';
    }
    return null;
  }

  /// Direkt yaş doğrulaması
  static String? validateDirectAge(int? age) {
    if (age == null) {
      return 'Vefat yaşı girilmelidir.';
    }
    if (age <= 0) {
      return 'Vefat yaşı 0 veya negatif olamaz.';
    }
    if (age > 150) {
      return 'Lütfen 150’den küçük geçerli bir yaş giriniz.';
    }
    return null;
  }

  /// Düşülen yaş doğrulaması
  static String? validateDeductionAge({required int? deductionAge, required int? resolvedAge}) {
    if (deductionAge == null) {
      return 'Düşülen yaş girilmelidir.';
    }
    if (deductionAge < 0) {
      return 'Düşülen yaş negatif olamaz.';
    }
    if (resolvedAge != null && deductionAge > resolvedAge) {
      return 'Düşülen yaş ($deductionAge), vefat yaşından ($resolvedAge) büyük olamaz.';
    }
    return null;
  }

  /// Fitre / Fidye bedeli doğrulaması
  static String? validateFitre(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Fitre / günlük fidye bedeli girilmelidir.';
    }
    final parsed = CurrencyFormatter.parseTL(value);
    if (parsed == null) {
      return 'Geçerli bir tutar giriniz (Örn: 240 veya 240,50).';
    }
    if (parsed <= 0) {
      return 'Fitre tutarı 0’dan büyük olmalıdır.';
    }
    if (parsed > 1000000) {
      return 'Lütfen mantıklı bir fitre tutarı giriniz.';
    }
    return null;
  }

  /// Kişi sayısı doğrulaması
  static String? validatePersonCount(int? count) {
    if (count == null) {
      return 'Kişi sayısı girilmelidir.';
    }
    if (count <= 0) {
      return 'Kişi sayısı en az 1 olmalıdır.';
    }
    if (count > 1000) {
      return 'Kişi sayısı en fazla 1000 olabilir.';
    }
    return null;
  }

  /// Katsayı doğrulaması
  static String? validateFactor(int? factor, String name) {
    if (factor == null) {
      return '$name adedi girilmelidir.';
    }
    if (factor < 0) {
      return '$name adedi negatif olamaz.';
    }
    if (factor > 10000) {
      return '$name adedi çok yüksek olamaz.';
    }
    return null;
  }

  /// Genel girdi doğrulaması - Tüm hesaplama öncesi kontrol
  static String? validateInput(CalculationInput input) {
    // 1. Yaş kontrolü
    if (input.ageMode == AgeCalculationMode.birthDeathYear) {
      final yearErr = validateYears(
        birthYear: input.birthYear,
        deathYear: input.deathYear,
      );
      if (yearErr != null) return yearErr;
    } else {
      final ageErr = validateDirectAge(input.directAge);
      if (ageErr != null) return ageErr;
    }

    final resolvedAge = input.resolvedAge;
    if (resolvedAge == null) {
      return 'Geçerli bir vefat yaşı hesaplanamadı.';
    }

    // 2. Düşülen yaş kontrolü
    final dedErr = validateDeductionAge(
      deductionAge: input.deductionAge,
      resolvedAge: resolvedAge,
    );
    if (dedErr != null) return dedErr;

    // 3. Fitre tutarı kontrolü
    if (input.fitreAmount <= 0) {
      return 'Fitre bedeli 0’dan büyük olmalıdır.';
    }

    // 4. Kişi sayısı kontrolü
    final personErr = validatePersonCount(input.personCount);
    if (personErr != null) return personErr;

    // 5. Katsayı kontrolleri
    if (input.namazFactor < 0 || input.orucFactor < 0 || input.yeminFactor < 0) {
      return 'Hesap katsayıları negatif olamaz.';
    }

    return null;
  }
}
