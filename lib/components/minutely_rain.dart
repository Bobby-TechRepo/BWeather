import 'dart:math' as math;

import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';

enum RainTrend { none, starting, stopping, continuing }

/// A one-line summary of the next 2 hours of 15-minute precipitation.
class RainOutlook extends Equatable {
    final RainTrend trend;

    /// Minutes until rain starts/stops (rounded up to 5); 0 when not relevant.
    final int minutes;

    const RainOutlook(this.trend, [this.minutes = 0]);

    /// Amounts below this (per 15 minutes) count as dry.
    static double wetThreshold(String unit) => unit.toLowerCase().contains("inch") ? 0.004 : 0.1;

    static bool isWet(MinutelyPrecipitation step) => step.precipitation >= wetThreshold(step.unit);

    /// [steps] must start with the current step (see Forecast.upcomingMinutely);
    /// [now] is the time at the place.
    factory RainOutlook.from(List<MinutelyPrecipitation> steps, DateTime now) {
        if (steps.isEmpty) return const RainOutlook(RainTrend.none);

        int minutesUntil(DateTime time) {
            final minutes = time.difference(now).inMinutes;
            return math.max(5, ((minutes + 4) ~/ 5) * 5);
        }

        final wetNow = isWet(steps.first);
        for (final step in steps.skip(1)) {
            if (isWet(step) != wetNow) {
                return RainOutlook(wetNow ? RainTrend.stopping : RainTrend.starting, minutesUntil(step.time));
            }
        }
        return RainOutlook(wetNow ? RainTrend.continuing : RainTrend.none);
    }

    String describe(AppLocalizations l10n) => switch (trend) {
        RainTrend.none => l10n.noRainSoon,
        RainTrend.starting => l10n.rainStartingIn(minutes),
        RainTrend.stopping => l10n.rainStoppingIn(minutes),
        RainTrend.continuing => l10n.rainContinuing,
    };

    @override
    List<Object?> get props => [trend, minutes];
}

/// "Rain starting in about 20 min" with a small bar chart of the next 2 hours.
class MinutelyRainCard extends StatelessWidget {
    final Forecast forecast;

    const MinutelyRainCard({ super.key, required this.forecast });

    @override
    Widget build(BuildContext context) {
        final steps = forecast.upcomingMinutely();
        final now = forecast.localNow(); // time at the place, like the steps
        if (steps.isEmpty) return const SizedBox.shrink();

        final l10n = context.l10n;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final outlook = RainOutlook.from(steps, now);
        final shown = steps.take(8).toList();
        // Scale bars to the wettest step, but never below "moderate" so drizzle looks small.
        final moderate = steps.first.unit.toLowerCase().contains("inch") ? 0.04 : 1.0;
        final peak = math.max(moderate, shown.map((step) => step.precipitation).reduce(math.max));

        return Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: colors.surfaceContainerLow.withValues(alpha: 0.92),
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                        Icon(outlook.trend == RainTrend.none ? Icons.umbrella_outlined : Icons.umbrella, size: 20, color: colors.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(outlook.describe(l10n), style: theme.textTheme.titleSmall)),
                    ]),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 44,
                        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            for (final step in shown)
                                Expanded(
                                    child: Semantics(
                                        label: "${formatClock(step.time, context.localeName)}: ${step.precipitation} ${step.unit}",
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2),
                                            child: Container(
                                                height: RainOutlook.isWet(step) ? math.max(4.0, 44 * (step.precipitation / peak).clamp(0.0, 1.0).toDouble()) : 2,
                                                decoration: BoxDecoration(
                                                    color: RainOutlook.isWet(step) ? colors.primary : colors.outlineVariant,
                                                    borderRadius: BorderRadius.circular(3),
                                                ),
                                            ),
                                        ),
                                    ),
                                ),
                        ]),
                    ),
                    const SizedBox(height: 6),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(l10n.now, style: theme.textTheme.bodySmall),
                        Text(l10n.nextTwoHours, style: theme.textTheme.bodySmall),
                        Text(formatClock(shown.last.time.add(const Duration(minutes: 15)), context.localeName), style: theme.textTheme.bodySmall),
                    ]),
                ]),
            ),
        );
    }
}
