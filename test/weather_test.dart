import 'dart:async';

import 'package:bweather/services/location_service.dart';
import 'package:bweather/states/forecast/city_state.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/settings_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:bweather/utils/status.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers.dart';

class MockForecastRepository extends Mock implements ForecastRepository {}

class FakeLocationService implements LocationService {
    Object? failure;
    Coordinates position = (latitude: 6.6, longitude: 3.5);
    int calls = 0;

    @override
    Future<Coordinates> currentPosition({ bool requestPermission = true }) async {
        calls++;
        if (failure != null) throw failure!;
        return position;
    }

    @override
    Future<bool> openSettings() async => true;
}

const lagos = City(name: "Lagos", country: "Nigeria", region: "Lagos", latitude: 6.4550, longitude: 3.3941);
const parisFr = City(name: "Paris", country: "France", latitude: 48.8534, longitude: 2.3488);
const parisUs = City(name: "Paris", country: "United States", latitude: 33.6609, longitude: -95.5555);

Forecast sampleForecast() => Forecast(
    utcOffsetSeconds: 3600,
    current: Current(
        time: DateTime(2026, 11, 12, 9), weatherCode: 2, isDay: true,
        temperature: const Value(value: 27.4, unit: "°C"), apparentTemperature: const Value(value: 30.1, unit: "°C"),
        windSpeed: const Value(value: 9.0, unit: "km/h"), windGusts: const Value(value: 20.0, unit: "km/h"),
        windDirection: const Value(value: 225, unit: "°"), relativeHumidity: const Value(value: 80, unit: "%"),
        surfacePressure: const Value(value: 1010.0, unit: "hPa"), rain: const Value(value: 0.0, unit: "mm"),
        precipitation: const Value(value: 0.0, unit: "mm"), cloudCover: const Value(value: 40, unit: "%"),
    ),
    hourly: const [],
    daily: const [],
);

/// Lets queued microtasks / async gaps run.
Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 10));

void main() {
    initHydratedStorage();

    late MockForecastRepository repository;
    late FakeLocationService locationService;
    late SettingsCubit settings;
    final normals = ClimateNormals(highs: List.filled(366, 30.0), lows: List.filled(366, 22.0), fromYear: 2006, toYear: 2025);

    setUpAll(() {
        registerFallbackValue(lagos);
        registerFallbackValue(const Units());
    });

    setUp(() {
        repository = MockForecastRepository();
        locationService = FakeLocationService();
        settings = SettingsCubit();

        when(() => repository.getWeather(any(), units: any(named: 'units'), includeMinutely: any(named: 'includeMinutely')))
            .thenAnswer((invocation) async => (invocation.positionalArguments.first as City).copyWith(forecast: sampleForecast()));
        when(() => repository.locate(latitude: any(named: 'latitude'), longitude: any(named: 'longitude')))
            .thenAnswer((invocation) async => City(
                name: "Ikorodu", country: "Nigeria",
                latitude: invocation.namedArguments[#latitude] as double,
                longitude: invocation.namedArguments[#longitude] as double,
            ));
        when(() => repository.approximateLocation()).thenAnswer((_) async => lagos);
        when(() => repository.climateNormals(latitude: any(named: 'latitude'), longitude: any(named: 'longitude')))
            .thenAnswer((_) async => normals);
    });

    WeatherCubit build() => WeatherCubit(
        settings,
        repository: repository,
        locationService: locationService,
        connectivityChanges: const Stream<List<ConnectivityResult>>.empty(),
        autoStart: false,
    );

    group('WeatherCubit', () {
        test('initial state is empty and not onboarded', () {
            final cubit = build();
            expect(cubit.state, const WeatherState());
            expect(cubit.state.onboarded, isFalse);
        });

        test('toJson/fromJson round-trips saved places', () async {
            final cubit = build();
            cubit.addCity(lagos);
            await settle();

            final restored = cubit.fromJson(cubit.toJson(cubit.state)!);
            expect(restored?.cities.single.key, lagos.id);
            expect(restored?.cities.single.city.forecast, isNotNull);
            expect(restored?.onboarded, isTrue);
        });

        test('restoring never leaves a place stuck in "loading"', () {
            final json = {
                "cities": [ CityState.saved(lagos).copy(status: StateStatus.loading).toJson() ],
            };
            final restored = WeatherState.fromJson(json);
            expect(restored.cities.single.status, StateStatus.initial);
        });

        test('one unreadable saved city does not wipe the others', () {
            final json = {
                "cities": [ {"city": {"name": "Broken"}}, CityState.saved(lagos).toJson() ],
            };
            final restored = WeatherState.fromJson(json);
            expect(restored.cities.map((city) => city.city.name), ["Lagos"]);
        });

        test('addCity saves the city, fetches its forecast and completes onboarding', () async {
            final cubit = build();
            final key = cubit.addCity(lagos);
            await settle();

            final place = cubit.state.place(key)!;
            expect(place.status, StateStatus.success);
            expect(place.city.forecast, isNotNull);
            expect(place.updatedAt, isNotNull);
            expect(cubit.state.onboarded, isTrue);
        });

        test('same-named cities in different countries can both be saved', () async {
            final cubit = build();
            cubit.addCity(parisFr);
            cubit.addCity(parisUs);
            cubit.addCity(parisFr); // duplicate, ignored
            await settle();

            expect(cubit.state.cities.map((city) => city.city.country), ["France", "United States"]);
        });

        test('removeCity removes by key, not by list position', () async {
            final cubit = build();
            cubit.addCity(parisFr);
            final usKey = cubit.addCity(parisUs);
            await settle();

            cubit.removeCity(usKey);
            expect(cubit.state.cities.map((city) => city.city.country), ["France"]);
        });

        test('a failed refresh keeps the previous forecast and records the error', () async {
            final cubit = build();
            final key = cubit.addCity(lagos);
            await settle();

            when(() => repository.getWeather(any(), units: any(named: 'units'), includeMinutely: any(named: 'includeMinutely'))).thenThrow(WeatherRequestFailure());
            await cubit.refreshPlace(key);

            final place = cubit.state.place(key)!;
            expect(place.status, StateStatus.failure);
            expect(place.city.forecast, isNotNull);
            expect(place.issue, ForecastIssue.network);
        });

        test('a response for a city removed meanwhile is ignored', () async {
            final completer = Completer<City>();
            when(() => repository.getWeather(any(), units: any(named: 'units'), includeMinutely: any(named: 'includeMinutely'))).thenAnswer((_) => completer.future);

            final cubit = build();
            final key = cubit.addCity(lagos);
            await settle();
            cubit.removeCity(key);

            completer.complete(lagos.copyWith(forecast: sampleForecast()));
            await settle();

            expect(cubit.state.cities, isEmpty);
        });

        test('locate uses the exact GPS coordinates', () async {
            locationService.position = (latitude: 37.3861, longitude: -122.0839);
            final cubit = build();

            await cubit.locate();

            final location = cubit.state.location!;
            expect(location.city.latitude, 37.3861);
            expect(location.city.longitude, -122.0839);
            expect(location.approximate, isFalse);
            expect(cubit.state.status, StateStatus.success);
        });

        test('denied permission falls back to an approximate location instead of exiting', () async {
            locationService.failure = const LocationException(LocationFailureReason.permissionDenied);
            final cubit = build();

            await cubit.locate();

            expect(cubit.state.locationIssue, LocationIssue.permissionDenied);
            expect(cubit.state.location?.approximate, isTrue);
            expect(cubit.state.location?.city.name, "Lagos");
        });

        test('useMyLocation keeps the welcome screen up when GPS fails', () async {
            locationService.failure = const LocationException(LocationFailureReason.permissionDeniedForever);
            final cubit = build();

            await cubit.useMyLocation();

            expect(cubit.state.onboarded, isFalse);
            expect(cubit.state.locationIssue, LocationIssue.permissionDeniedForever);
        });

        test('useMyLocation completes onboarding when GPS works', () async {
            final cubit = build();
            await cubit.useMyLocation();
            expect(cubit.state.onboarded, isTrue);
        });

        test('a small GPS move keeps the current place without reverse geocoding again', () async {
            final cubit = build();
            await cubit.locate();
            clearInteractions(repository);

            locationService.position = (latitude: 6.601, longitude: 3.501); // ~150 m away
            await cubit.locate();

            verifyNever(() => repository.locate(latitude: any(named: 'latitude'), longitude: any(named: 'longitude')));
        });

        test('forecasts are fetched in metric and shown in the user\'s units', () async {
            settings.tempUnit = TempUnit.fahrenheit;
            final cubit = build();
            cubit.addCity(lagos);
            await settle();

            verify(() => repository.getWeather(any(), units: Units.metric, includeMinutely: any(named: 'includeMinutely'))).called(1);
            final current = cubit.state.cities.single.city.forecast!.current;
            expect(current.temperature.unit, "°F");
            expect(current.temperature.value, closeTo(81.32, 0.01)); // 27.4 °C
        });

        test('changing units converts forecasts on the device, without refetching', () async {
            final cubit = build();
            cubit.addCity(lagos);
            await settle();
            clearInteractions(repository);

            settings.tempUnit = TempUnit.fahrenheit;
            settings.windSpeedUnit = WindSpeedUnit.mph;
            settings.precipitationUnit = PrecipitationUnit.inch;
            await settle();

            verifyNever(() => repository.getWeather(any(), units: any(named: 'units'), includeMinutely: any(named: 'includeMinutely')));
            final current = cubit.state.cities.single.city.forecast!.current;
            expect(current.temperature.unit, "°F");
            expect(current.windSpeed.unit, "mp/h");
            expect(current.windSpeed.value, closeTo(5.59, 0.01)); // 9 km/h
            expect(current.rain.unit, "inch");
            // Pressure and humidity are untouched.
            expect(current.surfacePressure.unit, "hPa");

            settings.tempUnit = TempUnit.celsius;
            await settle();
            expect(cubit.state.cities.single.city.forecast!.current.temperature.value, closeTo(27.4, 0.01));
        });

        test('reorderCity moves a saved city to its final index (onReorderItem)', () async {
            final cubit = build();
            cubit.addCity(parisFr);
            cubit.addCity(parisUs);
            cubit.addCity(lagos);
            await settle();

            cubit.reorderCity(0, 2); // drag Paris FR to the end
            expect(cubit.state.cities.map((city) => city.city.name).toList(), ["Paris", "Lagos", "Paris"]);
            expect(cubit.state.cities.last.city.country, "France");

            cubit.reorderCity(2, 0); // and back to the top
            expect(cubit.state.cities.first.city.country, "France");
        });

        test('turning on minute-by-minute rain refetches with minutely data', () async {
            final cubit = build();
            cubit.addCity(lagos);
            await settle();
            clearInteractions(repository);

            settings.minuteRain = true;
            await settle();

            verify(() => repository.getWeather(any(), units: any(named: 'units'), includeMinutely: true)).called(1);
            expect(cubit.state.cities.single.status, StateStatus.success);
        });

        test('climate normals are fetched once per place and kept', () async {
            final cubit = build();
            cubit.addCity(lagos);
            await settle();

            expect(cubit.state.cities.single.normals, normals);
            verify(() => repository.climateNormals(latitude: lagos.latitude, longitude: lagos.longitude)).called(1);

            clearInteractions(repository);
            await cubit.refreshAll(force: true);
            await settle();
            verifyNever(() => repository.climateNormals(latitude: any(named: 'latitude'), longitude: any(named: 'longitude')));
            expect(cubit.state.cities.single.normals, normals);
        });

        test('a failed normals request leaves the forecast intact', () async {
            when(() => repository.climateNormals(latitude: any(named: 'latitude'), longitude: any(named: 'longitude')))
                .thenThrow(WeatherRequestFailure());
            final cubit = build();
            cubit.addCity(lagos);
            await settle();

            expect(cubit.state.cities.single.status, StateStatus.success);
            expect(cubit.state.cities.single.normals, isNull);
        });

        test('restoreCity puts a removed city back where it was, with its forecast', () async {
            final cubit = build();
            cubit.addCity(parisFr);
            cubit.addCity(lagos);
            cubit.addCity(parisUs);
            await settle();

            final removed = cubit.state.cities[1];
            cubit.removeCity(removed.key);
            expect(cubit.state.cities.map((city) => city.key), isNot(contains(removed.key)));
            clearInteractions(repository);

            cubit.restoreCity(removed, 1);
            expect(cubit.state.cities[1], removed);
            expect(cubit.state.cities.length, 3);
            // Still fresh: no new request.
            verifyNever(() => repository.getWeather(any(), units: any(named: 'units'), includeMinutely: any(named: 'includeMinutely')));

            // Restoring twice does nothing.
            cubit.restoreCity(removed, 0);
            expect(cubit.state.cities.length, 3);
        });

        test('changing only the theme does not refetch', () async {
            final cubit = build();
            cubit.addCity(lagos);
            await settle();
            clearInteractions(repository);

            settings.themeMode = "dark";
            await settle();

            verifyNever(() => repository.getWeather(any(), units: any(named: 'units'), includeMinutely: any(named: 'includeMinutely')));
        });
    });
}
