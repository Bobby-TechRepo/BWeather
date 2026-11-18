import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/states/trips/trip.dart';
import 'package:bweather/states/trips/trip_weather.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/utils/weather_codes.dart';

/// Display name for a packing suggestion.
String packingItemName(AppLocalizations l10n, PackingItem item) => switch (item) {
    PackingItem.umbrella => l10n.packUmbrella,
    PackingItem.rainJacket => l10n.packRainJacket,
    PackingItem.sunscreen => l10n.packSunscreen,
    PackingItem.sunglasses => l10n.packSunglasses,
    PackingItem.hat => l10n.packHat,
    PackingItem.lightClothes => l10n.packLightClothes,
    PackingItem.waterBottle => l10n.packWaterBottle,
    PackingItem.warmLayer => l10n.packWarmLayer,
    PackingItem.coat => l10n.packCoat,
    PackingItem.gloves => l10n.packGloves,
    PackingItem.windbreaker => l10n.packWindbreaker,
    PackingItem.insectRepellent => l10n.packInsectRepellent,
};

/// Plain-text summary of a trip's weather, for the share sheet.
String tripShareText(Trip trip, List<TripDay> days, AppLocalizations l10n, String locale) {
    final lines = <String>[
        "${trip.name} (${formatDateRange(trip.start, trip.end, locale)})",
        "",
    ];
    for (final day in days) {
        final date = formatDayDate(day.date, locale);
        final place = day.stop.city.name;
        switch (day.weather) {
            case ForecastDay(:final daily):
                lines.add(l10n.shareForecastDay(
                    date, place,
                    WeatherCode.decode(code: daily.weatherCode, isNight: false).describe(l10n),
                    "${roundTemp(daily.temperatureMin.value)}°", "${roundTemp(daily.temperatureMax.value)}°",
                    daily.precipitationProbabilityMax?.value ?? 0,
                ));
            case TypicalDay(:final high, :final low):
                lines.add(l10n.shareTypicalDay(date, place, "${roundTemp(low)}°", "${roundTemp(high)}°"));
            case UnknownDay():
                lines.add("$date · $place");
        }
    }
    final packing = packingFor(days);
    if (packing.isNotEmpty) {
        lines
            ..add("")
            ..add("${l10n.packingList}: ${packing.map((item) => packingItemName(l10n, item)).join(", ")}");
    }
    lines
        ..add("")
        ..add(l10n.sharedFromApp);
    return lines.join("\n");
}
