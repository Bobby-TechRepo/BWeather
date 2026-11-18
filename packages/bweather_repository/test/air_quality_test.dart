import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    group('AirQuality', () {
        test('maps US AQI to EPA levels', () {
            expect(const AirQuality(usAqi: 42).aqiLevel, AqiLevel.good);
            expect(const AirQuality(usAqi: 100).aqiLevel, AqiLevel.moderate);
            expect(const AirQuality(usAqi: 158).aqiLevel, AqiLevel.unhealthy);
            expect(const AirQuality(usAqi: 350).aqiLevel, AqiLevel.hazardous);
            expect(const AirQuality().aqiLevel, isNull);
        });

        test('maps UV index to WHO levels', () {
            expect(const AirQuality(uvIndex: 2.4).uvLevel, UvLevel.low);
            expect(const AirQuality(uvIndex: 6.6).uvLevel, UvLevel.high);
            expect(const AirQuality(uvIndex: 8.4).uvLevel, UvLevel.veryHigh);
            expect(const AirQuality(uvIndex: 11).uvLevel, UvLevel.extreme);
        });

        test('round-trips through JSON', () {
            const airQuality = AirQuality(usAqi: 158, europeanAqi: 61, pm25: 68.2, pm10: 210.4, dust: 340, uvIndex: 4.35, pollen: {"grass_pollen": 3.2});
            expect(AirQuality.fromJson(airQuality.toJson()), airQuality);
        });

        test('is stored with the forecast only when present', () {
            final forecast = Forecast(
                utcOffsetSeconds: 0,
                current: Current(
                    time: DateTime(2026, 11, 12), weatherCode: 0, isDay: true,
                    temperature: const Value(value: 20.0, unit: '°C'), apparentTemperature: const Value(value: 20.0, unit: '°C'),
                    windSpeed: const Value(value: 1.0, unit: 'km/h'), windGusts: const Value(value: 1.0, unit: 'km/h'),
                    windDirection: const Value(value: 0, unit: '°'), relativeHumidity: const Value(value: 50, unit: '%'),
                    surfacePressure: const Value(value: 1010.0, unit: 'hPa'), rain: const Value(value: 0.0, unit: 'mm'),
                    precipitation: const Value(value: 0.0, unit: 'mm'), cloudCover: const Value(value: 0, unit: '%'),
                ),
                hourly: const [], daily: const [],
            );
            expect(forecast.toJson().containsKey("airQuality"), isFalse);

            final withAir = forecast.withAirQuality(const AirQuality(usAqi: 50));
            expect(Forecast.fromJson(withAir.toJson()).airQuality?.usAqi, 50);
        });
    });
}
