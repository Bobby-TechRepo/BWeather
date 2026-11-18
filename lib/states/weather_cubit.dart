import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bweather/services/location_service.dart';
import 'package:bweather/states/forecast/city_state.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/settings_cubit.dart';
import 'package:bweather/utils/status.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Owns the user's location, their saved cities and every forecast.
///
/// Places are always addressed by [CityState.key], never by list position, so
/// adding/removing cities while requests are in flight can't corrupt state.
class WeatherCubit extends HydratedCubit<WeatherState> {
    /// Forecasts older than this are refreshed on launch, resume and reconnect.
    static const staleAfter = Duration(minutes: 15);

    /// GPS moves smaller than this keep the current place (and its name),
    /// so we don't reverse-geocode on every launch.
    static const sameLocationRadiusKm = 3.0;

    final ForecastRepository _repository;
    final SettingsCubit _settings;
    final LocationService _locationService;

    late Units _units;
    late bool _minuteRain;
    StreamSubscription<SettingsState>? _settingsSubscription;
    StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

    /// Fixed storage key: the class name changes in obfuscated release builds,
    /// which would lose saved places and forecasts on update.
    @override
    String get storagePrefix => 'WeatherCubit';

    /// Keys of places with a forecast request in flight (prevents duplicate requests).
    final Set<String> _inFlight = {};

    WeatherCubit(this._settings, {
        ForecastRepository? repository,
        LocationService? locationService,
        Stream<List<ConnectivityResult>>? connectivityChanges,
        bool autoStart = true,
    }) : _repository = repository ?? ForecastRepository(),
         _locationService = locationService ?? const DeviceLocationService(),
         super(const WeatherState()) {
        _units = _settings.state.units;
        // Saved forecasts are normally in these units already; this is a no-op then.
        _convertAll();
        _minuteRain = _settings.state.minuteRain;
        _settingsSubscription = _settings.stream.listen(_onSettingsChanged);
        _connectivitySubscription = (connectivityChanges ?? Connectivity().onConnectivityChanged).listen(
            _onConnectivityChanged,
            onError: (Object error) => log("Connectivity stream error", error: error),
        );

        if (autoStart) {
            unawaited(start());
        }
    }

    // ---------------------------------------------------------------- lifecycle

    /// Called once on launch.
    Future<void> start() async {
        if (!state.onboarded) {
            // Welcome screen is showing. Look up an approximate location in the
            // background so the user can just tap "Continue".
            await _useApproximateLocation();
            return;
        }

        await Future.wait([
            refreshAll(),
            // Don't pop a permission dialog on every launch; only update the
            // location silently if the user already granted access.
            locate(requestPermission: false),
        ]);
    }

    /// Call when the app returns to the foreground.
    Future<void> onResume() => refreshAll();

    @override
    Future<void> close() async {
        await _settingsSubscription?.cancel();
        await _connectivitySubscription?.cancel();
        return super.close();
    }

    void _onSettingsChanged(SettingsState settings) {
        if (settings.units != _units) {
            // Convert what we have: instant, offline, and no new requests.
            _units = settings.units;
            _convertAll();
        }
        if (settings.minuteRain != _minuteRain) {
            _minuteRain = settings.minuteRain;
            unawaited(refreshAll(force: true));
        }
    }

    void _convertAll() {
        if (isClosed) return;
        final location = state.location;
        emit(state.copy(
            location: location?.copy(city: location.city.convertedTo(_units), status: location.status, issue: location.issue),
            cities: [for (final place in state.cities) place.copy(city: place.city.convertedTo(_units), status: place.status, issue: place.issue)],
        ));
    }

    void _onConnectivityChanged(List<ConnectivityResult> results) {
        final online = results.any((result) => result != ConnectivityResult.none);
        if (!online || !state.onboarded) return;

        if (state.location == null && !state.status.isLoading) {
            unawaited(locate(requestPermission: false));
        }
        unawaited(refreshAll());
    }

    // ---------------------------------------------------------------- onboarding

    /// "Use my location" on the welcome screen or the location banner.
    Future<void> useMyLocation() async {
        await locate(requestPermission: true);
        // Only leave the welcome screen once we have a *precise* location; if GPS
        // failed the screen stays up with the error and the other options.
        final location = state.location;
        if (!isClosed && location != null && !location.approximate && !state.onboarded) {
            emit(state.copy(onboarded: true));
        }
    }

    /// "Continue with `<approximate place>`" on the welcome screen.
    void completeOnboarding() {
        if (!state.onboarded) {
            emit(state.copy(onboarded: true));
        }
    }

    Future<bool> openLocationSettings() => _locationService.openSettings();

    // ---------------------------------------------------------------- location

    /// Finds the user via GPS. Falls back to an IP-based approximate location
    /// when GPS isn't available and there is no location yet. Never exits the app.
    Future<void> locate({ bool requestPermission = true }) async {
        if (state.status.isLoading) return;
        emit(state.copy(status: StateStatus.loading, locationIssue: LocationIssue.none));

        try {
            final position = await _locationService.currentPosition(requestPermission: requestPermission);
            final existing = state.location;

            if (existing != null && !existing.approximate && _distanceKm(existing.city, position) < sameLocationRadiusKm) {
                emit(state.copy(status: StateStatus.success));
                if (existing.status.isFailure || existing.isStale(staleAfter)) {
                    await refreshPlace(existing.key);
                }
                return;
            }

            final city = await _repository.locate(latitude: position.latitude, longitude: position.longitude);
            emit(state.copy(location: CityState.current(city), status: StateStatus.success));
            await refreshPlace(CityState.currentLocationKey);
        } on LocationException catch (error) {
            final issue = switch (error.reason) {
                LocationFailureReason.serviceDisabled => LocationIssue.serviceDisabled,
                LocationFailureReason.permissionDenied => LocationIssue.permissionDenied,
                LocationFailureReason.permissionDeniedForever => LocationIssue.permissionDeniedForever,
                LocationFailureReason.unavailable => LocationIssue.unavailable,
            };
            emit(state.copy(status: StateStatus.failure, locationIssue: issue));
            if (state.location == null) {
                await _useApproximateLocation();
            }
        } catch (error) {
            log("Location error", error: error);
            emit(state.copy(status: StateStatus.failure, locationIssue: LocationIssue.unavailable));
            if (state.location == null) {
                await _useApproximateLocation();
            }
        }
    }

    Future<void> _useApproximateLocation() async {
        try {
            final city = await _repository.approximateLocation();
            // GPS may have succeeded meanwhile; never replace a precise location.
            if (isClosed || (state.location != null && !state.location!.approximate)) return;
            emit(state.copy(location: CityState.current(city, approximate: true)));
            await refreshPlace(CityState.currentLocationKey);
        } catch (error) {
            log("Approximate (IP) location unavailable", error: error);
        }
    }

    // ---------------------------------------------------------------- cities

    /// Adds [city] (if it isn't saved already) and returns its key so the UI can show it.
    String addCity(City city) {
        final place = CityState.saved(city);
        if (state.place(place.key) == null) {
            emit(state.copy(cities: [...state.cities, place], onboarded: true));
            unawaited(refreshPlace(place.key));
        } else if (!state.onboarded) {
            emit(state.copy(onboarded: true));
        }
        return place.key;
    }

    /// Moves the saved city at [oldIndex] so it ends up at [newIndex] (positions
    /// in [WeatherState.cities], as given by ReorderableListView.onReorderItem,
    /// which already accounts for the removed item).
    void reorderCity(int oldIndex, int newIndex) {
        final count = state.cities.length;
        if (oldIndex < 0 || oldIndex >= count) return;
        final target = math.max(0, math.min(newIndex, count - 1));
        if (target == oldIndex) return;

        final cities = [...state.cities];
        cities.insert(target, cities.removeAt(oldIndex));
        emit(state.copy(cities: cities));
    }

    void removeCity(String key) {
        if (key == CityState.currentLocationKey) return;
        emit(state.copy(cities: state.cities.where((city) => city.key != key).toList()));
    }

    /// Puts back a city removed by mistake ("Undo"), at its old position and
    /// with its forecast, so nothing has to be fetched again.
    void restoreCity(CityState place, int index) {
        if (place.isCurrentLocation || state.place(place.key) != null) return;
        final cities = [...state.cities];
        cities.insert(math.max(0, math.min(index, cities.length)), place);
        emit(state.copy(cities: cities));
        if (place.isStale(staleAfter)) {
            unawaited(refreshPlace(place.key));
        }
    }

    // ---------------------------------------------------------------- forecasts

    /// Refreshes every place that failed, has no forecast or is stale (or all of them when [force]).
    Future<void> refreshAll({ bool force = false }) async {
        await Future.wait([
            for (final place in state.places)
                if (force || place.status.isFailure || !place.hasForecast || place.isStale(staleAfter))
                    refreshPlace(place.key),
        ]);
    }

    /// Fetches a fresh forecast for the place with [key].
    Future<void> refreshPlace(String key) async {
        final place = state.place(key);
        if (place == null || !_inFlight.add(key)) return;

        final requestedId = place.city.id;
        final minuteRain = _minuteRain;
        try {
            _update(key, requestedId, (current) => current.copy(status: StateStatus.loading));
            // Always fetched in metric; converted to the user's units on arrival, so
            // a unit change while the request runs is picked up too.
            final fetched = await _repository.getWeather(place.city, units: Units.metric, includeMinutely: minuteRain);
            final city = fetched.convertedTo(_units);
            _update(key, requestedId, (current) => current.copy(city: city, status: StateStatus.success, updatedAt: DateTime.now()));
            if (place.normals == null) {
                unawaited(_loadNormals(key, requestedId, place.city));
            }
        } catch (error) {
            log("Forecast error - ${place.city.name}", error: error);
            _update(key, requestedId, (current) => current.copy(status: StateStatus.failure, issue: _forecastIssue(error)));
        } finally {
            _inFlight.remove(key);
        }

        // Minute-by-minute rain was toggled while this request ran: fetch again.
        if (minuteRain != _minuteRain && !isClosed) {
            await refreshPlace(key);
        }
    }

    /// Keys with a climate-normals request in flight.
    final Set<String> _normalsInFlight = {};

    /// Climate normals are optional: on failure the comparison is simply hidden
    /// and retried with the next successful refresh.
    Future<void> _loadNormals(String key, String cityId, City city) async {
        if (!_normalsInFlight.add(key)) return;
        try {
            final normals = await _repository.climateNormals(latitude: city.latitude, longitude: city.longitude);
            _update(key, cityId, (current) => current.copy(normals: normals, issue: current.issue));
        } catch (error) {
            log("Climate normals unavailable - ${city.name}", error: error);
        } finally {
            _normalsInFlight.remove(key);
        }
    }

    static ForecastIssue _forecastIssue(Object error) {
        if (error is WeatherRequestFailure) return ForecastIssue.network;
        if (error is WeatherNotFoundFailure) return ForecastIssue.data;
        return ForecastIssue.unknown;
    }

    /// Applies [change] to the place with [key], but only if it is still the
    /// same place ([cityId]) that the request was made for.
    void _update(String key, String cityId, CityState Function(CityState current) change) {
        if (isClosed) return;

        final location = state.location;
        if (location != null && location.key == key) {
            if (location.city.id == cityId) {
                emit(state.copy(location: change(location)));
            }
            return;
        }

        final index = state.cities.indexWhere((city) => city.key == key);
        if (index == -1 || state.cities[index].city.id != cityId) return;

        final cities = [...state.cities];
        cities[index] = change(cities[index]);
        emit(state.copy(cities: cities));
    }

    static double _distanceKm(City city, Coordinates position) {
        const earthRadiusKm = 6371.0;
        double radians(double degrees) => degrees * math.pi / 180;

        final dLat = radians(position.latitude - city.latitude);
        final dLon = radians(position.longitude - city.longitude);
        final a = math.pow(math.sin(dLat / 2), 2) +
            math.cos(radians(city.latitude)) * math.cos(radians(position.latitude)) * math.pow(math.sin(dLon / 2), 2);
        return earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    }

    // ---------------------------------------------------------------- persistence

    @override
    WeatherState? fromJson(Map<String, dynamic> json) {
        try {
            return WeatherState.fromJson(json);
        } catch (err, stack) {
            log("Weather State deserialization error", error: err, stackTrace: stack);
        }
        return null;
    }

    @override
    Map<String, dynamic>? toJson(WeatherState state) {
        try {
            return state.toJson();
        } catch (err) {
            log("Weather State serialization error", error: err);
        }
        return null;
    }
}
