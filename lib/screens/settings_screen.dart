import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aquatrack/core/theme/app_colors.dart';
import 'package:aquatrack/services/preferences_service.dart';
import 'package:aquatrack/services/notification_service.dart';
import 'package:aquatrack/models/reminder_settings.dart';
import 'package:aquatrack/providers/water_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final PreferencesService _prefs = PreferencesService.instance;
  final NotificationService _notifications = NotificationService.instance;

  int _dailyGoalMl = 2500;
  ReminderSettings _reminderSettings = ReminderSettings.defaultSettings();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final goal = await _prefs.getDailyGoal();
      final reminders = await _prefs.getReminderSettings();

      setState(() {
        _dailyGoalMl = goal.goalMl;
        _reminderSettings = reminders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateDailyGoal(int newGoal) async {
    await _prefs.setDailyGoal(newGoal);
    await ref.read(waterProvider.notifier).updateDailyGoal(newGoal);
    setState(() {
      _dailyGoalMl = newGoal;
    });
  }

  Future<void> _updateReminderSettings(ReminderSettings settings) async {
    await _prefs.setReminderSettings(settings);
    await _notifications.scheduleReminders(settings);
    setState(() {
      _reminderSettings = settings;
    });
  }

  void _showGoalDialog() {
    final controller = TextEditingController(
      text: (_dailyGoalMl / 1000).toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Daily Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Goal (Liters)',
                hintText: 'e.g., 2.5',
                suffixText: 'L',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Recommended: 2-3 liters per day',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final liters = double.tryParse(controller.text);
              if (liters != null && liters > 0 && liters <= 10) {
                final ml = (liters * 1000).toInt();
                _updateDailyGoal(ml);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Daily goal updated!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid goal (0.1-10 liters)'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showIntervalDialog() {
    int selectedMinutes = _reminderSettings.intervalMinutes;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder Interval'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: const Text('Every 30 minutes'),
              value: 30,
              groupValue: selectedMinutes,
              onChanged: (value) {
                if (value != null) {
                  selectedMinutes = value;
                  Navigator.pop(context);
                  _updateReminderSettings(
                    _reminderSettings.copyWith(intervalMinutes: value),
                  );
                }
              },
            ),
            RadioListTile<int>(
              title: const Text('Every hour'),
              value: 60,
              groupValue: selectedMinutes,
              onChanged: (value) {
                if (value != null) {
                  selectedMinutes = value;
                  Navigator.pop(context);
                  _updateReminderSettings(
                    _reminderSettings.copyWith(intervalMinutes: value),
                  );
                }
              },
            ),
            RadioListTile<int>(
              title: const Text('Every 2 hours'),
              value: 120,
              groupValue: selectedMinutes,
              onChanged: (value) {
                if (value != null) {
                  selectedMinutes = value;
                  Navigator.pop(context);
                  _updateReminderSettings(
                    _reminderSettings.copyWith(intervalMinutes: value),
                  );
                }
              },
            ),
            RadioListTile<int>(
              title: const Text('Every 3 hours'),
              value: 180,
              groupValue: selectedMinutes,
              onChanged: (value) {
                if (value != null) {
                  selectedMinutes = value;
                  Navigator.pop(context);
                  _updateReminderSettings(
                    _reminderSettings.copyWith(intervalMinutes: value),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildGoalSection(),
              const SizedBox(height: 24),
              _buildReminderSection(),
              const SizedBox(height: 24),
              _buildAboutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Settings',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildGoalSection() {
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
          const Row(
            children: [
              Icon(Icons.flag, color: AppColors.primary, size: 24),
              SizedBox(width: 12),
              Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Daily Water Goal'),
            subtitle: Text('${(_dailyGoalMl / 1000).toStringAsFixed(1)} liters'),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
            onTap: _showGoalDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSection() {
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
          const Row(
            children: [
              Icon(Icons.notifications, color: AppColors.primary, size: 24),
              SizedBox(width: 12),
              Text(
                'Reminders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Enable Reminders'),
            subtitle: const Text('Get notified to drink water'),
            value: _reminderSettings.isEnabled,
            activeColor: AppColors.primary,
            onChanged: (value) async {
              if (value) {
                final granted = await _notifications.requestPermissions();
                if (!granted) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification permission denied'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                  return;
                }
              }
              _updateReminderSettings(
                _reminderSettings.copyWith(isEnabled: value),
              );
            },
          ),
          if (_reminderSettings.isEnabled) ...[
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reminder Interval'),
              subtitle: Text(_getIntervalText(_reminderSettings.intervalMinutes)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
              onTap: _showIntervalDialog,
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active Hours'),
              subtitle: Text(
                '${_reminderSettings.startTime} - ${_reminderSettings.endTime}',
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Time picker coming soon!'),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  String _getIntervalText(int minutes) {
    if (minutes < 60) {
      return 'Every $minutes minutes';
    } else {
      final hours = minutes ~/ 60;
      return 'Every $hours ${hours == 1 ? 'hour' : 'hours'}';
    }
  }

  Widget _buildAboutSection() {
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
          const Row(
            children: [
              Icon(Icons.info, color: AppColors.primary, size: 24),
              SizedBox(width: 12),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('About AquaTrack'),
            subtitle: const Text('Your daily water intake companion'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'AquaTrack',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.water_drop,
                  size: 48,
                  color: AppColors.primary,
                ),
                children: const [
                  Text(
                    'AquaTrack helps you stay hydrated by tracking your daily water intake and sending helpful reminders.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

