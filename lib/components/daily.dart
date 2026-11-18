import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/utils/weather_codes.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyView extends StatelessWidget {
    final Daily daily;

    /// Overrides the weekday name, e.g. "Today".
    final String? label;

    const DailyView({ super.key, required this.daily, this.label });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final l10n = context.l10n;
        final weatherCode = WeatherCode.decode(code: daily.weatherCode, isNight: false);
        final min = roundTemp(daily.temperatureMin.value), max = roundTemp(daily.temperatureMax.value);
        final unit = daily.temperatureMax.unit;
        final rainChance = daily.precipitationProbabilityMax;
        final title = label ?? shortDay(daily.time, context.localeName);

        return Semantics(
            label: "${l10n.semanticsDay(title, weatherCode.describe(l10n), "$min$unit", "$max$unit")}${rainChance == null ? "" : ", ${l10n.semanticsRainChance(rainChance.value)}"}",
            excludeSemantics: true,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(title, style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.bold)),
                SvgPicture.asset(weatherCode.image, width: 90, height: 80),
                Text("$min° / $max$unit", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: colors.onSurfaceVariant)),
                if (rainChance != null && rainChance.value > 0)
                    Text("💧 ${rainChance.value}${rainChance.unit}", style: TextStyle(fontSize: 12, color: colors.primary)),
            ]),
        );
    }
}
