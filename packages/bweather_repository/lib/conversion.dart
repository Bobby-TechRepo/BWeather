import 'package:bweather_repository/models/city.dart';
import 'package:bweather_repository/models/forecast.dart';
import 'package:bweather_repository/units.dart';

/// Converts temperatures, wind speeds and precipitation between units on the
/// device, so changing units in Settings needs no new request.
///
/// Values are recognised by their unit label, exactly as Open-Meteo writes
/// them: "°C"/"°F", "km/h"/"mp/h"/"m/s"/"kn", "mm"/"inch". Anything else
/// (%, °, hPa…) is left alone.
class UnitConverter {
    const UnitConverter._();

    static String temperatureLabel(TempUnit unit) => switch (unit) {
        TempUnit.celsius => "°C",
        TempUnit.fahrenheit => "°F",
    };

    static String windLabel(WindSpeedUnit unit) => switch (unit) {
        WindSpeedUnit.kmh => "km/h",
        WindSpeedUnit.mph => "mp/h",
        WindSpeedUnit.ms => "m/s",
        WindSpeedUnit.kn => "kn",
    };

    static String precipitationLabel(PrecipitationUnit unit) => switch (unit) {
        PrecipitationUnit.mm => "mm",
        PrecipitationUnit.inch => "inch",
    };

    /// Converts [value] (in [unit]) to [units]. Returns the new value and label,
    /// or the input unchanged when the unit isn't a temperature, speed or amount.
    static (double, String) convert(double value, String unit, Units units) {
        final key = unit.toLowerCase().replaceAll(" ", "");

        // Temperature, via °C.
        if (key == "°c" || key == "°f") {
            final celsius = key == "°f" ? (value - 32) * 5 / 9 : value;
            return units.tempUnit == TempUnit.fahrenheit
                ? (_round(celsius * 9 / 5 + 32), temperatureLabel(units.tempUnit))
                : (_round(celsius), temperatureLabel(units.tempUnit));
        }

        // Wind speed, via km/h.
        final toKmh = switch (key) {
            "km/h" || "kmh" => 1.0,
            "mp/h" || "mph" => 1.609344,
            "m/s" || "ms" => 3.6,
            "kn" || "kt" || "knots" => 1.852,
            _ => null,
        };
        if (toKmh != null) {
            final kmh = value * toKmh;
            final out = switch (units.windSpeedUnit) {
                WindSpeedUnit.kmh => kmh,
                WindSpeedUnit.mph => kmh / 1.609344,
                WindSpeedUnit.ms => kmh / 3.6,
                WindSpeedUnit.kn => kmh / 1.852,
            };
            return (_round(out), windLabel(units.windSpeedUnit));
        }

        // Precipitation, via mm.
        final toMm = switch (key) {
            "mm" => 1.0,
            "inch" || "in" || "inches" => 25.4,
            _ => null,
        };
        if (toMm != null) {
            final mm = value * toMm;
            final out = units.precipitationUnit == PrecipitationUnit.inch ? mm / 25.4 : mm;
            return (_round(out), precipitationLabel(units.precipitationUnit));
        }

        return (value, unit);
    }

    static Value<double> value(Value<double> input, Units units) {
        final (converted, label) = convert(input.value, input.unit, units);
        return (converted == input.value && label == input.unit) ? input : Value(value: converted, unit: label);
    }

    static Value<double>? maybe(Value<double>? input, Units units) => input == null ? null : value(input, units);

    /// Keeps repeated conversions from piling up floating-point noise, while
    /// staying precise enough that converting back gives the original value.
    static double _round(double value) => (value * 10000).roundToDouble() / 10000;
}

extension CurrentConversion on Current {
    Current convertedTo(Units units) => Current(
        time: time, weatherCode: weatherCode, isDay: isDay,
        temperature: UnitConverter.value(temperature, units),
        apparentTemperature: UnitConverter.value(apparentTemperature, units),
        windSpeed: UnitConverter.value(windSpeed, units),
        windGusts: UnitConverter.value(windGusts, units),
        precipitation: UnitConverter.value(precipitation, units),
        rain: UnitConverter.value(rain, units),
        surfacePressure: surfacePressure, windDirection: windDirection,
        cloudCover: cloudCover, relativeHumidity: relativeHumidity,
    );
}

extension HourlyConversion on Hourly {
    Hourly convertedTo(Units units) => Hourly(
        time: time, weatherCode: weatherCode, isDay: isDay,
        temperature: UnitConverter.value(temperature, units),
        apparentTemperature: UnitConverter.value(apparentTemperature, units),
        dewPoint: UnitConverter.value(dewPoint, units),
        rain: UnitConverter.value(rain, units),
        relativeHumidity: relativeHumidity, precipitationProbability: precipitationProbability,
    );
}

extension DailyConversion on Daily {
    Daily convertedTo(Units units) => Daily(
        time: time, weatherCode: weatherCode, sunrise: sunrise, sunset: sunset,
        temperatureMax: UnitConverter.value(temperatureMax, units),
        temperatureMin: UnitConverter.value(temperatureMin, units),
        apparentTemperatureMax: UnitConverter.value(apparentTemperatureMax, units),
        apparentTemperatureMin: UnitConverter.value(apparentTemperatureMin, units),
        precipitationSum: UnitConverter.maybe(precipitationSum, units),
        windSpeedMax: UnitConverter.maybe(windSpeedMax, units),
        precipitationProbabilityMax: precipitationProbabilityMax,
    );
}

extension MinutelyConversion on MinutelyPrecipitation {
    MinutelyPrecipitation convertedTo(Units units) {
        final (value, label) = UnitConverter.convert(precipitation, unit, units);
        return MinutelyPrecipitation(time: time, precipitation: value, unit: label);
    }
}

extension ForecastConversion on Forecast {
    /// The same forecast with every temperature, speed and amount in [units].
    Forecast convertedTo(Units units) => Forecast(
        utcOffsetSeconds: utcOffsetSeconds,
        current: current.convertedTo(units),
        hourly: [for (final hour in hourly) hour.convertedTo(units)],
        daily: [for (final day in daily) day.convertedTo(units)],
        airQuality: airQuality,
        minutely: [for (final step in minutely) step.convertedTo(units)],
    );
}

extension CityConversion on City {
    City convertedTo(Units units) {
        final forecast = this.forecast;
        return forecast == null ? this : copyWith(forecast: forecast.convertedTo(units));
    }
}
