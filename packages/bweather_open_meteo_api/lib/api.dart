import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bweather_open_meteo_api/air_quality.dart';
import 'package:bweather_open_meteo_api/cities.dart';
import 'package:bweather_open_meteo_api/model.dart';
import 'package:http/http.dart';

/// Exception thrown when locationSearch fails (network error, timeout or non-200).
class LocationRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when getWeather fails (network error, timeout or non-200).
class WeatherRequestFailure implements Exception {}

/// Exception thrown when the weather response for a location can't be read.
class WeatherNotFoundFailure implements Exception {}

/// Name and country for a coordinate, as returned by [WeatherClient.reverseGeocode].
class PlaceName {
    final String name, country;
    final String? region;

    const PlaceName({ required this.name, required this.country, this.region });
}

/// {@template open_meteo_api_client}
/// Dart API Client which wraps the [Open Meteo API](https://open-meteo.com).
/// {@endtemplate}
class WeatherClient {
    static const _baseUrlWeather = 'api.open-meteo.com';
    static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';
    static const _baseUrlAirQuality = 'air-quality-api.open-meteo.com';
    static const _baseUrlArchive = 'archive-api.open-meteo.com';
    static const _baseUrlRadar = 'api.rainviewer.com';
    static const _baseUrlReverse = 'nominatim.openstreetmap.org';
    static const _ipLocationUrl = 'ipapi.co';

    /// Nominatim's usage policy requires an identifying User-Agent.
    /// Browsers ignore this header on web, which is fine.
    static const userAgent = 'BWeather/1.0 (Bsoft Limited)';

    static const requestTimeout = Duration(seconds: 15);

    /// Hours of hourly data to request, starting at the current hour.
    static const forecastHours = 48;

    final Client _httpClient;

    /// {@macro open_meteo_api_client}
    WeatherClient({ Client? httpClient }): _httpClient = httpClient ?? Client();

    /// GET with a timeout; network errors and timeouts become [failure].
    Future<Response> _get(Uri uri, Exception Function() failure, { Map<String, String>? headers, Duration timeout = requestTimeout }) async {
        try {
            return await _httpClient.get(uri, headers: headers).timeout(timeout);
        } on TimeoutException catch (error) {
            log("Request timed out: ${uri.host}${uri.path}", error: error);
            throw failure();
        } on ClientException catch (error) {
            log("Request failed: ${uri.host}${uri.path}", error: error);
            throw failure();
        }
    }

    /// Fetches the forecast [Result] for [city].
    Future<Result> forecast(City city, { required String precipitationUnit, required String tempUnit, required String windSpeedUnit, bool includeMinutely = false }) async {
        final Map<String, String> params = {
            "latitude" : city.latitude.toString(),
            "longitude": city.longitude.toString(),
            if (city.elevation != null) "elevation": city.elevation.toString(),
            "temperature_unit": tempUnit,
            "wind_speed_unit": windSpeedUnit,
            "precipitation_unit": precipitationUnit,
            "current": "temperature_2m,relative_humidity_2m,apparent_temperature,is_day,rain,weather_code,pressure_msl,surface_pressure,wind_speed_10m,wind_direction_10m,wind_gusts_10m,precipitation,cloud_cover",
            "hourly": "temperature_2m,relative_humidity_2m,dew_point_2m,apparent_temperature,precipitation_probability,rain,weather_code,is_day",
            "daily": dailyVariables,
            "forecast_hours": forecastHours.toString(),
            if (includeMinutely) "minutely_15": "precipitation",
            if (includeMinutely) "forecast_minutely_15": "8",
            // "auto" lets Open-Meteo resolve the zone from the coordinates, which is
            // always right even if a cached city has a stale or missing zone name.
            "timezone": "auto",
        };

        final response = await _get(Uri.https(_baseUrlWeather, 'v1/forecast', params), WeatherRequestFailure.new);

        if (response.statusCode != 200) {
            throw WeatherRequestFailure();
        }

        try {
            return Result.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        } catch (error) {
            log("Weather response could not be parsed - ${city.name}", error: error);
            throw WeatherNotFoundFailure();
        }
    }

    /// Daily variables shared by [forecast] and [dailyForecast].
    static const dailyVariables = "weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,precipitation_sum,rain_sum,precipitation_probability_max,wind_speed_10m_max,wind_gusts_10m_max";

    /// How many days ahead the forecast reaches (today included).
    static const maxForecastDays = 16;

    /// Daily forecast between [start] and [end] (place-local dates), for trips.
    /// Both must lie inside the forecast window (up to [maxForecastDays] ahead,
    /// or a few days back); the caller clamps them.
    Future<({Daily daily, DailyUnits units})> dailyForecast({
        required double latitude, required double longitude, required DateTime start, required DateTime end,
        required String precipitationUnit, required String tempUnit, required String windSpeedUnit,
    }) async {
        String date(DateTime d) => "${d.year.toString().padLeft(4, "0")}-${d.month.toString().padLeft(2, "0")}-${d.day.toString().padLeft(2, "0")}";
        final request = Uri.https(_baseUrlWeather, 'v1/forecast', {
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
            "temperature_unit": tempUnit,
            "wind_speed_unit": windSpeedUnit,
            "precipitation_unit": precipitationUnit,
            "daily": dailyVariables,
            "start_date": date(start),
            "end_date": date(end),
            "timezone": "auto",
        });

        final response = await _get(request, WeatherRequestFailure.new);
        if (response.statusCode != 200) {
            throw WeatherRequestFailure();
        }
        try {
            final json = jsonDecode(response.body) as Map<String, dynamic>;
            return (daily: Daily.fromJson(json["daily"]), units: DailyUnits.fromJson(json["daily_units"]));
        } catch (error) {
            log("Daily forecast response could not be parsed", error: error);
            throw WeatherNotFoundFailure();
        }
    }

    /// Daily max/min temperature (°C) between two dates, from the historical archive.
    Future<DailyHistory> dailyHistory({ required double latitude, required double longitude, required DateTime start, required DateTime end }) async {
        String date(DateTime d) => "${d.year.toString().padLeft(4, "0")}-${d.month.toString().padLeft(2, "0")}-${d.day.toString().padLeft(2, "0")}";
        final request = Uri.https(_baseUrlArchive, 'v1/archive', {
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
            "start_date": date(start),
            "end_date": date(end),
            "daily": "temperature_2m_max,temperature_2m_min",
            "timezone": "auto",
        });

        final response = await _get(request, WeatherRequestFailure.new, timeout: const Duration(seconds: 30));
        if (response.statusCode != 200) {
            throw WeatherRequestFailure();
        }
        try {
            return DailyHistory.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        } catch (error) {
            log("Archive response could not be parsed", error: error);
            throw WeatherNotFoundFailure();
        }
    }

    /// Available radar frames (past ~2 hours) from RainViewer's public API.
    Future<RadarFrames> radarFrames() async {
        final response = await _get(Uri.https(_baseUrlRadar, '/public/weather-maps.json'), WeatherRequestFailure.new);
        if (response.statusCode != 200) {
            throw WeatherRequestFailure();
        }
        try {
            return RadarFrames.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        } catch (error) {
            log("Radar response could not be parsed", error: error);
            throw WeatherNotFoundFailure();
        }
    }

    /// Current air quality, UV index and (Europe only) pollen for a coordinate.
    Future<AirQualityResult> airQuality({ required double latitude, required double longitude }) async {
        final request = Uri.https(_baseUrlAirQuality, 'v1/air-quality', {
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
            "current": ["european_aqi", "us_aqi", "pm10", "pm2_5", "dust", "uv_index", ...AirQualityResult.pollenKeys].join(","),
            "timezone": "auto",
        });

        final response = await _get(request, WeatherRequestFailure.new);
        if (response.statusCode != 200) {
            throw WeatherRequestFailure();
        }

        try {
            return AirQualityResult.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        } catch (error) {
            log("Air quality response could not be parsed", error: error);
            throw WeatherNotFoundFailure();
        }
    }

    /// Finds cities matching [query] (`/v1/search?name=(query)`).
    Future<List<City>> locationSearch(String query, { int count = 10, String language = 'en' }) async {
        final request = Uri.https(_baseUrlGeocoding, '/v1/search', { 'name': query, 'count': count.toString(), 'language': language });

        final response = await _get(request, LocationRequestFailure.new);

        if (response.statusCode != 200) {
            throw LocationRequestFailure();
        }

        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (!json.containsKey('results') || (json['results'] as List).isEmpty) {
            throw LocationNotFoundFailure();
        }

        return (json['results'] as List).map((element) => City.fromJson(element)).toList();
    }

    /// Turns a coordinate into a human readable place name using OpenStreetMap Nominatim.
    ///
    /// Only the *name* is taken from here; the coordinate itself is never replaced,
    /// so the forecast is always for exactly where the user is.
    Future<PlaceName> reverseGeocode({ required double latitude, required double longitude, String language = 'en' }) async {
        final request = Uri.https(_baseUrlReverse, '/reverse', {
            'format': 'jsonv2',
            'lat': latitude.toString(),
            'lon': longitude.toString(),
            'zoom': '10',
            'addressdetails': '1',
            'accept-language': language,
        });

        final response = await _get(request, LocationRequestFailure.new, headers: const { 'User-Agent': userAgent });

        if (response.statusCode != 200) {
            throw LocationRequestFailure();
        }

        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final address = (json['address'] as Map?) ?? const {};

        final name = address['city'] ?? address['town'] ?? address['village'] ?? address['hamlet']
            ?? address['suburb'] ?? address['municipality'] ?? address['county'] ?? json['name'];

        if (name == null || name.toString().isEmpty) {
            throw LocationNotFoundFailure();
        }

        return PlaceName(
            name: name.toString(),
            country: (address['country'] ?? '').toString(),
            region: address['state']?.toString(),
        );
    }

    /// Approximate location from the device's IP address. Used only as a
    /// fallback when GPS is unavailable or permission is denied.
    Future<City> currentLocation() async {
        final request = Uri.https(_ipLocationUrl, "/json/");

        final response = await _get(request, LocationRequestFailure.new);

        if (response.statusCode != 200) {
            throw LocationRequestFailure();
        }

        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['error'] == true || !json.containsKey('city') || json['latitude'] == null) {
            throw LocationNotFoundFailure();
        }

        return City.fromJson(json);
    }
}
