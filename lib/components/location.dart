import 'package:bweather/components/shimmering/location.dart';
import 'package:bweather/components/weather_background.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/states/forecast/city_state.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/main_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:bweather/utils/sky_palette.dart';
import 'package:bweather/utils/status.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/utils/weather_codes.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Card for one place in the Locations list, tinted by the sky there:
/// name, local time, conditions, temperature, today's high/low and the next hours.
class LocationItem extends StatelessWidget {
    final String placeKey;

    /// Narrow layout for the desktop side panel (fewer hours, smaller type).
    final bool compact;

    /// Shown for saved cities: opens a menu with "Remove".
    final VoidCallback? onRemove;

    const LocationItem({ super.key, required this.placeKey, this.compact = false, this.onRemove });

    @override
    Widget build(BuildContext context) {
        return BlocSelector<WeatherCubit, WeatherState, CityState?>(
            selector: (state) => state.place(placeKey),
            builder: (context, place) {
                if (place == null) return const SizedBox.shrink();
                if (place.city.forecast == null && !place.status.isFailure) {
                    return const LocationItemShimmering();
                }
                return _SkyCard(place: place, compact: compact, onRemove: onRemove);
            },
        );
    }
}

class _SkyCard extends StatelessWidget {
    final CityState place;
    final bool compact;
    final VoidCallback? onRemove;

    const _SkyCard({ required this.place, required this.compact, this.onRemove });

    static const _shadow = [Shadow(color: Color(0x40000000), blurRadius: 6)];

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final locale = context.localeName;
        final text = Theme.of(context).textTheme;
        final forecast = place.city.forecast;
        final current = forecast?.current;

        final scene = current == null
            ? const SkyScene(SkyKind.overcast, night: false)
            : SkyScene.from(weatherCode: current.weatherCode, isDay: current.isDay);
        final code = current == null ? null : WeatherCode.decode(code: current.weatherCode, isNight: !current.isDay);
        final today = forecast?.today();
        final hours = forecast?.upcomingHours(compact ? 4 : 6) ?? const [];

        const white = Colors.white;
        final soft = Colors.white.withValues(alpha: 0.82);

        final subtitle = [
            if (place.isCurrentLocation) place.approximate ? l10n.approximateLocation : l10n.yourLocation,
            if (forecast != null) formatClock(forecast.localNow(), locale),
        ].join(" · ");

        return Semantics(
            button: true,
            label: [
                place.city.name,
                if (current != null) l10n.semanticsCurrent("${roundTemp(current.temperature.value)}", code!.describe(l10n)),
            ].join(", "),
            child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: SkyPalette.of(scene),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: SkyPalette.of(scene).colors.first.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Material(
                    type: MaterialType.transparency,
                    borderRadius: BorderRadius.circular(24),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                        onTap: () => context.read<MainCubit>().showPlace(place.key),
                        child: DefaultTextStyle.merge(
                            style: const TextStyle(color: white, shadows: _shadow),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(compact ? 14 : 18, compact ? 12 : 16, compact ? 6 : 8, compact ? 12 : 16),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Row(children: [
                                                    if (place.isCurrentLocation)
                                                        const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.near_me, size: 16, color: white, shadows: _shadow)),
                                                    Flexible(
                                                        child: Text(
                                                            place.city.name,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: (compact ? text.titleMedium : text.titleLarge)?.copyWith(color: white, fontWeight: FontWeight.w600, shadows: _shadow),
                                                        ),
                                                    ),
                                                ]),
                                                if (subtitle.isNotEmpty)
                                                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: text.bodySmall?.copyWith(color: soft, fontWeight: FontWeight.w500)),
                                                SizedBox(height: compact ? 10 : 18),
                                                Text(
                                                    code?.describe(l10n) ?? l10n.forecastUnavailable,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: text.bodyMedium?.copyWith(color: white, fontWeight: FontWeight.w600),
                                                ),
                                            ]),
                                        ),
                                        if (code != null)
                                            Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: SvgPicture.asset(code.image, width: compact ? 40 : 52, height: compact ? 40 : 52),
                                            ),
                                        const SizedBox(width: 4),
                                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                            Text(
                                                current == null ? "--" : "${roundTemp(current.temperature.value)}°",
                                                style: (compact ? text.headlineLarge : text.displaySmall)?.copyWith(color: white, fontWeight: FontWeight.w300, height: 1.0, shadows: _shadow),
                                            ),
                                            if (today != null)
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 6),
                                                    child: Text(
                                                        l10n.widgetRange("${roundTemp(today.temperatureMax.value)}°", "${roundTemp(today.temperatureMin.value)}°"),
                                                        style: text.labelMedium?.copyWith(color: soft, fontWeight: FontWeight.w600),
                                                    ),
                                                ),
                                        ]),
                                        _Menu(place: place, onRemove: onRemove),
                                    ]),
                                    if (place.status.isLoading)
                                        Padding(
                                            padding: const EdgeInsets.only(top: 10, right: 10),
                                            child: LinearProgressIndicator(minHeight: 2, color: white, backgroundColor: white.withValues(alpha: 0.2)),
                                        ),
                                    if (forecast != null && hours.isNotEmpty) ...[
                                        Padding(
                                            padding: EdgeInsets.only(top: compact ? 10 : 14, bottom: compact ? 8 : 10, right: 10),
                                            child: Divider(height: 1, color: white.withValues(alpha: 0.25)),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            // Hours are visual detail; the forecast page reads them out properly.
                                            child: ExcludeSemantics(child: Row(children: [
                                                for (final hour in hours)
                                                    Expanded(
                                                        child: Column(children: [
                                                            Text(formatHour(hour.time, locale), maxLines: 1, style: text.labelSmall?.copyWith(color: soft)),
                                                            const SizedBox(height: 4),
                                                            SvgPicture.asset(WeatherCode.decode(code: hour.weatherCode, isNight: forecast.isNight(hour)).image, height: compact ? 24 : 28),
                                                            const SizedBox(height: 2),
                                                            Text("${roundTemp(hour.temperature.value)}°", style: text.labelLarge?.copyWith(color: white, fontWeight: FontWeight.w600)),
                                                        ]),
                                                    ),
                                            ])),
                                        ),
                                    ],
                                    if (forecast == null && place.status.isFailure)
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton.icon(
                                                style: TextButton.styleFrom(foregroundColor: white),
                                                onPressed: () => context.read<WeatherCubit>().refreshPlace(place.key),
                                                icon: const Icon(Icons.refresh, size: 18),
                                                label: Text(l10n.retry),
                                            ),
                                        ),
                                ]),
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}

/// "⋮" menu on saved cities (the user's own location can't be removed).
class _Menu extends StatelessWidget {
    final CityState place;
    final VoidCallback? onRemove;

    const _Menu({ required this.place, this.onRemove });

    @override
    Widget build(BuildContext context) {
        final remove = onRemove;
        if (remove == null) return const SizedBox(width: 10);

        return PopupMenuButton<String>(
            tooltip: MaterialLocalizations.of(context).showMenuTooltip,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            padding: EdgeInsets.zero,
            iconSize: 20,
            onSelected: (_) => remove(),
            itemBuilder: (context) => [
                PopupMenuItem(
                    value: "remove",
                    child: Row(children: [
                        Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                        const SizedBox(width: 12),
                        Text(context.l10n.removeCity(place.city.name)),
                    ]),
                ),
            ],
        );
    }
}
