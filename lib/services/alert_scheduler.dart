import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/services/alert_store.dart';
import 'package:bweather/services/background.dart';
import 'package:bweather/services/home_widget_service.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/services/notification_service.dart';
import 'package:bweather/services/trip_reminders.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/settings_cubit.dart';
import 'package:bweather/states/trips/trips_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workmanager/workmanager.dart';

/// Keeps background work in sync with the app (Android only):
/// - pushes the latest forecast to the home-screen widget,
/// - writes the target (place, units, language, prefs) for the background isolate,
/// - registers the hourly background refresh when alerts are on, a widget
///   is installed or a trip reminder is set, and cancels it otherwise.
class AlertScheduler {
    static const checkFrequency = Duration(hours: 1);

    final SettingsCubit _settings;
    final WeatherCubit _weather;
    final TripsCubit? _trips;
    final AlertStore _store;
    final HomeWidgetService _widget;

    StreamSubscription<SettingsState>? _settingsSubscription;
    StreamSubscription<WeatherState>? _weatherSubscription;
    StreamSubscription<TripsState>? _tripsSubscription;
    AppLifecycleListener? _lifecycle;
    String? _lastWritten;
    bool? _registered;
    bool _widgetInstalled = false;

    AlertScheduler(this._settings, this._weather, { this._trips, AlertStore? store, HomeWidgetService? widget })
        : _store = store ?? AlertStore(), _widget = widget ?? HomeWidgetService();

    /// Call once from main(), before runApp.
    static Future<void> initializeBackground() async {
        if (!NotificationService.isSupported) return;
        try {
            await Workmanager().initialize(callbackDispatcher);
        } catch (error) {
            log("Background work unavailable", error: error);
        }
    }

    void start() {
        if (!NotificationService.isSupported) return;
        _settingsSubscription = _settings.stream.listen((_) => _sync());
        _weatherSubscription = _weather.stream.listen((_) => _sync());
        _tripsSubscription = _trips?.stream.listen((_) => _sync());
        // A widget may have been added while the app was in the background.
        _lifecycle = AppLifecycleListener(onResume: _checkWidgets);
        unawaited(_checkWidgets());
    }

    Future<void> dispose() async {
        _lifecycle?.dispose();
        await _settingsSubscription?.cancel();
        await _weatherSubscription?.cancel();
        await _tripsSubscription?.cancel();
    }

    Future<void> _checkWidgets() async {
        _widgetInstalled = await _widget.hasWidgets();
        await _sync();
    }

    Future<void> _sync() async {
        final settings = _settings.state;
        final places = _weather.state.places;
        // Alerts and the widget follow the user's location, or the first saved city.
        final place = places.isEmpty ? null : places.first;

        try {
            final forecast = place?.city.forecast;
            if (_widgetInstalled && place != null && forecast != null) {
                final l10n = _localizations(settings.languageCode);
                // This can run before MaterialApp has loaded the locale's date symbols.
                await initializeDateFormatting(dateLocale(l10n.localeName));
                await _widget.update(WeatherWidgetData.from(
                    city: place.city, forecast: forecast, l10n: l10n, locale: l10n.localeName,
                    updatedAt: place.updatedAt ?? DateTime.now(),
                ));
            }

            final target = place == null
                ? null
                : AlertTarget(
                    city: place.city, units: settings.units, languageCode: settings.languageCode,
                    prefs: settings.alerts, widgetEnabled: _widgetInstalled,
                    reminders: TripReminder.fromTrips(_trips?.state.trips ?? const []),
                );
            final active = (target != null && target.needsRefresh) ? target : null;
            final enabled = active != null;

            final encoded = active == null ? "" : jsonEncode(active.toJson());
            if (encoded != _lastWritten) {
                _lastWritten = encoded;
                await _store.writeTarget(active);
            }

            if (enabled && _registered != true) {
                _registered = true;
                await Workmanager().registerPeriodicTask(
                    alertTaskUniqueName,
                    alertTaskName,
                    frequency: checkFrequency,
                    constraints: Constraints(networkType: NetworkType.connected),
                    existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
                );
            } else if (!enabled && _registered != false) {
                _registered = false;
                await Workmanager().cancelByUniqueName(alertTaskUniqueName);
            }
        } catch (error) {
            log("Couldn't update background work", error: error);
        }
    }

    static AppLocalizations _localizations(String languageCode) {
        final code = languageCode.isNotEmpty ? languageCode : PlatformDispatcher.instance.locale.languageCode;
        final supported = AppLocalizations.supportedLocales.any((locale) => locale.languageCode == code);
        return lookupAppLocalizations(Locale(supported ? code : "en"));
    }
}
