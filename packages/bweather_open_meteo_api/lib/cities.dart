import 'dart:convert';

import 'package:bweather_open_meteo_api/util.dart';

class City {
    final String name, country;
    final String timezone;
    final double? elevation;
    final double latitude, longitude;

    /// First-level administrative area (state / province), e.g. "Lagos".
    /// Used to tell apart places that share a name.
    final String? region;

    const City({ required this.name, this.elevation, this.timezone = "auto", required this.country, required this.latitude, required this.longitude, this.region });

    factory City.fromJson(dynamic json) {
        return City(
            name: (json["name"] ?? json["city"]).toString(),
            timezone: JsonParser.parseStringOrNull(json, "timezone") ?? "auto",
            country: (json["country_name"] ?? json["country"] ?? "").toString(),
            region: JsonParser.parseStringOrNull(json, "admin1") ?? JsonParser.parseStringOrNull(json, "region"),
            latitude: JsonParser.parseDouble(json, "latitude"),
            longitude: JsonParser.parseDouble(json, "longitude"),
            elevation: JsonParser.parseDoubleOrNull(json, "elevation"),
        );
    }

    Map<String, dynamic> toJson() => {
        "name" : name, "timezone": timezone, "elevation": elevation, "country" : country, "latitude": latitude, "longitude": longitude,
        if (region != null) "region": region,
    };

    String serialize() => jsonEncode(toJson());

    @override
    bool operator == (Object other) =>
        other is City && other.name == name && other.latitude == latitude && other.longitude == longitude;

    @override
    int get hashCode => Object.hash(name, latitude, longitude);

    @override
    String toString() => "City($name, ${region ?? '-'}, $country, $latitude, $longitude)";
}
