import 'devir_distribution.dart';

/// İskat ve fidye hesaplama sonuçlarını tutan model.
class CalculationResult {
  final int age;
  final int deductionAge;
  final int calculatedYears;
  final int totalMonths;
  final double fitreAmount;
  final double monthlyNamaz;
  final double monthlyOruc;
  final double monthlyYemin;
  final double monthlyTotal;
  final double grandTotal;
  final DevirDistribution devirDistribution;
  final bool isValid;
  final String? errorMessage;

  const CalculationResult({
    required this.age,
    required this.deductionAge,
    required this.calculatedYears,
    required this.totalMonths,
    required this.fitreAmount,
    required this.monthlyNamaz,
    required this.monthlyOruc,
    required this.monthlyYemin,
    required this.monthlyTotal,
    required this.grandTotal,
    required this.devirDistribution,
    this.isValid = true,
    this.errorMessage,
  });

  /// Geçersiz/hata durumundaki boş sonuç nesnesi
  factory CalculationResult.invalid(String message) {
    return CalculationResult(
      age: 0,
      deductionAge: 0,
      calculatedYears: 0,
      totalMonths: 0,
      fitreAmount: 0.0,
      monthlyNamaz: 0.0,
      monthlyOruc: 0.0,
      monthlyYemin: 0.0,
      monthlyTotal: 0.0,
      grandTotal: 0.0,
      devirDistribution: const DevirDistribution(
        totalMonths: 0,
        totalPeople: 0,
        groups: [],
        grandTotalRounds: 0,
      ),
      isValid: false,
      errorMessage: message,
    );
  }
}
