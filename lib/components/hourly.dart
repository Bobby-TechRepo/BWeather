import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/utils/weather_codes.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HourlyView extends StatelessWidget {
    final Hourly hourly;
    final bool isNight;

    /// Overrides the hour, e.g. "Now".
    final String? label;

    const HourlyView({ super.key, required this.hourly, required this.isNight, this.label });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final l10n = context.l10n;
        final weatherCode = WeatherCode.decode(code: hourly.weatherCode, isNight: isNight);
        final temp = roundTemp(hourly.temperature.value);
        final title = label ?? formatHour(hourly.time, context.localeName);
        final rainChance = hourly.precipitationProbability.value;

        return Semantics(
            label: "$title: ${weatherCode.describe(l10n)}, $temp${hourly.temperature.unit}, ${l10n.semanticsRainChance(rainChance)}",
            excludeSemantics: true,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(title, style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.bold)),
                SvgPicture.asset(weatherCode.image, height: 80, width: 90),
                Text("$temp${hourly.temperature.unit}", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400, color: colors.onSurfaceVariant)),
                if (rainChance > 0)
                    Text("💧 $rainChance${hourly.precipitationProbability.unit}", style: TextStyle(fontSize: 12, color: colors.primary)),
            ]),
        );
    }
}
