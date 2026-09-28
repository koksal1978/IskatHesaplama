import 'package:flutter/material.dart';
import '../controllers/calculation_controller.dart';
import '../models/gender.dart';
import '../utils/constants.dart';

/// Cinsiyet seçimi kart bileşeni.
class GenderCard extends StatelessWidget {
  final CalculationController controller;

  const GenderCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  Icons.people_outline,
                  color: AppConstants.primaryGreen,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  '2. Cinsiyet Seçimi',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // SegmentedButton: Cinsiyet
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<Gender>(
                segments: const [
                  ButtonSegment<Gender>(
                    value: Gender.female,
                    label: Text('Kadın (Varsayılan 9 yaş)'),
                    icon: Icon(Icons.female),
                  ),
                  ButtonSegment<Gender>(
                    value: Gender.male,
                    label: Text('Erkek (Varsayılan 12 yaş)'),
                    icon: Icon(Icons.male),
                  ),
                ],
                selected: {controller.gender},
                onSelectionChanged: (Set<Gender> newSelection) {
                  controller.setGender(newSelection.first);
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
          ],
        ),
      ),
    );
  }
}
