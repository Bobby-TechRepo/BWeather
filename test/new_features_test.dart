import 'package:bweather/components/minutely_rain.dart';
import 'package:bweather/components/weather_background.dart';
import 'package:bweather/states/forecast/city_state.dart';
import 'package:bweather/states/settings_cubit.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter_test/flutter_test.dart';

List<MinutelyPrecipitation> _steps(List<double> amounts, { DateTime? start }) => [
    for (int i = 0; i < amounts.length; i++)
        MinutelyPrecipitation(time: (start ?? DateTime(2026, 11, 12, 14)).add(Duration(minutes: 15 * i)), precipitation: amounts[i], unit: "mm"),
];

void main() {
    group('RainOutlook', () {
        final now = DateTime(2026, 11, 12, 14, 5);

        test('no rain', () {
            expect(RainOutlook.from(_steps([0, 0, 0, 0, 0, 0, 0, 0]), now), const RainOutlook(RainTrend.none));
        });

        test('rain starting, rounded up to 5 minutes', () {
            // Wet from 14:30: 25 minutes after 14:05.
            expect(RainOutlook.from(_steps([0, 0.05, 0.4, 1.2, 0.3, 0, 0, 0]), now), const RainOutlook(RainTrend.starting, 25));
        });

        test('rain stopping', () {
            expect(RainOutlook.from(_steps([0.8, 0.3, 0, 0, 0, 0, 0, 0]), now), const RainOutlook(RainTrend.stopping, 25));
        });

        test('rain continuing', () {
            expect(RainOutlook.from(_steps([0.5, 0.6, 0.4, 0.3, 0.2, 0.2, 0.3, 0.5]), now), const RainOutlook(RainTrend.continuing));
        });

        test('drizzle under 0.1 mm counts as dry; inches use their own threshold', () {
            expect(RainOutlook.from(_steps([0.05, 0.09]), now).trend, RainTrend.none);
            final inches = [MinutelyPrecipitation(time: now, precipitation: 0.01, unit: "inch")];
            expect(RainOutlook.isWet(inches.first), isTrue);
        });

        test('rain starting within the current step shows at least 5 minutes', () {
            expect(RainOutlook.from(_steps([0, 0.5], start: DateTime(2026, 11, 12, 13, 55)), now), const RainOutlook(RainTrend.starting, 5));
        });
    });

    group('SkyScene', () {
        test('maps WMO codes to scenes', () {
            expect(SkyScene.from(weatherCode: 0, isDay: true).hasSun, isTrue);
            expect(SkyScene.from(weatherCode: 1, isDay: false).hasStars, isTrue);
            expect(SkyScene.from(weatherCode: 45, isDay: true).kind, SkyKind.fog);
            expect(SkyScene.from(weatherCode: 63, isDay: true).kind, SkyKind.rain);
            expect(SkyScene.from(weatherCode: 82, isDay: true).kind, SkyKind.heavyRain);
            expect(SkyScene.from(weatherCode: 75, isDay: true).snowFlakes, greaterThan(0));
            expect(SkyScene.from(weatherCode: 95, isDay: false).hasLightning, isTrue);
            expect(SkyScene.from(weatherCode: 1234, isDay: true).kind, SkyKind.overcast);
        });
    });

    group('Settings', () {
        test('new options default to: minute rain off, animation on, crash reports on', () {
            const state = SettingsState();
            expect(state.minuteRain, isFalse);
            expect(state.animatedBackground, isTrue);
            expect(state.crashReports, isTrue);
        });

        test('new options persist', () {
            final restored = SettingsState.fromJson(
                const SettingsState().copy(minuteRain: true, animatedBackground: false, crashReports: false, languageCode: "yo").toJson(),
            );
            expect(restored.minuteRain, isTrue);
            expect(restored.animatedBackground, isFalse);
            expect(restored.crashReports, isFalse);
            expect(restored.languageCode, "yo");
        });

        test('settings saved by older versions get the defaults', () {
            final restored = SettingsState.fromJson(const {"temp_unit": "celsius"});
            expect(restored.minuteRain, isFalse);
            expect(restored.animatedBackground, isTrue);
        });
    });

    group('Date locale', () {
        test('languages without intl date names fall back to English', () {
            expect(dateLocale("ha"), "en");
            expect(dateLocale("yo"), "en");
            expect(dateLocale("ig"), "en");
            expect(dateLocale("es"), "es");
            expect(dateLocale("zh"), "zh");
        });
    });

    group('CityState comparison', () {
        test('compares today\'s high (any unit) with the normal high', () {
            final today = DateTime.now();
            final normals = ClimateNormals(highs: List.filled(366, 30.0), lows: List.filled(366, 20.0), fromYear: 2006, toYear: 2025);
            final forecast = Forecast(
                utcOffsetSeconds: today.timeZoneOffset.inSeconds,
                current: Current(
                    time: today, weatherCode: 0, isDay: true,
                    temperature: const Value(value: 93.0, unit: '°F'), apparentTemperature: const Value(value: 93.0, unit: '°F'),
                    windSpeed: const Value(value: 1.0, unit: 'km/h'), windGusts: const Value(value: 1.0, unit: 'km/h'),
                    windDirection: const Value(value: 0, unit: '°'), relativeHumidity: const Value(value: 50, unit: '%'),
                    surfacePressure: const Value(value: 1010.0, unit: 'hPa'), rain: const Value(value: 0.0, unit: 'mm'),
                    precipitation: const Value(value: 0.0, unit: 'mm'), cloudCover: const Value(value: 0, unit: '%'),
                ),
                hourly: const [],
                daily: [
                    Daily(
                        time: DateTime(today.year, today.month, today.day), weatherCode: 0,
                        temperatureMax: const Value(value: 95.0, unit: '°F'), temperatureMin: const Value(value: 77.0, unit: '°F'),
                        apparentTemperatureMax: const Value(value: 95.0, unit: '°F'), apparentTemperatureMin: const Value(value: 77.0, unit: '°F'),
                    ),
                ],
            );
            final place = CityState(
                key: "x",
                city: City(name: "Lagos", country: "Nigeria", latitude: 6.5, longitude: 3.4, forecast: forecast),
                normals: normals,
            );
            final comparison = place.comparison!;
            expect(comparison.differenceC, closeTo(5, 1e-9)); // 95 °F = 35 °C
            expect(comparison.anomaly, Anomaly.muchWarmer);
            expect(comparison.degreesIn('°F'), 9);
        });
    });
}
