class DailyGoal {
  final int goalMl;
  final DateTime lastUpdated;

  DailyGoal({
    required this.goalMl,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'goalMl': goalMl,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DailyGoal.fromMap(Map<String, dynamic> map) {
    return DailyGoal(
      goalMl: map['goalMl'] as int,
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
    );
  }

  DailyGoal copyWith({
    int? goalMl,
    DateTime? lastUpdated,
  }) {
    return DailyGoal(
      goalMl: goalMl ?? this.goalMl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

