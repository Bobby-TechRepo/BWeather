import 'dart:math' as math;

/// Small, offline astronomy helpers: moon phase and the sun's progress
/// through the day. Accurate to a few hours, which is plenty for display.

enum MoonPhase { newMoon, waxingCrescent, firstQuarter, waxingGibbous, fullMoon, waningGibbous, lastQuarter, waningCrescent }

class MoonInfo {
    /// Average length of a lunar cycle, in days.
    static const synodicMonth = 29.530588853;

    /// A known new moon: 6 January 2000, 18:14 UTC.
    static final _referenceNewMoon = DateTime.utc(2000, 1, 6, 18, 14);

    /// Days since the last new moon (0 to 29.53).
    final double age;

    const MoonInfo._(this.age);

    factory MoonInfo.at(DateTime time) {
        final days = time.toUtc().difference(_referenceNewMoon).inSeconds / Duration.secondsPerDay;
        final age = days % synodicMonth; // Dart's % is never negative for a positive divisor
        return MoonInfo._(age);
    }

    /// Position in the cycle: 0 = new, 0.5 = full, approaching 1 = new again.
    double get fraction => age / synodicMonth;

    /// Share of the visible disc that is lit (0 to 1).
    double get illumination => (1 - math.cos(2 * math.pi * fraction)) / 2;

    bool get waxing => fraction < 0.5;

    /// The nearest of the 8 named phases.
    MoonPhase get phase => MoonPhase.values[((fraction * 8) + 0.5).floor() % 8];
}

/// How far the sun is through today's daylight, at the place.
class SunProgress {
    final DateTime sunrise, sunset;

    const SunProgress({ required this.sunrise, required this.sunset });

    Duration get daylight => sunset.difference(sunrise);

    /// 0 at sunrise, 1 at sunset; null before sunrise or after sunset.
    /// [localNow] must be the time *at the place*, like [sunrise] and [sunset].
    double? at(DateTime localNow) {
        final total = daylight.inSeconds;
        if (total <= 0 || localNow.isBefore(sunrise) || localNow.isAfter(sunset)) return null;
        return localNow.difference(sunrise).inSeconds / total;
    }
}
