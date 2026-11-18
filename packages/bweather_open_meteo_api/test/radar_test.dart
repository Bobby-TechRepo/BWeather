import 'package:bweather_open_meteo_api/bweather_open_meteo_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    group('RadarFrames', () {
        test('parses host and past frames, oldest first', () {
            final frames = RadarFrames.fromJson({
                "version": "2.0",
                "generated": 1762950000,
                "host": "https://tilecache.rainviewer.com",
                "radar": {
                    "past": [
                        {"time": 1762949400, "path": "/v2/radar/1762949400"},
                        {"time": 1762950000, "path": "/v2/radar/1762950000"},
                    ],
                    "nowcast": [],
                },
            });
            expect(frames.host, "https://tilecache.rainviewer.com");
            expect(frames.past.map((frame) => frame.time), [1762949400, 1762950000]);
            expect(frames.past.last.path, "/v2/radar/1762950000");
        });

        test('tolerates a missing radar section', () {
            final frames = RadarFrames.fromJson({"host": "https://example.com"});
            expect(frames.past, isEmpty);
        });
    });

    group('DailyHistory', () {
        test('keeps missing days as null', () {
            final history = DailyHistory.fromJson({
                "daily": {"time": ["2020-01-01", "2020-01-02"], "temperature_2m_max": [31.2, null], "temperature_2m_min": [null, 20.1]},
            });
            expect(history.time.length, 2);
            expect(history.maxima, [31.2, null]);
            expect(history.minima, [null, 20.1]);
        });
    });

    group('Minutely15', () {
        test('parses times, amounts and the unit', () {
            final minutely = Minutely15.fromJson(
                {"time": ["2026-11-12T14:00", "2026-11-12T14:15"], "precipitation": [0.0, 0.4]},
                {"time": "iso8601", "precipitation": "mm"},
            );
            expect(minutely.time.last, DateTime(2026, 11, 12, 14, 15));
            expect(minutely.precipitation, [0.0, 0.4]);
            expect(minutely.unit, "mm");
        });
    });
}
