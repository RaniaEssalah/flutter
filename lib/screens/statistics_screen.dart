import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aquatrack/core/theme/app_colors.dart';
import 'package:aquatrack/services/database_service.dart';
import 'package:aquatrack/services/preferences_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  final DatabaseService _db = DatabaseService.instance;
  final PreferencesService _prefs = PreferencesService.instance;

  Map<String, int> _weeklyData = {};
  Map<String, int> _monthlyData = {};
  int _goalMl = 2500;
  bool _isLoading = true;
  String _selectedPeriod = 'week'; // 'week' or 'month'

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final goal = await _prefs.getDailyGoal();

      // Load last 7 days
      final weekStart = DateTime.now().subtract(const Duration(days: 6));
      final weekStartStr = DateFormat('yyyy-MM-dd').format(weekStart);
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final weekData = await _db.getDailyTotalsInRange(weekStartStr, todayStr);

      // Load last 30 days
      final monthStart = DateTime.now().subtract(const Duration(days: 29));
      final monthStartStr = DateFormat('yyyy-MM-dd').format(monthStart);
      final monthData = await _db.getDailyTotalsInRange(monthStartStr, todayStr);

      setState(() {
        _goalMl = goal.goalMl;
        _weeklyData = weekData;
        _monthlyData = monthData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPeriodSelector(),
                      const SizedBox(height: 24),
                      _buildChart(),
                      const SizedBox(height: 24),
                      _buildOverallStats(),
                      const SizedBox(height: 24),
                      _buildAchievements(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Row(
        children: [
          Text(
            'Statistics',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPeriodButton('Week', 'week'),
          ),
          Expanded(
            child: _buildPeriodButton('Month', 'month'),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, String value) {
    final isSelected = _selectedPeriod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    final data = _selectedPeriod == 'week' ? _weeklyData : _monthlyData;
    final days = _selectedPeriod == 'week' ? 7 : 30;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Intake (${_selectedPeriod == 'week' ? 'Last 7 Days' : 'Last 30 Days'})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: _buildBarChart(data, days),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<String, int> data, int days) {
    final now = DateTime.now();
    final spots = <BarChartGroupData>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final value = data[dateStr] ?? 0;
      final index = days - 1 - i;

      spots.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: value.toDouble(),
              color: value >= _goalMl
                  ? AppColors.progressFilled
                  : AppColors.primaryLight,
              width: _selectedPeriod == 'week' ? 24 : 8,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        maxY: (_goalMl * 1.5).toDouble(),
        minY: 0,
        barGroups: spots,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _goalMl.toDouble() / 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
              dashArray: value == _goalMl.toDouble() ? null : [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (_selectedPeriod == 'week') {
                  final date = now.subtract(Duration(days: 6 - value.toInt()));
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('E').format(date).substring(0, 1),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                } else {
                  // Show only every 5th day for month view
                  if (value.toInt() % 5 == 0) {
                    final date = now.subtract(Duration(days: 29 - value.toInt()));
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        DateFormat('d').format(date),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${(value / 1000).toStringAsFixed(0)}L',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final date = now.subtract(
                Duration(days: days - 1 - group.x.toInt()),
              );
              return BarTooltipItem(
                '${DateFormat('MMM d').format(date)}\n${(rod.toY / 1000).toStringAsFixed(1)}L',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStats() {
    final data = _selectedPeriod == 'week' ? _weeklyData : _monthlyData;
    final totalMl = data.values.fold(0, (sum, val) => sum + val);
    final daysWithData = data.length;
    final averageMl = daysWithData > 0 ? totalMl ~/ daysWithData : 0;
    final daysMetGoal = data.values.where((v) => v >= _goalMl).length;
    final maxMl = data.values.isEmpty ? 0 : data.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.waterGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatRow('Total Intake', '${(totalMl / 1000).toStringAsFixed(1)}L'),
          const SizedBox(height: 12),
          _buildStatRow('Daily Average', '${(averageMl / 1000).toStringAsFixed(1)}L'),
          const SizedBox(height: 12),
          _buildStatRow('Days Met Goal', '$daysMetGoal/${_selectedPeriod == 'week' ? 7 : 30}'),
          const SizedBox(height: 12),
          _buildStatRow('Best Day', '${(maxMl / 1000).toStringAsFixed(1)}L'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    return FutureBuilder(
      future: _prefs.getAchievements(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final achievements = snapshot.data!;
        final unlockedCount = achievements.where((a) => a.isUnlocked).length;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '$unlockedCount/${achievements.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...achievements.take(5).map((achievement) {
                return _buildAchievementItem(achievement);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementItem(achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement.isUnlocked
            ? AppColors.cardBackground
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            achievement.icon,
            style: TextStyle(
              fontSize: 32,
              color: achievement.isUnlocked ? null : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: achievement.isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                ),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: achievement.isUnlocked
                        ? AppColors.textSecondary
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          if (achievement.isUnlocked)
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 24,
            ),
        ],
      ),
    );
  }
}

