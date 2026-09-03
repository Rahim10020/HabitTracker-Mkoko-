package com.example.R_HabitTracker

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

// Read-only home screen widget: today's completion summary + up to 5
// scheduled habits with a done/not-done marker. Tapping anywhere on the
// widget opens the app (no in-widget interactivity — see patch notes).
// Data is written by WidgetService (lib/services/widget_service.dart)
// via HomeWidget.saveWidgetData, keyed "summary_text" and
// "habit_row_0".."habit_row_4".
class HabitWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val rowIds = intArrayOf(
            R.id.habit_row_0,
            R.id.habit_row_1,
            R.id.habit_row_2,
            R.id.habit_row_3,
            R.id.habit_row_4
        )

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.habit_widget_layout).apply {
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                setTextViewText(
                    R.id.widget_summary,
                    widgetData.getString("summary_text", "0/0 habitudes aujourd'hui")
                )

                rowIds.forEachIndexed { index, id ->
                    val text = widgetData.getString("habit_row_$index", "") ?: ""
                    setTextViewText(id, text)
                    setViewVisibility(id, if (text.isEmpty()) View.GONE else View.VISIBLE)
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
