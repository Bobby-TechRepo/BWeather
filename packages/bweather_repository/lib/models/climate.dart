import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// Typical daily high/low (°C) for each day of the year at a place, averaged
/// over recent years. Used for "warmer/cooler than usual".
class ClimateNormals extends Equatable {
    /// Days on each side of a date included in its average (smooths noise).
    static const windowDays = 7;

    /// Index 0..365 = day of year 1..366 (Feb 29 included). Null where unknown.
    final List<double?> highs, lows;

    /// The years averaged, e.g. "2006–2025", for display/debugging.
    final int fromYear, toYear;

    const ClimateNormals({ required this.highs, required this.lows, required this.fromYear, required this.toYear });

    static int dayOfYear(DateTime date) => date.difference(DateTime(date.year)).inDays + 1;

    double? highFor(DateTime date) => _at(highs, dayOfYear(date));
    double? lowFor(DateTime date) => _at(lows, dayOfYear(date));

    static double? _at(List<double?> values, int day) => (day >= 1 && day <= values.length) ? values[day - 1] : null;

    /// Builds normals from daily history: for every day of the year, the mean of
    /// all values within ±[windowDays] of that calendar day across all years.
    factory ClimateNormals.fromDaily({ required List<DateTime> dates, required List<double?> maxima, required List<double?> minima }) {
        final count = math.min(dates.length, math.min(maxima.length, minima.length));
        final highSums = List<double>.filled(366, 0), lowSums = List<double>.filled(366, 0);
        final highCounts = List<int>.filled(366, 0), lowCounts = List<int>.filled(366, 0);
        var fromYear = 9999, toYear = 0;

        for (int i = 0; i < count; i++) {
            final high = maxima[i], low = minima[i];
            if (high == null && low == null) continue;
            final day = dayOfYear(dates[i]);
            fromYear = math.min(fromYear, dates[i].year);
            toYear = math.max(toYear, dates[i].year);
            for (int offset = -windowDays; offset <= windowDays; offset++) {
                final target = (day - 1 + offset) % 366; // wraps around the new year
                if (high != null) {
                    highSums[target] += high;
                    highCounts[target]++;
                }
                if (low != null) {
                    lowSums[target] += low;
                    lowCounts[target]++;
                }
            }
        }

        return ClimateNormals(
            highs: [for (int d = 0; d < 366; d++) highCounts[d] == 0 ? null : highSums[d] / highCounts[d]],
            lows: [for (int d = 0; d < 366; d++) lowCounts[d] == 0 ? null : lowSums[d] / lowCounts[d]],
            fromYear: toYear == 0 ? 0 : fromYear,
            toYear: toYear,
        );
    }

    factory ClimateNormals.fromJson(dynamic json) {
        List<double?> list(String key) => [for (final value in (json[key] as List)) value == null ? null : double.parse(value.toString())];
        return ClimateNormals(
            highs: list("highs"), lows: list("lows"),
            fromYear: int.parse(json["fromYear"].toString()), toYear: int.parse(json["toYear"].toString()),
        );
    }

    Map<String, dynamic> toJson() => {
        // Rounded to 0.1 °C to keep the saved state small.
        "highs": [for (final value in highs) value == null ? null : (value * 10).round() / 10],
        "lows": [for (final value in lows) value == null ? null : (value * 10).round() / 10],
        "fromYear": fromYear, "toYear": toYear,
    };

    @override
    List<Object?> get props => [highs, lows, fromYear, toYear];
}

/// How today's forecast high compares with the normal high.
enum Anomaly { muchCooler, cooler, normal, warmer, muchWarmer }

class TemperatureComparison extends Equatable {
    /// Difference in °C (positive = warmer than usual).
    final double differenceC;

    const TemperatureComparison(this.differenceC);

    /// Differences smaller than this count as "about normal".
    static const normalBandC = 1.5;
    static const largeC = 5.0;

    Anomaly get anomaly {
        if (differenceC <= -largeC) return Anomaly.muchCooler;
        if (differenceC <= -normalBandC) return Anomaly.cooler;
        if (differenceC >= largeC) return Anomaly.muchWarmer;
        if (differenceC >= normalBandC) return Anomaly.warmer;
        return Anomaly.normal;
    }

    /// The difference in degrees of the user's unit ("°C" or "°F"), rounded and positive.
    int degreesIn(String unit) {
        final value = unit.toUpperCase().contains("F") ? differenceC * 9 / 5 : differenceC;
        return value.abs().round();
    }

    @override
    List<Object?> get props => [differenceC];
}
