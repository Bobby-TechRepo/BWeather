import 'package:bweather/components/weather_background.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/screens/trips/trip_detail.dart';
import 'package:bweather/states/trips/trip.dart';
import 'package:bweather/states/trips/trip_weather.dart';
import 'package:bweather/states/trips/trips_cubit.dart';
import 'package:bweather/utils/sky_palette.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/utils/weather_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

/// A trip in the Trips list: name, dates, stops and a one-line weather outlook,
/// tinted by the most common forecast sky.
class TripCard extends StatelessWidget {
    final String tripId;

    const TripCard({ super.key, required this.tripId });

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final locale = context.localeName;
        final text = Theme.of(context).textTheme;
        final colors = Theme.of(context).colorScheme;

        return BlocBuilder<TripsCubit, TripsState>(
            builder: (context, state) {
                final trip = state.trip(tripId);
                if (trip == null) return const SizedBox.shrink();

                final cubit = context.read<TripsCubit>();
                final outlook = TripOutlook.of(cubit.days(trip));
                final timing = trip.timing();
                final code = outlook.commonCode;
                final tinted = code != null && timing != TripTiming.past;
                final foreground = tinted ? Colors.white : colors.onSurface;
                final soft = tinted ? Colors.white.withValues(alpha: 0.82) : colors.onSurfaceVariant;
                final loading = trip.stops.any((stop) => state.loading.contains(stop.id));

                return Material(
                    color: tinted ? Colors.transparent : colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                    clipBehavior: Clip.antiAlias,
                    child: Ink(
                        decoration: tinted ? BoxDecoration(gradient: SkyPalette.of(SkyScene.from(weatherCode: code, isDay: true))) : null,
                        child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(TripDetailScreen.routeName, arguments: trip.id),
                            child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Text(trip.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: text.titleLarge?.copyWith(color: foreground, fontWeight: FontWeight.w600)),
                                                const SizedBox(height: 2),
                                                Text(
                                                    "${formatDateRange(trip.start, trip.end, locale)} · ${l10n.tripDayCount(trip.dayCount)}",
                                                    style: text.bodySmall?.copyWith(color: soft, fontWeight: FontWeight.w500),
                                                ),
                                            ]),
                                        ),
                                        if (code != null) SvgPicture.asset(WeatherCode.decode(code: code, isNight: false).image, width: 48, height: 48),
                                    ]),
                                    const SizedBox(height: 12),
                                    Text(
                                        trip.stops.map((stop) => stop.city.name).join("  →  "),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: text.bodyMedium?.copyWith(color: foreground, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(spacing: 8, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
                                        _Pill(text: tripTimingLabel(l10n, trip), foreground: foreground, tinted: tinted),
                                        if (outlook.low != null && outlook.high != null)
                                            _Pill(text: l10n.tripOutlookRange("${roundTemp(outlook.low!)}°", "${roundTemp(outlook.high!)}°"), foreground: foreground, tinted: tinted),
                                        if (outlook.forecastDays > 0)
                                            _Pill(text: l10n.tripRainyDays(outlook.rainyDays), foreground: foreground, tinted: tinted),
                                        if (code != null && outlook.forecastDays > 0)
                                            Text(WeatherCode.decode(code: code, isNight: false).describe(l10n), style: text.labelMedium?.copyWith(color: soft)),
                                        if (loading) SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2, color: foreground)),
                                    ]),
                                ]),
                            ),
                        ),
                    ),
                );
            },
        );
    }
}

/// "Starts in 12 days" / "Happening now" / "Ended".
String tripTimingLabel(AppLocalizations l10n, Trip trip) => switch (trip.timing()) {
    TripTiming.upcoming => l10n.tripStartsIn(trip.daysUntil()),
    TripTiming.ongoing => l10n.tripOngoing,
    TripTiming.past => l10n.tripEnded,
};

class _Pill extends StatelessWidget {
    final String text;
    final Color foreground;
    final bool tinted;

    const _Pill({ required this.text, required this.foreground, required this.tinted });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        return DecoratedBox(
            decoration: BoxDecoration(
                color: tinted ? Colors.white.withValues(alpha: 0.18) : colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: foreground, fontWeight: FontWeight.w600)),
            ),
        );
    }
}
