import 'gender.dart';

/// Yaş hesaplama yöntemi
enum AgeCalculationMode {
  birthDeathYear,
  directAge,
}

/// Hesaplama için kullanıcıdan alınan tüm girdileri temsil eden model.
class CalculationInput {
  final AgeCalculationMode ageMode;
  final int? birthYear;
  final int? deathYear;
  final int? directAge;
  final Gender gender;
  final int deductionAge;
  final int fitreYear;
  final double fitreAmount;
  final int namazFactor;
  final int orucFactor;
  final int yeminFactor;
  final int personCount;

  const CalculationInput({
    this.ageMode = AgeCalculationMode.directAge,
    this.birthYear,
    this.deathYear,
    this.directAge = 80,
    this.gender = Gender.male,
    this.deductionAge = 12,
    required this.fitreYear,
    this.fitreAmount = 240.0,
    this.namazFactor = 180,
    this.orucFactor = 61,
    this.yeminFactor = 10,
    this.personCount = 10,
  });

  /// Girdiden hesaplanan vefat yaşını döndürür.
  int? get resolvedAge {
    switch (ageMode) {
      case AgeCalculationMode.birthDeathYear:
        if (birthYear != null && deathYear != null && deathYear! >= birthYear!) {
          return deathYear! - birthYear!;
        }
        return null;
      case AgeCalculationMode.directAge:
        return directAge;
    }
  }

  CalculationInput copyWith({
    AgeCalculationMode? ageMode,
    int? birthYear,
    int? deathYear,
    int? directAge,
    Gender? gender,
    int? deductionAge,
    int? fitreYear,
    double? fitreAmount,
    int? namazFactor,
    int? orucFactor,
    int? yeminFactor,
    int? personCount,
  }) {
    return CalculationInput(
      ageMode: ageMode ?? this.ageMode,
      birthYear: birthYear ?? this.birthYear,
      deathYear: deathYear ?? this.deathYear,
      directAge: directAge ?? this.directAge,
      gender: gender ?? this.gender,
      deductionAge: deductionAge ?? this.deductionAge,
      fitreYear: fitreYear ?? this.fitreYear,
      fitreAmount: fitreAmount ?? this.fitreAmount,
      namazFactor: namazFactor ?? this.namazFactor,
      orucFactor: orucFactor ?? this.orucFactor,
      yeminFactor: yeminFactor ?? this.yeminFactor,
      personCount: personCount ?? this.personCount,
    );
  }
}
