import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/utils/weather_codes.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';

/// Which notifications the user opted into. Persisted with the settings.
class AlertPrefs extends Equatable {
    final bool morningBrief, rain, severe;

    /// Local hour (0–23) after which the morning briefing is sent.
    final int briefHour;

    const AlertPrefs({ this.morningBrief = false, this.rain = false, this.severe = false, this.briefHour = 7 });

    bool get anyEnabled => morningBrief || rain || severe;

    AlertPrefs copy({ bool? morningBrief, bool? rain, bool? severe, int? briefHour }) => AlertPrefs(
        morningBrief: morningBrief ?? this.morningBrief, rain: rain ?? this.rain,
        severe: severe ?? this.severe, briefHour: briefHour ?? this.briefHour,
    );

    factory AlertPrefs.fromJson(dynamic json) {
        if (json is! Map) return const AlertPrefs();
        final hour = int.tryParse(json["briefHour"].toString()) ?? 7;
        return AlertPrefs(
            morningBrief: json["morningBrief"] == true, rain: json["rain"] == true, severe: json["severe"] == true,
            briefHour: hour < 0 ? 0 : (hour > 23 ? 23 : hour),
        );
    }

    Map<String, dynamic> toJson() => { "morningBrief": morningBrief, "rain": rain, "severe": severe, "briefHour": briefHour };

    @override
    List<Object?> get props => [morningBrief, rain, severe, briefHour];
}

/// What has already been sent, so the hourly check doesn't repeat itself.
class AlertLog extends Equatable {
    /// "yyyy-mm-dd" (place-local) of the last morning briefing.
    final String? lastBriefDay;
    final DateTime? lastRainAlertAt, lastSevereAlertAt;

    const AlertLog({ this.lastBriefDay, this.lastRainAlertAt, this.lastSevereAlertAt });

    AlertLog copy({ String? lastBriefDay, DateTime? lastRainAlertAt, DateTime? lastSevereAlertAt }) => AlertLog(
        lastBriefDay: lastBriefDay ?? this.lastBriefDay,
        lastRainAlertAt: lastRainAlertAt ?? this.lastRainAlertAt,
        lastSevereAlertAt: lastSevereAlertAt ?? this.lastSevereAlertAt,
    );

    factory AlertLog.fromJson(dynamic json) {
        if (json is! Map) return const AlertLog();
        DateTime? date(String key) => json[key] == null ? null : DateTime.tryParse(json[key].toString());
        return AlertLog(lastBriefDay: json["lastBriefDay"]?.toString(), lastRainAlertAt: date("lastRainAlertAt"), lastSevereAlertAt: date("lastSevereAlertAt"));
    }

    Map<String, dynamic> toJson() => {
        "lastBriefDay": lastBriefDay,
        "lastRainAlertAt": lastRainAlertAt?.toIso8601String(),
        "lastSevereAlertAt": lastSevereAlertAt?.toIso8601String(),
    };

    @override
    List<Object?> get props => [lastBriefDay, lastRainAlertAt, lastSevereAlertAt];
}

enum AlertKind { brief, rain, severe }

class PendingAlert extends Equatable {
    final AlertKind kind;
    final String title, body;

    const PendingAlert({ required this.kind, required this.title, required this.body });

    @override
    List<Object?> get props => [kind, title, body];
}

/// Decides which notifications to send. Pure function so it can be unit tested.
class AlertEvaluator {
    /// Probability (%) from which an upcoming hour counts as "rain likely".
    static const rainThreshold = 60;

    /// If the current hour is already this likely to rain, don't announce it.
    static const alreadyRainingThreshold = 50;

    static const rainCooldown = Duration(hours: 3);
    static const severeCooldown = Duration(hours: 6);

    /// Gusts (km/h) and feels-like temperature (°C) that count as severe.
    static const severeGustKmh = 75.0;
    static const extremeHeatC = 41.0;

    /// The morning briefing can go out up to this many hours after [AlertPrefs.briefHour]
    /// (background checks run roughly hourly and can be delayed by the OS).
    static const briefWindowHours = 3;

    static const thunderCodes = {95, 96, 99};

    /// Returns the alerts to show and the updated log.
    static (List<PendingAlert>, AlertLog) evaluate({
        required Forecast forecast,
        required AlertPrefs prefs,
        required AlertLog log,
        required String place,
        required AppLocalizations l10n,
        required String locale,
        required DateTime now,
    }) {
        final alerts = <PendingAlert>[];
        var updated = log;
        final localNow = forecast.localNow(now);
        final today = "${localNow.year}-${localNow.month.toString().padLeft(2, "0")}-${localNow.day.toString().padLeft(2, "0")}";

        // Morning briefing.
        if (prefs.morningBrief && log.lastBriefDay != today
            && localNow.hour >= prefs.briefHour && localNow.hour < prefs.briefHour + briefWindowHours) {
            final day = forecast.today(now);
            if (day != null) {
                final unit = day.temperatureMax.unit;
                alerts.add(PendingAlert(
                    kind: AlertKind.brief,
                    title: l10n.briefTitle(place),
                    body: l10n.briefBody(
                        WeatherCode.decode(code: day.weatherCode, isNight: false).describe(l10n),
                        "${roundTemp(day.temperatureMin.value)}$unit",
                        "${roundTemp(day.temperatureMax.value)}$unit",
                        day.precipitationProbabilityMax?.value ?? 0,
                    ),
                ));
                updated = updated.copy(lastBriefDay: today);
            }
        }

        final upcoming = forecast.upcomingHours(4, now);

        // Rain soon: likely in the next 2 hours, not already raining now.
        if (prefs.rain && upcoming.length >= 2 && _cooledDown(log.lastRainAlertAt, rainCooldown, now)) {
            final current = upcoming.first;
            final rainingNow = current.precipitationProbability.value >= alreadyRainingThreshold || forecast.current.rain.value > 0;
            if (!rainingNow) {
                for (final hour in upcoming.skip(1).take(2)) {
                    if (hour.precipitationProbability.value >= rainThreshold) {
                        alerts.add(PendingAlert(
                            kind: AlertKind.rain,
                            title: l10n.rainAlertTitle(place),
                            body: l10n.rainAlertBody(hour.precipitationProbability.value, formatClock(hour.time, locale)),
                        ));
                        updated = updated.copy(lastRainAlertAt: now);
                        break;
                    }
                }
            }
        }

        // Severe weather: thunderstorms soon, very strong gusts, extreme heat.
        if (prefs.severe && _cooledDown(log.lastSevereAlertAt, severeCooldown, now)) {
            PendingAlert? severe;
            for (final hour in upcoming.take(3)) {
                if (thunderCodes.contains(hour.weatherCode)) {
                    severe = PendingAlert(
                        kind: AlertKind.severe,
                        title: l10n.severeThunderTitle(place),
                        body: l10n.severeThunderBody(formatClock(hour.time, locale)),
                    );
                    break;
                }
            }

            final gusts = forecast.current.windGusts;
            if (severe == null && toKmh(gusts.value, gusts.unit) >= severeGustKmh) {
                severe = PendingAlert(
                    kind: AlertKind.severe,
                    title: l10n.severeWindTitle(place),
                    body: l10n.severeWindBody("${gusts.value.round()} ${gusts.unit}"),
                );
            }

            final feelsLikeMax = forecast.today(now)?.apparentTemperatureMax;
            if (severe == null && feelsLikeMax != null && toCelsius(feelsLikeMax.value, feelsLikeMax.unit) >= extremeHeatC) {
                severe = PendingAlert(
                    kind: AlertKind.severe,
                    title: l10n.severeHeatTitle(place),
                    body: l10n.severeHeatBody("${roundTemp(feelsLikeMax.value)}${feelsLikeMax.unit}"),
                );
            }

            if (severe != null) {
                alerts.add(severe);
                updated = updated.copy(lastSevereAlertAt: now);
            }
        }

        return (alerts, updated);
    }

    static bool _cooledDown(DateTime? last, Duration cooldown, DateTime now) =>
        last == null || now.difference(last) >= cooldown;

    /// Converts a wind speed in the API's unit ("km/h", "mp/h", "m/s", "kn") to km/h.
    static double toKmh(double value, String unit) {
        final normalized = unit.toLowerCase().replaceAll(" ", "");
        if (normalized.contains("mp")) return value * 1.609344;
        if (normalized == "m/s" || normalized == "ms") return value * 3.6;
        if (normalized.startsWith("kn") || normalized == "kt") return value * 1.852;
        return value;
    }

    /// Converts a temperature in "°C" or "°F" to °C.
    static double toCelsius(double value, String unit) =>
        unit.toUpperCase().contains("F") ? (value - 32) * 5 / 9 : value;
}
