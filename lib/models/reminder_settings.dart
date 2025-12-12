class ReminderSettings {
  final bool isEnabled;
  final int intervalMinutes;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<int> selectedDays; // 1-7 (Monday-Sunday)

  ReminderSettings({
    required this.isEnabled,
    required this.intervalMinutes,
    required this.startTime,
    required this.endTime,
    required this.selectedDays,
  });

  Map<String, dynamic> toMap() {
    return {
      'isEnabled': isEnabled,
      'intervalMinutes': intervalMinutes,
      'startTimeHour': startTime.hour,
      'startTimeMinute': startTime.minute,
      'endTimeHour': endTime.hour,
      'endTimeMinute': endTime.minute,
      'selectedDays': selectedDays.join(','),
    };
  }

  factory ReminderSettings.fromMap(Map<String, dynamic> map) {
    return ReminderSettings(
      isEnabled: map['isEnabled'] as bool,
      intervalMinutes: map['intervalMinutes'] as int,
      startTime: TimeOfDay(
        hour: map['startTimeHour'] as int,
        minute: map['startTimeMinute'] as int,
      ),
      endTime: TimeOfDay(
        hour: map['endTimeHour'] as int,
        minute: map['endTimeMinute'] as int,
      ),
      selectedDays: (map['selectedDays'] as String)
          .split(',')
          .map((e) => int.parse(e))
          .toList(),
    );
  }

  factory ReminderSettings.defaultSettings() {
    return ReminderSettings(
      isEnabled: true,
      intervalMinutes: 120, // 2 hours
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 22, minute: 0),
      selectedDays: [1, 2, 3, 4, 5, 6, 7], // All days
    );
  }

  ReminderSettings copyWith({
    bool? isEnabled,
    int? intervalMinutes,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<int>? selectedDays,
  }) {
    return ReminderSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      selectedDays: selectedDays ?? this.selectedDays,
    );
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

