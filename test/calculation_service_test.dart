import 'package:flutter_test/flutter_test.dart';
import 'package:iskat_hesaplama/models/calculation_input.dart';
import 'package:iskat_hesaplama/models/gender.dart';
import 'package:iskat_hesaplama/services/calculation_service.dart';
import 'package:iskat_hesaplama/utils/currency_formatter.dart';

void main() {
  late CalculationService service;

  setUp(() {
    service = CalculationService();
  });

  group('İskat ve Fidye Hesaplama Unit Testleri (1-14)', () {
    // TEST 1 — Erkek varsayılan düşülen yaş
    test('TEST 1: Erkek varsayılan düşülen yaş hesabı', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 80,
        gender: Gender.male,
        deductionAge: 12,
        fitreYear: 2026,
        fitreAmount: 240,
      );

      final result = service.calculate(input);

      expect(result.isValid, isTrue);
      expect(result.deductionAge, equals(12));
      expect(result.calculatedYears, equals(68));
      expect(result.totalMonths, equals(816));
    });

    // TEST 2 — Kadın varsayılan düşülen yaş
    test('TEST 2: Kadın varsayılan düşülen yaş hesabı', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 80,
        gender: Gender.female,
        deductionAge: 9,
        fitreYear: 2026,
        fitreAmount: 240,
      );

      final result = service.calculate(input);

      expect(result.isValid, isTrue);
      expect(result.deductionAge, equals(9));
      expect(result.calculatedYears, equals(71));
      expect(result.totalMonths, equals(852));
    });

    // TEST 3 — Erkek tam hesap
    test('TEST 3: Erkek tam hesap (Görseldeki referans senaryo)', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 80,
        gender: Gender.male,
        deductionAge: 12,
        fitreYear: 2026,
        fitreAmount: 240,
        namazFactor: 180,
        orucFactor: 61,
        yeminFactor: 10,
        personCount: 10,
      );

      final result = service.calculate(input);

      expect(result.isValid, isTrue);
      expect(result.calculatedYears, equals(68));
      expect(result.totalMonths, equals(816));
      expect(result.monthlyNamaz, equals(43200.0));
      expect(result.monthlyOruc, equals(14640.0));
      expect(result.monthlyYemin, equals(2400.0));
      expect(result.monthlyTotal, equals(60240.0));
      expect(result.grandTotal, equals(49155840.0));

      // Devir dağılımı doğrulaması
      final devir = result.devirDistribution;
      expect(devir.totalPeople, equals(10));
      expect(devir.groups.length, equals(2));

      // 1. Grup: 6 kişi x 82 = 492
      expect(devir.groups[0].groupName, equals('1. Grup'));
      expect(devir.groups[0].personCount, equals(6));
      expect(devir.groups[0].roundsPerPerson, equals(82));
      expect(devir.groups[0].totalRounds, equals(492));

      // 2. Grup: 4 kişi x 81 = 324
      expect(devir.groups[1].groupName, equals('2. Grup'));
      expect(devir.groups[1].personCount, equals(4));
      expect(devir.groups[1].roundsPerPerson, equals(81));
      expect(devir.groups[1].totalRounds, equals(324));

      // Genel toplam devir: 816
      expect(devir.grandTotalRounds, equals(816));
    });

    // TEST 4 — Kadın tam hesap
    test('TEST 4: Kadın tam hesap', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 80,
        gender: Gender.female,
        deductionAge: 9,
        fitreYear: 2026,
        fitreAmount: 240,
        namazFactor: 180,
        orucFactor: 61,
        yeminFactor: 10,
        personCount: 10,
      );

      final result = service.calculate(input);

      expect(result.isValid, isTrue);
      expect(result.calculatedYears, equals(71));
      expect(result.totalMonths, equals(852));
      expect(result.monthlyTotal, equals(60240.0));
      expect(result.grandTotal, equals(51324480.0));
    });

    // TEST 5 — Kadın manuel düşülen yaş
    test('TEST 5: Kadın manuel düşülen yaş (11 yaş)', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 80,
        gender: Gender.female,
        deductionAge: 11, // Manuel girildi
        fitreYear: 2026,
        fitreAmount: 240,
      );

      final result = service.calculate(input);

      expect(result.isValid, isTrue);
      expect(result.calculatedYears, equals(69));
      expect(result.totalMonths, equals(828));
    });

    // TEST 6 — Erkek manuel düşülen yaş
    test('TEST 6: Erkek manuel düşülen yaş (10 yaş)', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 80,
        gender: Gender.male,
        deductionAge: 10, // Manuel girildi
        fitreYear: 2026,
        fitreAmount: 240,
      );

      final result = service.calculate(input);

      expect(result.isValid, isTrue);
      expect(result.calculatedYears, equals(70));
      expect(result.totalMonths, equals(840));
    });

    // TEST 7 — Varsayılana dön mantığı
    test('TEST 7: Varsayılan düşülen yaş yardımcı fonksiyonları', () {
      expect(getDefaultDeductionAge(Gender.female), equals(9));
      expect(getDefaultDeductionAge(Gender.male), equals(12));
    });

    // TEST 8 — Cinsiyet değişimi ve sonradan manuel giriş
    test('TEST 8: Cinsiyet değişimi sonrası manuel değer önceliği', () {
      final inputManual = const CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 80,
        gender: Gender.female,
        deductionAge: 10, // Kullanıcı manuel 10 yaptı
        fitreYear: 2026,
        fitreAmount: 240,
      );

      final result = service.calculate(inputManual);
      expect(result.deductionAge, equals(10));
      expect(result.calculatedYears, equals(70));
      expect(result.totalMonths, equals(840));
    });

    // TEST 9 — Doğum ve ölüm yılı
    test('TEST 9: Doğum (1946) ve Ölüm (2026) yılından yaş hesabı', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.birthDeathYear,
        birthYear: 1946,
        deathYear: 2026,
        gender: Gender.male,
        deductionAge: 12,
        fitreYear: 2026,
        fitreAmount: 240,
      );

      expect(input.resolvedAge, equals(80));

      final result = service.calculate(input);
      expect(result.isValid, isTrue);
      expect(result.age, equals(80));
      expect(result.calculatedYears, equals(68));
      expect(result.totalMonths, equals(816));
    });

    // TEST 10 — Kişi sayısı 1
    test('TEST 10: 816 ay ve 1 kişi için devir dağılımı', () {
      final devir = service.calculateDevirDistribution(
        totalMonths: 816,
        personCount: 1,
      );

      expect(devir.totalPeople, equals(1));
      expect(devir.groups.length, equals(1));
      expect(devir.groups[0].roundsPerPerson, equals(816));
      expect(devir.groups[0].totalRounds, equals(816));
      expect(devir.grandTotalRounds, equals(816));
    });

    // TEST 11 — Tam bölünme durumu
    test('TEST 11: 800 ay ve 10 kişi tam bölünme', () {
      final devir = service.calculateDevirDistribution(
        totalMonths: 800,
        personCount: 10,
      );

      expect(devir.totalPeople, equals(10));
      expect(devir.groups.length, equals(1)); // Kalan 0 olduğu için tek grup
      expect(devir.groups[0].personCount, equals(10));
      expect(devir.groups[0].roundsPerPerson, equals(80));
      expect(devir.groups[0].totalRounds, equals(800));
    });

    // TEST 12 — Decimal fitre bedeli doğrulaması
    test('TEST 12: Decimal (240.50 TL) fitre ile tam hassas hesap', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 80,
        gender: Gender.male,
        deductionAge: 12,
        fitreYear: 2026,
        fitreAmount: 240.50, // 240,50 TL
        namazFactor: 180,
        orucFactor: 61,
        yeminFactor: 10,
        personCount: 10,
      );

      final result = service.calculate(input);

      expect(result.isValid, isTrue);
      // 180 * 240.50 = 43.290 TL
      expect(result.monthlyNamaz, equals(43290.0));
      // 61 * 240.50 = 14.670,50 TL
      expect(result.monthlyOruc, equals(14670.50));
      // 10 * 240.50 = 2.405 TL
      expect(result.monthlyYemin, equals(2405.0));
      // Aylık toplam = 43290 + 14670.50 + 2405 = 60.365,50 TL
      expect(result.monthlyTotal, equals(60365.50));
      // Genel toplam = 816 * 60365.50 = 49.258.248 TL
      expect(result.grandTotal, equals(49258248.0));
    });

    // TEST 13 — Düşülen yaş = Yaş
    test('TEST 13: Düşülen yaş ile vefat yaşı eşit (12 = 12)', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 12,
        gender: Gender.male,
        deductionAge: 12,
        fitreYear: 2026,
        fitreAmount: 240,
      );

      final result = service.calculate(input);

      expect(result.isValid, isTrue);
      expect(result.calculatedYears, equals(0));
      expect(result.totalMonths, equals(0));
      expect(result.grandTotal, equals(0.0));
      expect(result.devirDistribution.grandTotalRounds, equals(0));
    });

    // TEST 14 — Düşülen yaş > Yaş
    test('TEST 14: Düşülen yaş vefat yaşından büyük olduğunda doğrulama hatası', () {
      const input = CalculationInput(
        ageMode: AgeCalculationMode.directAge,
        directAge: 10,
        gender: Gender.male,
        deductionAge: 12, // 12 > 10
        fitreYear: 2026,
        fitreAmount: 240,
      );

      final result = service.calculate(input);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, isNotNull);
      expect(
        result.errorMessage,
        contains('büyük olamaz'),
      );
    });

    // Ek Güvenlik Testi: Biçimlendirme
    test('CurrencyFormatter TL biçimlendirme doğrulaması', () {
      expect(CurrencyFormatter.formatTL(43200), equals('43.200 TL'));
      expect(CurrencyFormatter.formatTL(14640), equals('14.640 TL'));
      expect(CurrencyFormatter.formatTL(2400), equals('2.400 TL'));
      expect(CurrencyFormatter.formatTL(60240), equals('60.240 TL'));
      expect(CurrencyFormatter.formatTL(49155840), equals('49.155.840 TL'));
      expect(CurrencyFormatter.formatTL(240.50), equals('240,50 TL'));
    });
  });
}
