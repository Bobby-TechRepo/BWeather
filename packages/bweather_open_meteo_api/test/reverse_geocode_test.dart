import 'package:bweather_open_meteo_api/bweather_open_meteo_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

const _nominatimResponse = '''{
    "name": "Mountain View",
    "address": { "city": "Mountain View", "county": "Santa Clara County", "state": "California", "country": "United States" }
}''';

void main() {
    late http.Client httpClient;
    late WeatherClient client;

    setUpAll(() => registerFallbackValue(FakeUri()));

    setUp(() {
        httpClient = MockHttpClient();
        client = WeatherClient(httpClient: httpClient);
    });

    group('reverseGeocode', () {
        test('returns the place name, region and country for a coordinate', () async {
            final response = MockResponse();
            when(() => response.statusCode).thenReturn(200);
            when(() => response.body).thenReturn(_nominatimResponse);
            when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => response);

            final place = await client.reverseGeocode(latitude: 37.39, longitude: -122.08);

            expect(place.name, 'Mountain View');
            expect(place.region, 'California');
            expect(place.country, 'United States');
        });

        test('sends an identifying User-Agent (Nominatim usage policy)', () async {
            final response = MockResponse();
            when(() => response.statusCode).thenReturn(200);
            when(() => response.body).thenReturn(_nominatimResponse);
            when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => response);

            await client.reverseGeocode(latitude: 37.39, longitude: -122.08);

            final captured = verify(() => httpClient.get(any(), headers: captureAny(named: 'headers'))).captured.single as Map<String, String>;
            expect(captured['User-Agent'], WeatherClient.userAgent);
        });

        test('throws LocationNotFoundFailure when no name is available', () async {
            final response = MockResponse();
            when(() => response.statusCode).thenReturn(200);
            when(() => response.body).thenReturn('{"address": {}}');
            when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => response);

            await expectLater(client.reverseGeocode(latitude: 0, longitude: 0), throwsA(isA<LocationNotFoundFailure>()));
        });

        test('throws LocationRequestFailure on non-200 response', () async {
            final response = MockResponse();
            when(() => response.statusCode).thenReturn(503);
            when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => response);

            await expectLater(client.reverseGeocode(latitude: 0, longitude: 0), throwsA(isA<LocationRequestFailure>()));
        });
    });

    group('network errors', () {
        test('forecast maps a ClientException to WeatherRequestFailure', () async {
            when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenThrow(http.ClientException('offline'));

            await expectLater(
                client.forecast(const City(name: 'X', country: 'Y', latitude: 1, longitude: 2), tempUnit: 'celsius', precipitationUnit: 'mm', windSpeedUnit: 'kmh'),
                throwsA(isA<WeatherRequestFailure>()),
            );
        });

        test('forecast omits elevation when it is unknown', () async {
            final response = MockResponse();
            when(() => response.statusCode).thenReturn(500);
            when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => response);

            try {
                await client.forecast(const City(name: 'X', country: 'Y', latitude: 1, longitude: 2), tempUnit: 'celsius', precipitationUnit: 'mm', windSpeedUnit: 'kmh');
            } catch (_) {}

            final uri = verify(() => httpClient.get(captureAny(), headers: any(named: 'headers'))).captured.single as Uri;
            expect(uri.queryParameters.containsKey('elevation'), isFalse);
            expect(uri.queryParameters['timezone'], 'auto');
        });
    });

    group('City.fromJson', () {
        test('tolerates a missing elevation and timezone', () {
            final city = City.fromJson({'name': 'Ikorodu', 'country': 'Nigeria', 'admin1': 'Lagos', 'latitude': 6.6, 'longitude': 3.5});
            expect(city.elevation, isNull);
            expect(city.timezone, 'auto');
            expect(city.region, 'Lagos');
        });

        test('reads ipapi.co responses (city / country_name)', () {
            final city = City.fromJson({'city': 'Lagos', 'country': 'NG', 'country_name': 'Nigeria', 'region': 'Lagos', 'latitude': 6.45, 'longitude': 3.39, 'timezone': 'Africa/Lagos'});
            expect(city.name, 'Lagos');
            expect(city.country, 'Nigeria');
            expect(city.timezone, 'Africa/Lagos');
        });
    });
}
