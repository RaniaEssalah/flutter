import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aquatrack/models/water_intake.dart';
import 'package:aquatrack/models/daily_goal.dart';
import 'package:aquatrack/models/achievement.dart';
import 'package:aquatrack/services/database_service.dart';
import 'package:aquatrack/services/preferences_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final waterProvider = StateNotifierProvider<WaterNotifier, WaterState>((ref) {
  return WaterNotifier();
});

class WaterState {
  final List<WaterIntake> todayIntakes;
  final int todayTotal;
  final DailyGoal dailyGoal;
  final bool isLoading;
  final String? error;

  WaterState({
    required this.todayIntakes,
    required this.todayTotal,
    required this.dailyGoal,
    this.isLoading = false,
    this.error,
  });

  WaterState copyWith({
    List<WaterIntake>? todayIntakes,
    int? todayTotal,
    DailyGoal? dailyGoal,
    bool? isLoading,
    String? error,
  }) {
    return WaterState(
      todayIntakes: todayIntakes ?? this.todayIntakes,
      todayTotal: todayTotal ?? this.todayTotal,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  double get progress => todayTotal / dailyGoal.goalMl;
}

class WaterNotifier extends StateNotifier<WaterState> {
  final DatabaseService _db = DatabaseService.instance;
  final PreferencesService _prefs = PreferencesService.instance;
  final Uuid _uuid = const Uuid();

  WaterNotifier()
      : super(WaterState(
          todayIntakes: [],
          todayTotal: 0,
          dailyGoal: DailyGoal(
            goalMl: 2500,
            lastUpdated: DateTime.now(),
          ),
          isLoading: true,
        )) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _prefs.init();
      final goal = await _prefs.getDailyGoal();
      await loadTodayData();
      state = state.copyWith(dailyGoal: goal, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to initialize: $e',
        isLoading: false,
      );
    }
  }

  Future<void> loadTodayData() async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final intakes = await _db.getWaterIntakesByDate(today);
      final total = await _db.getTodayTotal(today);

      state = state.copyWith(
        todayIntakes: intakes,
        todayTotal: total,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to load data: $e');
    }
  }

  Future<void> addWaterIntake(int amountMl) async {
    try {
      final now = DateTime.now();
      final intake = WaterIntake(
        id: _uuid.v4(),
        timestamp: now,
        amountMl: amountMl,
        date: DateFormat('yyyy-MM-dd').format(now),
      );

      await _db.createWaterIntake(intake);
      await loadTodayData();

      // Check for achievements
      await _checkAchievements();
    } catch (e) {
      state = state.copyWith(error: 'Failed to add intake: $e');
    }
  }

  Future<void> deleteWaterIntake(String id) async {
    try {
      await _db.deleteWaterIntake(id);
      await loadTodayData();
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete intake: $e');
    }
  }

  Future<void> updateDailyGoal(int goalMl) async {
    try {
      await _prefs.setDailyGoal(goalMl);
      final goal = await _prefs.getDailyGoal();
      state = state.copyWith(dailyGoal: goal);
    } catch (e) {
      state = state.copyWith(error: 'Failed to update goal: $e');
    }
  }

  Future<void> _checkAchievements() async {
    try {
      // Check if first drop achievement should be unlocked
      if (state.todayIntakes.length == 1) {
        await _prefs.unlockAchievement(
          AchievementType.firstDrop,
        );
      }

      // Check if hydration hero (5L in a day)
      if (state.todayTotal >= 5000) {
        await _prefs.unlockAchievement(
          AchievementType.hydrationHero,
        );
      }

      // Check early bird (before 8 AM)
      final hasEarlyLog = state.todayIntakes.any(
        (intake) => intake.timestamp.hour < 8,
      );
      if (hasEarlyLog) {
        // Would need to track this over 5 days
        // Simplified for now
      }

      // Check night owl (after 10 PM and goal completed)
      if (state.progress >= 1.0) {
        final hasLateLog = state.todayIntakes.any(
          (intake) => intake.timestamp.hour >= 22,
        );
        if (hasLateLog) {
          await _prefs.unlockAchievement(
            AchievementType.nightOwl,
          );
        }
      }
    } catch (e) {
      // Silently fail achievement checks
    }
  }
}

