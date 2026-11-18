import 'dart:developer';

import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/services/alerts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Thin wrapper around flutter_local_notifications. BWeather ships on Android
/// only; on other platforms (desktop builds) every call is a no-op.
class NotificationService {
    static bool get isSupported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    static const _forecastChannel = "forecast";
    static const _alertsChannel = "alerts";

    final FlutterLocalNotificationsPlugin _plugin;
    bool _initialized = false;

    NotificationService({ FlutterLocalNotificationsPlugin? plugin }): _plugin = plugin ?? FlutterLocalNotificationsPlugin();

    Future<void> init() async {
        if (!isSupported || _initialized) return;
        await _plugin.initialize(
            settings: const InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher")),
        );
        _initialized = true;
    }

    /// Asks for permission to post notifications. Returns true when granted.
    Future<bool> requestPermission() async {
        if (!isSupported) return false;
        await init();
        try {
            final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
            return await android?.requestNotificationsPermission() ?? false;
        } catch (error) {
            log("Notification permission request failed", error: error);
            return false;
        }
    }

    Future<void> show(PendingAlert alert, AppLocalizations l10n) async {
        if (!isSupported) return;
        await init();

        final isForecast = alert.kind == AlertKind.brief;
        final details = NotificationDetails(
            android: AndroidNotificationDetails(
                isForecast ? _forecastChannel : _alertsChannel,
                isForecast ? l10n.notifyChannelForecast : l10n.notifyChannelAlerts,
                importance: isForecast ? Importance.defaultImportance : Importance.high,
                priority: isForecast ? Priority.defaultPriority : Priority.high,
                styleInformation: BigTextStyleInformation(alert.body),
            ),
        );

        // One id per kind: a newer alert of the same kind replaces the older one.
        await _plugin.show(id: alert.kind.index, title: alert.title, body: alert.body, notificationDetails: details);
    }

    /// A pre-trip reminder. [key] identifies the trip so reminders for
    /// different trips don't replace each other.
    Future<void> showTripReminder({ required String key, required String title, required String body, required AppLocalizations l10n }) async {
        if (!isSupported) return;
        await init();
        final details = NotificationDetails(
            android: AndroidNotificationDetails(
                _forecastChannel, l10n.notifyChannelForecast,
                styleInformation: BigTextStyleInformation(body),
            ),
        );
        // Ids below 100 are used by the weather alerts.
        await _plugin.show(id: 100 + (key.hashCode & 0xFFFFF), title: title, body: body, notificationDetails: details);
    }
}
