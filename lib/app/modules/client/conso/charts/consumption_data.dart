class ConsumptionData {
  final String periode;
  final double valeur;
  final String unite;
  final DateTime date;
  final String? deviceId;
  final Map<String, dynamic>? metadata;

  ConsumptionData({
    required this.periode,
    required this.valeur,
    required this.unite,
    required this.date,
    this.deviceId,
    this.metadata,
  });

  // ✅ Pour le futur backend
  factory ConsumptionData.fromJson(Map<String, dynamic> json) {
    return ConsumptionData(
      periode: json['periode'] ?? '',
      valeur: (json['valeur'] ?? 0.0).toDouble(),
      unite: json['unite'] ?? 'kg',
      date: DateTime.parse(json['date']),
      deviceId: json['deviceId'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periode': periode,
      'valeur': valeur,
      'unite': unite,
      'date': date.toIso8601String(),
      'deviceId': deviceId,
      'metadata': metadata,
    };
  }
}

class ConsumptionPeriod {
  final String label;
  final int jours;
  final bool isSelected;

  ConsumptionPeriod({
    required this.label,
    required this.jours,
    this.isSelected = false,
  });
}
