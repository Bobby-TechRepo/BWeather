import 'package:bweather/utils/astronomy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    group('MoonInfo', () {
        test('known full moons', () {
            final moon = MoonInfo.at(DateTime.utc(2024, 4, 23, 23, 49));
            expect(moon.phase, MoonPhase.fullMoon);
            expect(moon.illumination, greaterThan(0.98));
        });

        test('known new moons', () {
            final moon = MoonInfo.at(DateTime.utc(2025, 1, 29, 12, 36));
            expect(moon.phase, MoonPhase.newMoon);
            expect(moon.illumination, lessThan(0.02));
        });

        test('quarters are about half lit and wax then wane', () {
            final first = MoonInfo.at(DateTime.utc(2025, 2, 5, 8, 2));
            expect(first.phase, MoonPhase.firstQuarter);
            expect(first.waxing, isTrue);
            expect(first.illumination, closeTo(0.5, 0.1));

            final last = MoonInfo.at(DateTime.utc(2025, 2, 20, 17, 32));
            expect(last.phase, MoonPhase.lastQuarter);
            expect(last.waxing, isFalse);
        });

        test('dates before the reference epoch still work', () {
            final moon = MoonInfo.at(DateTime.utc(1999, 12, 22, 17, 31)); // a full moon
            expect(moon.age, inInclusiveRange(0, MoonInfo.synodicMonth));
            expect(moon.phase, MoonPhase.fullMoon);
        });
    });

    group('SunProgress', () {
        final sun = SunProgress(sunrise: DateTime(2026, 11, 13, 6, 30), sunset: DateTime(2026, 11, 13, 18, 30));

        test('daylight length', () => expect(sun.daylight, const Duration(hours: 12)));

        test('progress through the day', () {
            expect(sun.at(DateTime(2026, 11, 13, 12, 30)), closeTo(0.5, 1e-9));
            expect(sun.at(DateTime(2026, 11, 13, 6, 30)), 0);
            expect(sun.at(DateTime(2026, 11, 13, 5)), isNull);
            expect(sun.at(DateTime(2026, 11, 13, 20)), isNull);
        });
    });
}
