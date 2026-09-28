import 'package:flutter_test/flutter_test.dart';
import 'package:iskat_hesaplama/controllers/calculation_controller.dart';
import 'package:iskat_hesaplama/models/gender.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CalculationController controller;

  setUp(() {
    controller = CalculationController();
  });

  tearDown(() {
    controller.dispose();
  });

  group('CalculationController Durum Yönetimi Testleri', () {
    test('Başlangıç varsayılan değerleri doğru yüklenmelidir', () {
      expect(controller.gender, equals(Gender.male));
      expect(controller.directAgeController.text, equals('80'));
      expect(controller.deductionAgeController.text, equals('12'));
      expect(controller.fitreAmountController.text, equals('240'));
      expect(controller.personCountController.text, equals('10'));
      expect(controller.result.isValid, isTrue);
      expect(controller.result.calculatedYears, equals(68));
      expect(controller.result.grandTotal, equals(49155840.0));
    });

    test('Cinsiyet değişimi varsayılan düşülen yaşı otomatik günceller', () {
      controller.setGender(Gender.female);
      expect(controller.gender, equals(Gender.female));
      expect(controller.deductionAgeController.text, equals('9'));
      expect(controller.result.calculatedYears, equals(71));
      expect(controller.result.totalMonths, equals(852));
    });

    test('Kullanıcı düşülen yaşı elle değiştirdiğinde o değer korunmalıdır', () {
      controller.setGender(Gender.female);
      controller.deductionAgeController.text = '11';
      controller.recalculate();

      expect(controller.result.deductionAge, equals(11));
      expect(controller.result.calculatedYears, equals(69));
      expect(controller.result.totalMonths, equals(828));
    });

    test('Varsayılana Dön butonu doğru değeri geri yükler', () {
      // Kadın için test
      controller.setGender(Gender.female);
      controller.deductionAgeController.text = '15';
      controller.recalculate();
      expect(controller.result.deductionAge, equals(15));

      controller.resetDeductionAgeToDefault();
      expect(controller.deductionAgeController.text, equals('9'));
      expect(controller.result.deductionAge, equals(9));

      // Erkek için test
      controller.setGender(Gender.male);
      controller.deductionAgeController.text = '15';
      controller.recalculate();
      expect(controller.result.deductionAge, equals(15));

      controller.resetDeductionAgeToDefault();
      expect(controller.deductionAgeController.text, equals('12'));
      expect(controller.result.deductionAge, equals(12));
    });

    test('Manuel fitre girişi öncelikli olarak kullanılır', () {
      controller.onFitreAmountManualChanged('250');
      expect(controller.result.fitreAmount, equals(250.0));
      expect(controller.currentFitreInfo?.isManual, isTrue);
    });

    test('Tümünü Temizle ve Varsayılanlara Dön', () {
      controller.clearAll();
      expect(controller.birthYearController.text, isEmpty);
      expect(controller.directAgeController.text, isEmpty);

      controller.resetToDefaults();
      expect(controller.gender, equals(Gender.male));
      expect(controller.directAgeController.text, equals('80'));
      expect(controller.deductionAgeController.text, equals('12'));
      expect(controller.result.grandTotal, equals(49155840.0));
    });
  });
}
