import 'package:flutter/material.dart';
import '../controllers/calculation_controller.dart';
import '../utils/constants.dart';
import '../widgets/age_input_card.dart';
import '../widgets/calculation_result_card.dart';
import '../widgets/calculation_settings_card.dart';
import '../widgets/deduction_age_card.dart';
import '../widgets/disclaimer_card.dart';
import '../widgets/export_dialog.dart';
import '../widgets/fitre_card.dart';
import '../widgets/gender_card.dart';

/// İskat ve Fidye Hesaplama ana sayfası (Duyarlı Masaüstü Grid & Mobil Mimari).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CalculationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalculationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.creamBackground,
      appBar: AppBar(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConstants.appTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 2),
            Text(
              AppConstants.appSubtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppConstants.goldAccentLight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            tooltip: 'Hesap Özetini Paylaş / Yazdır',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => ExportDialog.show(context, _controller),
          ),
          IconButton(
            tooltip: 'Varsayılanlara Dön',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.resetToDefaults();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tüm değerler varsayılana sıfırlandı.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 1400 : 680,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 24.0 : 16.0,
                        vertical: isDesktop ? 18.0 : 14.0,
                      ),
                      child: isDesktop
                          ? _buildDesktopGrid(context)
                          : _buildMobileLayout(context),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Masaüstü / Windows için 2 Kolonlu Grid Yerleşimi
  Widget _buildDesktopGrid(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SOL KOLON: Girdi Kartları ve Ayarlar
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionBanner(
                icon: Icons.edit_note,
                title: 'HESAPLAMA GİRDİLERİ',
                subtitle: 'Kişi ve süre parametreleri',
              ),
              const SizedBox(height: 12),
              AgeInputCard(controller: _controller),
              const SizedBox(height: 12),
              GenderCard(controller: _controller),
              const SizedBox(height: 12),
              DeductionAgeCard(controller: _controller),
              const SizedBox(height: 12),
              FitreCard(controller: _controller),
              const SizedBox(height: 12),
              CalculationSettingsCard(controller: _controller),
              const SizedBox(height: 16),
              _buildActionButtons(context),
            ],
          ),
        ),
        const SizedBox(width: 20),

        // SAĞ KOLON: Sonuç Çıktıları ve Devir Dağılımı (Grid)
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionBanner(
                icon: Icons.analytics_outlined,
                title: 'HESAPLAMA SONUÇLARI',
                subtitle: 'Toplam tutar ve devir dağılımı',
              ),
              const SizedBox(height: 12),
              CalculationResultCard(controller: _controller, isDesktop: true),
              const SizedBox(height: 14),
              _buildShareButton(context),
              const SizedBox(height: 16),
              const DisclaimerCard(),
            ],
          ),
        ),
      ],
    );
  }

  /// Mobil / Dar ekranlar için tek sütunlu yerleşim
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AgeInputCard(controller: _controller),
        const SizedBox(height: 12),
        GenderCard(controller: _controller),
        const SizedBox(height: 12),
        DeductionAgeCard(controller: _controller),
        const SizedBox(height: 12),
        FitreCard(controller: _controller),
        const SizedBox(height: 12),
        CalculationSettingsCard(controller: _controller),
        const SizedBox(height: 16),
        _buildActionButtons(context),
        const SizedBox(height: 18),
        CalculationResultCard(controller: _controller, isDesktop: false),
        const SizedBox(height: 16),
        _buildShareButton(context),
        const SizedBox(height: 20),
        const DisclaimerCard(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionBanner({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppConstants.creamTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.creamBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryGreen, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.8,
                  color: AppConstants.primaryGreenDark,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppConstants.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                _controller.recalculate();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hesaplama güncellendi.'),
                    duration: Duration(milliseconds: 1500),
                  ),
                );
              },
              icon: const Icon(Icons.calculate, color: Colors.white),
              label: const Text(
                'HESAPLA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => _controller.clearAll(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppConstants.textMuted,
                side: const BorderSide(color: AppConstants.creamBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Temizle',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => ExportDialog.show(context, _controller),
        icon: const Icon(Icons.share, color: Colors.white, size: 20),
        label: const Text(
          'HESAP ÖZETİNİ PAYLAŞ (RESİM & PDF)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.goldAccentDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
        ),
      ),
    );
  }
}

