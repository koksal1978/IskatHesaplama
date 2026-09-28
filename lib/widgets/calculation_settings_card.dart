import 'package:flutter/material.dart';
import '../controllers/calculation_controller.dart';
import '../utils/constants.dart';

/// Gelişmiş hesap katsayıları ve devir kişi sayısı ayar kartı.
class CalculationSettingsCard extends StatelessWidget {
  final CalculationController controller;

  const CalculationSettingsCard({super.key, required this.controller});

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
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          leading: const Icon(
            Icons.tune_outlined,
            color: AppConstants.primaryGreen,
          ),
          title: Text(
            'Gelişmiş Hesap Ayarları',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryGreen,
            ),
          ),
          subtitle: const Text(
            'Namaz, oruç, yemin katsayıları ve kişi sayısı',
            style: TextStyle(fontSize: 12, color: AppConstants.textMuted),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(color: AppConstants.creamBorder),
                  const SizedBox(height: 8),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 380;
                      if (isWide) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildPersonCountField(controller)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildNamazFactorField(controller)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildOrucFactorField(controller)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildYeminFactorField(controller)),
                              ],
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _buildPersonCountField(controller),
                          const SizedBox(height: 14),
                          _buildNamazFactorField(controller),
                          const SizedBox(height: 14),
                          _buildOrucFactorField(controller),
                          const SizedBox(height: 14),
                          _buildYeminFactorField(controller),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  // Varsayılan katsayılara dön butonu
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => controller.resetFactorsToDefault(),
                      icon: const Icon(Icons.settings_backup_restore),
                      label: const Text('Varsayılan Katsayılara Dön (180 / 61 / 10)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.primaryGreen,
                        side: const BorderSide(color: AppConstants.primaryGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
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

  Widget _buildPersonCountField(CalculationController controller) {
    return TextField(
      controller: controller.personCountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Devir Kişi Sayısı',
        hintText: 'Örn: 10',
        prefixIcon: Icon(Icons.groups_outlined),
        suffixText: 'kişi',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        helperText: 'Toplam sürenin devir dağılımı.',
      ),
      onChanged: (_) => controller.recalculate(),
    );
  }

  Widget _buildNamazFactorField(CalculationController controller) {
    return TextField(
      controller: controller.namazFactorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Namaz Vakti/Ay',
        hintText: '180 (30 gün × 6 vakit)',
        prefixIcon: Icon(Icons.mosque_outlined),
        suffixText: 'vakit',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      onChanged: (_) => controller.recalculate(),
    );
  }

  Widget _buildOrucFactorField(CalculationController controller) {
    return TextField(
      controller: controller.orucFactorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Oruç/Kefaret/Ay',
        hintText: '61 (Kefaret)',
        prefixIcon: Icon(Icons.nightlight_outlined),
        suffixText: 'gün',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      onChanged: (_) => controller.recalculate(),
    );
  }

  Widget _buildYeminFactorField(CalculationController controller) {
    return TextField(
      controller: controller.yeminFactorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Yemin Kefareti/Ay',
        hintText: '10',
        prefixIcon: Icon(Icons.pan_tool_alt_outlined),
        suffixText: 'fitre',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      onChanged: (_) => controller.recalculate(),
    );
  }
}
