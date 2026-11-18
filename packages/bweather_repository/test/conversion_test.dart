import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    const fahrenheitMph = Units(tempUnit: TempUnit.fahrenheit, windSpeedUnit: WindSpeedUnit.mph, precipitationUnit: PrecipitationUnit.inch);

    group('UnitConverter.convert', () {
        test('temperature', () {
            expect(UnitConverter.convert(0, "°C", fahrenheitMph), (32.0, "°F"));
            expect(UnitConverter.convert(212, "°F", Units.metric), (100.0, "°C"));
            expect(UnitConverter.convert(21.5, "°C", Units.metric), (21.5, "°C"));
        });

        test('wind speed between all four units', () {
            expect(UnitConverter.convert(36, "km/h", const Units(windSpeedUnit: WindSpeedUnit.ms)), (10.0, "m/s"));
            expect(UnitConverter.convert(10, "m/s", Units.metric), (36.0, "km/h"));
            expect(UnitConverter.convert(1.852, "km/h", const Units(windSpeedUnit: WindSpeedUnit.kn)), (1.0, "kn"));
            final (mph, label) = UnitConverter.convert(100, "km/h", fahrenheitMph);
            expect(mph, closeTo(62.14, 0.01));
            expect(label, "mp/h");
            expect(UnitConverter.convert(62.14, "mp/h", Units.metric).$1, closeTo(100, 0.01));
        });

        test('precipitation', () {
            expect(UnitConverter.convert(25.4, "mm", fahrenheitMph), (1.0, "inch"));
            expect(UnitConverter.convert(0.5, "inch", Units.metric), (12.7, "mm"));
        });

        test('other units are left alone', () {
            expect(UnitConverter.convert(1013, "hPa", fahrenheitMph), (1013.0, "hPa"));
            expect(UnitConverter.convert(80, "%", fahrenheitMph), (80.0, "%"));
        });

        test('round trips do not drift', () {
            var value = 27.4;
            for (int i = 0; i < 20; i++) {
                value = UnitConverter.convert(UnitConverter.convert(value, "°C", fahrenheitMph).$1, "°F", Units.metric).$1;
            }
            expect(value, closeTo(27.4, 0.01));
        });
    });

    group('Forecast.convertedTo', () {
        final forecast = Forecast(
            utcOffsetSeconds: 0,
            current: Current(
                time: DateTime(2026, 11, 14), weatherCode: 61, isDay: true,
                temperature: const Value(value: 20.0, unit: '°C'), apparentTemperature: const Value(value: 21.0, unit: '°C'),
                windSpeed: const Value(value: 36.0, unit: 'km/h'), windGusts: const Value(value: 72.0, unit: 'km/h'),
                windDirection: const Value(value: 90, unit: '°'), relativeHumidity: const Value(value: 70, unit: '%'),
                surfacePressure: const Value(value: 1010.0, unit: 'hPa'), rain: const Value(value: 2.54, unit: 'mm'),
                precipitation: const Value(value: 2.54, unit: 'mm'), cloudCover: const Value(value: 90, unit: '%'),
            ),
            hourly: [
                Hourly(
                    time: DateTime(2026, 11, 14, 10), weatherCode: 61,
                    temperature: const Value(value: 10.0, unit: '°C'), dewPoint: const Value(value: 5.0, unit: '°C'),
                    apparentTemperature: const Value(value: 9.0, unit: '°C'), rain: const Value(value: 1.0, unit: 'mm'),
                    relativeHumidity: const Value(value: 80, unit: '%'), precipitationProbability: const Value(value: 60, unit: '%'),
                ),
            ],
            daily: [
                Daily(
                    time: DateTime(2026, 11, 14), weatherCode: 61,
                    temperatureMax: const Value(value: 25.0, unit: '°C'), temperatureMin: const Value(value: 15.0, unit: '°C'),
                    apparentTemperatureMax: const Value(value: 26.0, unit: '°C'), apparentTemperatureMin: const Value(value: 14.0, unit: '°C'),
                    precipitationSum: const Value(value: 5.08, unit: 'mm'), windSpeedMax: const Value(value: 18.0, unit: 'km/h'),
                    precipitationProbabilityMax: const Value(value: 80, unit: '%'),
                ),
            ],
            minutely: [MinutelyPrecipitation(time: DateTime(2026, 11, 14, 10), precipitation: 0.254, unit: "mm")],
        );

        test('converts every temperature, speed and amount', () {
            final converted = forecast.convertedTo(fahrenheitMph);
            expect(converted.current.temperature, const Value(value: 68.0, unit: '°F'));
            expect(converted.current.windGusts.unit, 'mp/h');
            expect(converted.current.rain, const Value(value: 0.1, unit: 'inch'));
            expect(converted.current.windDirection, forecast.current.windDirection);
            expect(converted.hourly.single.dewPoint, const Value(value: 41.0, unit: '°F'));
            expect(converted.daily.single.temperatureMax, const Value(value: 77.0, unit: '°F'));
            expect(converted.daily.single.precipitationSum, const Value(value: 0.2, unit: 'inch'));
            expect(converted.daily.single.precipitationProbabilityMax, forecast.daily.single.precipitationProbabilityMax);
            expect(converted.minutely.single.unit, 'inch');
            expect(converted.minutely.single.precipitation, closeTo(0.01, 0.0005));
        });

        test('converting back gives the original (to display precision)', () {
            final back = forecast.convertedTo(fahrenheitMph).convertedTo(Units.metric);
            expect(back.current.temperature.unit, '°C');
            expect(back.current.temperature.value, closeTo(20.0, 0.001));
            expect(back.current.windSpeed.unit, 'km/h');
            expect(back.current.windSpeed.value, closeTo(36.0, 0.001));
            expect(back.daily.single.windSpeedMax!.value, closeTo(18.0, 0.001));
            expect(back.daily.single.precipitationSum!.value, closeTo(5.08, 0.001));
            expect(back.minutely.single.precipitation, closeTo(0.254, 0.001));
        });

        test('is a no-op in the same units', () {
            expect(forecast.convertedTo(Units.metric), forecast);
        });
    });
}
