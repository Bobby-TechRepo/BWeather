import 'dart:math' as math;

/// Decides light or dark for the "Auto" theme from the user's own clock:
/// light from sunrise to sunset at the user's location, dark otherwise.
/// Without a location it falls back to 07:00–19:00 on the device clock.
class DayNight {
    DayNight._();

    /// The sun's centre is this far below the horizon at sunrise and sunset
    /// (refraction plus the sun's radius).
    static const double _horizon = -0.833;

    static bool isDay(DateTime now, { double? latitude, double? longitude }) {
        if (latitude == null || longitude == null) {
            final hour = now.toLocal().hour;
            return hour >= 7 && hour < 19;
        }
        return sunElevation(now, latitude, longitude) > _horizon;
    }

    /// Height of the sun above the horizon, in degrees (low-precision solar
    /// position, good to well under a degree).
    static double sunElevation(DateTime time, double latitude, double longitude) {
        const rad = math.pi / 180;
        final days = time.toUtc().millisecondsSinceEpoch / 86400000 + 2440587.5 - 2451545.0;
        final anomaly = (357.529 + 0.98560028 * days) * rad;
        final meanLongitude = 280.459 + 0.98564736 * days;
        final eclipticLongitude = (meanLongitude + 1.915 * math.sin(anomaly) + 0.020 * math.sin(2 * anomaly)) * rad;
        final obliquity = (23.439 - 0.00000036 * days) * rad;

        final rightAscension = math.atan2(math.cos(obliquity) * math.sin(eclipticLongitude), math.cos(eclipticLongitude));
        final declination = math.asin(math.sin(obliquity) * math.sin(eclipticLongitude));
        final siderealDegrees = (18.697374558 + 24.06570982441908 * days) * 15 + longitude;
        final hourAngle = siderealDegrees * rad - rightAscension;

        final lat = latitude * rad;
        final sine = math.sin(lat) * math.sin(declination) + math.cos(lat) * math.cos(declination) * math.cos(hourAngle);
        return math.asin(sine.clamp(-1.0, 1.0)) / rad;
    }
}
