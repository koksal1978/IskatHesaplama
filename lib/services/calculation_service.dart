import 'dart:math';
import '../models/calculation_input.dart';
import '../models/calculation_result.dart';
import '../models/devir_distribution.dart';
import '../utils/currency_formatter.dart';
import '../utils/validators.dart';

/// İskat, fidye ve kefaret matematiksel hesaplama servisi.
class CalculationService {
  /// Verilen girdi modeline göre hesaplamayı yürütür.
  CalculationResult calculate(CalculationInput input) {
    // 1. Doğrulama kontrolü
    final validationError = Validators.validateInput(input);
    if (validationError != null) {
      return CalculationResult.invalid(validationError);
    }

    final int age = input.resolvedAge!;
    final int deductionAge = input.deductionAge;

    // Negatif süre oluşumuna izin verilmez
    final int calculatedYears = max(0, age - deductionAge);
    final int totalMonths = calculatedYears * 12;

    // Kuruş bazında hassas hesaplama (floating-point hatalarını önler)
    final int fitreKurus = CurrencyFormatter.toKurus(input.fitreAmount);

    final int namazKurus = input.namazFactor * fitreKurus;
    final int orucKurus = input.orucFactor * fitreKurus;
    final int yeminKurus = input.yeminFactor * fitreKurus;

    final int monthlyTotalKurus = namazKurus + orucKurus + yeminKurus;
    final int grandTotalKurus = totalMonths * monthlyTotalKurus;

    // Devir dağılımı
    final devirDistribution = calculateDevirDistribution(
      totalMonths: totalMonths,
      personCount: input.personCount,
    );

    return CalculationResult(
      age: age,
      deductionAge: deductionAge,
      calculatedYears: calculatedYears,
      totalMonths: totalMonths,
      fitreAmount: input.fitreAmount,
      monthlyNamaz: CurrencyFormatter.fromKurus(namazKurus),
      monthlyOruc: CurrencyFormatter.fromKurus(orucKurus),
      monthlyYemin: CurrencyFormatter.fromKurus(yeminKurus),
      monthlyTotal: CurrencyFormatter.fromKurus(monthlyTotalKurus),
      grandTotal: CurrencyFormatter.fromKurus(grandTotalKurus),
      devirDistribution: devirDistribution,
      isValid: true,
      errorMessage: null,
    );
  }

  /// Toplam ayın kişi sayısına göre devir dağılımını hesaplar.
  DevirDistribution calculateDevirDistribution({
    required int totalMonths,
    required int personCount,
  }) {
    if (personCount <= 0) {
      personCount = 1;
    }

    if (totalMonths <= 0) {
      return DevirDistribution(
        totalMonths: 0,
        totalPeople: personCount,
        groups: [
          DevirGroup(
            groupName: '1. Grup',
            personCount: personCount,
            roundsPerPerson: 0,
            totalRounds: 0,
          ),
        ],
        grandTotalRounds: 0,
      );
    }

    final int taban = totalMonths ~/ personCount;
    final int kalan = totalMonths % personCount;

    final List<DevirGroup> groups = [];

    if (kalan == 0) {
      // Tek grup yeterlidir
      groups.add(
        DevirGroup(
          groupName: '1. Grup',
          personCount: personCount,
          roundsPerPerson: taban,
          totalRounds: personCount * taban,
        ),
      );
    } else {
      // 1. Grup (kalan kadar kişi bir fazla devir yapar)
      final int group1Count = kalan;
      final int group1Rounds = taban + 1;
      final int group1Total = group1Count * group1Rounds;

      groups.add(
        DevirGroup(
          groupName: '1. Grup',
          personCount: group1Count,
          roundsPerPerson: group1Rounds,
          totalRounds: group1Total,
        ),
      );

      // 2. Grup (kalan kişiler taban devir yapar)
      final int group2Count = personCount - kalan;
      final int group2Rounds = taban;
      final int group2Total = group2Count * group2Rounds;

      groups.add(
        DevirGroup(
          groupName: '2. Grup',
          personCount: group2Count,
          roundsPerPerson: group2Rounds,
          totalRounds: group2Total,
        ),
      );
    }

    final int grandTotalRounds = groups.fold<int>(
      0,
      (sum, item) => sum + item.totalRounds,
    );

    return DevirDistribution(
      totalMonths: totalMonths,
      totalPeople: personCount,
      groups: groups,
      grandTotalRounds: grandTotalRounds,
    );
  }
}
