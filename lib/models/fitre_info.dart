/// Fitre / Günlük Fidye bilgi modeli.
class FitreInfo {
  final int year;
  final double amount;
  final String source;
  final String? sourceUrl;
  final DateTime fetchedAt;
  final bool isManual;

  const FitreInfo({
    required this.year,
    required this.amount,
    required this.source,
    this.sourceUrl,
    required this.fetchedAt,
    required this.isManual,
  });

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'amount': amount,
      'source': source,
      'sourceUrl': sourceUrl,
      'fetchedAt': fetchedAt.toIso8601String(),
      'isManual': isManual,
    };
  }

  factory FitreInfo.fromJson(Map<String, dynamic> json) {
    return FitreInfo(
      year: json['year'] as int,
      amount: (json['amount'] as num).toDouble(),
      source: json['source'] as String? ?? 'Bilinmiyor',
      sourceUrl: json['sourceUrl'] as String?,
      fetchedAt: json['fetchedAt'] != null
          ? DateTime.tryParse(json['fetchedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      isManual: json['isManual'] as bool? ?? false,
    );
  }

  FitreInfo copyWith({
    int? year,
    double? amount,
    String? source,
    String? sourceUrl,
    DateTime? fetchedAt,
    bool? isManual,
  }) {
    return FitreInfo(
      year: year ?? this.year,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      isManual: isManual ?? this.isManual,
    );
  }

  @override
  String toString() {
    return 'FitreInfo(year: $year, amount: $amount, source: $source, isManual: $isManual)';
  }
}
