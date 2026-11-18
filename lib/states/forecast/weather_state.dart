import 'dart:convert';
import 'dart:developer';

import 'package:bweather/states/forecast/city_state.dart';
import 'package:bweather/utils/status.dart';
import 'package:equatable/equatable.dart';

/// Why the user's location couldn't be determined.
enum LocationIssue { none, serviceDisabled, permissionDenied, permissionDeniedForever, unavailable }

class WeatherState extends Equatable {
    /// Bump when the persisted shape changes in a way old data can't be read.
    static const schemaVersion = 2;

    final CityState? location;
    final List<CityState> cities;

    /// Status of *finding the user's location* (forecasts have their own per-city status).
    final StateStatus status;
    final LocationIssue locationIssue;

    /// Whether the user has finished the welcome screen (picked GPS, an
    /// approximate location or a city). Persisted.
    final bool onboarded;

    const WeatherState({
        this.location, this.cities = const [], this.status = StateStatus.initial,
        this.locationIssue = LocationIssue.none, this.onboarded = false,
    });

    bool get hasLocation => location != null;

    /// Everything shown in the forecast pager, in order: location first.
    List<CityState> get places => [?location, ...cities];

    bool get hasPlaces => location != null || cities.isNotEmpty;


    CityState? place(String key) {
        if (location?.key == key) return location;
        for (final city in cities) {
            if (city.key == key) return city;
        }
        return null;
    }

    int indexOfPlace(String key) => places.indexWhere((place) => place.key == key);

    factory WeatherState.fromJson(Map<String, dynamic> json) {
        CityState? location;
        if (json["location"] != null) {
            try {
                location = CityState.fromJson(json["location"], fallbackKey: CityState.currentLocationKey);
            } catch (error) {
                log("Dropping unreadable saved location", error: error);
            }
        }

        // Parse each saved city on its own so one bad entry doesn't lose the rest.
        final cities = <CityState>[];
        for (final element in (json["cities"] as List? ?? const [])) {
            try {
                final city = CityState.fromJson(element);
                if (cities.every((existing) => existing.key != city.key)) {
                    cities.add(city);
                }
            } catch (error) {
                log("Dropping unreadable saved city", error: error);
            }
        }

        // Users upgrading from a version without onboarding already have places saved.
        final onboarded = json.containsKey("onboarded")
            ? json["onboarded"] == true
            : (location != null || cities.isNotEmpty);

        return WeatherState(location: location, cities: cities, onboarded: onboarded);
    }

    WeatherState copy({ CityState? location, bool clearLocation = false, List<CityState>? cities, StateStatus? status, LocationIssue? locationIssue, bool? onboarded }) {
        return WeatherState(
            location: clearLocation ? null : (location ?? this.location),
            cities: cities ?? this.cities,
            status: status ?? this.status,
            locationIssue: locationIssue ?? this.locationIssue,
            onboarded: onboarded ?? this.onboarded,
        );
    }

    Map<String, dynamic> toJson() => {
        "version": schemaVersion,
        "onboarded": onboarded,
        "location": location?.toJson(),
        "cities": cities.map((element) => element.toJson()).toList(),
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [location, cities, status, locationIssue, onboarded];
}
