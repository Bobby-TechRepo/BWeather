import 'dart:async';
import 'dart:developer';

import 'package:bweather/states/settings_cubit.dart';
import 'package:bweather/states/trips/trip.dart';
import 'package:bweather/states/trips/trip_weather.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class TripsState extends Equatable {
    /// Trips, soonest first.
    final List<Trip> trips;

    /// Forecasts by stop id.
    final Map<String, StopForecast> forecasts;

    /// Climate normals by city id, shared between stops in the same place.
    final Map<String, ClimateNormals> normals;

    /// Stop ids with a request running (not persisted).
    final Set<String> loading;

    /// Stop ids whose last forecast request failed (not persisted).
    final Set<String> failed;

    const TripsState({ this.trips = const [], this.forecasts = const {}, this.normals = const {}, this.loading = const {}, this.failed = const {} });

    Trip? trip(String id) {
        for (final trip in trips) {
            if (trip.id == id) return trip;
        }
        return null;
    }

    TripsState copy({ List<Trip>? trips, Map<String, StopForecast>? forecasts, Map<String, ClimateNormals>? normals, Set<String>? loading, Set<String>? failed }) => TripsState(
        trips: trips ?? this.trips,
        forecasts: forecasts ?? this.forecasts,
        normals: normals ?? this.normals,
        loading: loading ?? this.loading,
        failed: failed ?? this.failed,
    );

    factory TripsState.fromJson(Map<String, dynamic> json) {
        final trips = <Trip>[];
        for (final element in (json["trips"] as List? ?? const [])) {
            try {
                trips.add(Trip.fromJson(element));
            } catch (error) {
                log("Dropping unreadable trip", error: error);
            }
        }
        final forecasts = <String, StopForecast>{};
        (json["forecasts"] as Map? ?? const {}).forEach((key, value) {
            try {
                forecasts[key.toString()] = StopForecast.fromJson(value);
            } catch (_) {/* refetched later */}
        });
        final normals = <String, ClimateNormals>{};
        (json["normals"] as Map? ?? const {}).forEach((key, value) {
            try {
                normals[key.toString()] = ClimateNormals.fromJson(value);
            } catch (_) {/* refetched later */}
        });
        return TripsState(trips: trips, forecasts: forecasts, normals: normals);
    }

    Map<String, dynamic> toJson() => {
        "trips": trips.map((trip) => trip.toJson()).toList(),
        "forecasts": forecasts.map((key, value) => MapEntry(key, value.toJson())),
        "normals": normals.map((key, value) => MapEntry(key, value.toJson())),
    };

    @override
    List<Object?> get props => [trips, forecasts, normals, loading, failed];
}

/// Saved trips and the weather for their stops.
class TripsCubit extends HydratedCubit<TripsState> {
    final ForecastRepository _repository;
    final SettingsCubit _settings;
    late final StreamSubscription<SettingsState> _settingsSubscription;
    int _idCounter = 0;

    TripsCubit(this._settings, { ForecastRepository? repository })
        : _repository = repository ?? ForecastRepository(),
          super(const TripsState()) {
        _cleanUp();
        _convertAll(_settings.state.units);
        _settingsSubscription = _settings.stream.listen((settings) => _convertAll(settings.units));
    }

    @override
    Future<void> close() async {
        await _settingsSubscription.cancel();
        return super.close();
    }

    /// Unit changes are applied to the cached forecasts on the device.
    void _convertAll(Units units) {
        if (isClosed) return;
        final converted = state.forecasts.map((key, value) => MapEntry(key, value.convertedTo(units)));
        if (converted.entries.any((entry) => !identical(entry.value, state.forecasts[entry.key]))) {
            emit(state.copy(forecasts: converted));
        }
    }

    @override
    String get storagePrefix => 'TripsCubit';

    /// A new unique id for a trip or stop.
    String newId() => "${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}${(_idCounter++).toRadixString(36)}";

    // ---------------------------------------------------------------- editing

    /// Adds or replaces [trip]. Returns its id.
    String save(Trip trip) {
        final trips = [...state.trips.where((existing) => existing.id != trip.id), trip]
            ..sort((a, b) => a.start.compareTo(b.start));
        emit(state.copy(trips: trips));
        _cleanUp();
        unawaited(refresh(trip.id));
        return trip.id;
    }

    void delete(String id) {
        emit(state.copy(trips: state.trips.where((trip) => trip.id != id).toList()));
        _cleanUp();
    }

    /// Puts back a trip deleted by mistake.
    void restore(Trip trip) {
        if (state.trip(trip.id) == null) save(trip);
    }

    void togglePacked(String tripId, PackingItem item) {
        final trip = state.trip(tripId);
        if (trip == null) return;
        final packed = {...trip.packed};
        if (!packed.remove(item.name)) packed.add(item.name);
        _replace(trip.copy(packed: packed));
    }

    void setReminder(String tripId, bool remind) {
        final trip = state.trip(tripId);
        if (trip != null) _replace(trip.copy(remind: remind));
    }

    void _replace(Trip trip) {
        emit(state.copy(trips: [for (final existing in state.trips) existing.id == trip.id ? trip : existing]));
    }

    /// Forgets weather for stops and places no trip uses any more.
    void _cleanUp() {
        final stopIds = {for (final trip in state.trips) for (final stop in trip.stops) stop.id};
        final cityIds = {for (final trip in state.trips) for (final stop in trip.stops) stop.city.id};
        final forecasts = Map.of(state.forecasts)..removeWhere((key, _) => !stopIds.contains(key));
        final normals = Map.of(state.normals)..removeWhere((key, _) => !cityIds.contains(key));
        if (forecasts.length != state.forecasts.length || normals.length != state.normals.length) {
            emit(state.copy(forecasts: forecasts, normals: normals));
        }
    }

    // ---------------------------------------------------------------- weather

    /// Day-by-day weather for a trip in the current temperature unit.
    List<TripDay> days(Trip trip) =>
        tripDays(trip, forecasts: state.forecasts, normals: state.normals, tempUnit: _settings.state.tempUnit);

    /// Fetches what's missing or stale for the trip's stops. Past trips are left alone.
    Future<void> refresh(String tripId, { bool force = false }) async {
        final trip = state.trip(tripId);
        if (trip == null || trip.timing() == TripTiming.past) return;
        await Future.wait([for (final stop in trip.stops) _refreshStop(stop, force: force)]);
    }

    /// Refreshes every trip that hasn't ended (e.g. when the Trips tab opens).
    Future<void> refreshAll() => Future.wait([for (final trip in state.trips) refresh(trip.id)]);

    Future<void> _refreshStop(TripStop stop, { required bool force }) async {
        if (state.loading.contains(stop.id)) return;
        final cached = state.forecasts[stop.id];
        final inWindow = ForecastRepository.forecastWindow(start: stop.arrive, end: stop.depart) != null;
        final needsForecast = inWindow && (force || cached == null || cached.isStale());
        // Normals are only needed for days beyond the forecast.
        final needsNormals = !state.normals.containsKey(stop.city.id) && _beyondForecast(stop);
        if (!needsForecast && !needsNormals) return;

        emit(state.copy(loading: {...state.loading, stop.id}, failed: {...state.failed}..remove(stop.id)));
        var failed = false;
        try {
            if (needsForecast) {
                final days = await _repository.dailyForecast(stop.city, start: stop.arrive, end: stop.depart, units: Units.metric);
                if (isClosed) return;
                final forecast = StopForecast(days: days, fetchedAt: DateTime.now(), units: Units.metric.serialize())
                    .convertedTo(_settings.state.units);
                emit(state.copy(forecasts: {...state.forecasts, stop.id: forecast}));
            }
        } catch (error) {
            log("Trip forecast failed - ${stop.city.name}", error: error);
            failed = true;
        }
        try {
            if (needsNormals) {
                final normals = await _repository.climateNormals(latitude: stop.city.latitude, longitude: stop.city.longitude);
                if (isClosed) return;
                emit(state.copy(normals: {...state.normals, stop.city.id: normals}));
            }
        } catch (error) {
            log("Trip normals failed - ${stop.city.name}", error: error);
            failed = failed || !inWindow;
        }
        if (isClosed) return;
        emit(state.copy(
            loading: {...state.loading}..remove(stop.id),
            failed: failed ? {...state.failed, stop.id} : null,
        ));
    }

    static bool _beyondForecast(TripStop stop) {
        final today = dateOnly(DateTime.now());
        final lastForecastDay = DateTime(today.year, today.month, today.day + ForecastRepository.forecastDays - 1);
        return stop.depart.isAfter(lastForecastDay);
    }

    // ---------------------------------------------------------------- persistence

    @override
    TripsState? fromJson(Map<String, dynamic> json) {
        try {
            return TripsState.fromJson(json);
        } catch (error) {
            log("Trips state deserialization error", error: error);
            return null;
        }
    }

    @override
    Map<String, dynamic>? toJson(TripsState state) => state.toJson();
}
