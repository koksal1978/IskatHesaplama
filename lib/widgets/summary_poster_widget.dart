import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/calculation_input.dart';
import '../models/calculation_result.dart';
import '../utils/currency_formatter.dart';

/// Standart A4 dikey (595 × 842 pt, 1 : 1.414 oranında) tek sayfa afiş tasarımı.
/// Kullanıcının referans görselindeki (media_1790595842635.jpg) İskat / Fidye / Kefaret
/// Hesap Özeti tasarımını, tezhip süslemelerini, akış şemasını ve devir tablosunu
/// tek bir kağıda eksiksiz ve orantılı şekilde sığdırır.
class SummaryPosterWidget extends StatelessWidget {
  final CalculationInput input;
  final CalculationResult result;

  /// Standart A4 sayfa ölçüleri (nokta cinsinden)
  static const double a4Width = 595.0;
  static const double a4Height = 842.0;

  const SummaryPosterWidget({
    super.key,
    required this.input,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: a4Width,
      height: a4Height,
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8F1), // Sıcak parşömen / krem zemin
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. Arka Plan İslami Geometrik Yıldız / Filigran Deseni
          Positioned.fill(
            child: CustomPaint(
              painter: _IslamicGeometricBackgroundPainter(),
            ),
          ),

          // 2. Dış Koyu Yeşil Çerçeve
          Positioned(
            top: 6,
            left: 6,
            right: 6,
            bottom: 6,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF0B3B24),
                  width: 2.2,
                ),
              ),
            ),
          ),

          // 3. İç İnce Altın Çerçeve
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            bottom: 12,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFC5A059),
                  width: 1.0,
                ),
              ),
            ),
          ),

          // 4. Dört Köşe Tezhip Arabesk Süslemeleri
          Positioned(top: 8, left: 8, child: _buildCornerOrnament(0)),
          Positioned(top: 8, right: 8, child: _buildCornerOrnament(1)),
          Positioned(bottom: 8, left: 8, child: _buildCornerOrnament(2)),
          Positioned(bottom: 8, right: 8, child: _buildCornerOrnament(3)),

          // 5. Ana İçerik Kolonu (Tek A4 sayfasına dikey olarak tam oturan)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Üst Başlık Bölümü (Hilal + Başlık + Alt Başlık)
                  _buildHeaderSection(),

                  // Esas Alınan Fitre Kutusu
                  _buildFitreBanner(),

                  // Akış Şeması (4 kutu ve 4 ok)
                  _buildFlowchart(),

                  // 1 Aylık Esas Hesap
                  _buildMonthlyCalculationBox(),

                  // Ok
                  _buildSmallFlowArrow(),

                  // GENEL TOPLAM Bandı (Yan süsleme kanatları ile)
                  _buildGrandTotalSection(),

                  // Devir Dağılımı Tablosu
                  _buildDevirSection(),

                  // Alt Dipnot Kutusu
                  _buildFooterNote(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Üst Başlık Bölümü
  Widget _buildHeaderSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Altın hilal ve yıldız motifi
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 1, width: 36, color: const Color(0xFFC5A059)),
            const SizedBox(width: 8),
            const Icon(Icons.star, size: 9, color: Color(0xFFC5A059)),
            const SizedBox(width: 6),
            const Icon(Icons.nightlight_round, size: 18, color: Color(0xFFC5A059)),
            const SizedBox(width: 6),
            const Icon(Icons.star, size: 9, color: Color(0xFFC5A059)),
            const SizedBox(width: 8),
            Container(height: 1, width: 36, color: const Color(0xFFC5A059)),
          ],
        ),
        const SizedBox(height: 4),

        // Ana Başlık
        const Text(
          'İSKAT / FİDYE / KEFARET HESAP ÖZETİ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 18.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            color: Color(0xFF0B3B24),
          ),
        ),
        const SizedBox(height: 2),

        // Alt Başlık
        const Text(
          'Konuşmadaki devirli hesaplama mantığına göre hazırlanmış örnek akış şeması ve tablo',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            color: Color(0xFF1E4630),
          ),
        ),
      ],
    );
  }

  /// Esas Alınan Fitre Kutusu
  Widget _buildFitreBanner() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF6EC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFC5A059), width: 1.1),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF0B3B24),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calculate, color: Color(0xFFDFC17B), size: 15),
              ),
              const SizedBox(width: 8),
              Text(
                'Esas alınan fitre / günlük fidye bedeli: ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[850],
                ),
              ),
              Text(
                CurrencyFormatter.formatTL(result.fitreAmount),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0B3B24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Akış Şeması (4 kutu ve aralarında oklar)
  Widget _buildFlowchart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFlowStepBox('Vefat yaşı: ${result.age}'),
        _buildSmallFlowArrow(),
        _buildFlowStepBox('Düşülen yaş: ${result.deductionAge}'),
        _buildSmallFlowArrow(),
        _buildFlowStepBox(
          'Hesaplanan süre\n${result.age} - ${result.deductionAge} = ${result.calculatedYears} yıl',
        ),
        _buildSmallFlowArrow(),
        _buildFlowStepBox(
          'Ay hesabı\n${result.calculatedYears} × 12 = ${result.totalMonths} ay',
          isEmphasized: true,
        ),
      ],
    );
  }

  Widget _buildFlowStepBox(String text, {bool isEmphasized = false}) {
    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: isEmphasized ? const Color(0xFFF6F0E4) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isEmphasized ? const Color(0xFF0B3B24) : const Color(0xFF222222),
          width: isEmphasized ? 1.3 : 0.9,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: isEmphasized ? FontWeight.w800 : FontWeight.w700,
          color: const Color(0xFF1B1B1B),
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildSmallFlowArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5),
      child: Icon(
        Icons.arrow_downward_rounded,
        size: 14,
        color: Color(0xFF0B3B24),
      ),
    );
  }

  /// 1 Aylık Esas Hesap
  Widget _buildMonthlyCalculationBox() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF7EE),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF0B3B24), width: 1.1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 3 Kolon: Namaz, Oruç, Yemin
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSubCalcColumn(
                      icon: Icons.mosque_outlined,
                      title: '${input.namazFactor} vakit namaz fidyesi',
                      formula:
                          '${input.namazFactor} × ${result.fitreAmount.toInt()} TL =',
                      total: CurrencyFormatter.formatTL(result.monthlyNamaz),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildSubCalcColumn(
                      icon: Icons.nightlight_outlined,
                      title: '${input.orucFactor} oruç kefareti',
                      formula:
                          '${input.orucFactor} × ${result.fitreAmount.toInt()} TL =',
                      total: CurrencyFormatter.formatTL(result.monthlyOruc),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildSubCalcColumn(
                      icon: Icons.eco_outlined,
                      title: '${input.yeminFactor} fitre yemin kefareti',
                      formula:
                          '${input.yeminFactor} × ${result.fitreAmount.toInt()} TL =',
                      total: CurrencyFormatter.formatTL(result.monthlyYemin),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),

              // 1 Aylık Toplam Kutusu
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2EBDC),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFC5A059), width: 1.0),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0B3B24),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calculate,
                          color: Color(0xFFDFC17B),
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '1 Aylık Toplam',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B3B24),
                            ),
                          ),
                          Text(
                            '${result.monthlyNamaz.toInt()} + ${result.monthlyOruc.toInt()} + ${result.monthlyYemin.toInt()} = ${CurrencyFormatter.formatTL(result.monthlyTotal)}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0B3B24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Üst Başlık Şeridi
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF0B3B24),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFC5A059), width: 1.0),
          ),
          child: const Text(
            '1 Aylık Esas Hesap',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubCalcColumn({
    required IconData icon,
    required String title,
    required String formula,
    required String total,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFC5A059).withValues(alpha: 0.6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Color(0xFF0B3B24),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFDFC17B), size: 15),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B1B1B),
                height: 1.15,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formula,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF555555),
              ),
            ),
          ),
          const SizedBox(height: 1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              total,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0B3B24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// GENEL TOPLAM Bandı (Yan tezhip kanat süslemeleri ile)
  Widget _buildGrandTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Sol kanat süslemesi
        _buildSideArabesqueFlourish(isLeft: true),

        // Orta Yeşil Tabela
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF072B19),
                  Color(0xFF0D4428),
                  Color(0xFF072B19),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC5A059), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GENEL TOPLAM',
                  style: TextStyle(
                    color: Color(0xFFDFC17B),
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${result.totalMonths} × ${CurrencyFormatter.formatTL(result.monthlyTotal)} = ${CurrencyFormatter.formatTL(result.grandTotal)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Sağ kanat süslemesi
        _buildSideArabesqueFlourish(isLeft: false),
      ],
    );
  }

  /// Devir Dağılımı Tablosu
  Widget _buildDevirSection() {
    final dist = result.devirDistribution;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars, size: 12, color: Color(0xFFC5A059)),
            const SizedBox(width: 6),
            Text(
              '${input.personCount} Kişi ile Devir Dağılımı',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0B3B24),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.stars, size: 12, color: Color(0xFFC5A059)),
          ],
        ),
        const SizedBox(height: 5),

        // Tablo
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0B3B24), width: 0.9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Table(
              border: TableBorder.all(
                color: const Color(0xFF0B3B24).withValues(alpha: 0.3),
                width: 0.7,
              ),
              columnWidths: const {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(2.2),
                2: FlexColumnWidth(2.6),
                3: FlexColumnWidth(2.5),
              },
              children: [
                // Başlık Satırı
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0B3B24),
                  ),
                  children: [
                    _buildTableHeaderCell('Kişi Grubu'),
                    _buildTableHeaderCell('Kişi Sayısı'),
                    _buildTableHeaderCell('Kişi Başı Devir'),
                    _buildTableHeaderCell('Toplam Devir'),
                  ],
                ),
                // Veri Satırları
                for (final g in dist.groups)
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.white),
                    children: [
                      _buildTableCell(g.groupName),
                      _buildTableCell('${g.personCount} kişi'),
                      _buildTableCell('${g.roundsPerPerson} defa'),
                      _buildTableCell('${g.totalRounds}', isBold: true),
                    ],
                  ),
                // Toplam Satırı
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFEFE8D6)),
                  children: [
                    _buildTableCell('Toplam', isBold: true),
                    _buildTableCell('${dist.totalPeople} kişi', isBold: true),
                    _buildTableCell('—'),
                    _buildTableCell(
                      '${dist.grandTotalRounds}',
                      isBold: true,
                      color: const Color(0xFF0B3B24),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.5, horizontal: 3),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? const Color(0xFF222222),
          ),
        ),
      ),
    );
  }

  /// Dipnot Kutusu
  Widget _buildFooterNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7EE),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF0B3B24).withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(3.5),
            decoration: const BoxDecoration(
              color: Color(0xFF0B3B24),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Not: Bu görsel, konuşmadaki devirli hesaplama şekline göre hazırlanmış örnek hesap afişidir. Dini hüküm ve uygulama usulü için ehil bir din görevlisine danışılabilir.',
              style: TextStyle(
                fontSize: 8.5,
                color: Color(0xFF333333),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dört köşe için altın ve yeşil tezhip süsleme motifi
  Widget _buildCornerOrnament(int cornerIndex) {
    return SizedBox(
      width: 38,
      height: 38,
      child: CustomPaint(
        painter: _CornerArabesquePainter(cornerIndex: cornerIndex),
      ),
    );
  }

  /// Genel Toplam bandının yanlarındaki tezhip kanatları
  Widget _buildSideArabesqueFlourish({required bool isLeft}) {
    return SizedBox(
      width: 24,
      height: 44,
      child: CustomPaint(
        painter: _SideArabesquePainter(isLeft: isLeft),
      ),
    );
  }
}

/// Dört köşedeki altın tezhip arabesk köşe süslemesini çizen ressam
class _CornerArabesquePainter extends CustomPainter {
  final int cornerIndex; // 0: Top-Left, 1: Top-Right, 2: Bottom-Left, 3: Bottom-Right

  _CornerArabesquePainter({required this.cornerIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = const Color(0xFFC5A059)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final greenFill = Paint()
      ..color = const Color(0xFF0B3B24)
      ..style = PaintingStyle.fill;

    canvas.save();

    // Köşe yönlendirmesi
    if (cornerIndex == 1) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    } else if (cornerIndex == 2) {
      canvas.translate(0, size.height);
      canvas.scale(1, -1);
    } else if (cornerIndex == 3) {
      canvas.translate(size.width, size.height);
      canvas.scale(-1, -1);
    }

    // Dış palmet konturu
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(32, 0);
    path.quadraticBezierTo(20, 4, 12, 12);
    path.quadraticBezierTo(4, 20, 0, 32);
    path.close();
    canvas.drawPath(path, goldPaint);

    // İç koyu yeşil yaprak motifi
    final innerPath = Path();
    innerPath.moveTo(4, 4);
    innerPath.lineTo(18, 4);
    innerPath.quadraticBezierTo(10, 8, 4, 18);
    innerPath.close();
    canvas.drawPath(innerPath, greenFill);

    // Küçük altın nokta
    canvas.drawCircle(
      const Offset(8, 8),
      1.5,
      Paint()..color = const Color(0xFFC5A059),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Genel Toplam kutusu yanlarındaki tezhip kanat ressamı
class _SideArabesquePainter extends CustomPainter {
  final bool isLeft;

  _SideArabesquePainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = const Color(0xFFC5A059)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final greenFill = Paint()
      ..color = const Color(0xFF0B3B24)
      ..style = PaintingStyle.fill;

    canvas.save();
    if (!isLeft) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }

    final path = Path();
    path.moveTo(size.width, size.height * 0.2);
    path.quadraticBezierTo(0, size.height * 0.3, 0, size.height * 0.5);
    path.quadraticBezierTo(0, size.height * 0.7, size.width, size.height * 0.8);
    path.close();

    canvas.drawPath(path, greenFill);
    canvas.drawPath(path, goldPaint);

    // İç minik altın motif
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.5),
      2.0,
      Paint()..color = const Color(0xFFDFC17B),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Arka plan hafif İslami geometrik yıldız / filigran deseni ressamı
class _IslamicGeometricBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final faintGold = Paint()
      ..color = const Color(0xFFC5A059).withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const double step = 60.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        _drawEightPointStar(canvas, Offset(x, y), 18, faintGold);
      }
    }
  }

  void _drawEightPointStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const int points = 8;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final double r = (i % 2 == 0) ? radius : radius * 0.55;
      final double angle = i * math.pi / points;
      final double x = center.dx + r * math.cos(angle);
      final double y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
