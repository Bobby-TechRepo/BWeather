import 'package:bweather/components/details.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';

/// Grid of secondary conditions for the current hour / today *at the place*.
/// Sunrise and sunset live in the sun & moon card.
class DetailsSection extends StatelessWidget {
    final Forecast forecast;

    const DetailsSection({ super.key, required this.forecast });

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final current = forecast.current;
        final today = forecast.today();
        final hour = forecast.currentHour();

        final rainToday = today?.precipitationSum;

        return GridView.count(
            crossAxisCount: 2, physics: const NeverScrollableScrollPhysics(), shrinkWrap: true,
            crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.4,
            children: [
                Details(
                    title: l10n.windDirection,
                    info: "${compassPoint(l10n, current.windDirection.value)} ${current.windDirection.value}${current.windDirection.unit}",
                    iconAsset: "files/noto--compass.svg",
                ),
                Details(title: l10n.windGusts, info: "${current.windGusts.value.round()} ${current.windGusts.unit}", iconAsset: "files/fluent-emoji-flat--leaf-fluttering-in-wind.svg"),
                Details(
                    title: l10n.rainToday,
                    info: rainToday == null ? "${current.rain.value} ${current.rain.unit}" : "${rainToday.value.toStringAsFixed(1)} ${rainToday.unit}",
                    iconAsset: "files/emojione--umbrella-with-rain-drops.svg",
                ),
                Details(title: l10n.pressure, info: "${current.surfacePressure.value.round()} ${current.surfacePressure.unit}", iconAsset: "files/emojione--stopwatch.svg"),
                Details(title: l10n.cloudCover, info: "${current.cloudCover.value}${current.cloudCover.unit}", iconAsset: "files/emojione--sun-behind-cloud.svg"),
                Details(
                    title: l10n.dewPoint,
                    info: hour == null ? "--" : "${roundTemp(hour.dewPoint.value)}${hour.dewPoint.unit}",
                    iconAsset: "files/twemoji--droplet.svg",
                ),
            ],
        );
    }
}
