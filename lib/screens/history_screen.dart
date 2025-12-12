import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aquatrack/core/theme/app_colors.dart';
import 'package:aquatrack/services/database_service.dart';
import 'package:aquatrack/services/preferences_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final DatabaseService _db = DatabaseService.instance;
  final PreferencesService _prefs = PreferencesService.instance;
  
  Map<String, int> _dailyTotals = {};
  int _goalMl = 2500;
  bool _isLoading = true;
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final goal = await _prefs.getDailyGoal();
      final startDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
      final endDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
      
      final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
      final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);
      
      final totals = await _db.getDailyTotalsInRange(startDateStr, endDateStr);

      setState(() {
        _goalMl = goal.goalMl;
        _dailyTotals = totals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
    _loadData();
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
    _loadData();
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
                    children: [
                      _buildCalendar(),
                      const SizedBox(height: 24),
                      _buildLegend(),
                      const SizedBox(height: 24),
                      _buildMonthStats(),
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
    final monthStr = DateFormat('MMMM yyyy').format(_selectedMonth);
    final canGoNext = _selectedMonth.isBefore(
      DateTime(DateTime.now().year, DateTime.now().month),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'History',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left),
                color: AppColors.primary,
              ),
              SizedBox(
                width: 140,
                child: Text(
                  monthStr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: canGoNext ? _nextMonth : null,
                icon: const Icon(Icons.chevron_right),
                color: canGoNext ? AppColors.primary : AppColors.textHint,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday;

    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          _buildWeekdayHeaders(),
          const SizedBox(height: 12),
          _buildCalendarGrid(daysInMonth, startWeekday),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return SizedBox(
          width: 40,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(int daysInMonth, int startWeekday) {
    final List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 1; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 40));
    }

    // Add cells for each day of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final total = _dailyTotals[dateStr] ?? 0;
      final progress = total / _goalMl;

      dayWidgets.add(_buildDayCell(day, progress, date));
    }

    // Build rows
    final rows = <Widget>[];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      final end = (i + 7 < dayWidgets.length) ? i + 7 : dayWidgets.length;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayWidgets.sublist(i, end),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(int day, double progress, DateTime date) {
    final isToday = DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    final isFuture = date.isAfter(DateTime.now());

    Color cellColor;
    if (isFuture) {
      cellColor = AppColors.cardBackground;
    } else if (progress >= 1.0) {
      cellColor = AppColors.progressFilled;
    } else if (progress >= 0.75) {
      cellColor = AppColors.primaryLight;
    } else if (progress >= 0.5) {
      cellColor = AppColors.accent.withOpacity(0.5);
    } else if (progress > 0) {
      cellColor = AppColors.progressEmpty;
    } else {
      cellColor = Colors.grey.shade200;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
            color: (progress >= 0.5 && !isFuture)
                ? Colors.white
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem(Colors.grey.shade200, 'No data'),
              _buildLegendItem(AppColors.progressEmpty, '< 50%'),
              _buildLegendItem(
                AppColors.accent.withOpacity(0.5),
                '50-75%',
              ),
              _buildLegendItem(AppColors.primaryLight, '75-100%'),
              _buildLegendItem(AppColors.progressFilled, '100%+'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthStats() {
    final daysWithData = _dailyTotals.length;
    final totalMl = _dailyTotals.values.fold(0, (sum, val) => sum + val);
    final averageMl = daysWithData > 0 ? totalMl ~/ daysWithData : 0;
    final daysMetGoal = _dailyTotals.values.where((v) => v >= _goalMl).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.waterGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Month Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Days Tracked', '$daysWithData'),
              _buildStatItem('Goal Met', '$daysMetGoal'),
              _buildStatItem('Avg/Day', '${(averageMl / 1000).toStringAsFixed(1)}L'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

