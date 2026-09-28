/// Cinsiyet tanımları ve yardımcı fonksiyonlar.
enum Gender {
  female,
  male,
}

extension GenderExtension on Gender {
  /// Türkçe gösterim adı
  String get displayName {
    switch (this) {
      case Gender.female:
        return 'Kadın';
      case Gender.male:
        return 'Erkek';
    }
  }

  /// Cinsiyete göre varsayılan düşülen yaş başlangıç değeri
  int get defaultDeductionAge {
    switch (this) {
      case Gender.female:
        return 9;
      case Gender.male:
        return 12;
    }
  }
}

/// Cinsiyete göre varsayılan düşülen yaş getiren yardımcı fonksiyon.
int getDefaultDeductionAge(Gender gender) {
  switch (gender) {
    case Gender.female:
      return 9;
    case Gender.male:
      return 12;
  }
}
