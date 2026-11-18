import "dart:convert";

import "package:bweather_repository/bweather_repository.dart";
import "package:bweather/utils/status.dart";
import "package:equatable/equatable.dart";

/// Why the latest forecast request for a place failed.
enum ForecastIssue { none, network, data, unknown }

/// A place shown in the app (the user's location or a saved city) plus the
/// status of its latest forecast request.
class CityState extends Equatable {
    /// Key used for the user's own location.
    static const currentLocationKey = "current";

    /// Stable identity used by the cubit and UI. Never derived from list position.
    final String key;
    final City city;
    /// Reason for the last failure (not persisted).
    final ForecastIssue issue;
    final StateStatus status;

    /// When the forecast was last fetched successfully (device clock).
    final DateTime? updatedAt;

    /// True when the location came from the IP address rather than GPS.
    final bool approximate;

    /// Typical highs/lows here, for "warmer than usual". Fetched once per place.
    final ClimateNormals? normals;

    const CityState({
        required this.key, required this.city, this.status = StateStatus.initial, this.issue = ForecastIssue.none,
        this.updatedAt, this.approximate = false, this.normals,
    });

    /// A saved city, keyed by its coordinates.
    factory CityState.saved(City city) => CityState(key: city.id, city: city);

    /// The user's current location.
    factory CityState.current(City city, { bool approximate = false }) =>
        CityState(key: currentLocationKey, city: city, approximate: approximate);

    bool get isCurrentLocation => key == currentLocationKey;
    bool get hasForecast => city.forecast != null;

    bool isStale(Duration maxAge, [DateTime? now]) =>
        updatedAt == null || (now ?? DateTime.now()).difference(updatedAt!) > maxAge;

    factory CityState.fromJson(dynamic json, { String? fallbackKey }) {
        final city = City.fromJson(json["city"]);
        final status = json["status"].toString().toStateStatus;
        return CityState(
            key: json["key"]?.toString() ?? fallbackKey ?? city.id,
            city: city,
            // A request can't still be running after a restart.
            status: status.isLoading ? StateStatus.initial : status,
            updatedAt: json["updatedAt"] == null ? null : DateTime.tryParse(json["updatedAt"].toString()),
            approximate: json["approximate"] == true,
            normals: _readNormals(json["normals"]),
        );
    }

    static ClimateNormals? _readNormals(dynamic json) {
        if (json == null) return null;
        try {
            return ClimateNormals.fromJson(json);
        } catch (_) {
            return null; // refetched later
        }
    }

    CityState copy({ City? city, StateStatus? status, ForecastIssue? issue, DateTime? updatedAt, bool? approximate, ClimateNormals? normals }) {
        return CityState(
            key: key,
            city: city ?? this.city,
            status: status ?? this.status,
            // A new request clears the previous failure reason unless one is given.
            issue: issue ?? ForecastIssue.none,
            updatedAt: updatedAt ?? this.updatedAt,
            approximate: approximate ?? this.approximate,
            normals: normals ?? this.normals,
        );
    }

    Map<String, dynamic> toJson() => {
        "key": key, "city": city.toJson(), "status": status.serialize,
        "updatedAt": updatedAt?.toIso8601String(), "approximate": approximate,
        if (normals != null) "normals": normals!.toJson(),
    };

    /// Today's forecast high compared with the normal high for today, or null
    /// when either is unknown.
    TemperatureComparison? get comparison {
        final forecast = city.forecast, normals = this.normals;
        if (forecast == null || normals == null) return null;
        final today = forecast.today();
        if (today == null) return null;
        final normalHigh = normals.highFor(today.time);
        if (normalHigh == null) return null;
        final highC = today.temperatureMax.unit.toUpperCase().contains("F")
            ? (today.temperatureMax.value - 32) * 5 / 9
            : today.temperatureMax.value;
        return TemperatureComparison(highC - normalHigh);
    }

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [key, city, status, issue, updatedAt, approximate, normals];
}
