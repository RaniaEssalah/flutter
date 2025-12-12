import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:aquatrack/models/reminder_settings.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationService._init();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to home screen
  }

  Future<bool> requestPermissions() async {
    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  Future<void> scheduleReminders(ReminderSettings settings) async {
    await cancelAllReminders();

    if (!settings.isEnabled) {
      return;
    }

    final now = DateTime.now();
    final startMinutes = settings.startTime.hour * 60 + settings.startTime.minute;
    final endMinutes = settings.endTime.hour * 60 + settings.endTime.minute;

    int notificationId = 0;

    for (int day = 1; day <= 7; day++) {
      if (!settings.selectedDays.contains(day)) continue;

      int currentMinutes = startMinutes;

      while (currentMinutes < endMinutes) {
        final hour = currentMinutes ~/ 60;
        final minute = currentMinutes % 60;

        final scheduledDate = _nextInstanceOfDayAndTime(
          day,
          hour,
          minute,
        );

        if (scheduledDate.isAfter(now)) {
          await _scheduleNotification(
            notificationId++,
            scheduledDate,
          );
        }

        currentMinutes += settings.intervalMinutes;
      }
    }
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(int day, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Adjust to the correct day of week
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // If the scheduled time has passed, move to next week
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  Future<void> _scheduleNotification(int id, tz.TZDateTime scheduledDate) async {
    const androidDetails = AndroidNotificationDetails(
      'water_reminder',
      'Water Reminders',
      channelDescription: 'Reminders to drink water',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final messages = [
      'Time to hydrate! 💧',
      'Don\'t forget to drink water! 💦',
      'Stay hydrated! 🌊',
      'Water break time! 💙',
      'Your body needs water! 💧',
      'Drink up! Stay healthy! 💦',
      'Hydration reminder! 🌊',
      'Time for a water break! 💙',
    ];

    final message = messages[id % messages.length];

    await _notifications.zonedSchedule(
      id,
      'AquaTrack',
      message,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> showInstantReminder() async {
    const androidDetails = AndroidNotificationDetails(
      'water_reminder',
      'Water Reminders',
      channelDescription: 'Reminders to drink water',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999,
      'AquaTrack',
      'Time to hydrate! 💧',
      notificationDetails,
    );
  }

  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}

