class WaterIntake {
  final String id;
  final DateTime timestamp;
  final int amountMl;
  final String date; // Format: yyyy-MM-dd

  WaterIntake({
    required this.id,
    required this.timestamp,
    required this.amountMl,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'amountMl': amountMl,
      'date': date,
    };
  }

  factory WaterIntake.fromMap(Map<String, dynamic> map) {
    return WaterIntake(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      amountMl: map['amountMl'] as int,
      date: map['date'] as String,
    );
  }

  WaterIntake copyWith({
    String? id,
    DateTime? timestamp,
    int? amountMl,
    String? date,
  }) {
    return WaterIntake(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      amountMl: amountMl ?? this.amountMl,
      date: date ?? this.date,
    );
  }
}

