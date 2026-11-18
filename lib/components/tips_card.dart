import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/services/tips.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';

/// "Today's tips": what to wear, umbrella, laundry, best time outdoors, ...
class TipsCard extends StatelessWidget {
    final Forecast forecast;

    const TipsCard({ super.key, required this.forecast });

    static IconData iconFor(TipKind kind) => switch (kind) {
        TipKind.umbrella => Icons.umbrella_outlined,
        TipKind.clothes => Icons.checkroom_outlined,
        TipKind.sunscreen => Icons.wb_sunny_outlined,
        TipKind.hydrate => Icons.local_drink_outlined,
        TipKind.laundry => Icons.local_laundry_service_outlined,
        TipKind.outdoor => Icons.directions_run,
        TipKind.airQuality => Icons.masks_outlined,
        TipKind.mosquitoes => Icons.bug_report_outlined,
        TipKind.driving => Icons.directions_car_outlined,
    };

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final tips = TipsEngine.tips(forecast: forecast, l10n: l10n, locale: context.localeName, now: DateTime.now());
        if (tips.isEmpty) return const SizedBox.shrink();

        return Container(
            decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.tipsTitle, style: theme.textTheme.titleMedium?.copyWith(color: colors.primary)),
                const SizedBox(height: 8),
                for (final tip in tips)
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Icon(iconFor(tip.kind), size: 20, color: colors.secondary),
                            const SizedBox(width: 10),
                            Expanded(child: Text(tip.text, style: theme.textTheme.bodyMedium)),
                        ]),
                    ),
            ]),
        );
    }
}
