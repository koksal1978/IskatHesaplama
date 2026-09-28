import 'package:flutter/material.dart';
import '../controllers/calculation_controller.dart';
import '../models/calculation_input.dart';
import '../models/calculation_result.dart';
import '../models/fitre_info.dart';
import '../models/gender.dart';
import '../utils/constants.dart';
import '../utils/currency_formatter.dart';
import 'devir_table.dart';

/// Tüm hesaplama çıktılarını (Kişi Bilgileri, Fitre, 1 Aylık Esas Hesap,
/// Genel Toplam ve Devir Dağılımı) sunan ana sonuç kartı.
class CalculationResultCard extends StatelessWidget {
  final CalculationController controller;
  final bool isDesktop;

  const CalculationResultCard({
    super.key,
    required this.controller,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final result = controller.result;
    final theme = Theme.of(context);

    if (!result.isValid) {
      return Card(
        color: const Color(0xFFFFF0F0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppConstants.errorRed, width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppConstants.errorRed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  result.errorMessage ?? 'Hesaplama yapılamadı.',
                  style: const TextStyle(
                    color: AppConstants.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final fitreInfo = controller.currentFitreInfo;
    final input = controller.currentInput;

    if (isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // D) GENEL TOPLAM - Desktopta en başta vurgulu özet kartı
          _buildGenelToplamCard(theme, result),
          const SizedBox(height: 14),

          // A ve B Kartları Yan Yana Grid
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildKisiBilgileriCard(result, controller),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFitreBilgisiCard(input, result, fitreInfo),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // C) 1 AYLIK ESAS HESAP KARTI
          _buildEsasHesapCard(input, result),
          const SizedBox(height: 14),

          // E) DEVİR DAĞILIMI KARTI
          _buildDevirDagitimiCard(input, result),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildKisiBilgileriCard(result, controller),
        const SizedBox(height: 12),
        _buildFitreBilgisiCard(input, result, fitreInfo),
        const SizedBox(height: 12),
        _buildEsasHesapCard(input, result),
        const SizedBox(height: 14),
        _buildGenelToplamCard(theme, result),
        const SizedBox(height: 14),
        _buildDevirDagitimiCard(input, result),
      ],
    );
  }
  Widget _buildKisiBilgileriCard(
    CalculationResult result,
    CalculationController controller,
  ) {
    return Card(
      elevation: 0.5,
      color: AppConstants.creamCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppConstants.creamBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.person_outline,
              title: 'A) Kişi Bilgileri & Süre',
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Cinsiyet', controller.gender.displayName),
            _buildInfoRow('Vefat Yaşı', '${result.age} yaş'),
            _buildInfoRow('Düşülen Yaş', '${result.deductionAge} yaş'),
            _buildInfoRow(
              'Hesaplanan Süre',
              '${result.age} - ${result.deductionAge} = ${result.calculatedYears} yıl',
            ),
            _buildInfoRow(
              'Toplam Süre (Ay)',
              '${result.calculatedYears} × 12 = ${result.totalMonths} ay',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFitreBilgisiCard(
    CalculationInput input,
    CalculationResult result,
    FitreInfo? fitreInfo,
  ) {
    return Card(
      elevation: 0.5,
      color: AppConstants.creamCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppConstants.creamBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.receipt_long_outlined,
              title: 'B) Fitre / Günlük Fidye',
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Fitre Yılı', '${input.fitreYear}'),
            _buildInfoRow(
              'Fitre / Günlük Fidye Bedeli',
              CurrencyFormatter.formatTL(result.fitreAmount),
              isBold: true,
            ),
            _buildInfoRow(
              'Kaynak',
              fitreInfo?.source ?? 'Belirtilmedi',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEsasHesapCard(
    CalculationInput input,
    CalculationResult result,
  ) {
    return Card(
      elevation: 0.5,
      color: AppConstants.creamCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppConstants.creamBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.calculate_outlined,
              title: 'C) 1 Aylık Esas Hesap',
            ),
            const SizedBox(height: 12),
            _buildSubCalculationRow(
              icon: Icons.mosque_outlined,
              label: 'Namaz Fidyesi (${input.namazFactor} Vakit)',
              formula:
                  '${input.namazFactor} × ${CurrencyFormatter.formatTL(result.fitreAmount)}',
              total: CurrencyFormatter.formatTL(result.monthlyNamaz),
            ),
            const SizedBox(height: 8),
            _buildSubCalculationRow(
              icon: Icons.nightlight_outlined,
              label: 'Oruç Kefareti (${input.orucFactor} Gün)',
              formula:
                  '${input.orucFactor} × ${CurrencyFormatter.formatTL(result.fitreAmount)}',
              total: CurrencyFormatter.formatTL(result.monthlyOruc),
            ),
            const SizedBox(height: 8),
            _buildSubCalculationRow(
              icon: Icons.pan_tool_alt_outlined,
              label: 'Yemin Kefareti (${input.yeminFactor} Adet)',
              formula:
                  '${input.yeminFactor} × ${CurrencyFormatter.formatTL(result.fitreAmount)}',
              total: CurrencyFormatter.formatTL(result.monthlyYemin),
            ),
            const Divider(height: 20, color: AppConstants.creamBorder),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppConstants.creamTint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '1 Aylık Toplam:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.formatTL(result.monthlyTotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppConstants.primaryGreen,
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

  Widget _buildGenelToplamCard(
    ThemeData theme,
    CalculationResult result,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppConstants.primaryGreenDark,
            AppConstants.primaryGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppConstants.goldAccent,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGreenDark.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: AppConstants.goldAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'GENEL TOPLAM',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppConstants.goldAccentLight,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.auto_awesome,
                color: AppConstants.goldAccent,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${result.totalMonths} ay × ${CurrencyFormatter.formatTL(result.monthlyTotal)}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              CurrencyFormatter.formatTL(result.grandTotal),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevirDagitimiCard(
    CalculationInput input,
    CalculationResult result,
  ) {
    return Card(
      elevation: 0.5,
      color: AppConstants.creamCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppConstants.creamBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.groups_outlined,
              title: 'E) ${input.personCount} Kişi ile Devir Dağılımı',
            ),
            const SizedBox(height: 8),
            Text(
              'Toplam ${result.totalMonths} ay, ${input.personCount} kişiye dengeli şekilde paylaştırılmıştır:',
              style: const TextStyle(
                fontSize: 12.5,
                color: AppConstants.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            DevirTable(distribution: result.devirDistribution),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.primaryGreen, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppConstants.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppConstants.textDark.withValues(alpha: 0.85),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? AppConstants.primaryGreen : AppConstants.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCalculationRow({
    required IconData icon,
    required String label,
    required String formula,
    required String total,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppConstants.creamBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConstants.creamBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.goldAccentDark, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textDark,
                  ),
                ),
                Text(
                  formula,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppConstants.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            total,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
