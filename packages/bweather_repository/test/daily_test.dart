import 'package:bweather_repository/models/forecast.dart';
import 'package:flutter_test/flutter_test.dart';

// Assuming Value and Daily classes are imported here

void main() {
  group('Daily tests', () {
    test('Daily should serialize to JSON correctly', () {
      final daily = Daily(
        time: DateTime.parse("2024-11-27"),
        weatherCode: 123,
        temperatureMax: const Value(value: 30.0, unit: "C"),
        temperatureMin: const Value(value: 15.0, unit: "C"),
        apparentTemperatureMax: const Value(value: 32.0, unit: "C"),
        apparentTemperatureMin: const Value(value: 14.0, unit: "C"),
      );

      final json = daily.toJson();
      expect(json["time"], "2024-11-27 00:00:00.000");
      expect(json["weather_code"], 123);
      expect(json["temperature_max"], {"value": 30.0, "unit": "C"});
      expect(json["temperature_min"], {"value": 15.0, "unit": "C"});
      expect(json["apparent_temperature_max"], {"value": 32.0, "unit": "C"});
      expect(json["apparent_temperature_min"], {"value": 14.0, "unit": "C"});
    });

    test('Daily should deserialize from JSON correctly', () {
      final json = {
        "time": "2024-11-27",
        "weather_code": 123,
        "temperature_max": {"value": 30.0, "unit": "C"},
        "temperature_min": {"value": 15.0, "unit": "C"},
        "apparent_temperature_max": {"value": 32.0, "unit": "C"},
        "apparent_temperature_min": {"value": 14.0, "unit": "C"},
      };

      final daily = Daily.fromJson(json);
      expect(daily.time, DateTime.parse("2024-11-27"));
      expect(daily.weatherCode, 123);
      expect(daily.temperatureMax.value, 30.0);
      expect(daily.temperatureMin.unit, "C");
      expect(daily.apparentTemperatureMax.value, 32.0);
      expect(daily.apparentTemperatureMin.value, 14.0);
    });

    test('Daily should serialize to a JSON string correctly', () {
      final daily = Daily(
        time: DateTime.parse("2024-11-27"),
        weatherCode: 123,
        temperatureMax: const Value(value: 30.0, unit: "C"),
        temperatureMin: const Value(value: 15.0, unit: "C"),
        apparentTemperatureMax: const Value(value: 32.0, unit: "C"),
        apparentTemperatureMin: const Value(value: 14.0, unit: "C"),
      );

      final serialized = daily.serialize();
      expect(
        serialized,
        '{"time":"2024-11-27 00:00:00.000","weather_code":123,"apparent_temperature_min":{"value":14.0,"unit":"C"},"apparent_temperature_max":{"value":32.0,"unit":"C"},"temperature_min":{"value":15.0,"unit":"C"},"temperature_max":{"value":30.0,"unit":"C"}}',
      );
    });

    test('Daily should support equality comparison', () {
      final daily1 = Daily(
        time: DateTime.parse("2024-11-27"),
        weatherCode: 123,
        temperatureMax: const Value(value: 30.0, unit: "C"),
        temperatureMin: const Value(value: 15.0, unit: "C"),
        apparentTemperatureMax: const Value(value: 32.0, unit: "C"),
        apparentTemperatureMin: const Value(value: 14.0, unit: "C"),
      );

      final daily2 = Daily(
        time: DateTime.parse("2024-11-27"),
        weatherCode: 123,
        temperatureMax: const Value(value: 30.0, unit: "C"),
        temperatureMin: const Value(value: 15.0, unit: "C"),
        apparentTemperatureMax: const Value(value: 32.0, unit: "C"),
        apparentTemperatureMin: const Value(value: 14.0, unit: "C"),
      );

      final daily3 = Daily(
        time: DateTime.parse("2024-11-27"),
        weatherCode: 124, // Different weather code
        temperatureMax: const Value(value: 30.0, unit: "C"),
        temperatureMin: const Value(value: 15.0, unit: "C"),
        apparentTemperatureMax: const Value(value: 32.0, unit: "C"),
        apparentTemperatureMin: const Value(value: 14.0, unit: "C"),
      );

      expect(daily1 == daily2, true); // Equal objects
      expect(daily1 == daily3, false); // Different weather code
    });
  });
}
