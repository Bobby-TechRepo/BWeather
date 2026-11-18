import 'package:bweather/l10n/app_localizations_en.dart';
import 'package:bweather/services/trip_reminders.dart';
import 'package:bweather/states/settings_cubit.dart';
import 'package:bweather/states/trips/trip.dart';
import 'package:bweather/states/trips/trip_text.dart';
import 'package:bweather/states/trips/trip_weather.dart';
import 'package:bweather/states/trips/trips_cubit.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers.dart';

class MockForecastRepository extends Mock implements ForecastRepository {}

const abuja = City(name: "Abuja", country: "Nigeria", latitude: 9.06, longitude: 7.49);
const kano = City(name: "Kano", country: "Nigeria", latitude: 12.0, longitude: 8.52);

Daily day(DateTime date, { double max = 30, double min = 20, int code = 1, int rain = 10, double sum = 0, double wind = 10, String unit = "°C" }) => Daily(
    time: date, weatherCode: code,
    temperatureMax: Value(value: max, unit: unit), temperatureMin: Value(value: min, unit: unit),
    apparentTemperatureMax: Value(value: max, unit: unit), apparentTemperatureMin: Value(value: min, unit: unit),
    precipitationProbabilityMax: Value(value: rain, unit: "%"),
    precipitationSum: Value(value: sum, unit: "mm"),
    windSpeedMax: Value(value: wind, unit: "km/h"),
);

Trip twoStopTrip() => Trip(id: "t1", name: "North", stops: [
    TripStop(id: "s1", city: abuja, arrive: DateTime(2026, 12, 3), depart: DateTime(2026, 12, 5)),
    TripStop(id: "s2", city: kano, arrive: DateTime(2026, 12, 5), depart: DateTime(2026, 12, 7)),
]);

void main() {
    group('Trip', () {
        test('dates, travel days and the stop on each day', () {
            final trip = twoStopTrip();
            expect(trip.dayCount, 5);
            expect(trip.stopOn(DateTime(2026, 12, 4))?.id, "s1");
            // Dec 5: leave Abuja, arrive in Kano.
            expect(trip.stopOn(DateTime(2026, 12, 5))?.id, "s2");
            expect(trip.leavingOn(DateTime(2026, 12, 5))?.id, "s1");
            expect(trip.leavingOn(DateTime(2026, 12, 6)), isNull);
        });

        test('timing and countdown', () {
            final trip = twoStopTrip();
            expect(trip.timing(DateTime(2026, 11, 30)), TripTiming.upcoming);
            expect(trip.daysUntil(DateTime(2026, 11, 30, 22)), 3);
            expect(trip.timing(DateTime(2026, 12, 7, 23)), TripTiming.ongoing);
            expect(trip.timing(DateTime(2026, 12, 8)), TripTiming.past);
        });

        test('JSON round trip', () {
            final trip = twoStopTrip().copy(packed: {"umbrella"}, remind: true);
            expect(Trip.fromJson(trip.toJson()), trip);
        });
    });

    group('validateStops', () {
        test('accepts back-to-back stops', () => expect(validateStops(twoStopTrip().stops), isNull));
        test('needs a stop', () => expect(validateStops(const []), TripProblem.noStops));
        test('rejects overlapping stops', () {
            final stops = [
                TripStop(id: "a", city: abuja, arrive: DateTime(2026, 12, 3), depart: DateTime(2026, 12, 6)),
                TripStop(id: "b", city: kano, arrive: DateTime(2026, 12, 5), depart: DateTime(2026, 12, 7)),
            ];
            expect(validateStops(stops), TripProblem.stopsOverlap);
        });
        test('rejects very long trips', () {
            final stops = [TripStop(id: "a", city: abuja, arrive: DateTime(2026, 1, 1), depart: DateTime(2026, 6, 1))];
            expect(validateStops(stops), TripProblem.tooLong);
        });
    });

    group('tripDays', () {
        final normals = ClimateNormals(highs: List.filled(366, 33.0), lows: List.filled(366, 20.0), fromYear: 2006, toYear: 2025);

        test('uses the forecast where there is one, else typical weather, else unknown', () {
            final trip = twoStopTrip();
            final days = tripDays(
                trip,
                forecasts: {"s1": StopForecast(days: [day(DateTime(2026, 12, 3))], fetchedAt: DateTime(2026, 12, 1), units: "")},
                normals: {kano.id: normals},
                tempUnit: TempUnit.celsius,
            );
            expect(days.length, 5);
            expect(days[0].weather, isA<ForecastDay>());
            expect(days[1].weather, isA<UnknownDay>()); // Abuja, no forecast, no normals
            expect(days[2].weather, isA<TypicalDay>()); // Kano from Dec 5
            expect(days[2].isTravelDay, isTrue);
        });

        test('typical weather follows the temperature unit', () {
            final days = tripDays(twoStopTrip(), forecasts: const {}, normals: {abuja.id: normals}, tempUnit: TempUnit.fahrenheit);
            final typical = days.first.weather as TypicalDay;
            expect(typical.high, closeTo(91.4, 0.01));
            expect(typical.unit, "°F");
        });
    });

    group('TripOutlook and packing', () {
        TripDay forecastDay(Daily daily) => TripDay(date: daily.time, stop: twoStopTrip().stops.first, weather: ForecastDay(daily));

        test('outlook summarises range, rain and the usual sky', () {
            final outlook = TripOutlook.of([
                forecastDay(day(DateTime(2026, 12, 3), max: 31, min: 22, code: 61, rain: 70)),
                forecastDay(day(DateTime(2026, 12, 4), max: 34, min: 23, code: 61, rain: 20)),
                forecastDay(day(DateTime(2026, 12, 5), max: 29, min: 19, code: 1, rain: 0)),
            ]);
            expect(outlook.low, 19);
            expect(outlook.high, 34);
            expect(outlook.commonCode, 61);
            expect(outlook.rainyDays, 1);
        });

        test('hot and rainy trip', () {
            final items = packingFor([
                forecastDay(day(DateTime(2026, 12, 3), max: 34, min: 24, rain: 80)),
                forecastDay(day(DateTime(2026, 12, 4), max: 33, min: 24, rain: 60)),
                forecastDay(day(DateTime(2026, 12, 5), max: 32, min: 23, sum: 5)),
            ]);
            expect(items, containsAll([PackingItem.umbrella, PackingItem.rainJacket, PackingItem.sunscreen, PackingItem.waterBottle, PackingItem.insectRepellent]));
            expect(items, isNot(contains(PackingItem.coat)));
        });

        test('cold and windy trip, in Fahrenheit', () {
            final items = packingFor([forecastDay(day(DateTime(2026, 12, 3), max: 40, min: 28, wind: 50, unit: "°F"))]);
            expect(items, containsAll([PackingItem.warmLayer, PackingItem.coat, PackingItem.gloves, PackingItem.windbreaker]));
            expect(items, isNot(contains(PackingItem.umbrella)));
        });
    });

    group('share text', () {
        setUpAll(() => initializeDateFormatting('en'));

        test('lists each day and the packing list', () {
            final trip = twoStopTrip();
            final days = tripDays(trip, forecasts: {"s1": StopForecast(days: [day(DateTime(2026, 12, 3), code: 0, rain: 90)], fetchedAt: DateTime(2026, 12, 1), units: "")}, normals: const {}, tempUnit: TempUnit.celsius);
            final text = tripShareText(trip, days, AppLocalizationsEn(), "en");
            expect(text, contains("North"));
            expect(text, contains("Abuja: Clear sky, 20° to 30°, rain 90%"));
            expect(text, contains("Umbrella"));
            expect(text, endsWith("Shared from BWeather"));
        });
    });

    group('TripReminder', () {
        test('is due from 17:00 the day before until 10:00 on the day', () {
            final reminder = TripReminder(id: "x", tripName: "North", city: abuja, departure: DateTime(2026, 12, 3));
            expect(reminder.isDue(DateTime(2026, 12, 2, 16, 59)), isFalse);
            expect(reminder.isDue(DateTime(2026, 12, 2, 17)), isTrue);
            expect(reminder.isDue(DateTime(2026, 12, 3, 9, 59)), isTrue);
            expect(reminder.isDue(DateTime(2026, 12, 3, 10)), isFalse);
        });

        test('only for upcoming trips that ask for it', () {
            final trip = twoStopTrip();
            expect(TripReminder.fromTrips([trip], DateTime(2026, 11, 30)), isEmpty);
            final reminders = TripReminder.fromTrips([trip.copy(remind: true)], DateTime(2026, 11, 30));
            expect(reminders.single.city.name, "Abuja");
            expect(reminders.single.id, "t1@2026-12-03");
            expect(TripReminder.fromTrips([trip.copy(remind: true)], DateTime(2026, 12, 4)), isEmpty);
        });
    });

    group('forecastWindow', () {
        final today = DateTime(2026, 11, 14);

        test('clamps to 16 days ahead', () {
            final window = ForecastRepository.forecastWindow(start: DateTime(2026, 11, 20), end: DateTime(2026, 12, 20), today: today)!;
            expect(window.start, DateTime(2026, 11, 20));
            expect(window.end, DateTime(2026, 11, 29));
        });

        test('null when entirely out of range', () {
            expect(ForecastRepository.forecastWindow(start: DateTime(2027, 1, 1), end: DateTime(2027, 1, 5), today: today), isNull);
        });
    });

    group('TripsCubit', () {
        late MockForecastRepository repository;
        late SettingsCubit settings;

        setUpAll(() {
            registerFallbackValue(abuja);
            registerFallbackValue(const Units());
        });

        setUp(() {
            initHydratedStorage();
            repository = MockForecastRepository();
            settings = SettingsCubit();
            when(() => repository.dailyForecast(any(), start: any(named: 'start'), end: any(named: 'end'), units: any(named: 'units')))
                .thenAnswer((invocation) async => [day(invocation.namedArguments[#start] as DateTime)]);
            when(() => repository.climateNormals(latitude: any(named: 'latitude'), longitude: any(named: 'longitude')))
                .thenAnswer((_) async => ClimateNormals(highs: List.filled(366, 30.0), lows: List.filled(366, 20.0), fromYear: 2006, toYear: 2025));
        });

        Trip tripStarting(DateTime start, { int days = 3, String id = "t" }) => Trip(id: id, name: id, stops: [
            TripStop(id: "$id-s", city: abuja, arrive: start, depart: start.add(Duration(days: days - 1))),
        ]);

        test('saving sorts trips and fetches the forecast for a near trip', () async {
            final cubit = TripsCubit(settings, repository: repository);
            final today = dateOnly(DateTime.now());
            cubit.save(tripStarting(today.add(const Duration(days: 30)), id: "later"));
            cubit.save(tripStarting(today.add(const Duration(days: 2)), id: "soon"));
            await Future<void>.delayed(Duration.zero);
            await cubit.refreshAll();

            expect(cubit.state.trips.map((trip) => trip.id), ["soon", "later"]);
            expect(cubit.state.forecasts.containsKey("soon-s"), isTrue);
            // The far trip needs typical weather instead.
            expect(cubit.state.normals.containsKey(abuja.id), isTrue);
            expect(cubit.state.forecasts.containsKey("later-s"), isFalse);
        });

        test('packing ticks, reminder and delete/restore', () {
            final cubit = TripsCubit(settings, repository: repository);
            final trip = tripStarting(dateOnly(DateTime.now()).add(const Duration(days: 40)));
            cubit.save(trip);
            cubit.togglePacked(trip.id, PackingItem.umbrella);
            cubit.setReminder(trip.id, true);
            expect(cubit.state.trip(trip.id)!.packed, {"umbrella"});
            expect(cubit.state.trip(trip.id)!.remind, isTrue);

            final saved = cubit.state.trip(trip.id)!;
            cubit.delete(trip.id);
            expect(cubit.state.trips, isEmpty);
            cubit.restore(saved);
            expect(cubit.state.trip(trip.id), saved);
        });

        test('state survives a JSON round trip', () {
            final cubit = TripsCubit(settings, repository: repository);
            cubit.save(twoStopTrip());
            final restored = TripsState.fromJson(cubit.state.toJson());
            expect(restored.trips, cubit.state.trips);
        });
    });
}
