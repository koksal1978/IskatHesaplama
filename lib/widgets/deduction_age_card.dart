import 'package:flutter/material.dart';
import '../controllers/calculation_controller.dart';
import '../models/gender.dart';
import '../utils/constants.dart';

/// Düşülen yaş (bülûğ çağı öncesi süre) giriş ve yönetim kartı.
class DeductionAgeCard extends StatelessWidget {
  final CalculationController controller;

  const DeductionAgeCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFemale = controller.gender == Gender.female;
    final defaultAge = getDefaultDeductionAge(controller.gender);
    final currentDeduction =
        int.tryParse(controller.deductionAgeController.text.trim());

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
                  Icons.remove_circle_outline,
                  color: AppConstants.primaryGreen,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  '3. Düşülen Yaş',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Giriş alanı ve Varsayılana Dön Butonu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.deductionAgeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Düşülen Yaş Değeri',
                      hintText: 'Örn: $defaultAge',
                      prefixIcon: const Icon(Icons.tune),
                      suffixText: 'yaş',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      helperText: currentDeduction != null &&
                              currentDeduction != defaultAge
                          ? 'Özel değer girildi (Varsayılan: $defaultAge)'
                          : null,
                    ),
                    onChanged: (_) => controller.recalculate(),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => controller.resetDeductionAgeToDefault(),
                    icon: const Icon(Icons.restore, size: 18),
                    label: const Text('Varsayılana\nDön', textAlign: TextAlign.center),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConstants.primaryGreen,
                      side: const BorderSide(color: AppConstants.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Bilgilendirme metni
            Text(
              isFemale
                  ? 'Kadın için başlangıç değeri: 9 yaş. İsterseniz değiştirebilirsiniz.'
                  : 'Erkek için başlangıç değeri: 12 yaş. İsterseniz değiştirebilirsiniz.',
              style: const TextStyle(
                fontSize: 12.5,
                color: AppConstants.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
