import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/calculation_controller.dart';
import '../utils/constants.dart';

/// Fitre ve günlük fidye bedeli giriş, internetten çekme ve kaynak kartı.
class FitreCard extends StatelessWidget {
  final CalculationController controller;

  const FitreCard({super.key, required this.controller});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fitreInfo = controller.currentFitreInfo;

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
                  Icons.volunteer_activism_outlined,
                  color: AppConstants.primaryGreen,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '4. Fitre / Günlük Fidye Bedeli',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Fitre Yılı ve İnternetten Getir Butonu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: controller.fitreYearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Fitre Yılı',
                      hintText: 'Örn: 2026',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    onChanged: (_) => controller.recalculate(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: controller.isFetchingFitre
                          ? null
                          : () => controller.fetchFitreFromInternet(),
                      icon: controller.isFetchingFitre
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.cloud_download_outlined, size: 20),
                      label: Text(
                        controller.isFetchingFitre
                            ? 'Getiriliyor...'
                            : 'İnternetten\nGetir',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (controller.fitreStatusMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.creamTint,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConstants.goldAccent.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  controller.fitreStatusMessage!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppConstants.textDark,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 14),

            // Fitre / Günlük Fidye Bedeli Girişi (Manuel veya Çekilen)
            TextField(
              controller: controller.fitreAmountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Fitre / Günlük Fidye Bedeli',
                hintText: 'Örn: 240 veya 240,50',
                prefixIcon: Icon(Icons.payments_outlined),
                suffixText: 'TL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                helperText:
                    'İnternetten tutar gelse dahi dilediğiniz zaman elle değiştirebilirsiniz.',
              ),
              onChanged: (val) => controller.onFitreAmountManualChanged(val),
            ),

            // Kaynak Rozeti
            if (fitreInfo != null) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppConstants.creamBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppConstants.creamBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppConstants.goldAccentDark,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kaynak: ${fitreInfo.source}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppConstants.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (fitreInfo.sourceUrl != null)
                      InkWell(
                        onTap: () => _launchUrl(fitreInfo.sourceUrl!),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.open_in_new,
                            size: 16,
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
