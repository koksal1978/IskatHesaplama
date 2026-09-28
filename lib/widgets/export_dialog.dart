import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../controllers/calculation_controller.dart';
import '../services/export_service.dart';
import '../utils/constants.dart';
import 'summary_poster_widget.dart';

/// Kullanıcının hesap afişini önizlemesini, Resim (PNG) veya PDF olarak
/// paylaşmasını ve yazdırmasını sağlayan diyalog penceresi.
class ExportDialog extends StatefulWidget {
  final CalculationController controller;

  const ExportDialog({super.key, required this.controller});

  static Future<void> show(BuildContext context, CalculationController controller) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ExportDialog(controller: controller),
    );
  }

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  final GlobalKey _posterKey = GlobalKey();
  bool _isProcessing = false;
  String? _statusText;

  Future<Uint8List?> _getPngBytes() async {
    setState(() {
      _isProcessing = true;
      _statusText = 'Afiş görseli hazırlanıyor...';
    });
    // Widget renderının tamamlanması için kısa bir gecikme
    await Future.delayed(const Duration(milliseconds: 150));
    final bytes = await ExportService.capturePng(_posterKey);
    return bytes;
  }

  Future<void> _handleShareImage() async {
    final bytes = await _getPngBytes();
    if (bytes == null) {
      _showError('Görsel oluşturulamadı.');
      return;
    }
    setState(() => _statusText = 'Paylaşım penceresi açılıyor...');
    final success = await ExportService.shareImage(bytes);
    if (mounted) {
      setState(() => _isProcessing = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Görsel başarıyla paylaşıldı.')),
        );
      }
    }
  }

  Future<void> _handleSharePdf() async {
    final bytes = await _getPngBytes();
    if (bytes == null) {
      _showError('Görsel oluşturulamadı.');
      return;
    }
    setState(() => _statusText = 'PDF belgesi oluşturuluyor...');
    final pdfBytes = await ExportService.generatePdfFromImage(bytes);
    setState(() => _statusText = 'PDF paylaşılıyor...');
    final success = await ExportService.sharePdf(pdfBytes);
    if (mounted) {
      setState(() => _isProcessing = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF başarıyla paylaşıldı.')),
        );
      }
    }
  }

  Future<void> _handlePrint() async {
    final bytes = await _getPngBytes();
    if (bytes == null) {
      _showError('Yazdırma verisi oluşturulamadı.');
      return;
    }
    setState(() => _statusText = 'Yazdırma penceresi hazırlanıyor...');
    final pdfBytes = await ExportService.generatePdfFromImage(bytes);
    await ExportService.printPdf(pdfBytes);
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleSaveLocal() async {
    final bytes = await _getPngBytes();
    if (bytes == null) {
      _showError('Görsel oluşturulamadı.');
      return;
    }
    setState(() => _statusText = 'Dosya kaydediliyor...');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = await ExportService.saveToFile(
      bytes,
      'iskat_hesap_ozeti_$timestamp.png',
    );
    if (mounted) {
      setState(() => _isProcessing = false);
      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Görsel kaydedildi: $path'),
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        _showError('Dosya kaydedilemedi.');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.errorRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final input = widget.controller.currentInput;
    final result = widget.controller.result;

    return Dialog(
      backgroundColor: AppConstants.creamBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 850),
        child: Column(
          children: [
            // Üst Başlık ve Kapat Butonu
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 10, 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.share_outlined,
                    color: AppConstants.primaryGreen,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Hesap Özeti Paylaş & Yazdır',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppConstants.creamBorder),

            // Önizleme Alanı (Kaydırılabilir ve Zoomlanabilir)
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: const Color(0xFFE5E2DA),
                    width: double.infinity,
                    height: double.infinity,
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 3.5,
                      boundaryMargin: const EdgeInsets.all(20),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: RepaintBoundary(
                              key: _posterKey,
                              child: SummaryPosterWidget(
                                input: input,
                                result: result,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Yükleniyor / İşleniyor Katmanı
                  if (_isProcessing)
                    Container(
                      color: Colors.black45,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: AppConstants.primaryGreen,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _statusText ?? 'Lütfen bekleyin...',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppConstants.creamBorder),

            // Alt İşlem Butonları (Paylaşım Seçenekleri)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  // 1. Resim Olarak Paylaş
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _handleShareImage,
                    icon: const Icon(Icons.image_outlined, size: 18),
                    label: const Text('Resim Paylaş (PNG)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                    ),
                  ),

                  // 2. PDF Olarak Paylaş
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _handleSharePdf,
                    icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                    label: const Text('PDF Paylaş'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D4428),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                    ),
                  ),

                  // 3. Yazdır
                  OutlinedButton.icon(
                    onPressed: _isProcessing ? null : _handlePrint,
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text('Yazdır'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConstants.primaryGreen,
                      side: const BorderSide(color: AppConstants.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                    ),
                  ),

                  // 4. Cihaza Kaydet
                  OutlinedButton.icon(
                    onPressed: _isProcessing ? null : _handleSaveLocal,
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Kaydet'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConstants.textDark,
                      side: const BorderSide(color: AppConstants.creamBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
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
}
