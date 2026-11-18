import 'dart:convert';

import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
    group('ClimateNormals.fromDaily', () {
        test('averages each calendar day across years', () {
            final normals = ClimateNormals.fromDaily(
                dates: [DateTime(2020, 7, 1), DateTime(2021, 7, 1)],
                maxima: [30, 34],
                minima: [20, 22],
            );
            expect(normals.highFor(DateTime(2026, 7, 1)), closeTo(32, 1e-9));
            expect(normals.lowFor(DateTime(2026, 7, 1)), closeTo(21, 1e-9));
            expect(normals.fromYear, 2020);
            expect(normals.toYear, 2021);
        });

        test('smooths over neighbouring days and wraps around the new year', () {
            final normals = ClimateNormals.fromDaily(dates: [DateTime(2021, 12, 31)], maxima: [10], minima: [0]);
            // Dec 31 contributes to the first days of January too.
            expect(normals.highFor(DateTime(2026, 1, 3)), 10);
            // ...but not to days more than a week away.
            expect(normals.highFor(DateTime(2026, 1, 20)), isNull);
        });

        test('skips gaps instead of counting them as 0', () {
            final normals = ClimateNormals.fromDaily(
                dates: [DateTime(2020, 3, 10), DateTime(2021, 3, 10)],
                maxima: [20, null],
                minima: [null, 8],
            );
            expect(normals.highFor(DateTime(2026, 3, 10)), 20);
            expect(normals.lowFor(DateTime(2026, 3, 10)), 8);
        });

        test('survives a JSON round trip (rounded to 0.1)', () {
            final normals = ClimateNormals.fromDaily(dates: [DateTime(2020, 5, 5)], maxima: [25.04], minima: [14.96]);
            final restored = ClimateNormals.fromJson(jsonDecode(jsonEncode(normals.toJson())));
            expect(restored.highFor(DateTime(2026, 5, 5)), 25.0);
            expect(restored.lowFor(DateTime(2026, 5, 5)), 15.0);
            expect(restored.fromYear, 2020);
        });
    });

    group('TemperatureComparison', () {
        test('classifies the difference', () {
            expect(const TemperatureComparison(0.4).anomaly, Anomaly.normal);
            expect(const TemperatureComparison(-1.4).anomaly, Anomaly.normal);
            expect(const TemperatureComparison(2).anomaly, Anomaly.warmer);
            expect(const TemperatureComparison(6).anomaly, Anomaly.muchWarmer);
            expect(const TemperatureComparison(-3).anomaly, Anomaly.cooler);
            expect(const TemperatureComparison(-7).anomaly, Anomaly.muchCooler);
        });

        test('reports degrees in the user unit', () {
            expect(const TemperatureComparison(-3).degreesIn("°C"), 3);
            expect(const TemperatureComparison(5).degreesIn("°F"), 9);
        });
    });

    group('ForecastRepository.climateNormals', () {
        late http.Client httpClient;
        late ForecastRepository repository;

        setUpAll(() => registerFallbackValue(FakeUri()));

        setUp(() {
            httpClient = MockHttpClient();
            repository = ForecastRepository(httpClient: httpClient);
        });

        test('requests the last 20 complete years from the archive', () async {
            when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(
                jsonEncode({"daily": {"time": ["2020-06-01", "2021-06-01"], "temperature_2m_max": [30.0, 32.0], "temperature_2m_min": [21.0, null]}}),
                200,
            ));

            final normals = await repository.climateNormals(latitude: 6.5, longitude: 3.4, now: DateTime(2026, 11, 12));

            final uri = verify(() => httpClient.get(captureAny(), headers: any(named: 'headers'))).captured.single as Uri;
            expect(uri.host, 'archive-api.open-meteo.com');
            expect(uri.queryParameters['start_date'], '2006-01-01');
            expect(uri.queryParameters['end_date'], '2025-12-31');
            expect(normals.highFor(DateTime(2026, 6, 1)), 31);
            expect(normals.lowFor(DateTime(2026, 6, 1)), 21);
        });

        test('throws when the archive has no data', () async {
            when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(
                jsonEncode({"daily": {"time": [], "temperature_2m_max": [], "temperature_2m_min": []}}), 200,
            ));
            expect(repository.climateNormals(latitude: 0, longitude: 0), throwsA(isA<WeatherNotFoundFailure>()));
        });
    });

    group('Forecast.minutely', () {
        final steps = [
            for (int i = 0; i < 8; i++)
                MinutelyPrecipitation(time: DateTime(2026, 11, 12, 14).add(Duration(minutes: 15 * i)), precipitation: i * 0.1, unit: "mm"),
        ];

        test('a step round-trips through JSON', () {
            final step = MinutelyPrecipitation.fromJson(jsonDecode(jsonEncode(steps[3].toJson())));
            expect(step, steps[3]);
        });

        test('upcomingMinutely starts with the step in progress', () {
            final forecast = Forecast(utcOffsetSeconds: 3600, current: _current, hourly: const [], daily: const [], minutely: steps);
            final upcoming = forecast.upcomingMinutely(DateTime.utc(2026, 11, 12, 13, 20));
            expect(upcoming.first.time, DateTime(2026, 11, 12, 14, 15));
            expect(upcoming.length, 7);
        });
    });
}

final _current = Current(
    time: DateTime(2026, 11, 12), weatherCode: 61, isDay: true,
    temperature: const Value(value: 20.0, unit: '°C'), apparentTemperature: const Value(value: 20.0, unit: '°C'),
    windSpeed: const Value(value: 1.0, unit: 'km/h'), windGusts: const Value(value: 1.0, unit: 'km/h'),
    windDirection: const Value(value: 0, unit: '°'), relativeHumidity: const Value(value: 50, unit: '%'),
    surfacePressure: const Value(value: 1010.0, unit: 'hPa'), rain: const Value(value: 0.0, unit: 'mm'),
    precipitation: const Value(value: 0.0, unit: 'mm'), cloudCover: const Value(value: 0, unit: '%'),
);
