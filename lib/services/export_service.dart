import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

/// Hesap özetinin görsel (PNG) ve PDF olarak üretilmesi, paylaşılması ve yazdırılmasını yöneten servis.
class ExportService {
  /// Bir [RepaintBoundary] bileşenini yüksek çözünürlüklü (3.0 pixelRatio) PNG baytlarına dönüştürür.
  static Future<Uint8List?> capturePng(GlobalKey boundaryKey) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  /// PNG afiş görselini A4 boyutunda ölçekli bir PDF belgesine dönüştürür.
  static Future<Uint8List> generatePdfFromImage(Uint8List imageBytes) async {
    final pdf = pw.Document(title: 'İskat ve Fidye Hesap Özeti');
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(12),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image, fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Resmi cihazdaki diğer uygulamalarla (WhatsApp, Telegram, vb.) paylaşır.
  static Future<bool> shareImage(
    Uint8List imageBytes, {
    String filename = 'iskat_hesap_ozeti.png',
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(imageBytes);

      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: 'İskat / Fidye / Kefaret Hesap Özeti',
        ),
      );
      return result.status == ShareResultStatus.success;
    } catch (_) {
      return false;
    }
  }

  /// PDF belgesini diğer uygulamalarla paylaşır.
  static Future<bool> sharePdf(
    Uint8List pdfBytes, {
    String filename = 'iskat_hesap_ozeti.pdf',
  }) async {
    try {
      await Printing.sharePdf(bytes: pdfBytes, filename: filename);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// PDF belgesini doğrudan yazıcıya gönderir veya sistem yazdırma penceresini açar.
  static Future<void> printPdf(
    Uint8List pdfBytes, {
    String name = 'Iskat_Hesap_Ozeti',
  }) async {
    await Printing.layoutPdf(
      onLayout: (_) async => pdfBytes,
      name: name,
    );
  }

  /// Dosyayı kullanıcının İndirilenler veya Belgeler klasörüne kaydeder.
  static Future<String?> saveToFile(
    Uint8List bytes,
    String filename,
  ) async {
    try {
      Directory? targetDir;
      if (Platform.isWindows) {
        targetDir = await getDownloadsDirectory();
      }
      targetDir ??= await getApplicationDocumentsDirectory();

      final file = File('${targetDir.path}/$filename');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (_) {
      return null;
    }
  }
}
