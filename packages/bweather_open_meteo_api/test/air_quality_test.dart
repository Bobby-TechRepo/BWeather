import 'package:bweather_open_meteo_api/bweather_open_meteo_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

const _response = '''{
    "latitude": 6.5, "longitude": 3.375,
    "current": {
        "time": "2026-11-12T07:00", "interval": 3600,
        "european_aqi": 61, "us_aqi": 158, "pm10": 210.4, "pm2_5": 68.2, "dust": 340.0, "uv_index": 4.35,
        "alder_pollen": null, "birch_pollen": null, "grass_pollen": 3.2, "mugwort_pollen": null, "olive_pollen": null, "ragweed_pollen": null
    }
}''';

void main() {
    late http.Client httpClient;
    late WeatherClient client;

    setUpAll(() => registerFallbackValue(FakeUri()));

    setUp(() {
        httpClient = MockHttpClient();
        client = WeatherClient(httpClient: httpClient);
    });

    test('airQuality parses current values and keeps only available pollen', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(_response);
        when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => response);

        final result = await client.airQuality(latitude: 6.5, longitude: 3.4);

        expect(result.usAqi, 158);
        expect(result.europeanAqi, 61);
        expect(result.pm25, 68.2);
        expect(result.dust, 340.0);
        expect(result.uvIndex, 4.35);
        expect(result.pollen, {"grass_pollen": 3.2});

        final uri = verify(() => httpClient.get(captureAny(), headers: any(named: 'headers'))).captured.single as Uri;
        expect(uri.host, 'air-quality-api.open-meteo.com');
        expect(uri.queryParameters['current'], contains('us_aqi'));
    });

    test('airQuality throws WeatherRequestFailure on non-200', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(500);
        when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => response);

        await expectLater(client.airQuality(latitude: 0, longitude: 0), throwsA(isA<WeatherRequestFailure>()));
    });
}
