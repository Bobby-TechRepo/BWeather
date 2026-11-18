import 'package:bweather/components/trip_card.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/screens/trips/trip_editor.dart';
import 'package:bweather/services/notification_service.dart';
import 'package:bweather/states/trips/trip.dart';
import 'package:bweather/states/trips/trip_text.dart';
import 'package:bweather/states/trips/trip_weather.dart';
import 'package:bweather/states/trips/trips_cubit.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/utils/weather_codes.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

/// One trip: day-by-day weather per stop, packing list, reminder and sharing.
/// The route argument is the trip id.
class TripDetailScreen extends StatefulWidget {
    static const String routeName = "trip";

    final String tripId;

    const TripDetailScreen({ super.key, required this.tripId });

    @override
    State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
    @override
    void initState() {
        super.initState();
        context.read<TripsCubit>().refresh(widget.tripId);
    }

    Future<void> _setReminder(Trip trip, bool on) async {
        final cubit = context.read<TripsCubit>();
        if (on) {
            final messenger = ScaffoldMessenger.of(context);
            final message = context.l10n.notifyPermissionDenied;
            final granted = await context.read<NotificationService>().requestPermission();
            if (!granted) {
                messenger.showSnackBar(SnackBar(content: Text(message)));
                return;
            }
        }
        cubit.setReminder(trip.id, on);
    }

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final locale = context.localeName;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return BlocBuilder<TripsCubit, TripsState>(
            builder: (context, state) {
                final trip = state.trip(widget.tripId);
                if (trip == null) {
                    // Deleted (e.g. from the editor).
                    return const Scaffold(body: SizedBox.shrink());
                }
                final cubit = context.read<TripsCubit>();
                final days = cubit.days(trip);
                final packing = packingFor(days);
                final hasTypical = days.any((day) => day.weather is TypicalDay);
                final failed = trip.stops.any((stop) => state.failed.contains(stop.id));
                final loading = trip.stops.any((stop) => state.loading.contains(stop.id));
                final timing = trip.timing();

                return Scaffold(
                    body: RefreshIndicator(
                        edgeOffset: 112,
                        onRefresh: () => cubit.refresh(trip.id, force: true),
                        child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                                SliverAppBar.large(
                                    title: Text(trip.name),
                                    actions: [
                                        IconButton(
                                            tooltip: l10n.shareTrip,
                                            icon: const Icon(Icons.share_outlined),
                                            onPressed: () => SharePlus.instance.share(ShareParams(text: tripShareText(trip, days, l10n, locale), subject: trip.name)),
                                        ),
                                        IconButton(
                                            tooltip: l10n.editTrip,
                                            icon: const Icon(Icons.edit_outlined),
                                            onPressed: () => Navigator.of(context).pushNamed(TripEditorScreen.routeName, arguments: trip.id),
                                        ),
                                        const SizedBox(width: 8),
                                    ],
                                ),
                                SliverToBoxAdapter(
                                    child: _Constrained(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                            Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                                                Chip(avatar: const Icon(Icons.event, size: 18), label: Text("${formatDateRange(trip.start, trip.end, locale)} · ${l10n.tripDayCount(trip.dayCount)}")),
                                                Chip(label: Text(tripTimingLabel(l10n, trip))),
                                                if (loading) const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                                            ]),
                                            if (failed)
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 8),
                                                    child: Row(children: [
                                                        Icon(Icons.cloud_off, size: 18, color: colors.error),
                                                        const SizedBox(width: 8),
                                                        Expanded(child: Text(l10n.couldNotRefresh, style: theme.textTheme.bodyMedium?.copyWith(color: colors.error))),
                                                        TextButton(onPressed: () => cubit.refresh(trip.id, force: true), child: Text(l10n.retry)),
                                                    ]),
                                                ),
                                            if (NotificationService.isSupported && timing == TripTiming.upcoming)
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 12),
                                                    child: Card(
                                                        child: SwitchListTile(
                                                            secondary: const Icon(Icons.notifications_active_outlined),
                                                            title: Text(l10n.tripReminder),
                                                            subtitle: Text(l10n.tripReminderDetail),
                                                            value: trip.remind,
                                                            onChanged: (on) => _setReminder(trip, on),
                                                        ),
                                                    ),
                                                ),
                                            const SizedBox(height: 8),
                                        ]),
                                    ),
                                ),
                                SliverList.builder(
                                    itemCount: days.length,
                                    itemBuilder: (context, index) {
                                        final day = days[index];
                                        final newStop = index == 0 || days[index - 1].stop.id != day.stop.id;
                                        return _Constrained(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                                if (newStop) _StopHeader(stop: day.stop),
                                                _DayRow(day: day),
                                            ]),
                                        );
                                    },
                                ),
                                SliverToBoxAdapter(
                                    child: _Constrained(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                            if (hasTypical)
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 12),
                                                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Icon(Icons.info_outline, size: 18, color: colors.onSurfaceVariant),
                                                        const SizedBox(width: 8),
                                                        Expanded(child: Text(l10n.typicalWeatherNote(ForecastRepository.forecastDays), style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant))),
                                                    ]),
                                                ),
                                            const SizedBox(height: 24),
                                            Text(l10n.packingList, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 8),
                                            Card(
                                                child: packing.isEmpty
                                                    ? ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(l10n.packingEmpty))
                                                    : Column(children: [
                                                        for (final item in packing)
                                                            CheckboxListTile(
                                                                value: trip.packed.contains(item.name),
                                                                onChanged: (_) => cubit.togglePacked(trip.id, item),
                                                                title: Text(packingItemName(l10n, item)),
                                                                controlAffinity: ListTileControlAffinity.leading,
                                                            ),
                                                    ]),
                                            ),
                                            const SizedBox(height: 32),
                                        ]),
                                    ),
                                ),
                            ],
                        ),
                    ),
                );
            },
        );
    }
}

class _Constrained extends StatelessWidget {
    final Widget child;

    const _Constrained({ required this.child });

    @override
    Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: child),
        ),
    );
}

class _StopHeader extends StatelessWidget {
    final TripStop stop;

    const _StopHeader({ required this.stop });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Semantics(
                header: true,
                child: Row(children: [
                    Icon(Icons.place_outlined, size: 20, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(child: Text(stop.city.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600))),
                    Text(formatDateRange(stop.arrive, stop.depart, context.localeName), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ]),
            ),
        );
    }
}

class _DayRow extends StatelessWidget {
    final TripDay day;

    const _DayRow({ required this.day });

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final text = theme.textTheme;

        final (Widget icon, String condition, String? range, String? rain) = switch (day.weather) {
            ForecastDay(:final daily) => (
                SvgPicture.asset(WeatherCode.decode(code: daily.weatherCode, isNight: false).image, width: 40, height: 40),
                WeatherCode.decode(code: daily.weatherCode, isNight: false).describe(l10n),
                "${roundTemp(daily.temperatureMax.value)}° / ${roundTemp(daily.temperatureMin.value)}°",
                daily.precipitationProbabilityMax == null ? null : "${daily.precipitationProbabilityMax!.value}%",
            ),
            TypicalDay(:final high, :final low) => (
                Icon(Icons.history_toggle_off, size: 28, color: colors.onSurfaceVariant),
                l10n.typicalWeather,
                "${roundTemp(high)}° / ${roundTemp(low)}°",
                null,
            ),
            UnknownDay() => (
                Icon(Icons.more_horiz, size: 28, color: colors.onSurfaceVariant),
                l10n.weatherUnknown,
                null,
                null,
            ),
        };

        return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(children: [
                        SizedBox(width: 44, child: Center(child: icon)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(formatDayDate(day.date, context.localeName), style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                                Text(condition, maxLines: 1, overflow: TextOverflow.ellipsis, style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                                if (day.leaving case final leaving?)
                                    Text(l10n.travelDay(leaving.city.name), style: text.labelSmall?.copyWith(color: colors.primary, fontWeight: FontWeight.w600)),
                            ]),
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            if (range != null) Text(range, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            if (rain != null)
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                    Icon(Icons.water_drop_outlined, size: 14, color: colors.primary),
                                    Text(rain, style: text.labelMedium?.copyWith(color: colors.primary)),
                                ]),
                        ]),
                    ]),
                ),
            ),
        );
    }
}
