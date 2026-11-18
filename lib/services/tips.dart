import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/services/alerts.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';

enum TipKind { umbrella, clothes, sunscreen, hydrate, laundry, outdoor, airQuality, mosquitoes, driving }

class Tip extends Equatable {
    final TipKind kind;
    final String text;

    const Tip(this.kind, this.text);

    @override
    List<Object?> get props => [kind, text];
}

/// Practical advice for today derived from the forecast ("what to wear",
/// umbrella, laundry, best time outdoors, ...). Pure, for unit tests.
class TipsEngine {
    static const maxTips = 5;

    static const _fogCodes = {45, 48};
    static const _heavyRainCodes = {65, 67, 82, 95, 96, 99};

    static List<Tip> tips({
        required Forecast forecast,
        required AppLocalizations l10n,
        required String locale,
        required DateTime now,
    }) {
        final tips = <Tip>[];
        final today = forecast.today(now);
        final next12 = forecast.upcomingHours(12, now);
        final localNow = forecast.localNow(now);
        final airQuality = forecast.airQuality;

        double celsius(Value<double> value) => AlertEvaluator.toCelsius(value.value, value.unit);

        // Driving hazards first: they matter most.
        for (final hour in next12.take(6)) {
            if (_fogCodes.contains(hour.weatherCode)) {
                tips.add(Tip(TipKind.driving, l10n.tipDriveFog(formatClock(hour.time, locale))));
                break;
            }
            if (_heavyRainCodes.contains(hour.weatherCode)) {
                tips.add(Tip(TipKind.driving, l10n.tipDriveRain(formatClock(hour.time, locale))));
                break;
            }
        }

        // Umbrella: rain likely today; say when.
        final rainChance = today?.precipitationProbabilityMax?.value ?? 0;
        if (rainChance >= 50 && next12.isNotEmpty) {
            final wettest = next12.reduce((a, b) => b.precipitationProbability.value > a.precipitationProbability.value ? b : a);
            if (wettest.precipitationProbability.value >= 40) {
                tips.add(Tip(TipKind.umbrella, l10n.tipUmbrella(wettest.precipitationProbability.value, formatClock(wettest.time, locale))));
            }
        }

        // What to wear, from today's highest feels-like temperature.
        final feelsLike = today?.apparentTemperatureMax;
        if (feelsLike != null) {
            final c = celsius(feelsLike);
            final text = c >= 32 ? l10n.tipClothesHot
                : c >= 24 ? l10n.tipClothesWarm
                : c >= 15 ? l10n.tipClothesMild
                : c >= 5 ? l10n.tipClothesCool
                : l10n.tipClothesCold;
            tips.add(Tip(TipKind.clothes, text));

            if (c >= 35) {
                tips.add(Tip(TipKind.hydrate, l10n.tipHydrate("${roundTemp(feelsLike.value)}${feelsLike.unit}")));
            }
        }

        // Sun protection.
        final uvLevel = airQuality?.uvLevel;
        if (uvLevel != null && uvLevel.index >= UvLevel.high.index) {
            final label = switch (uvLevel) {
                UvLevel.high => l10n.uvHigh,
                UvLevel.veryHigh => l10n.uvVeryHigh,
                _ => l10n.uvExtreme,
            };
            tips.add(Tip(TipKind.sunscreen, l10n.tipSunscreen(label.toLowerCase())));
        }

        // Air quality.
        final aqi = airQuality?.usAqi;
        if (aqi != null && aqi > 100) {
            tips.add(Tip(TipKind.airQuality, l10n.tipAirQuality));
        }

        // Best time outdoors: dry, daylight, closest to a comfortable 22 °C.
        final daylight = next12.where((hour) => hour.isDay ?? (hour.time.hour >= 7 && hour.time.hour < 19)).toList();
        final dryDaylight = daylight.where((hour) => hour.precipitationProbability.value < 30).toList();
        if (dryDaylight.isNotEmpty) {
            double discomfort(Hourly hour) => (celsius(hour.apparentTemperature) - 22).abs();
            final best = dryDaylight.reduce((a, b) => discomfort(b) < discomfort(a) ? b : a);
            if (best.time.hour != localNow.hour) {
                tips.add(Tip(TipKind.outdoor, l10n.tipBestOutdoorTime(formatClock(best.time, locale))));
            }
        }

        // Laundry: the next daylight hours must be dry and not too humid.
        if (daylight.length >= 4) {
            final window = daylight.take(6).toList();
            final dry = window.every((hour) => hour.precipitationProbability.value < 20);
            final humidity = window.map((hour) => hour.relativeHumidity.value).reduce((a, b) => a + b) / window.length;
            if (dry && humidity < 75) {
                tips.add(Tip(TipKind.laundry, l10n.tipLaundryGood));
            } else if (window.any((hour) => hour.precipitationProbability.value >= 50)) {
                tips.add(Tip(TipKind.laundry, l10n.tipLaundryBad));
            }
        }

        // Mosquitoes: a warm, humid evening ahead.
        final evening = next12.where((hour) => hour.time.hour >= 18 && hour.time.hour <= 22).toList();
        if (evening.isNotEmpty
            && evening.every((hour) => celsius(hour.temperature) >= 24 && hour.relativeHumidity.value >= 70)) {
            tips.add(Tip(TipKind.mosquitoes, l10n.tipMosquitoes));
        }

        return tips.take(maxTips).toList();
    }
}
