package com.bsoft.bweather

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home-screen widget: current conditions for the user's location (or first saved city).
 *
 * The app and the hourly background refresh write plain strings with
 * `HomeWidget.saveWidgetData` (see lib/services/home_widget_service.dart);
 * this provider only draws them.
 */
class WeatherWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.weather_widget).apply {
                val place = widgetData.getString("place", null)
                if (place == null) {
                    // Nothing saved yet: invite the user to open the app once.
                    setTextViewText(R.id.widget_place, context.getString(R.string.widget_open_app))
                    setTextViewText(R.id.widget_temperature, "--°")
                    setTextViewText(R.id.widget_emoji, "🌤️")
                    setTextViewText(R.id.widget_condition, "")
                    setTextViewText(R.id.widget_range, "")
                    setTextViewText(R.id.widget_updated, "")
                } else {
                    setTextViewText(R.id.widget_place, place)
                    setTextViewText(R.id.widget_temperature, widgetData.getString("temperature", "--°"))
                    setTextViewText(R.id.widget_emoji, widgetData.getString("emoji", ""))
                    setTextViewText(R.id.widget_condition, widgetData.getString("condition", ""))
                    setTextViewText(R.id.widget_range, widgetData.getString("range", ""))
                    setTextViewText(R.id.widget_updated, widgetData.getString("updated", ""))
                }

                // Tapping the widget opens the app.
                setOnClickPendingIntent(
                    R.id.widget_container,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
