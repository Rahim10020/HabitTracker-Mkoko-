import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Wraps flutter_local_notifications for per-habit reminders.
///
/// Each habit gets up to 7 scheduled notifications (one per scheduled
/// weekday), recurring weekly, at the habit's `reminderTime`. IDs are
/// derived from the habit id so they can be looked up and cancelled
/// without keeping a separate map: `habitId * 10 + isoWeekday` (1..7).
/// This caps habit ids this scheme supports cleanly at ~200M, which is
/// not a real constraint for a local sqlite autoincrement id.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    try {
      final localZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localZone.identifier));
    } catch (_) {
      // fall back to UTC if the platform's zone name can't be resolved
      // for some reason; wall-clock scheduling below still uses
      // tz.local, so this keeps notifications firing at a consistent
      // (if not locally-adjusted) time rather than failing outright.
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
    _initialized = true;
  }

  /// Requests notification permission (Android 13+ / iOS). Call this
  /// right before the user turns a reminder on, not at app startup, so
  /// the system prompt has context.
  Future<bool> requestPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? true; // pre-Android-13 has no runtime prompt
    }

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
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

  /// Schedules a weekly-recurring reminder for [habitId]/[habitName] at
  /// [time], on each ISO weekday in [scheduledDays] (1=Mon..7=Sun).
  /// Replaces any previously scheduled reminder for this habit.
  Future<void> scheduleHabitReminder({
    required int habitId,
    required String habitName,
    required List<int> scheduledDays,
    required int hour,
    required int minute,
  }) async {
    await cancelHabitReminder(habitId);

    for (final isoWeekday in scheduledDays) {
      final scheduledDate =
          _nextInstanceOfWeekdayTime(isoWeekday, hour, minute);
      await _plugin.zonedSchedule(
        _notificationId(habitId, isoWeekday),
        'Rappel d\'habitude',
        habitName,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_reminders',
            'Rappels d\'habitudes',
            channelDescription:
                'Notifications de rappel pour vos habitudes',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        // avoids requiring the separate "exact alarm" permission on
        // Android 12+; a habit reminder doesn't need to-the-second
        // precision.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> cancelHabitReminder(int habitId) async {
    for (var isoWeekday = 1; isoWeekday <= 7; isoWeekday++) {
      await _plugin.cancel(_notificationId(habitId, isoWeekday));
    }
  }

  int _notificationId(int habitId, int isoWeekday) =>
      habitId * 10 + isoWeekday;

  tz.TZDateTime _nextInstanceOfWeekdayTime(
      int isoWeekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != isoWeekday || !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
