import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/services/home_widget_service.dart';
import 'package:bweather/services/tips.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

final l10n = lookupAppLocalizations(const Locale('en'));

/// 48 hours from local midnight, 12 Nov 2026, UTC+1 (Lagos).
Forecast _forecast({
    Map<int, int> rainByHour = const {},
    Map<int, int> codeByHour = const {},
    double temperature = 28,
    int humidity = 80,
    double feelsLikeMax = 33,
    int rainChanceToday = 10,
    AirQuality? airQuality,
}) => Forecast(
    utcOffsetSeconds: 3600,
    current: Current(
        time: DateTime(2026, 11, 12, 8), weatherCode: 2, isDay: true,
        temperature: Value(value: temperature, unit: '°C'), apparentTemperature: Value(value: temperature + 2, unit: '°C'),
        windSpeed: const Value(value: 10.0, unit: 'km/h'), windGusts: const Value(value: 20.0, unit: 'km/h'),
        windDirection: const Value(value: 200, unit: '°'), relativeHumidity: Value(value: humidity, unit: '%'),
        surfacePressure: const Value(value: 1010.0, unit: 'hPa'), rain: const Value(value: 0.0, unit: 'mm'),
        precipitation: const Value(value: 0.0, unit: 'mm'), cloudCover: const Value(value: 50, unit: '%'),
    ),
    hourly: [
        for (int i = 0; i < 48; i++)
            Hourly(
                time: DateTime(2026, 11, 12).add(Duration(hours: i)),
                weatherCode: codeByHour[i] ?? 1,
                isDay: (i % 24) >= 7 && (i % 24) < 19,
                temperature: Value(value: temperature, unit: '°C'), dewPoint: const Value(value: 20.0, unit: '°C'),
                apparentTemperature: Value(value: temperature + 2 - (i % 24 - 12).abs() * 0.5, unit: '°C'),
                rain: const Value(value: 0.0, unit: 'mm'),
                relativeHumidity: Value(value: humidity, unit: '%'),
                precipitationProbability: Value(value: rainByHour[i] ?? 0, unit: '%'),
            ),
    ],
    daily: [
        Daily(
            time: DateTime(2026, 11, 12), weatherCode: 2,
            temperatureMax: const Value(value: 31.0, unit: '°C'), temperatureMin: const Value(value: 24.0, unit: '°C'),
            apparentTemperatureMax: Value(value: feelsLikeMax, unit: '°C'), apparentTemperatureMin: const Value(value: 25.0, unit: '°C'),
            precipitationProbabilityMax: Value(value: rainChanceToday, unit: '%'),
        ),
    ],
    airQuality: airQuality,
);

/// 09:00 local.
final morning = DateTime.utc(2026, 11, 12, 8, 0);

List<Tip> _tips(Forecast forecast) => TipsEngine.tips(forecast: forecast, l10n: l10n, locale: "en", now: morning);

Iterable<TipKind> _kinds(Forecast forecast) => _tips(forecast).map((tip) => tip.kind);

void main() {
    // In the app, GlobalMaterialLocalizations loads date symbols; plain unit tests must do it themselves.
    setUpAll(() => initializeDateFormatting('en'));

    group('TipsEngine', () {
        test('suggests an umbrella with the likeliest time', () {
            final tips = _tips(_forecast(rainChanceToday: 80, rainByHour: {15: 80}));
            final umbrella = tips.firstWhere((tip) => tip.kind == TipKind.umbrella);
            expect(umbrella.text, contains("80%"));
            expect(umbrella.text, contains("3:00"));
        });

        test('picks clothing from the feels-like maximum', () {
            expect(_tips(_forecast(feelsLikeMax: 36)).firstWhere((tip) => tip.kind == TipKind.clothes).text, l10n.tipClothesHot);
            expect(_tips(_forecast(feelsLikeMax: 18)).firstWhere((tip) => tip.kind == TipKind.clothes).text, l10n.tipClothesMild);
        });

        test('reminds to drink water in extreme heat', () {
            expect(_kinds(_forecast(feelsLikeMax: 38)), contains(TipKind.hydrate));
            expect(_kinds(_forecast(feelsLikeMax: 30)), isNot(contains(TipKind.hydrate)));
        });

        test('sunscreen when UV is high and an air quality warning when AQI > 100', () {
            final kinds = _kinds(_forecast(airQuality: const AirQuality(uvIndex: 9, usAqi: 160)));
            expect(kinds, containsAll([TipKind.sunscreen, TipKind.airQuality]));
        });

        test('warns drivers about fog', () {
            final tips = _tips(_forecast(codeByHour: {10: 45}));
            expect(tips.first.kind, TipKind.driving);
        });

        test('laundry advice depends on rain and humidity', () {
            expect(_tips(_forecast(humidity: 60)).map((tip) => tip.text), contains(l10n.tipLaundryGood));
            expect(_tips(_forecast(humidity: 60, rainByHour: {11: 70})).map((tip) => tip.text), contains(l10n.tipLaundryBad));
        });

        test('warns about mosquitoes on a warm, humid evening', () {
            expect(_kinds(_forecast(temperature: 27, humidity: 85)), contains(TipKind.mosquitoes));
            expect(_kinds(_forecast(temperature: 27, humidity: 40)), isNot(contains(TipKind.mosquitoes)));
        });

        test('never returns more than ${TipsEngine.maxTips} tips', () {
            final tips = _tips(_forecast(
                rainChanceToday: 80, rainByHour: {15: 80}, codeByHour: {10: 45}, feelsLikeMax: 38,
                airQuality: const AirQuality(uvIndex: 9, usAqi: 160),
            ));
            expect(tips.length, lessThanOrEqualTo(TipsEngine.maxTips));
        });
    });

    group('WeatherWidgetData', () {
        test('builds the widget text', () {
            final data = WeatherWidgetData.from(
                city: const City(name: "Lagos", country: "Nigeria", latitude: 6.45, longitude: 3.39),
                forecast: _forecast(temperature: 27.6),
                l10n: l10n, locale: "en",
                updatedAt: DateTime(2026, 11, 12, 9, 5),
            );
            expect(data.place, "Lagos");
            expect(data.temperature, "28°");
            expect(data.emoji, "⛅");
            expect(data.range, "H 31°C · L 24°C");
            expect(data.updated, contains("9:05"));
        });

        test('emoji covers day/night and unknown codes', () {
            expect(WeatherWidgetData.emojiFor(0), "☀️");
            expect(WeatherWidgetData.emojiFor(0, isNight: true), "🌙");
            expect(WeatherWidgetData.emojiFor(63), "🌧️");
            expect(WeatherWidgetData.emojiFor(96), "⛈️");
            expect(WeatherWidgetData.emojiFor(4), "🌡️");
        });
    });
}
