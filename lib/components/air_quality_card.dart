import 'package:bweather/l10n/l10n.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';

/// Air quality (US AQI, PM2.5, PM10, dust), UV index and, in Europe, pollen.
class AirQualityCard extends StatelessWidget {
    final AirQuality airQuality;

    const AirQualityCard({ super.key, required this.airQuality });

    /// Dust above this (µg/m³) triggers the mask hint (Harmattan season).
    static const dustWarning = 150.0;

    static Color aqiColor(AqiLevel level) => switch (level) {
        AqiLevel.good => const Color(0xFF2E9E44),
        AqiLevel.moderate => const Color(0xFFD9A400),
        AqiLevel.sensitive => const Color(0xFFE8710A),
        AqiLevel.unhealthy => const Color(0xFFD32F2F),
        AqiLevel.veryUnhealthy => const Color(0xFF8E24AA),
        AqiLevel.hazardous => const Color(0xFF7B1F1F),
    };

    static Color uvColor(UvLevel level) => switch (level) {
        UvLevel.low => const Color(0xFF2E9E44),
        UvLevel.moderate => const Color(0xFFD9A400),
        UvLevel.high => const Color(0xFFE8710A),
        UvLevel.veryHigh => const Color(0xFFD32F2F),
        UvLevel.extreme => const Color(0xFF8E24AA),
    };

    static String aqiLabel(AppLocalizations l10n, AqiLevel level) => switch (level) {
        AqiLevel.good => l10n.aqiGood,
        AqiLevel.moderate => l10n.aqiModerate,
        AqiLevel.sensitive => l10n.aqiSensitive,
        AqiLevel.unhealthy => l10n.aqiUnhealthy,
        AqiLevel.veryUnhealthy => l10n.aqiVeryUnhealthy,
        AqiLevel.hazardous => l10n.aqiHazardous,
    };

    static String uvLabel(AppLocalizations l10n, UvLevel level) => switch (level) {
        UvLevel.low => l10n.uvLow,
        UvLevel.moderate => l10n.uvModerate,
        UvLevel.high => l10n.uvHigh,
        UvLevel.veryHigh => l10n.uvVeryHigh,
        UvLevel.extreme => l10n.uvExtreme,
    };

    static String pollenLabel(AppLocalizations l10n, String key) => switch (key) {
        "alder_pollen" => l10n.pollenAlder,
        "birch_pollen" => l10n.pollenBirch,
        "grass_pollen" => l10n.pollenGrass,
        "mugwort_pollen" => l10n.pollenMugwort,
        "olive_pollen" => l10n.pollenOlive,
        "ragweed_pollen" => l10n.pollenRagweed,
        _ => key,
    };

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        final aqi = airQuality.usAqi, aqiLevel = airQuality.aqiLevel;
        final uv = airQuality.uvIndex, uvLevel = airQuality.uvLevel;
        final dust = airQuality.dust;
        final pollen = airQuality.pollen.entries.where((entry) => entry.value >= 1).toList();

        String micrograms(double? value) => value == null ? "--" : "${value.round()} µg/m³";

        return Container(
            decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.airQuality, style: theme.textTheme.titleMedium?.copyWith(color: colors.primary)),
                const SizedBox(height: 10),
                if (aqi != null && aqiLevel != null)
                    Semantics(
                        label: "${l10n.airQualityIndex(aqi)}, ${aqiLabel(l10n, aqiLevel)}",
                        excludeSemantics: true,
                        child: Row(children: [
                            _Badge(text: "$aqi", color: aqiColor(aqiLevel)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(aqiLabel(l10n, aqiLevel), style: theme.textTheme.titleSmall),
                                Text(l10n.airQualityIndex(aqi), style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                            ])),
                        ]),
                    ),
                const SizedBox(height: 12),
                Wrap(spacing: 16, runSpacing: 8, children: [
                    _Metric(label: l10n.pm25, value: micrograms(airQuality.pm25)),
                    _Metric(label: l10n.pm10, value: micrograms(airQuality.pm10)),
                    _Metric(label: l10n.dust, value: micrograms(dust)),
                    if (uv != null && uvLevel != null)
                        _Metric(label: l10n.uvIndex, value: "${uv.round()} · ${uvLabel(l10n, uvLevel)}", color: uvColor(uvLevel)),
                ]),
                if (dust != null && dust >= dustWarning) ...[
                    const SizedBox(height: 10),
                    Row(children: [
                        Icon(Icons.masks_outlined, size: 18, color: colors.error),
                        const SizedBox(width: 6),
                        Expanded(child: Text(l10n.harmattanDustHint, style: theme.textTheme.bodySmall?.copyWith(color: colors.error))),
                    ]),
                ],
                if (pollen.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(l10n.pollen, style: theme.textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Wrap(spacing: 16, runSpacing: 4, children: [
                        for (final entry in pollen) _Metric(label: pollenLabel(l10n, entry.key), value: entry.value.round().toString()),
                    ]),
                ],
            ]),
        );
    }
}

class _Badge extends StatelessWidget {
    final String text;
    final Color color;

    const _Badge({ required this.text, required this.color });

    @override
    Widget build(BuildContext context) => Container(
        width: 56, height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
    );
}

class _Metric extends StatelessWidget {
    final String label, value;
    final Color? color;

    const _Metric({ required this.label, required this.value, this.color });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(value, style: theme.textTheme.titleSmall?.copyWith(color: color ?? theme.colorScheme.onSurface)),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ]);
    }
}
