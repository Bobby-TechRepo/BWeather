import 'package:bweather/services/alerts.dart';
import 'package:bweather/states/trips/trip.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';

/// Forecast days fetched for one stop, and the units they are in.
class StopForecast extends Equatable {
    final List<Daily> days;
    final DateTime fetchedAt;

    /// `Units.serialize()` of the units [days] are in.
    final String units;

    const StopForecast({ required this.days, required this.fetchedAt, required this.units });

    /// Trip forecasts change slowly; refresh at most every few hours.
    static const maxAge = Duration(hours: 3);

    bool isStale([DateTime? now]) => (now ?? DateTime.now()).difference(fetchedAt) > maxAge;

    /// The same days in [target] units (no request needed).
    StopForecast convertedTo(Units target) => target.serialize() == units
        ? this
        : StopForecast(days: [for (final day in days) day.convertedTo(target)], fetchedAt: fetchedAt, units: target.serialize());

    Daily? on(DateTime date) {
        for (final day in days) {
            if (day.time.year == date.year && day.time.month == date.month && day.time.day == date.day) return day;
        }
        return null;
    }

    factory StopForecast.fromJson(dynamic json) => StopForecast(
        days: [for (final day in (json["days"] as List)) Daily.fromJson(day)],
        fetchedAt: DateTime.parse(json["fetchedAt"].toString()),
        units: json["units"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "days": days.map((day) => day.toJson()).toList(),
        "fetchedAt": fetchedAt.toIso8601String(),
        "units": units,
    };

    @override
    List<Object?> get props => [days, fetchedAt, units];
}

/// What we know about one day of a trip.
sealed class DayWeather extends Equatable {
    const DayWeather();
}

/// A real forecast (within about 16 days).
class ForecastDay extends DayWeather {
    final Daily daily;

    const ForecastDay(this.daily);

    @override
    List<Object?> get props => [daily];
}

/// Too far ahead for a forecast: the average for the date over recent years.
class TypicalDay extends DayWeather {
    /// In the user's unit ([unit] is "°C" or "°F").
    final double high, low;
    final String unit;

    const TypicalDay({ required this.high, required this.low, required this.unit });

    @override
    List<Object?> get props => [high, low, unit];
}

/// Nothing yet (still loading, offline, or no data for that place).
class UnknownDay extends DayWeather {
    const UnknownDay();

    @override
    List<Object?> get props => [];
}

class TripDay extends Equatable {
    final DateTime date;
    final TripStop stop;

    /// Set on travel days: the stop you leave that morning.
    final TripStop? leaving;
    final DayWeather weather;

    const TripDay({ required this.date, required this.stop, this.leaving, required this.weather });

    bool get isTravelDay => leaving != null;

    @override
    List<Object?> get props => [date, stop, leaving, weather];
}

/// Day-by-day weather for [trip]: the forecast where there is one, otherwise
/// typical weather from climate [normals] (keyed by city id, in °C).
List<TripDay> tripDays(Trip trip, { required Map<String, StopForecast> forecasts, required Map<String, ClimateNormals> normals, required TempUnit tempUnit }) {
    final fahrenheit = tempUnit == TempUnit.fahrenheit;
    double convert(double celsius) => fahrenheit ? celsius * 9 / 5 + 32 : celsius;

    return [
        for (final date in trip.dates)
            if (trip.stopOn(date) case final stop?)
                TripDay(
                    date: date,
                    stop: stop,
                    leaving: trip.leavingOn(date),
                    weather: () {
                        final forecast = forecasts[stop.id]?.on(date);
                        if (forecast != null) return ForecastDay(forecast);
                        final normal = normals[stop.city.id];
                        final high = normal?.highFor(date), low = normal?.lowFor(date);
                        if (high != null && low != null) {
                            return TypicalDay(high: convert(high), low: convert(low), unit: fahrenheit ? "°F" : "°C");
                        }
                        return const UnknownDay();
                    }(),
                ),
    ];
}

/// A short overview of a trip's weather for cards and sharing.
class TripOutlook extends Equatable {
    /// Lowest low and highest high over the trip, in the user's unit; null when nothing is known.
    final double? low, high;
    final String unit;

    /// The weather code seen most often in the forecast days, if any.
    final int? commonCode;

    /// Days with rain likely (≥ 40% or ≥ 1 mm in the forecast).
    final int rainyDays;
    final int forecastDays, typicalDays;

    const TripOutlook({ this.low, this.high, required this.unit, this.commonCode, this.rainyDays = 0, this.forecastDays = 0, this.typicalDays = 0 });

    factory TripOutlook.of(List<TripDay> days) {
        double? low, high;
        String unit = "";
        final codes = <int, int>{};
        int rainy = 0, forecastCount = 0, typicalCount = 0;

        void include(double dayLow, double dayHigh) {
            low = low == null || dayLow < low! ? dayLow : low;
            high = high == null || dayHigh > high! ? dayHigh : high;
        }

        for (final day in days) {
            switch (day.weather) {
                case ForecastDay(:final daily):
                    forecastCount++;
                    unit = daily.temperatureMax.unit;
                    include(daily.temperatureMin.value, daily.temperatureMax.value);
                    codes[daily.weatherCode] = (codes[daily.weatherCode] ?? 0) + 1;
                    if (isRainy(daily)) rainy++;
                case TypicalDay(high: final dayHigh, low: final dayLow, unit: final dayUnit):
                    typicalCount++;
                    unit = unit.isEmpty ? dayUnit : unit;
                    include(dayLow, dayHigh);
                case UnknownDay():
                    break;
            }
        }

        int? common;
        int best = 0;
        codes.forEach((code, count) {
            if (count > best) {
                best = count;
                common = code;
            }
        });

        return TripOutlook(low: low, high: high, unit: unit, commonCode: common, rainyDays: rainy, forecastDays: forecastCount, typicalDays: typicalCount);
    }

    static bool isRainy(Daily daily) {
        final probability = daily.precipitationProbabilityMax?.value ?? 0;
        final sum = daily.precipitationSum;
        final sumMm = sum == null ? 0.0 : (sum.unit.toLowerCase().contains("inch") ? sum.value * 25.4 : sum.value);
        return probability >= 40 || sumMm >= 1;
    }

    @override
    List<Object?> get props => [low, high, unit, commonCode, rainyDays, forecastDays, typicalDays];
}

/// Things worth packing for the weather on a trip.
enum PackingItem {
    umbrella, rainJacket, sunscreen, sunglasses, hat, lightClothes, waterBottle,
    warmLayer, coat, gloves, windbreaker, insectRepellent,
}

/// Suggests [PackingItem]s from the trip's days. Temperatures are compared in °C.
List<PackingItem> packingFor(List<TripDay> days) {
    double? maxHigh, minLow, maxWindKmh;
    int rainy = 0;

    void temps(double lowC, double highC) {
        maxHigh = maxHigh == null || highC > maxHigh! ? highC : maxHigh;
        minLow = minLow == null || lowC < minLow! ? lowC : minLow;
    }

    for (final day in days) {
        switch (day.weather) {
            case ForecastDay(:final daily):
                temps(
                    AlertEvaluator.toCelsius(daily.temperatureMin.value, daily.temperatureMin.unit),
                    AlertEvaluator.toCelsius(daily.temperatureMax.value, daily.temperatureMax.unit),
                );
                if (TripOutlook.isRainy(daily)) rainy++;
                final wind = daily.windSpeedMax;
                if (wind != null) {
                    final kmh = AlertEvaluator.toKmh(wind.value, wind.unit);
                    maxWindKmh = maxWindKmh == null || kmh > maxWindKmh ? kmh : maxWindKmh;
                }
            case TypicalDay(:final high, :final low, :final unit):
                temps(AlertEvaluator.toCelsius(low, unit), AlertEvaluator.toCelsius(high, unit));
            case UnknownDay():
                break;
        }
    }

    final high = maxHigh, low = minLow, wind = maxWindKmh;
    return [
        if (rainy > 0) PackingItem.umbrella,
        if (rainy >= 3) PackingItem.rainJacket,
        if (high != null && high >= 27) PackingItem.lightClothes,
        if (high != null && high >= 28) ...[PackingItem.sunscreen, PackingItem.sunglasses, PackingItem.hat],
        if (high != null && high >= 32) PackingItem.waterBottle,
        if (high != null && high >= 26 && rainy > 0) PackingItem.insectRepellent,
        if (low != null && low <= 12) PackingItem.warmLayer,
        if (low != null && low <= 3) ...[PackingItem.coat, PackingItem.gloves],
        if (wind != null && wind >= 40) PackingItem.windbreaker,
    ];
}
