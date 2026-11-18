import 'dart:convert';

import 'package:bweather_open_meteo_api/util.dart';
import 'package:bweather_repository/models/forecast.dart';
import 'package:equatable/equatable.dart';

class City extends Equatable {
    final String name, country;
    final String timezone;
    final double? elevation;
    final double latitude, longitude;

    /// State / province, e.g. "Lagos". Optional; helps tell same-named places apart.
    final String? region;

    final Forecast? forecast;

    const City({ required this.name, this.elevation, this.timezone = "auto", required this.country, required this.latitude, required this.longitude, this.forecast, this.region });

    /// Stable identity for a saved place: its coordinate rounded to ~100 m.
    /// Two "Paris" entries in different countries get different ids.
    String get id => "${latitude.toStringAsFixed(3)},${longitude.toStringAsFixed(3)}";

    /// "Ikorodu, Lagos, Nigeria" style label (skips empty parts).
    String get subtitle => [region, country].whereType<String>().where((part) => part.isNotEmpty).join(", ");

    factory City.fromJson(dynamic json) {
        final forecastJson = json["forecast"];
        Forecast? forecast;
        if (forecastJson != null) {
            try {
                forecast = Forecast.fromJson(forecastJson);
            } catch (_) {
                // A cached forecast from an older app version can't be read: drop
                // just the forecast (it will be refetched) and keep the saved city.
                forecast = null;
            }
        }

        return City(
            forecast: forecast,
            name: json["name"].toString(),
            timezone: JsonParser.parseStringOrNull(json, "timezone") ?? "auto",
            country: (json["country"] ?? "").toString(),
            region: JsonParser.parseStringOrNull(json, "region"),
            latitude: JsonParser.parseDouble(json, "latitude"),
            longitude: JsonParser.parseDouble(json, "longitude"),
            elevation: JsonParser.parseDoubleOrNull(json, "elevation"),
        );
    }

    City copyWith({ String? name, String? country, String? region, Forecast? forecast }) => City(
        name: name ?? this.name, country: country ?? this.country, region: region ?? this.region,
        timezone: timezone, elevation: elevation, latitude: latitude, longitude: longitude,
        forecast: forecast ?? this.forecast,
    );

    Map<String, dynamic> toJson() => {
        "name" : name, "timezone": timezone, "elevation": elevation, "country" : country, "latitude": latitude, "longitude": longitude,
        "forecast": forecast?.toJson(),
        if (region != null) "region": region,
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [name, elevation, timezone, country, region, latitude, longitude, forecast];
}
