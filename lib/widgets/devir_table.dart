import 'package:flutter/material.dart';
import '../models/devir_distribution.dart';
import '../utils/constants.dart';

/// Kişi sayısına göre devir dağılımını gösteren responsive tablo bileşeni.
class DevirTable extends StatelessWidget {
  final DevirDistribution distribution;

  const DevirTable({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.creamBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 320),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              AppConstants.primaryGreen.withValues(alpha: 0.08),
            ),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryGreen,
              fontSize: 13,
            ),
            dataTextStyle: const TextStyle(
              color: AppConstants.textDark,
              fontSize: 13,
            ),
            columnSpacing: 20,
            horizontalMargin: 16,
            columns: const [
              DataColumn(label: Text('Kişi Grubu')),
              DataColumn(label: Text('Kişi Sayısı'), numeric: true),
              DataColumn(label: Text('Kişi Başı Devir'), numeric: true),
              DataColumn(label: Text('Toplam Devir'), numeric: true),
            ],
            rows: [
              ...distribution.groups.map(
                (g) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        g.groupName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataCell(Text('${g.personCount} kişi')),
                    DataCell(Text('${g.roundsPerPerson} defa')),
                    DataCell(
                      Text(
                        '${g.totalRounds}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              // Genel Toplam Satırı
              DataRow(
                color: WidgetStateProperty.all(AppConstants.creamTint),
                cells: [
                  const DataCell(
                    Text(
                      'Toplam',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryGreen,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '${distribution.totalPeople} kişi',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const DataCell(
                    Text('—', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataCell(
                    Text(
                      '${distribution.grandTotalRounds}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
