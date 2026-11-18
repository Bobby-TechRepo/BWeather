import 'dart:convert';

import 'package:bweather_open_meteo_api/util.dart';
import 'package:equatable/equatable.dart';

class CurrentUnits extends Equatable{
    final String temperature2m, relativeHumidity2m, apparentTemperature, rain, pressureMsl;
    final String surfacePressure, windSpeed10m, windDirection10m, windGusts10m, precipitation, cloudCover;

    const CurrentUnits({
        required this.apparentTemperature, required this.pressureMsl,
        required this.rain, required this.relativeHumidity2m, required this.surfacePressure, required this.temperature2m,
        required this.windDirection10m, required this.windGusts10m,
        required this.windSpeed10m, required this.cloudCover, required this.precipitation
    });

    factory CurrentUnits.fromJson(dynamic json) {
        return CurrentUnits(
            apparentTemperature: json["apparent_temperature"].toString(),
            pressureMsl: json["pressure_msl"].toString(), rain: json["rain"].toString(),
            relativeHumidity2m: json["relative_humidity_2m"].toString(), surfacePressure: json["surface_pressure"].toString(),
            temperature2m: json["temperature_2m"].toString(),
            windDirection10m: json["wind_direction_10m"].toString(), windGusts10m: json["wind_gusts_10m"].toString(),
            windSpeed10m: json["wind_speed_10m"].toString(), precipitation: json["precipitation"].toString(), cloudCover: json["cloud_cover"].toString()
        );
    }

    Map<String, dynamic> toJson() => {
        "apparent_temperature" : apparentTemperature, "surface_pressure": surfacePressure,
        "pressure_msl": pressureMsl, "rain": rain, "relative_humidity_2m": relativeHumidity2m, "temperature_2m": temperature2m,
        "wind_direction_10m": windDirection10m, "wind_gusts_10m": windGusts10m,
        "wind_speed_10m": windSpeed10m, "precipitation": precipitation, "cloud_cover": cloudCover
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        temperature2m, relativeHumidity2m, apparentTemperature, rain, pressureMsl,
        surfacePressure, windSpeed10m, windDirection10m, windGusts10m, precipitation, cloudCover
    ];
}

class Current extends Equatable{
    final DateTime time;
    final int isDay, weatherCode, relativeHumidity2m, windDirection10m,cloudCover;
    final double temperature2m, apparentTemperature, precipitation, rain, pressureMsl, surfacePressure, windSpeed10m;
    final double windGusts10m;

    const Current({
        required this.windSpeed10m, required this.windGusts10m, required this.windDirection10m, required this.time,
        required this.weatherCode, required this.temperature2m, required this.surfacePressure, required this.rain,
        required this.relativeHumidity2m, required this.pressureMsl, required this.isDay,
        required this.apparentTemperature, required this.cloudCover, required this.precipitation
    });

    factory Current.fromJson(dynamic json) {
        return Current(
            windSpeed10m: JsonParser.parseDouble(json, "wind_speed_10m"), windGusts10m: JsonParser.parseDouble(json, "wind_gusts_10m"),
            windDirection10m: JsonParser.parseInt(json, "wind_direction_10m"), time: JsonParser.parseDate(json, "time"),
            weatherCode: JsonParser.parseInt(json, "weather_code"), temperature2m: JsonParser.parseDouble(json, "temperature_2m"),
            surfacePressure: JsonParser.parseDouble(json, "surface_pressure"), rain: JsonParser.parseDouble(json, "rain"),
            relativeHumidity2m: JsonParser.parseInt(json, "relative_humidity_2m"), pressureMsl: JsonParser.parseDouble(json, "pressure_msl"),
            isDay: JsonParser.parseInt(json, "is_day"), apparentTemperature: JsonParser.parseDouble(json, "apparent_temperature"),
            cloudCover: JsonParser.parseInt(json, "cloud_cover"), precipitation: JsonParser.parseDouble(json, "precipitation")
        );
    }

    Map<String, dynamic> toJson() => {
        "wind_speed_10m": windSpeed10m, "wind_gusts_10m": windGusts10m, "wind_direction_10m": windDirection10m,
        "time": time.toString(), "weather_code": weatherCode, "temperature_2m": temperature2m, "surface_pressure": surfacePressure,
        "rain": rain, "relative_humidity_2m": relativeHumidity2m, "pressure_msl": pressureMsl, "is_day": isDay,
        "apparent_temperature": apparentTemperature, "precipitation": precipitation, "cloud_cover": cloudCover
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        time,
        temperature2m, relativeHumidity2m, apparentTemperature, precipitation, rain, pressureMsl, surfacePressure, windSpeed10m,
        weatherCode, windGusts10m, isDay, windDirection10m,cloudCover
    ];
}

class HourlyUnits extends Equatable{
    final String temperature2m, relativeHumidity2m, dewPoint2m, apparentTemperature;
    final String precipitationProbability, rain;

    const HourlyUnits({
        required this.apparentTemperature, required this.relativeHumidity2m, required this.rain,
        required this.temperature2m, required this.precipitationProbability,
        required this.dewPoint2m
    });

    factory HourlyUnits.fromJson(dynamic json) {
        return HourlyUnits(
            apparentTemperature: JsonParser.parseString(json, "apparent_temperature"), relativeHumidity2m: JsonParser.parseString(json, "relative_humidity_2m"),
            rain: JsonParser.parseString(json, "rain"), temperature2m: JsonParser.parseString(json, "temperature_2m"),
            precipitationProbability: JsonParser.parseString(json, "precipitation_probability"), dewPoint2m: JsonParser.parseString(json, "dew_point_2m")
        );
    }

    Map<String, dynamic> toJson() => {
        "temperature_2m": temperature2m,
        "rain": rain, "relative_humidity_2m": relativeHumidity2m, "apparent_temperature": apparentTemperature,
        "precipitation_probability": precipitationProbability, "dew_point_2m": dewPoint2m,
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        temperature2m, dewPoint2m, apparentTemperature, rain,
        relativeHumidity2m, precipitationProbability
    ];
}

class Hourly extends Equatable{
    final List<DateTime> time;
    final List<double> temperature2m, dewPoint2m, apparentTemperature, rain;
    final List<int> relativeHumidity2m, precipitationProbability, weatherCode;

    /// 1 when the sun is up for that hour, 0 otherwise. Empty if not requested.
    final List<int> isDay;

    const Hourly({
        required this.time, required this.dewPoint2m, required this.precipitationProbability,
        required this.weatherCode, required this.temperature2m, required this.relativeHumidity2m,
        required this.rain, required this.apparentTemperature, this.isDay = const []
    });

    factory Hourly.fromJson(dynamic json) {
        return Hourly(
            apparentTemperature: JsonParser.parseDoubleList(json, "apparent_temperature"), relativeHumidity2m: JsonParser.parseIntList(json, "relative_humidity_2m"),
            rain: JsonParser.parseDoubleList(json, "rain"), temperature2m: JsonParser.parseDoubleList(json, "temperature_2m"), weatherCode: JsonParser.parseIntList(json, "weather_code"),
            precipitationProbability: JsonParser.parseIntList(json, "precipitation_probability"), dewPoint2m: JsonParser.parseDoubleList(json, "dew_point_2m"),
            time: JsonParser.parseDateList(json, "time"), isDay: JsonParser.parseIntList(json, "is_day")
        );
    }

    Map<String, dynamic> toJson() => {
        "time": time.map((element)=> element.toString()).toList(), "weather_code": weatherCode, "temperature_2m": temperature2m,
        "rain": rain, "relative_humidity_2m": relativeHumidity2m, "apparent_temperature": apparentTemperature,
        "precipitation_probability": precipitationProbability, "dew_point_2m": dewPoint2m, "is_day": isDay,
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        time, temperature2m, dewPoint2m, apparentTemperature, rain,
        relativeHumidity2m, precipitationProbability, weatherCode, isDay
    ];
}

class DailyUnits extends Equatable{
    final String temperature2mMax, temperature2mMin, apparentTemperatureMax, apparentTemperatureMin;
    final String precipitationSum, rainSum, windSpeed10mMax, windGusts10mMax;
    final String precipitationProbabilityMax;

    const DailyUnits({
        required this.apparentTemperatureMax,
        required this.apparentTemperatureMin, required this.precipitationSum, required this.temperature2mMax,
        required this.rainSum, required this.temperature2mMin, required this.windGusts10mMax,
        required this.windSpeed10mMax, this.precipitationProbabilityMax = "%"
    });

    factory DailyUnits.fromJson(dynamic json) {
        return DailyUnits(
            apparentTemperatureMin: JsonParser.parseString(json, "apparent_temperature_min"), apparentTemperatureMax: JsonParser.parseString(json, "apparent_temperature_max"),
            temperature2mMin: JsonParser.parseString(json, "temperature_2m_min"), temperature2mMax: JsonParser.parseString(json, "temperature_2m_max"),
            precipitationSum: JsonParser.parseString(json, "precipitation_sum"), rainSum: JsonParser.parseString(json, "rain_sum"),
            windGusts10mMax: JsonParser.parseString(json, "wind_gusts_10m_max"), windSpeed10mMax: JsonParser.parseString(json, "wind_speed_10m_max"),
            precipitationProbabilityMax: JsonParser.parseStringOrNull(json, "precipitation_probability_max") ?? "%"
        );
    }

    Map<String, dynamic> toJson() => {
        "apparent_temperature_min": apparentTemperatureMin, "apparent_temperature_max": apparentTemperatureMax,
        "temperature_2m_min": temperature2mMin, "temperature_2m_max": temperature2mMax,
        "precipitation_sum": precipitationSum, "rain_sum": rainSum, "wind_gusts_10m_max": windGusts10mMax, "wind_speed_10m_max": windSpeed10mMax
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        temperature2mMax, temperature2mMin, apparentTemperatureMax, apparentTemperatureMin,
        precipitationSum, rainSum, windSpeed10mMax, windGusts10mMax
    ];
}

class Daily extends Equatable{
    final List<DateTime> time, sunrise, sunset;
    final List<int> weatherCode;
    final List<double> temperature2mMax, temperature2mMin, apparentTemperatureMax, apparentTemperatureMin;
    final List<double> precipitationSum, rainSum, windSpeed10mMax, windGusts10mMax;
    final List<int> precipitationProbabilityMax;

    const Daily({
        required this.windSpeed10mMax, required this.windGusts10mMax, required this.sunset, required this.rainSum,
        required this.temperature2mMax, required this.precipitationSum, required this.apparentTemperatureMin,
        required this.sunrise, required this.apparentTemperatureMax, required this.temperature2mMin, required this.time,
        required this.weatherCode, this.precipitationProbabilityMax = const []
    });

    factory Daily.fromJson(dynamic json) {
        return Daily(
            apparentTemperatureMin: JsonParser.parseDoubleList(json, "apparent_temperature_min"), apparentTemperatureMax: JsonParser.parseDoubleList(json, "apparent_temperature_max"),
            sunrise: JsonParser.parseDateList(json, "sunrise"), sunset: JsonParser.parseDateList(json, "sunset"), weatherCode: JsonParser.parseIntList(json, "weather_code"),
            temperature2mMin: JsonParser.parseDoubleList(json, "temperature_2m_min"), temperature2mMax: JsonParser.parseDoubleList(json, "temperature_2m_max"),
            time: JsonParser.parseDateList(json, "time"), precipitationSum: JsonParser.parseDoubleList(json, "precipitation_sum"), rainSum: JsonParser.parseDoubleList(json, "rain_sum"),
            windGusts10mMax: JsonParser.parseDoubleList(json, "wind_gusts_10m_max"), windSpeed10mMax: JsonParser.parseDoubleList(json, "wind_speed_10m_max"),
            precipitationProbabilityMax: JsonParser.parseIntList(json, "precipitation_probability_max")
        );
    }

    Map<String, dynamic> toJson() => {
        "time": time.map((element)=> element.toString()).toList(), "weather_code": weatherCode, "apparent_temperature_min": apparentTemperatureMin, "apparent_temperature_max": apparentTemperatureMax,
        "sunset": sunset.map((element)=> element.toString()).toList(), "sunrise": sunrise.map((element)=> element.toString()).toList(), "temperature_2m_min": temperature2mMin, "temperature_2m_max": temperature2mMax,
        "precipitation_sum": precipitationSum, "rain_sum": rainSum, "wind_gusts_10m_max": windGusts10mMax, "wind_speed_10m_max": windSpeed10mMax,
        "precipitation_probability_max": precipitationProbabilityMax
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        temperature2mMax, temperature2mMin, apparentTemperatureMax, apparentTemperatureMin,
        precipitationSum, rainSum, windSpeed10mMax, windGusts10mMax, time, sunrise, sunset,
        weatherCode, precipitationProbabilityMax
    ];
}

class Result extends Equatable{
    final double latitude, longitude, elevation;
    final int utcOffsetSeconds;
    final String timezone, timezoneAbbreviation;

    final CurrentUnits currentUnits;
    final Current current;

    final HourlyUnits hourlyUnits;
    final Hourly hourly;

    final DailyUnits dailyUnits;
    final Daily daily;

    /// 15-minute precipitation for the next 2 hours; null unless requested.
    final Minutely15? minutely15;

    const Result({
        required this.latitude, required this.longitude, required this.elevation,
        required this.timezone, required this.timezoneAbbreviation, required this.utcOffsetSeconds,
        required this.currentUnits, required this.current,
        required this.hourlyUnits, required this.hourly,
        required this.dailyUnits, required this.daily, this.minutely15,
    });

    factory Result.fromJson(dynamic json) {
        return Result(
            latitude: JsonParser.parseDouble(json, "latitude"), longitude: JsonParser.parseDouble(json, "longitude"),
            elevation: JsonParser.parseDouble(json, "elevation"), timezone: JsonParser.parseString(json, "timezone"),
            timezoneAbbreviation: JsonParser.parseString(json, "timezone_abbreviation"),
            utcOffsetSeconds: JsonParser.parseInt(json, "utc_offset_seconds"),
            currentUnits: CurrentUnits.fromJson(json["current_units"]), current: Current.fromJson(json["current"]),
            hourlyUnits: HourlyUnits.fromJson(json["hourly_units"]), hourly: Hourly.fromJson(json["hourly"]),
            dailyUnits: DailyUnits.fromJson(json["daily_units"]), daily: Daily.fromJson(json["daily"]),
            minutely15: json["minutely_15"] == null ? null : Minutely15.fromJson(json["minutely_15"], json["minutely_15_units"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "latitude": latitude, "longitude": longitude, "elevation": elevation,
        "timezone": timezone, "timezone_abbreviation": timezoneAbbreviation, "utc_offset_seconds": utcOffsetSeconds,
        "current_units": currentUnits.toJson(), "current": current.toJson(), "hourly_units": hourlyUnits.toJson(), "hourly": hourly.toJson(),
        "daily_units": dailyUnits.toJson(), "daily": daily.toJson()
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [
        latitude, longitude, elevation, timezone, timezoneAbbreviation, utcOffsetSeconds,
        current, currentUnits, dailyUnits, daily, hourly, hourlyUnits, minutely15
    ];
}

/// Precipitation in 15-minute steps (`minutely_15=precipitation`).
///
/// Open-Meteo has true 15-minute data for central Europe and North America;
/// elsewhere the values are interpolated from hourly forecasts.
class Minutely15 extends Equatable {
    final List<DateTime> time;
    final List<double> precipitation;
    final String unit;

    const Minutely15({ required this.time, required this.precipitation, this.unit = "mm" });

    factory Minutely15.fromJson(dynamic json, dynamic units) => Minutely15(
        time: JsonParser.parseDateList(json, "time"),
        precipitation: JsonParser.parseDoubleList(json, "precipitation"),
        unit: (units is Map ? units["precipitation"] : null)?.toString() ?? "mm",
    );

    @override
    List<Object?> get props => [time, precipitation, unit];
}

/// Daily maximum/minimum temperatures (°C) from the historical archive.
class DailyHistory {
    final List<DateTime> time;
    /// Null where the archive has no value for a day.
    final List<double?> maxima, minima;

    const DailyHistory({ required this.time, required this.maxima, required this.minima });

    factory DailyHistory.fromJson(Map<String, dynamic> json) {
        final daily = json["daily"];
        return DailyHistory(
            time: JsonParser.parseDateList(daily, "time"),
            maxima: JsonParser.parseNullableDoubleList(daily, "temperature_2m_max"),
            minima: JsonParser.parseNullableDoubleList(daily, "temperature_2m_min"),
        );
    }
}

/// Radar frames from RainViewer's public weather-maps API (past ~2 hours).
class RadarFrames {
    final String host;

    /// (unix time in seconds, tile path), oldest first.
    final List<({int time, String path})> past;

    const RadarFrames({ required this.host, required this.past });

    factory RadarFrames.fromJson(Map<String, dynamic> json) {
        final radar = (json["radar"] as Map?) ?? const {};
        final past = (radar["past"] as List? ?? const [])
            .whereType<Map>()
            .map((frame) => (time: int.parse(frame["time"].toString()), path: frame["path"].toString()))
            .toList();
        return RadarFrames(host: json["host"]?.toString() ?? "https://tilecache.rainviewer.com", past: past);
    }
}
