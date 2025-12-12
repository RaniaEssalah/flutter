import 'package:shared_preferences/shared_preferences.dart';
import 'package:aquatrack/models/daily_goal.dart';
import 'package:aquatrack/models/reminder_settings.dart';
import 'package:aquatrack/models/achievement.dart';
import 'dart:convert';

class PreferencesService {
  static final PreferencesService instance = PreferencesService._init();
  SharedPreferences? _prefs;

  PreferencesService._init();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('PreferencesService not initialized');
    }
    return _prefs!;
  }

  // Daily Goal
  static const String _keyDailyGoal = 'daily_goal_ml';
  static const String _keyGoalUpdated = 'goal_last_updated';
  static const int _defaultGoalMl = 2500; // 2.5 liters

  Future<DailyGoal> getDailyGoal() async {
    final goalMl = prefs.getInt(_keyDailyGoal) ?? _defaultGoalMl;
    final updatedStr = prefs.getString(_keyGoalUpdated);
    final lastUpdated = updatedStr != null
        ? DateTime.parse(updatedStr)
        : DateTime.now();

    return DailyGoal(goalMl: goalMl, lastUpdated: lastUpdated);
  }

  Future<void> setDailyGoal(int goalMl) async {
    await prefs.setInt(_keyDailyGoal, goalMl);
    await prefs.setString(_keyGoalUpdated, DateTime.now().toIso8601String());
  }

  // Reminder Settings
  static const String _keyReminderEnabled = 'reminder_enabled';
  static const String _keyReminderInterval = 'reminder_interval';
  static const String _keyReminderStartHour = 'reminder_start_hour';
  static const String _keyReminderStartMinute = 'reminder_start_minute';
  static const String _keyReminderEndHour = 'reminder_end_hour';
  static const String _keyReminderEndMinute = 'reminder_end_minute';
  static const String _keyReminderDays = 'reminder_days';

  Future<ReminderSettings> getReminderSettings() async {
    final isEnabled = prefs.getBool(_keyReminderEnabled) ?? true;
    final intervalMinutes = prefs.getInt(_keyReminderInterval) ?? 120;
    final startHour = prefs.getInt(_keyReminderStartHour) ?? 8;
    final startMinute = prefs.getInt(_keyReminderStartMinute) ?? 0;
    final endHour = prefs.getInt(_keyReminderEndHour) ?? 22;
    final endMinute = prefs.getInt(_keyReminderEndMinute) ?? 0;
    final daysStr = prefs.getString(_keyReminderDays) ?? '1,2,3,4,5,6,7';

    return ReminderSettings(
      isEnabled: isEnabled,
      intervalMinutes: intervalMinutes,
      startTime: TimeOfDay(hour: startHour, minute: startMinute),
      endTime: TimeOfDay(hour: endHour, minute: endMinute),
      selectedDays: daysStr.split(',').map((e) => int.parse(e)).toList(),
    );
  }

  Future<void> setReminderSettings(ReminderSettings settings) async {
    await prefs.setBool(_keyReminderEnabled, settings.isEnabled);
    await prefs.setInt(_keyReminderInterval, settings.intervalMinutes);
    await prefs.setInt(_keyReminderStartHour, settings.startTime.hour);
    await prefs.setInt(_keyReminderStartMinute, settings.startTime.minute);
    await prefs.setInt(_keyReminderEndHour, settings.endTime.hour);
    await prefs.setInt(_keyReminderEndMinute, settings.endTime.minute);
    await prefs.setString(
      _keyReminderDays,
      settings.selectedDays.join(','),
    );
  }

  // Achievements
  static const String _keyAchievements = 'achievements';

  Future<List<Achievement>> getAchievements() async {
    final achievementsJson = prefs.getString(_keyAchievements);
    if (achievementsJson == null) {
      return Achievement.getDefaultAchievements();
    }

    final List<dynamic> decoded = json.decode(achievementsJson);
    return decoded.map((e) => Achievement.fromMap(e)).toList();
  }

  Future<void> saveAchievements(List<Achievement> achievements) async {
    final encoded = json.encode(
      achievements.map((e) => e.toMap()).toList(),
    );
    await prefs.setString(_keyAchievements, encoded);
  }

  Future<void> unlockAchievement(AchievementType type) async {
    final achievements = await getAchievements();
    final index = achievements.indexWhere((a) => a.type == type);
    
    if (index != -1 && !achievements[index].isUnlocked) {
      achievements[index] = achievements[index].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await saveAchievements(achievements);
    }
  }

  // First Launch
  static const String _keyFirstLaunch = 'first_launch';

  Future<bool> isFirstLaunch() async {
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  Future<void> setFirstLaunchComplete() async {
    await prefs.setBool(_keyFirstLaunch, false);
  }

  // User Profile (optional)
  static const String _keyUserName = 'user_name';
  static const String _keyUserWeight = 'user_weight';

  Future<String?> getUserName() async {
    return prefs.getString(_keyUserName);
  }

  Future<void> setUserName(String name) async {
    await prefs.setString(_keyUserName, name);
  }

  Future<double?> getUserWeight() async {
    return prefs.getDouble(_keyUserWeight);
  }

  Future<void> setUserWeight(double weight) async {
    await prefs.setDouble(_keyUserWeight, weight);
  }
}

