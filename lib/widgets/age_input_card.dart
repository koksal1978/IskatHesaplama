import 'package:flutter/material.dart';
import '../controllers/calculation_controller.dart';
import '../models/calculation_input.dart';
import '../utils/constants.dart';

/// Yaş hesaplama yöntemi ve yaş girdilerini içeren kart bileşeni.
class AgeInputCard extends StatelessWidget {
  final CalculationController controller;

  const AgeInputCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBirthDeathMode =
        controller.ageMode == AgeCalculationMode.birthDeathYear;
    final resolvedAge = controller.currentInput.resolvedAge;

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppConstants.creamBorder, width: 1.2),
      ),
      color: AppConstants.creamCard,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.cake_outlined,
                  color: AppConstants.primaryGreen,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  '1. Yaş Bilgisi',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // SegmentedButton: Yöntem seçimi
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<AgeCalculationMode>(
                segments: const [
                  ButtonSegment<AgeCalculationMode>(
                    value: AgeCalculationMode.birthDeathYear,
                    label: Text('Doğum / Ölüm Yılı'),
                    icon: Icon(Icons.date_range),
                  ),
                  ButtonSegment<AgeCalculationMode>(
                    value: AgeCalculationMode.directAge,
                    label: Text('Yaşı Direkt Gir'),
                    icon: Icon(Icons.edit_note),
                  ),
                ],
                selected: {controller.ageMode},
                onSelectionChanged: (Set<AgeCalculationMode> newSelection) {
                  controller.setAgeMode(newSelection.first);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppConstants.primaryGreen;
                      }
                      return AppConstants.creamTint;
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return AppConstants.textDark;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (isBirthDeathMode) ...[
              // Doğum Yılı ve Ölüm Yılı alanları
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.birthYearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Doğum Yılı',
                        hintText: 'Örn: 1946',
                        prefixIcon: Icon(Icons.history),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      onChanged: (_) => controller.recalculate(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller.deathYearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ölüm Yılı',
                        hintText: 'Örn: 2026',
                        prefixIcon: Icon(Icons.event),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      onChanged: (_) => controller.recalculate(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Yalnızca yıl girildiğinde hesaplanan yaş yaklaşık tam yaş değeridir.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppConstants.textMuted,
                ),
              ),
            ] else ...[
              // Direkt Yaş Girişi
              TextField(
                controller: controller.directAgeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Vefat Yaşı',
                  hintText: 'Örn: 80',
                  prefixIcon: Icon(Icons.person_pin_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: (_) => controller.recalculate(),
              ),
            ],

            const SizedBox(height: 12),

            // Sonuç rozeti
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: AppConstants.creamTint,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppConstants.goldAccent.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hesaplanan Yaş:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textDark,
                    ),
                  ),
                  Text(
                    resolvedAge != null && resolvedAge >= 0
                        ? 'Vefat yaşı: $resolvedAge'
                        : 'Lütfen geçerli yaş giriniz',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: resolvedAge != null && resolvedAge >= 0
                          ? AppConstants.primaryGreen
                          : AppConstants.errorRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
