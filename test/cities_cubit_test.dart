import 'package:bweather/states/cities_cubit.dart';
import 'package:bweather/utils/status.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForecastRepository extends Mock implements ForecastRepository {}

const ikorodu = City(name: "Ikorodu", country: "Nigeria", region: "Lagos", latitude: 6.61526, longitude: 3.5069);

Future<void> waitForDebounce() => Future<void>.delayed(CitiesCubit.debounce + const Duration(milliseconds: 50));

void main() {
    late MockForecastRepository repository;

    setUp(() {
        repository = MockForecastRepository();
        when(() => repository.search(any())).thenAnswer((_) async => [ikorodu]);
    });

    group('CitiesCubit', () {
        test('the built-in list is sorted and gets letter headers', () {
            final cubit = CitiesCubit(repository: repository);
            final names = cubit.state.catalog.map((city) => city.name).toList();
            expect(names, [...names]..sort());
            expect(cubit.state.letters[0], names.first[0].toUpperCase());
        });

        test('typing searches once, with the full query, after the debounce', () async {
            final cubit = CitiesCubit(repository: repository);

            // Simulates typing "Ikorodu" one key at a time (this used to search only "I").
            for (final query in ["I", "Ik", "Iko", "Ikor", "Ikoro", "Ikorod", "Ikorodu"]) {
                cubit.queryChanged(query);
            }
            await waitForDebounce();

            verify(() => repository.search("Ikorodu")).called(1);
            verifyNoMoreInteractions(repository);
            expect(cubit.state.searchResults, [ikorodu]);
            expect(cubit.state.status, StateStatus.success);
        });

        test('one-character queries do not hit the API', () async {
            final cubit = CitiesCubit(repository: repository);
            cubit.queryChanged("I");
            await waitForDebounce();

            verifyNever(() => repository.search(any()));
        });

        test('no matches is an empty successful result, not an error', () async {
            when(() => repository.search(any())).thenThrow(LocationNotFoundFailure());
            final cubit = CitiesCubit(repository: repository);

            await cubit.search("zzzz");

            expect(cubit.state.status, StateStatus.success);
            expect(cubit.state.searchResults, isEmpty);
            expect(cubit.state.query, "zzzz");
        });

        test('network errors are reported as a failure', () async {
            when(() => repository.search(any())).thenThrow(LocationRequestFailure());
            final cubit = CitiesCubit(repository: repository);

            await cubit.search("Lagos");

            expect(cubit.state.status, StateStatus.failure);
        });

        test('clear resets the search', () async {
            final cubit = CitiesCubit(repository: repository);
            await cubit.search("Ikorodu");
            cubit.clear();

            expect(cubit.state.query, "");
            expect(cubit.state.searchResults, isEmpty);
            expect(cubit.state.isSearching, isFalse);
        });
    });
}
