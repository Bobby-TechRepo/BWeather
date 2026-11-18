import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bweather/services/alerts.dart';
import 'package:bweather/services/trip_reminders.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:path_provider/path_provider.dart';

/// What the background refresh needs, written by the app whenever it changes.
///
/// Kept in its own small JSON file (not in hydrated_bloc's database) so the
/// background isolate never competes with the app for the same storage lock.
class AlertTarget {
    final City city;
    final Units units;

    /// "en", "fr", or "" to follow the device language.
    final String languageCode;
    final AlertPrefs prefs;

    /// Whether a home-screen widget is installed and should be refreshed too.
    final bool widgetEnabled;

    /// Pre-trip notifications still to come.
    final List<TripReminder> reminders;

    const AlertTarget({ required this.city, required this.units, required this.languageCode, required this.prefs, this.widgetEnabled = false, this.reminders = const [] });

    /// Whether the background task has anything to do.
    bool get needsRefresh => prefs.anyEnabled || widgetEnabled || reminders.isNotEmpty;

    /// Whether the saved place's forecast is needed (widget or weather alerts).
    bool get needsPlaceForecast => prefs.anyEnabled || widgetEnabled;

    factory AlertTarget.fromJson(Map<String, dynamic> json) => AlertTarget(
        city: City.fromJson(json["city"]),
        units: Units.fromJson(json["units"]),
        languageCode: (json["language"] ?? "").toString(),
        prefs: AlertPrefs.fromJson(json["prefs"]),
        widgetEnabled: json["widget"] == true,
        reminders: [
            for (final reminder in (json["reminders"] as List? ?? const []))
                TripReminder.fromJson(reminder),
        ],
    );

    Map<String, dynamic> toJson() => {
        // The forecast itself isn't needed: the background task fetches a fresh one.
        "city": City(name: city.name, country: city.country, region: city.region, latitude: city.latitude, longitude: city.longitude, elevation: city.elevation).toJson(),
        "units": units.toJson(),
        "language": languageCode,
        "prefs": prefs.toJson(),
        "widget": widgetEnabled,
        if (reminders.isNotEmpty) "reminders": reminders.map((reminder) => reminder.toJson()).toList(),
    };
}

class AlertStore {
    static const _targetFile = "alert_target.json";
    static const _logFile = "alert_log.json";
    static const _remindersFile = "trip_reminders_sent.json";

    Future<File> _file(String name) async {
        final directory = await getApplicationSupportDirectory();
        return File("${directory.path}${Platform.pathSeparator}$name");
    }

    Future<Map<String, dynamic>?> _read(String name) async {
        try {
            final file = await _file(name);
            if (!await file.exists()) return null;
            return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        } catch (error) {
            log("Couldn't read $name", error: error);
            return null;
        }
    }

    Future<void> _write(String name, Map<String, dynamic>? json) async {
        final file = await _file(name);
        if (json == null) {
            if (await file.exists()) await file.delete();
            return;
        }
        await file.writeAsString(jsonEncode(json), flush: true);
    }

    Future<AlertTarget?> readTarget() async {
        final json = await _read(_targetFile);
        if (json == null) return null;
        try {
            return AlertTarget.fromJson(json);
        } catch (error) {
            log("Invalid alert target", error: error);
            return null;
        }
    }

    Future<void> writeTarget(AlertTarget? target) => _write(_targetFile, target?.toJson());

    Future<AlertLog> readLog() async => AlertLog.fromJson(await _read(_logFile));

    Future<void> writeLog(AlertLog log) => _write(_logFile, log.toJson());

    /// Ids of trip reminders already shown.
    Future<Set<String>> readSentReminders() async {
        final json = await _read(_remindersFile);
        return {for (final id in (json?["sent"] as List? ?? const [])) id.toString()};
    }

    Future<void> writeSentReminders(Set<String> ids) => _write(_remindersFile, ids.isEmpty ? null : {"sent": ids.toList()});
}
