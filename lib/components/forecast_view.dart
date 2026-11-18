import 'package:bweather/components/air_quality_card.dart';
import 'package:bweather/components/details_section.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/l10n/messages.dart';
import 'package:bweather/components/error.dart';
import 'package:bweather/components/minutely_rain.dart';
import 'package:bweather/components/weather_background.dart';
import 'package:bweather/components/others.dart';
import 'package:bweather/components/shimmering/forecast.dart';
import 'package:bweather/components/sun_moon_card.dart';
import 'package:bweather/components/tips_card.dart';
import 'package:bweather/screens/radar.dart';
import 'package:bweather/states/forecast/city_state.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/settings_cubit.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:bweather/utils/status.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/utils/weather_codes.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_pull_refresh/liquid_pull_refresh.dart';

/// Full forecast for one place, looked up by its stable key.
class ForecastView extends StatelessWidget {
    final String placeKey;

    const ForecastView({ super.key, required this.placeKey });

    @override
    Widget build(BuildContext context) {
        // Rebuilds only when *this* place changes.
        return BlocSelector<WeatherCubit, WeatherState, CityState?>(
            selector: (state) => state.place(placeKey),
            builder: (context, place) {
                if (place == null) {
                    return const SizedBox.shrink(); // being removed
                }

                final forecast = place.city.forecast;
                if (forecast == null) {
                    if (place.status.isFailure) {
                        return ErrorView(
                            message: context.l10n.forecastIssue(place.issue, place.city.name),
                            onRetry: () => context.read<WeatherCubit>().refreshPlace(place.key),
                        );
                    }
                    return const ForecastShimmering();
                }

                return LayoutBuilder(
                    // Layout follows the space this page actually gets (the window
                    // minus the rail and places panel), not the whole screen.
                    builder: (context, constraints) => _ForecastContent(place: place, forecast: forecast, width: constraints.maxWidth),
                );
            },
        );
    }
}

class _ForecastContent extends StatelessWidget {
    final CityState place;
    final Forecast forecast;
    final double width;

    /// Room for the details column beside the main reading.
    static const wideWidth = 760.0;

    const _ForecastContent({ required this.place, required this.forecast, required this.width });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final compact = width < 600, wide = width >= wideWidth;
        final animate = context.select<SettingsCubit, bool>((settings) => settings.state.animatedBackground);
        final cubit = context.read<WeatherCubit>();
        final l10n = context.l10n;
        final locale = context.localeName;

        final current = forecast.current;
        final airQuality = forecast.airQuality;
        final weatherCode = WeatherCode.decode(code: current.weatherCode, isNight: !current.isDay);
        // Date and time *at the place*, not on this device.
        final localNow = forecast.localNow();
        final currentHour = forecast.currentHour();
        final text = Theme.of(context).textTheme;
        final muted = text.bodyMedium!.copyWith(color: colors.onSurfaceVariant);
        final today = forecast.today();

        final content = LiquidPullRefresh(
            onRefresh: () => cubit.refreshPlace(place.key),
            showChildOpacityTransition: false,
            backgroundColor: colors.surface,
            animSpeedFactor: 2.0,
            color: colors.primary,
            heightLoader: 80,
            height: 80,
            showDroplet: true,
            springAnimationDurationInMilliseconds: 400,
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: [
                    _StatusStrip(place: place, showRefresh: !compact || _isDesktopPlatform),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                                        if (place.isCurrentLocation)
                                            Padding(padding: const EdgeInsets.only(right: 6), child: Icon(Icons.near_me, size: 20, color: colors.primary, semanticLabel: l10n.yourLocation)),
                                        Flexible(child: Semantics(header: true, child: Text(place.city.name, textAlign: TextAlign.center, maxLines: 2, style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w600)))),
                                    ]),
                                ),
                                if (place.city.subtitle.isNotEmpty)
                                    Padding(padding: const EdgeInsets.only(top: 2), child: Text(place.city.subtitle, textAlign: TextAlign.center, style: muted)),
                                const SizedBox(height: 6),
                                Text(
                                    "${formatDate(localNow, locale)} · ${formatClock(localNow, locale)} (${formatUtcOffset(forecast.utcOffset)})",
                                    textAlign: TextAlign.center,
                                    style: muted,
                                ),
                                Semantics(
                                    label: l10n.semanticsCurrent("${roundTemp(current.temperature.value)}", weatherCode.describe(l10n)),
                                    excludeSemantics: true,
                                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                                        Flexible(
                                            child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                    "${roundTemp(current.temperature.value)}°",
                                                    style: text.displayLarge?.copyWith(fontSize: compact ? 88 : 104, fontWeight: FontWeight.w200, height: 1.1, color: colors.onSurface),
                                                ),
                                            ),
                                        ),
                                        const SizedBox(width: 8),
                                        SvgPicture.asset(weatherCode.image, height: compact ? 128 : 150),
                                    ]),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(weatherCode.describe(l10n), textAlign: TextAlign.center, style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                    [
                                        l10n.feelsLike("${roundTemp(current.apparentTemperature.value)}°"),
                                        if (today != null) l10n.widgetRange("${roundTemp(today.temperatureMax.value)}°", "${roundTemp(today.temperatureMin.value)}°"),
                                    ].join("  ·  "),
                                    textAlign: TextAlign.center,
                                    style: muted.copyWith(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 14),
                                Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [
                                    if (place.comparison != null) _ComparisonChip(place: place, comparison: place.comparison!, unit: current.temperature.unit),
                                    ActionChip(
                                        avatar: Icon(Icons.radar, size: 18, color: colors.primary),
                                        label: Text(l10n.radar),
                                        onPressed: () => Navigator.of(context).pushNamed(
                                            RadarScreen.routeName,
                                            arguments: RadarTarget(latitude: place.city.latitude, longitude: place.city.longitude, name: place.city.name),
                                        ),
                                    ),
                                ]),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(compact ? 12 : 20, 20, compact ? 12 : 20, 20),
                                    child: ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 520),
                                        child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: colors.surfaceContainerLow.withValues(alpha: 0.85),
                                                borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                                child: IntrinsicHeight(
                                                    child: Row(children: [
                                                        Expanded(child: _Stat(
                                                            icon: SvgPicture.asset("files/cloud-bolt-rain.svg", width: 22, colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn)),
                                                            value: currentHour == null ? "--" : "${currentHour.precipitationProbability.value}${currentHour.precipitationProbability.unit}",
                                                            label: l10n.rainChance,
                                                        )),
                                                        const _StatDivider(),
                                                        Expanded(child: _Stat(
                                                            icon: SvgPicture.asset("files/leaf.svg", width: 22, colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn)),
                                                            value: "${current.windSpeed.value.round()} ${current.windSpeed.unit}",
                                                            label: l10n.windWithDirection(compassPoint(l10n, current.windDirection.value)),
                                                        )),
                                                        const _StatDivider(),
                                                        Expanded(child: _Stat(
                                                            icon: Icon(Icons.water_drop_outlined, color: colors.primary, size: 22),
                                                            value: "${current.relativeHumidity.value}${current.relativeHumidity.unit}",
                                                            label: l10n.humidity,
                                                        )),
                                                    ]),
                                                ),
                                            ),
                                        ),
                                    ),
                                ),
                            ])),
                            if (wide)
                                SizedBox(width: width >= 1100 ? 400 : 340, child: Column(children: [
                                    if (forecast.minutely.isNotEmpty) ...[MinutelyRainCard(forecast: forecast), const SizedBox(height: 10)],
                                    DetailsSection(forecast: forecast),
                                    const SizedBox(height: 10),
                                    SunMoonCard(forecast: forecast, latitude: place.city.latitude),
                                    if (airQuality != null) ...[const SizedBox(height: 10), AirQualityCard(airQuality: airQuality)],
                                    const SizedBox(height: 10),
                                    TipsCard(forecast: forecast),
                                ])),
                        ]),
                    ),
                    if (!wide && forecast.minutely.isNotEmpty)
                        Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10, 10), child: MinutelyRainCard(forecast: forecast)),
                    SizedBox(height: compact ? 10 : 30),
                    Others(forecast: forecast),
                    if (!wide)
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: DetailsSection(forecast: forecast)),
                    if (!wide)
                        Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 0), child: SunMoonCard(forecast: forecast, latitude: place.city.latitude)),
                    if (!wide)
                        Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 0), child: TipsCard(forecast: forecast)),
                    if (!wide && airQuality != null)
                        Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 0), child: AirQualityCard(airQuality: airQuality)),
                    const SizedBox(height: 12),
                ]),
            ),
        );

        return Stack(children: [
            Positioned.fill(
                child: WeatherBackground(
                    scene: SkyScene.from(weatherCode: current.weatherCode, isDay: current.isDay),
                    animate: animate,
                ),
            ),
            content,
        ]);
    }
}

/// Pull-to-refresh is awkward with a mouse, so desktop builds also get a button.
bool get _isDesktopPlatform => !kIsWeb && switch (defaultTargetPlatform) {
    TargetPlatform.windows || TargetPlatform.linux || TargetPlatform.macOS => true,
    _ => false,
};

/// "3° warmer than usual" compared with the 20-year average high for today.
class _ComparisonChip extends StatelessWidget {
    final CityState place;
    final TemperatureComparison comparison;
    final String unit;

    const _ComparisonChip({ required this.place, required this.comparison, required this.unit });

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final colors = Theme.of(context).colorScheme;
        final degrees = comparison.degreesIn(unit);
        final (label, icon, color) = switch (comparison.anomaly) {
            Anomaly.normal => (l10n.tempAboutNormal, Icons.thermostat, colors.onSurfaceVariant),
            Anomaly.warmer || Anomaly.muchWarmer => (l10n.tempWarmerThanUsual(degrees), Icons.trending_up, comparison.anomaly == Anomaly.muchWarmer ? colors.error : colors.tertiary),
            Anomaly.cooler || Anomaly.muchCooler => (l10n.tempCoolerThanUsual(degrees), Icons.trending_down, colors.primary),
        };
        final normals = place.normals;

        return Tooltip(
            message: normals == null ? "" : l10n.tempNormalsSource("${normals.fromYear}", "${normals.toYear}"),
            triggerMode: TooltipTriggerMode.tap,
            child: Chip(
                avatar: Icon(icon, size: 18, color: color),
                label: Text(label),
                side: BorderSide(color: color.withValues(alpha: 0.4)),
                backgroundColor: Colors.transparent,
            ),
        );
    }
}

/// "Updated 5 min ago", a progress bar while refreshing, or a retry link when the
/// last refresh failed but older data is still shown.
class _StatusStrip extends StatelessWidget {
    final CityState place;
    final bool showRefresh;

    const _StatusStrip({ required this.place, this.showRefresh = false });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final style = TextStyle(fontSize: 12, color: colors.onSurfaceVariant);

        if (place.status.isLoading) {
            return const LinearProgressIndicator(minHeight: 2);
        }

        final l10n = context.l10n;
        final updated = place.updatedAt == null ? "" : l10n.updatedAgo(formatAge(l10n, place.updatedAt!));
        if (place.status.isFailure) {
            return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.cloud_off, size: 14, color: colors.error),
                    const SizedBox(width: 4),
                    Flexible(child: Text("${l10n.couldNotRefresh}${updated.isEmpty ? "" : " · $updated"}", style: style.copyWith(color: colors.error))),
                    TextButton(onPressed: () => context.read<WeatherCubit>().refreshPlace(place.key), child: Text(l10n.retry)),
                ]),
            );
        }

        if (!showRefresh) {
            return Padding(padding: const EdgeInsets.only(top: 6), child: Text(updated, style: style));
        }
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(updated, style: style),
            IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                tooltip: l10n.refresh,
                visualDensity: VisualDensity.compact,
                onPressed: () => context.read<WeatherCubit>().refreshPlace(place.key),
            ),
        ]);
    }
}

class _Stat extends StatelessWidget {
    final Widget icon;
    final String value, label;

    const _Stat({ required this.icon, required this.value, required this.label });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final text = Theme.of(context).textTheme;
        // Read as one item: "Humidity: 72%".
        return Semantics(
            label: "$label: $value",
            excludeSemantics: true,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
                icon,
                const SizedBox(height: 6),
                FittedBox(fit: BoxFit.scaleDown, child: Text(value, maxLines: 1, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colors.onSurface))),
                const SizedBox(height: 2),
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
            ]),
        );
    }
}

class _StatDivider extends StatelessWidget {
    const _StatDivider();

    @override
    Widget build(BuildContext context) =>
        VerticalDivider(width: 1, indent: 4, endIndent: 4, color: Theme.of(context).colorScheme.outlineVariant);
}
