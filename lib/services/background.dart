import 'dart:developer';
import 'dart:ui';

import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/services/alert_store.dart';
import 'package:bweather/services/alerts.dart';
import 'package:bweather/services/home_widget_service.dart';
import 'package:bweather/services/trip_reminders.dart';
import 'package:bweather/utils/weather_codes.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/services/notification_service.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workmanager/workmanager.dart';

/// Unique name of the periodic background refresh (alerts + home-screen widget).
const alertTaskUniqueName = "bweather-alerts";
const alertTaskName = "bweather.alertCheck";

/// Entry point of the background isolate (must be top-level).
@pragma('vm:entry-point')
void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) => runBackgroundRefresh());
}

/// Fetches a fresh forecast for the saved target, refreshes the home-screen
/// widget and posts any due alerts. Returns true so the OS doesn't retry: a
/// failed run simply waits for the next hour.
Future<bool> runBackgroundRefresh({ ForecastRepository? repository, NotificationService? notifications, HomeWidgetService? widget, AlertStore? store, DateTime? now }) async {
    store ??= AlertStore();
    try {
        final target = await store.readTarget();
        if (target == null || !target.needsRefresh) return true;

        final l10n = _localizations(target.languageCode);
        await initializeDateFormatting(dateLocale(l10n.localeName));
        final time = now ?? DateTime.now();
        repository ??= ForecastRepository();
        notifications ??= NotificationService();

        await _sendTripReminders(target, store: store, repository: repository, notifications: notifications, l10n: l10n, now: time);
        if (!target.needsPlaceForecast) return true;

        final city = await repository.getWeather(target.city, units: target.units);
        final forecast = city.forecast;
        if (forecast == null) return true;

        if (target.widgetEnabled) {
            await (widget ?? HomeWidgetService()).update(WeatherWidgetData.from(
                city: city, forecast: forecast, l10n: l10n, locale: l10n.localeName, updatedAt: time,
            ));
        }

        if (!target.prefs.anyEnabled) return true;

        final (alerts, updatedLog) = AlertEvaluator.evaluate(
            forecast: forecast,
            prefs: target.prefs,
            log: await store.readLog(),
            place: target.city.name,
            l10n: l10n,
            locale: l10n.localeName,
            now: time,
        );

        for (final alert in alerts) {
            await notifications.show(alert, l10n);
        }
        await store.writeLog(updatedLog);
    } catch (error, stack) {
        log("Background refresh failed", error: error, stackTrace: stack);
    }
    return true;
}

/// Posts the pre-trip reminders that are due and not sent yet. A failed
/// forecast still sends the reminder, with a generic line.
Future<void> _sendTripReminders(AlertTarget target, { required AlertStore store, required ForecastRepository repository, required NotificationService notifications, required AppLocalizations l10n, required DateTime now }) async {
    if (target.reminders.isEmpty) {
        await store.writeSentReminders(const {});
        return;
    }
    final sent = await store.readSentReminders();
    for (final reminder in target.reminders) {
        if (sent.contains(reminder.id) || !reminder.isDue(now)) continue;
        await notifications.showTripReminder(
            key: reminder.id,
            title: l10n.tripReminderTitle(reminder.city.name),
            body: await _reminderBody(reminder, repository: repository, units: target.units, l10n: l10n),
            l10n: l10n,
        );
        sent.add(reminder.id);
    }
    // Forget reminders for trips that were deleted, moved or turned off.
    final current = {for (final reminder in target.reminders) reminder.id};
    await store.writeSentReminders(sent.intersection(current));
}

Future<String> _reminderBody(TripReminder reminder, { required ForecastRepository repository, required Units units, required AppLocalizations l10n }) async {
    try {
        final days = await repository.dailyForecast(reminder.city, start: reminder.departure, end: reminder.departure, units: units);
        if (days.isNotEmpty) {
            final day = days.first;
            return l10n.briefBody(
                WeatherCode.decode(code: day.weatherCode, isNight: false).describe(l10n),
                "${roundTemp(day.temperatureMin.value)}${day.temperatureMin.unit}",
                "${roundTemp(day.temperatureMax.value)}${day.temperatureMax.unit}",
                day.precipitationProbabilityMax?.value ?? 0,
            );
        }
    } catch (error) {
        log("Trip reminder forecast failed", error: error);
    }
    return l10n.tripReminderBodyFallback;
}

AppLocalizations _localizations(String languageCode) {
    final code = languageCode.isNotEmpty ? languageCode : PlatformDispatcher.instance.locale.languageCode;
    final supported = AppLocalizations.supportedLocales.any((locale) => locale.languageCode == code);
    return lookupAppLocalizations(Locale(supported ? code : "en"));
}
