import 'dart:convert';
import 'dart:math' as math;

import 'package:bweather_open_meteo_api/util.dart';
import 'package:bweather_repository/models/air_quality.dart';

import 'package:equatable/equatable.dart';

class Value<T> extends Equatable{
    final T value;
    final String unit;

    const Value({ required this.value, required this.unit });

    factory Value.fromJson(dynamic json) {
        dynamic raw = json["value"];
        // JSON doesn't keep int vs double apart (25.0 can come back as 25), so coerce to T.
        if (raw is num) {
            if (raw is! T) raw = raw.toDouble();
            if (raw is! T) raw = raw.toInt();
        }
        return Value<T>(value: raw as T, unit: json["unit"].toString());
    }

    /// Optional variant: `null` in, `null` out.
    static Value<T>? maybeFromJson<T>(dynamic json) => json == null ? null : Value<T>.fromJson(json);

    Map<String, dynamic> toJson() => { "value": value, "unit": unit };
    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [ value, unit ];
}

class Current extends Equatable{
    final Value<double> temperature, apparentTemperature, windSpeed,  windGusts, precipitation, rain, surfacePressure;
    final Value<int> windDirection, cloudCover, relativeHumidity;
    final bool isDay;
    final int weatherCode;

    final DateTime time;

    const Current({
        required this.windSpeed, required this.windGusts, required this.windDirection, required this.time,
        required this.weatherCode, required this.temperature, required this.surfacePressure, required this.rain,
        required this.relativeHumidity, required this.isDay,
        required this.apparentTemperature, required this.cloudCover, required this.precipitation
    });

    factory Current.fromJson(dynamic json) {
        return Current(
            windSpeed:  Value<double>.fromJson(json["wind_speed"]), windGusts: Value.fromJson(json["wind_gusts"]),
            windDirection: Value<int>.fromJson(json["wind_direction"]), time: JsonParser.parseDate(json, "time"),
            weatherCode: JsonParser.parseInt(json, "weather_code"), temperature: Value.fromJson(json["temperature"]),
            surfacePressure: Value<double>.fromJson(json["surface_pressure"]), rain: Value.fromJson(json["rain"]),
            relativeHumidity: Value.fromJson(json["relative_humidity"]),
            isDay: JsonParser.parseBoolean(json, "is_day"), apparentTemperature: Value.fromJson(json["apparent_temperature"]),
            cloudCover: Value<int>.fromJson(json["cloud_cover"]), precipitation: Value.fromJson(json["precipitation"])
        );
    }

    Map<String, dynamic> toJson() => {
        "wind_speed": windSpeed.toJson(), "wind_gusts": windGusts.toJson(), "wind_direction": windDirection.toJson(),
        "time": time.toString(), "weather_code": weatherCode, "temperature": temperature.toJson(), "surface_pressure": surfacePressure.toJson(),
        "rain": rain.toJson(), "relative_humidity": relativeHumidity.toJson(), "is_day": isDay,
        "apparent_temperature": apparentTemperature.toJson(), "precipitation": precipitation.toJson(), "cloud_cover": cloudCover.toJson()
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        temperature, relativeHumidity, apparentTemperature, windSpeed,  windGusts, precipitation, rain, surfacePressure,
        windDirection, cloudCover, isDay, weatherCode, time
    ];
}

class Hourly extends Equatable{
    final DateTime time;
    final Value<double> temperature, dewPoint, apparentTemperature, rain;
    final Value<int> relativeHumidity, precipitationProbability;
    final int weatherCode;

    /// Whether the sun is up during this hour (null for data cached by older versions).
    final bool? isDay;

    const Hourly({
        required this.time, required this.dewPoint, required this.precipitationProbability,
        required this.weatherCode, required this.temperature, required this.relativeHumidity,
        required this.rain, required this.apparentTemperature, this.isDay
    });

    factory Hourly.fromJson(dynamic json) {
        return Hourly(
            apparentTemperature: Value<double>.fromJson(json["apparent_temperature"]), relativeHumidity: Value<int>.fromJson(json["relative_humidity"]),
            rain: Value<double>.fromJson(json["rain"]), temperature: Value<double>.fromJson(json["temperature"]), weatherCode: JsonParser.parseInt(json, "weather_code"),
            precipitationProbability: Value<int>.fromJson(json["precipitation_probability"]), dewPoint: Value<double>.fromJson(json["dew_point"]),
            time: JsonParser.parseDate(json, "time"), isDay: json["is_day"] == null ? null : JsonParser.parseBoolean(json, "is_day")
        );
    }

    Map<String, dynamic> toJson() => {
        "time": time.toString(), "weather_code": weatherCode, "temperature": temperature.toJson(),
        "rain": rain.toJson(), "relative_humidity": relativeHumidity.toJson(), "apparent_temperature": apparentTemperature.toJson(),
        "precipitation_probability": precipitationProbability.toJson(), "dew_point": dewPoint.toJson(),
        if (isDay != null) "is_day": isDay,
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        time, temperature, dewPoint, apparentTemperature, rain, relativeHumidity, precipitationProbability, weatherCode, isDay
    ];
}


class Daily extends Equatable{
    final DateTime time;
    final int weatherCode;
    final Value<double> temperatureMax, temperatureMin, apparentTemperatureMax, apparentTemperatureMin;

    // Optional extras (null for data cached by older versions of the app).
    final DateTime? sunrise, sunset;
    final Value<double>? precipitationSum, windSpeedMax;
    final Value<int>? precipitationProbabilityMax;

    const Daily({
        required this.temperatureMax, required this.apparentTemperatureMin,
        required this.apparentTemperatureMax, required this.temperatureMin, required this.time,
        required this.weatherCode, this.sunrise, this.sunset, this.precipitationSum,
        this.precipitationProbabilityMax, this.windSpeedMax
    });

    factory Daily.fromJson(dynamic json) {
        return Daily(
            apparentTemperatureMin: Value<double>.fromJson(json["apparent_temperature_min"]), apparentTemperatureMax: Value<double>.fromJson(json["apparent_temperature_max"]),
            weatherCode: JsonParser.parseInt(json, "weather_code"),
            temperatureMin: Value<double>.fromJson(json["temperature_min"]), temperatureMax: Value<double>.fromJson(json["temperature_max"]),
            time: JsonParser.parseDate(json, "time"),
            sunrise: JsonParser.parseDateOrNull(json, "sunrise"), sunset: JsonParser.parseDateOrNull(json, "sunset"),
            precipitationSum: Value.maybeFromJson<double>(json["precipitation_sum"]),
            precipitationProbabilityMax: Value.maybeFromJson<int>(json["precipitation_probability_max"]),
            windSpeedMax: Value.maybeFromJson<double>(json["wind_speed_max"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "time": time.toString(), "weather_code": weatherCode, "apparent_temperature_min": apparentTemperatureMin.toJson(), "apparent_temperature_max": apparentTemperatureMax.toJson(),
        "temperature_min": temperatureMin.toJson(), "temperature_max": temperatureMax.toJson(),
        if (sunrise != null) "sunrise": sunrise.toString(),
        if (sunset != null) "sunset": sunset.toString(),
        if (precipitationSum != null) "precipitation_sum": precipitationSum!.toJson(),
        if (precipitationProbabilityMax != null) "precipitation_probability_max": precipitationProbabilityMax!.toJson(),
        if (windSpeedMax != null) "wind_speed_max": windSpeedMax!.toJson(),
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        temperatureMax, temperatureMin, apparentTemperatureMax, apparentTemperatureMin,
        weatherCode, time, sunrise, sunset, precipitationSum, precipitationProbabilityMax, windSpeedMax
    ];
}

/// Precipitation over a 15-minute step starting at [time] (place-local).
class MinutelyPrecipitation extends Equatable {
    final DateTime time;
    final double precipitation;
    final String unit;

    const MinutelyPrecipitation({ required this.time, required this.precipitation, required this.unit });

    factory MinutelyPrecipitation.fromJson(dynamic json) => MinutelyPrecipitation(
        time: JsonParser.parseDate(json, "time"),
        precipitation: JsonParser.parseDouble(json, "precipitation"),
        unit: json["unit"].toString(),
    );

    Map<String, dynamic> toJson() => { "time": time.toString(), "precipitation": precipitation, "unit": unit };

    @override
    List<Object?> get props => [time, precipitation, unit];
}

class Forecast extends Equatable{
    final int utcOffsetSeconds;

    final Current current;
    final List<Hourly> hourly;
    final List<Daily> daily;

    /// Air quality / UV / pollen; null when unavailable or not fetched yet.
    final AirQuality? airQuality;

    /// Next 2 hours in 15-minute steps; empty unless minute-by-minute rain is on.
    final List<MinutelyPrecipitation> minutely;

    const Forecast({
        required this.utcOffsetSeconds,
        required this.current, required this.hourly, required this.daily,
        this.airQuality, this.minutely = const [],
    });

    Forecast withAirQuality(AirQuality? airQuality) => Forecast(
        utcOffsetSeconds: utcOffsetSeconds, current: current, hourly: hourly, daily: daily, airQuality: airQuality, minutely: minutely,
    );

    /// The 15-minute steps from the current one onwards (at the place).
    List<MinutelyPrecipitation> upcomingMinutely([DateTime? now]) {
        final local = localNow(now);
        return minutely.where((step) => step.time.add(const Duration(minutes: 15)).isAfter(local)).toList();
    }

    /// The UTC offset of the forecast location, e.g. +05:30 for India.
    Duration get utcOffset => Duration(seconds: utcOffsetSeconds);

    /// Wall-clock time *at the forecast location*.
    ///
    /// Open-Meteo returns times without a zone (already in the location's local
    /// time), and they parse as naive local DateTimes. This returns a value built
    /// the same way, so the two can be compared directly.
    DateTime localNow([DateTime? now]) {
        final shifted = (now ?? DateTime.now()).toUtc().add(utcOffset);
        return DateTime(shifted.year, shifted.month, shifted.day, shifted.hour, shifted.minute);
    }

    /// The next [count] hours starting with the current hour at the location.
    List<Hourly> upcomingHours(int count, [DateTime? now]) {
        final local = localNow(now);
        final currentHour = DateTime(local.year, local.month, local.day, local.hour);
        final start = hourly.indexWhere((hour) => !hour.time.isBefore(currentHour));
        if (start == -1) {
            return const [];
        }
        return hourly.sublist(start, math.min(start + count, hourly.length));
    }

    /// The hourly entry for the current hour at the location, if available.
    Hourly? currentHour([DateTime? now]) {
        final hours = upcomingHours(1, now);
        return hours.isEmpty ? null : hours.first;
    }

    /// Whether [hour] is during the night at the location.
    ///
    /// Uses the API's per-hour `is_day`, then that day's sunrise/sunset, and
    /// only as a last resort a fixed 06:00–18:00 day.
    bool isNight(Hourly hour) {
        if (hour.isDay != null) {
            return !hour.isDay!;
        }
        for (final day in daily) {
            final sunrise = day.sunrise, sunset = day.sunset;
            if (sunrise != null && sunset != null && sunrise.year == hour.time.year && sunrise.month == hour.time.month && sunrise.day == hour.time.day) {
                return hour.time.isBefore(sunrise) || !hour.time.isBefore(sunset);
            }
        }
        return hour.time.hour < 6 || hour.time.hour >= 18;
    }

    /// Today's daily entry at the location, if available.
    Daily? today([DateTime? now]) {
        final local = localNow(now);
        for (final day in daily) {
            if (day.time.year == local.year && day.time.month == local.month && day.time.day == local.day) {
                return day;
            }
        }
        return daily.isEmpty ? null : daily.first;
    }

    factory Forecast.fromJson(dynamic json) {
        return Forecast(
            utcOffsetSeconds: JsonParser.parseInt(json, "utc_offset_seconds"),
            current: Current.fromJson(json["current"]),
            hourly: (json["hourly"] as List).map((element)=> Hourly.fromJson(element)).toList(),
            daily: (json["daily"] as List).map((element)=> Daily.fromJson(element)).toList(),
            airQuality: json["airQuality"] == null ? null : AirQuality.fromJson(json["airQuality"]),
            minutely: [for (final step in (json["minutely"] as List? ?? const [])) MinutelyPrecipitation.fromJson(step)],
        );
    }

    Map<String, dynamic> toJson() => {
        "utc_offset_seconds": utcOffsetSeconds,
        "current": current.toJson(),
        "hourly": hourly.map((element)=> element.toJson()).toList(),
        "daily": daily.map((element) => element.toJson()).toList(),
        if (airQuality != null) "airQuality": airQuality!.toJson(),
        if (minutely.isNotEmpty) "minutely": minutely.map((step) => step.toJson()).toList(),
    };

    String serialize() => jsonEncode(toJson());
    
    @override
    List<Object?> get props => [current, utcOffsetSeconds, hourly, daily, airQuality, minutely];
}