import 'dart:developer';

import 'package:http/http.dart';

import 'package:bweather_open_meteo_api/bweather_open_meteo_api.dart' as api;
import 'package:bweather_repository/models/air_quality.dart';
import 'package:bweather_repository/models/city.dart' as city_model;
import 'package:bweather_repository/models/climate.dart';
import 'package:bweather_repository/models/forecast.dart' as models;
import 'package:bweather_repository/units.dart';

class ForecastRepository {
    final api.WeatherClient _client;

    ForecastRepository({ Client? httpClient }): _client = api.WeatherClient(httpClient: httpClient ?? Client());

    /// Returns [city] with a fresh forecast attached. The city's name, country
    /// and region are kept as-is; coordinates/elevation/timezone come from the API.
    /// [includeMinutely] adds the next 2 hours of precipitation in 15-minute steps.
    Future<city_model.City> getWeather(city_model.City city, { Units units = const Units.defaults(), bool includeMinutely = false }) async {
        final requestCity = api.City(name: city.name, elevation: city.elevation, timezone: city.timezone, country: city.country, latitude: city.latitude, longitude: city.longitude);
        // Air quality is fetched in parallel and is optional: if it fails, the forecast still loads.
        final airQualityFuture = _airQuality(city.latitude, city.longitude);
        final result = await _client.forecast(requestCity, precipitationUnit: units.precipitationUnit.serialize, tempUnit: units.tempUnit.serialize, windSpeedUnit: units.windSpeedUnit.serialize, includeMinutely: includeMinutely);
        final airQuality = await airQualityFuture;

        final current = models.Current(
            apparentTemperature: models.Value(value: result.current.apparentTemperature, unit: result.currentUnits.apparentTemperature),
            windDirection: models.Value(value: result.current.windDirection10m, unit: result.currentUnits.windDirection10m),
            windGusts: models.Value(value: result.current.windGusts10m, unit: result.currentUnits.windGusts10m),
            weatherCode: result.current.weatherCode, time: result.current.time,
            windSpeed: models.Value(value: result.current.windSpeed10m, unit: result.currentUnits.windSpeed10m),
            temperature: models.Value(value: result.current.temperature2m, unit: result.currentUnits.temperature2m),
            surfacePressure: models.Value(value: result.current.surfacePressure, unit: result.currentUnits.surfacePressure),
            relativeHumidity: models.Value(value: result.current.relativeHumidity2m, unit: result.currentUnits.relativeHumidity2m),
            rain: models.Value(value: result.current.rain, unit: result.currentUnits.rain),
            precipitation: models.Value(value: result.current.precipitation, unit: result.currentUnits.precipitation),
            cloudCover: models.Value(value: result.current.cloudCover, unit: result.currentUnits.cloudCover),
            isDay: result.current.isDay == 1
        );

        final daily = _mapDaily(result.daily, result.dailyUnits);

        final h = result.hourly, hu = result.hourlyUnits;
        final hourly = <models.Hourly>[
            for (int i = 0; i < _shortest([h.time, h.weatherCode, h.temperature2m]); i++)
                models.Hourly(
                    time: h.time[i], weatherCode: h.weatherCode[i],
                    temperature: models.Value(value: h.temperature2m[i], unit: hu.temperature2m),
                    dewPoint: models.Value(value: _at(h.dewPoint2m, i) ?? 0.0, unit: hu.dewPoint2m),
                    precipitationProbability: models.Value(value: _at(h.precipitationProbability, i) ?? 0, unit: hu.precipitationProbability),
                    relativeHumidity: models.Value(value: _at(h.relativeHumidity2m, i) ?? 0, unit: hu.relativeHumidity2m),
                    apparentTemperature: models.Value(value: _at(h.apparentTemperature, i) ?? h.temperature2m[i], unit: hu.apparentTemperature),
                    rain: models.Value(value: _at(h.rain, i) ?? 0.0, unit: hu.rain),
                    isDay: _at(h.isDay, i) == null ? null : h.isDay[i] == 1,
                ),
        ];

        final m = result.minutely15;
        final minutely = m == null ? const <models.MinutelyPrecipitation>[] : <models.MinutelyPrecipitation>[
            for (int i = 0; i < _shortest([m.time, m.precipitation]); i++)
                models.MinutelyPrecipitation(time: m.time[i], precipitation: m.precipitation[i], unit: m.unit),
        ];

        final forecast = models.Forecast(
            utcOffsetSeconds: result.utcOffsetSeconds, current: current, daily: daily, hourly: hourly,
            airQuality: airQuality, minutely: minutely,
        );

        return city_model.City(
            name: city.name, country: city.country, region: city.region,
            timezone: result.timezone, elevation: result.elevation,
            // Keep the requested coordinates rather than the API's grid cell, so the
            // place's id (derived from its coordinates) stays stable across refreshes.
            latitude: city.latitude, longitude: city.longitude, forecast: forecast,
        );
    }

    /// Years of history averaged into climate normals.
    static const normalsYears = 20;

    /// Typical daily highs/lows (°C) for a place over the last [normalsYears]
    /// complete years. One request (~7,300 days); cache the result per place.
    Future<ClimateNormals> climateNormals({ required double latitude, required double longitude, DateTime? now }) async {
        final year = (now ?? DateTime.now()).year;
        final history = await _client.dailyHistory(
            latitude: latitude, longitude: longitude,
            start: DateTime(year - normalsYears), end: DateTime(year - 1, 12, 31),
        );
        final normals = ClimateNormals.fromDaily(dates: history.time, maxima: history.maxima, minima: history.minima);
        if (normals.toYear == 0) throw api.WeatherNotFoundFailure();
        return normals;
    }

    /// Radar frames from RainViewer (past ~2 hours, oldest first).
    Future<api.RadarFrames> radarFrames() => _client.radarFrames();

    /// Daily forecast for a place between two dates (place-local), clamped to
    /// what the forecast covers: [api.WeatherClient.maxForecastDays] ahead and
    /// [pastDays] back. Returns an empty list when the range is entirely outside.
    /// [today] is the date at the place; defaults to the device date.
    Future<List<models.Daily>> dailyForecast(city_model.City city, { required DateTime start, required DateTime end, Units units = const Units.defaults(), DateTime? today }) async {
        final range = forecastWindow(start: start, end: end, today: today);
        if (range == null) return const [];
        final result = await _client.dailyForecast(
            latitude: city.latitude, longitude: city.longitude, start: range.start, end: range.end,
            precipitationUnit: units.precipitationUnit.serialize, tempUnit: units.tempUnit.serialize, windSpeedUnit: units.windSpeedUnit.serialize,
        );
        return _mapDaily(result.daily, result.units);
    }

    /// How many days ahead the forecast reaches (today included).
    static const forecastDays = api.WeatherClient.maxForecastDays;

    /// Days before today that a trip view still asks the forecast API for.
    static const pastDays = 7;

    /// The part of [start]..[end] the forecast API can answer, or null.
    static ({DateTime start, DateTime end})? forecastWindow({ required DateTime start, required DateTime end, DateTime? today }) {
        final now = today ?? DateTime.now();
        final first = DateTime(now.year, now.month, now.day - pastDays);
        final last = DateTime(now.year, now.month, now.day + api.WeatherClient.maxForecastDays - 1);
        final from = DateTime(start.year, start.month, start.day), to = DateTime(end.year, end.month, end.day);
        final clampedStart = from.isBefore(first) ? first : from;
        final clampedEnd = to.isAfter(last) ? last : to;
        if (clampedEnd.isBefore(clampedStart)) return null;
        return (start: clampedStart, end: clampedEnd);
    }

    static List<models.Daily> _mapDaily(api.Daily d, api.DailyUnits du) => <models.Daily>[
            for (int i = 0; i < _shortest([d.time, d.weatherCode, d.temperature2mMax, d.temperature2mMin, d.apparentTemperatureMax, d.apparentTemperatureMin]); i++)
                models.Daily(
                    time: d.time[i], weatherCode: d.weatherCode[i],
                    apparentTemperatureMax: models.Value(value: d.apparentTemperatureMax[i], unit: du.apparentTemperatureMax),
                    apparentTemperatureMin: models.Value(value: d.apparentTemperatureMin[i], unit: du.apparentTemperatureMin),
                    temperatureMax: models.Value(value: d.temperature2mMax[i], unit: du.temperature2mMax),
                    temperatureMin: models.Value(value: d.temperature2mMin[i], unit: du.temperature2mMin),
                    sunrise: _at(d.sunrise, i),
                    sunset: _at(d.sunset, i),
                    precipitationSum: _value(_at(d.precipitationSum, i), du.precipitationSum),
                    precipitationProbabilityMax: _value(_at(d.precipitationProbabilityMax, i), du.precipitationProbabilityMax),
                    windSpeedMax: _value(_at(d.windSpeed10mMax, i), du.windSpeed10mMax),
                ),
    ];

    Future<AirQuality?> _airQuality(double latitude, double longitude) async {
        try {
            final result = await _client.airQuality(latitude: latitude, longitude: longitude);
            final airQuality = AirQuality(
                usAqi: result.usAqi, europeanAqi: result.europeanAqi, pm25: result.pm25, pm10: result.pm10,
                dust: result.dust, uvIndex: result.uvIndex, pollen: result.pollen,
            );
            return airQuality.isEmpty ? null : airQuality;
        } catch (error) {
            log("Air quality unavailable", error: error);
            return null;
        }
    }

    /// Cities whose name matches [query]. Throws [api.LocationNotFoundFailure] when nothing matches.
    Future<List<city_model.City>> search(String query) async {
        final locations = await _client.locationSearch(query.trim());

        return locations.map((location) => city_model.City(
            name: location.name, country: location.country, region: location.region, elevation: location.elevation,
            timezone: location.timezone, latitude: location.latitude, longitude: location.longitude
        )).toList();
    }

    /// A [city_model.City] for the exact GPS coordinate.
    ///
    /// The forecast is always requested for these coordinates; reverse geocoding
    /// only supplies a display name. If naming fails, the place is still usable
    /// as "My location".
    Future<city_model.City> locate({ required double latitude, required double longitude }) async {
        String name = "My location", country = "";
        String? region;
        try {
            final place = await _client.reverseGeocode(latitude: latitude, longitude: longitude);
            name = place.name;
            country = place.country;
            region = place.region;
        } catch (error) {
            log("Reverse geocoding failed; using a generic name", error: error);
        }

        return city_model.City(name: name, country: country, region: region, latitude: latitude, longitude: longitude);
    }

    /// Approximate location from the device's IP address (city level).
    /// Fallback for when GPS is off or permission is denied.
    Future<city_model.City> approximateLocation() async {
        final location = await _client.currentLocation();

        return city_model.City(
            name: location.name, country: location.country, region: location.region, elevation: location.elevation,
            timezone: location.timezone, latitude: location.latitude, longitude: location.longitude
        );
    }

    static int _shortest(List<List<Object>> lists) =>
        lists.map((list) => list.length).reduce((a, b) => a < b ? a : b);

    static T? _at<T>(List<T> list, int index) => index < list.length ? list[index] : null;

    static models.Value<T>? _value<T>(T? value, String unit) => value == null ? null : models.Value<T>(value: value, unit: unit);
}
