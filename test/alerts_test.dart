import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/services/alerts.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

final l10n = lookupAppLocalizations(const Locale('en'));

Hourly _hour(DateTime time, { int rain = 0, int code = 1 }) => Hourly(
    time: time, weatherCode: code, isDay: time.hour >= 6 && time.hour < 18,
    temperature: const Value(value: 28.0, unit: '°C'), dewPoint: const Value(value: 20.0, unit: '°C'),
    apparentTemperature: const Value(value: 30.0, unit: '°C'), rain: const Value(value: 0.0, unit: 'mm'),
    relativeHumidity: const Value(value: 70, unit: '%'), precipitationProbability: Value(value: rain, unit: '%'),
);

/// A 48-hour forecast starting at local midnight on 12 Nov 2026 (UTC+1, like Lagos).
Forecast _forecast({ Map<int, int> rainByHour = const {}, Map<int, int> codeByHour = const {}, double gusts = 20, double feelsLikeMax = 33 }) => Forecast(
    utcOffsetSeconds: 3600,
    current: Current(
        time: DateTime(2026, 11, 12, 7), weatherCode: 2, isDay: true,
        temperature: const Value(value: 26.0, unit: '°C'), apparentTemperature: const Value(value: 28.0, unit: '°C'),
        windSpeed: const Value(value: 10.0, unit: 'km/h'), windGusts: Value(value: gusts, unit: 'km/h'),
        windDirection: const Value(value: 200, unit: '°'), relativeHumidity: const Value(value: 80, unit: '%'),
        surfacePressure: const Value(value: 1010.0, unit: 'hPa'), rain: const Value(value: 0.0, unit: 'mm'),
        precipitation: const Value(value: 0.0, unit: 'mm'), cloudCover: const Value(value: 50, unit: '%'),
    ),
    hourly: [
        for (int i = 0; i < 48; i++)
            _hour(DateTime(2026, 11, 12).add(Duration(hours: i)), rain: rainByHour[i] ?? 0, code: codeByHour[i] ?? 1),
    ],
    daily: [
        Daily(
            time: DateTime(2026, 11, 12), weatherCode: 63,
            temperatureMax: const Value(value: 31.4, unit: '°C'), temperatureMin: const Value(value: 23.6, unit: '°C'),
            apparentTemperatureMax: Value(value: feelsLikeMax, unit: '°C'), apparentTemperatureMin: const Value(value: 25.0, unit: '°C'),
            precipitationProbabilityMax: const Value(value: 70, unit: '%'),
        ),
    ],
);

/// 07:30 local time in Lagos.
final morning = DateTime.utc(2026, 11, 12, 6, 30);

(List<PendingAlert>, AlertLog) _evaluate(Forecast forecast, AlertPrefs prefs, { AlertLog log = const AlertLog(), DateTime? now }) =>
    AlertEvaluator.evaluate(forecast: forecast, prefs: prefs, log: log, place: "Lagos", l10n: l10n, locale: "en", now: now ?? morning);

void main() {
    // In the app, GlobalMaterialLocalizations loads date symbols; plain unit tests must do it themselves.
    setUpAll(() => initializeDateFormatting('en'));

    group('morning briefing', () {
        const prefs = AlertPrefs(morningBrief: true, briefHour: 7);

        test('is sent once, after the chosen hour, with today\'s summary', () {
            final (alerts, log) = _evaluate(_forecast(), prefs);
            expect(alerts.single.kind, AlertKind.brief);
            expect(alerts.single.title, "Today in Lagos");
            expect(alerts.single.body, contains("24°C to 31°C"));
            expect(alerts.single.body, contains("70%"));

            final (again, _) = _evaluate(_forecast(), prefs, log: log, now: morning.add(const Duration(hours: 1)));
            expect(again, isEmpty);
        });

        test('is not sent before the chosen hour', () {
            final (alerts, _) = _evaluate(_forecast(), prefs, now: DateTime.utc(2026, 11, 12, 5, 0)); // 06:00 local
            expect(alerts, isEmpty);
        });

        test('is skipped when the window has passed (e.g. phone was off)', () {
            final (alerts, _) = _evaluate(_forecast(), prefs, now: DateTime.utc(2026, 11, 12, 13, 0)); // 14:00 local
            expect(alerts, isEmpty);
        });
    });

    group('rain alerts', () {
        const prefs = AlertPrefs(rain: true);

        test('fire when rain is likely in the next two hours', () {
            final (alerts, log) = _evaluate(_forecast(rainByHour: {9: 80}), prefs);
            expect(alerts.single.kind, AlertKind.rain);
            expect(alerts.single.body, contains("80%"));
            expect(log.lastRainAlertAt, morning);
        });

        test('stay quiet when it is already raining', () {
            final (alerts, _) = _evaluate(_forecast(rainByHour: {7: 70, 8: 90}), prefs);
            expect(alerts, isEmpty);
        });

        test('respect the cooldown', () {
            final log = AlertLog(lastRainAlertAt: morning.subtract(const Duration(hours: 1)));
            final (alerts, _) = _evaluate(_forecast(rainByHour: {9: 80}), prefs, log: log);
            expect(alerts, isEmpty);
        });
    });

    group('severe weather', () {
        const prefs = AlertPrefs(severe: true);

        test('warns about thunderstorms in the next hours', () {
            final (alerts, _) = _evaluate(_forecast(codeByHour: {8: 95}), prefs);
            expect(alerts.single.title, "Thunderstorms near Lagos");
        });

        test('warns about very strong gusts', () {
            final (alerts, _) = _evaluate(_forecast(gusts: 90), prefs);
            expect(alerts.single.title, "Strong winds in Lagos");
        });

        test('warns about extreme heat', () {
            final (alerts, _) = _evaluate(_forecast(feelsLikeMax: 43), prefs);
            expect(alerts.single.title, "Extreme heat in Lagos");
        });

        test('nothing on a normal day', () {
            final (alerts, _) = _evaluate(_forecast(), prefs);
            expect(alerts, isEmpty);
        });
    });

    group('unit conversion', () {
        test('wind speeds', () {
            expect(AlertEvaluator.toKmh(10, "m/s"), closeTo(36, 0.01));
            expect(AlertEvaluator.toKmh(10, "mp/h"), closeTo(16.09, 0.01));
            expect(AlertEvaluator.toKmh(10, "kn"), closeTo(18.52, 0.01));
            expect(AlertEvaluator.toKmh(10, "km/h"), 10);
        });

        test('temperatures', () {
            expect(AlertEvaluator.toCelsius(212, "°F"), closeTo(100, 0.01));
            expect(AlertEvaluator.toCelsius(30, "°C"), 30);
        });
    });

    group('AlertPrefs', () {
        test('round-trips through JSON and clamps the hour', () {
            const prefs = AlertPrefs(morningBrief: true, rain: true, briefHour: 8);
            expect(AlertPrefs.fromJson(prefs.toJson()), prefs);
            expect(AlertPrefs.fromJson({"briefHour": 99}).briefHour, 23);
            expect(AlertPrefs.fromJson(null), const AlertPrefs());
        });
    });
}
