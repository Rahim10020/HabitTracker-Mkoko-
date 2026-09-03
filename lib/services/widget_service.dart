import 'package:home_widget/home_widget.dart';

/// One row in the widget's today list.
class TodayHabitStatus {
  final String name;
  final bool done;
  const TodayHabitStatus(this.name, this.done);
}

/// Pushes a lightweight, read-only summary of today's habits to the
/// Android home screen widget (android/.../HabitWidgetProvider.kt).
/// Android only — no iOS widget extension in this patch (that needs a
/// separate Xcode target, out of scope here).
class WidgetService {
  WidgetService._();
  static final WidgetService instance = WidgetService._();

  // must match the Kotlin class name in HabitWidgetProvider.kt
  static const _androidProviderName = 'HabitWidgetProvider';
  static const _maxRows = 5;

  Future<void> refresh({
    required int completedCount,
    required int totalCount,
    required List<TodayHabitStatus> todayHabits,
  }) async {
    try {
      final summary = totalCount == 0
          ? 'Aucune habitude aujourd\'hui'
          : '$completedCount/$totalCount habitudes aujourd\'hui';

      final rows = todayHabits
          .take(_maxRows)
          .map((h) => '${h.done ? '✓' : '○'} ${h.name}')
          .toList();
      // pad to a fixed row count so the native layout can just hide
      // unused rows rather than needing a dynamic list widget.
      while (rows.length < _maxRows) {
        rows.add('');
      }

      await Future.wait([
        HomeWidget.saveWidgetData<String>('summary_text', summary),
        for (var i = 0; i < _maxRows; i++)
          HomeWidget.saveWidgetData<String>('habit_row_$i', rows[i]),
      ]);
      await HomeWidget.updateWidget(androidName: _androidProviderName);
    } catch (_) {
      // no widget added to the home screen yet, running on a platform
      // without the plugin set up, etc. — never let this break the app.
    }
  }
}
