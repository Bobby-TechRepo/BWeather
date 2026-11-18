import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter_test/flutter_test.dart';

Hourly _hour(DateTime time) => Hourly(
    time: time, weatherCode: 0,
    temperature: const Value(value: 20.0, unit: '°C'), dewPoint: const Value(value: 10.0, unit: '°C'),
    apparentTemperature: const Value(value: 20.0, unit: '°C'), rain: const Value(value: 0.0, unit: 'mm'),
    relativeHumidity: const Value(value: 50, unit: '%'), precipitationProbability: const Value(value: 0, unit: '%'),
);

Daily _day(DateTime time) => Daily(
    time: time, weatherCode: 0,
    temperatureMax: const Value(value: 30.0, unit: '°C'), temperatureMin: const Value(value: 20.0, unit: '°C'),
    apparentTemperatureMax: const Value(value: 30.0, unit: '°C'), apparentTemperatureMin: const Value(value: 20.0, unit: '°C'),
);

Forecast _forecast({ required int offsetSeconds }) => Forecast(
    utcOffsetSeconds: offsetSeconds,
    current: Current(
        time: DateTime(2026, 11, 12, 6, 45), weatherCode: 0, isDay: true,
        temperature: const Value(value: 20.0, unit: '°C'), apparentTemperature: const Value(value: 20.0, unit: '°C'),
        windSpeed: const Value(value: 1.0, unit: 'm/s'), windGusts: const Value(value: 1.0, unit: 'm/s'),
        windDirection: const Value(value: 0, unit: '°'), relativeHumidity: const Value(value: 50, unit: '%'),
        surfacePressure: const Value(value: 1010.0, unit: 'hPa'), rain: const Value(value: 0.0, unit: 'mm'),
        precipitation: const Value(value: 0.0, unit: 'mm'), cloudCover: const Value(value: 0, unit: '%'),
    ),
    // 00:00 on the 12th through 23:00 on the 13th, location-local time.
    hourly: [for (int i = 0; i < 48; i++) _hour(DateTime(2026, 11, 12).add(Duration(hours: i)))],
    daily: [_day(DateTime(2026, 11, 12)), _day(DateTime(2026, 11, 13))],
);

void main() {
    group('Forecast time helpers', () {
        test('localNow applies half-hour offsets (India, +05:30)', () {
            final forecast = _forecast(offsetSeconds: 19800);
            final now = DateTime.utc(2026, 11, 12, 1, 0);
            expect(forecast.localNow(now), DateTime(2026, 11, 12, 6, 30));
        });

        test('upcomingHours starts at the location\'s current hour, not midnight', () {
            final forecast = _forecast(offsetSeconds: 7 * 3600); // Jakarta
            final now = DateTime.utc(2026, 11, 11, 23, 45);       // 06:45 on the 12th in Jakarta
            final hours = forecast.upcomingHours(5, now);
            expect(hours.map((h) => h.time.hour), [6, 7, 8, 9, 10]);
        });

        test('upcomingHours is clamped at the end of the data', () {
            final forecast = _forecast(offsetSeconds: 0);
            final hours = forecast.upcomingHours(5, DateTime.utc(2026, 11, 13, 22, 10));
            expect(hours.length, 2);
        });

        test('today picks the location\'s date even when the device is on another day', () {
            final forecast = _forecast(offsetSeconds: 14 * 3600); // Kiribati
            final today = forecast.today(DateTime.utc(2026, 11, 12, 11, 0)); // already the 13th there
            expect(today?.time, DateTime(2026, 11, 13));
        });
    });

    group('isNight', () {
        test('prefers the per-hour is_day flag from the API', () {
            final forecast = _forecast(offsetSeconds: 0);
            final hour = Hourly(
                time: DateTime(2026, 11, 12, 2), weatherCode: 0, isDay: true,
                temperature: const Value(value: 20.0, unit: '°C'), dewPoint: const Value(value: 10.0, unit: '°C'),
                apparentTemperature: const Value(value: 20.0, unit: '°C'), rain: const Value(value: 0.0, unit: 'mm'),
                relativeHumidity: const Value(value: 50, unit: '%'), precipitationProbability: const Value(value: 0, unit: '%'),
            );
            expect(forecast.isNight(hour), isFalse);
        });

        test('treats early morning as night without is_day (old cached data)', () {
            final forecast = _forecast(offsetSeconds: 0);
            expect(forecast.isNight(forecast.hourly[2]), isTrue);   // 02:00
            expect(forecast.isNight(forecast.hourly[12]), isFalse); // 12:00
        });
    });

    group('Value.fromJson', () {
        test('coerces JSON ints into double values', () {
            final value = Value<double>.fromJson({'value': 25, 'unit': '°C'});
            expect(value.value, 25.0);
            expect(value.value, isA<double>());
        });
    });

    group('City', () {
        test('fromJson tolerates a null elevation (previously wiped saved data)', () {
            final city = City.fromJson({'name': 'Lagos', 'country': 'Nigeria', 'timezone': 'Africa/Lagos', 'elevation': null, 'latitude': 6.45, 'longitude': 3.39});
            expect(city.elevation, isNull);
        });

        test('fromJson keeps the city when its cached forecast is unreadable', () {
            final city = City.fromJson({'name': 'Lagos', 'country': 'Nigeria', 'latitude': 6.45, 'longitude': 3.39, 'forecast': {'broken': true}});
            expect(city.name, 'Lagos');
            expect(city.forecast, isNull);
        });

        test('id distinguishes same-named places', () {
            const parisFr = City(name: 'Paris', country: 'France', latitude: 48.8534, longitude: 2.3488);
            const parisUs = City(name: 'Paris', country: 'United States', latitude: 33.6609, longitude: -95.5555);
            expect(parisFr.id == parisUs.id, isFalse);
        });
    });
}
