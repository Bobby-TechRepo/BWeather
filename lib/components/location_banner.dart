import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/l10n/messages.dart';
import 'package:bweather/states/forecast/weather_state.dart';
import 'package:bweather/states/weather_cubit.dart';
import 'package:bweather/utils/status.dart';
import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _BannerData extends Equatable {
    final bool show, approximate, busy;
    final LocationIssue issue;

    const _BannerData({ required this.show, required this.approximate, required this.busy, required this.issue });

    factory _BannerData.from(WeatherState state) {
        final location = state.location;
        final approximate = location?.approximate ?? false;
        final missing = location == null && state.locationIssue != LocationIssue.none;
        return _BannerData(
            show: approximate || missing,
            approximate: approximate,
            busy: state.status.isLoading,
            issue: state.locationIssue,
        );
    }

    @override
    List<Object?> get props => [show, approximate, busy, issue];
}

/// Slim banner above the forecast when we only have an approximate location
/// (or none), offering to use the precise one.
class LocationBanner extends StatelessWidget {
    const LocationBanner({ super.key });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final cubit = context.read<WeatherCubit>();
        final l10n = context.l10n;

        return BlocSelector<WeatherCubit, WeatherState, _BannerData>(
            selector: _BannerData.from,
            builder: (context, data) {
                if (!data.show) return const SizedBox.shrink();

                final blocked = data.issue == LocationIssue.permissionDeniedForever || data.issue == LocationIssue.serviceDisabled;
                final text = data.approximate ? l10n.approximateBanner : l10n.locationIssue(data.issue);

                return Material(
                    color: colors.secondaryContainer,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(children: [
                            Icon(Icons.location_searching, size: 18, color: colors.onSecondaryContainer),
                            const SizedBox(width: 8),
                            Expanded(child: Text(text, style: TextStyle(color: colors.onSecondaryContainer, fontSize: 13))),
                            if (data.busy)
                                const Padding(padding: EdgeInsets.all(12), child: SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)))
                            else if (blocked)
                                TextButton(onPressed: cubit.openLocationSettings, child: Text(l10n.navSettings))
                            else
                                TextButton(onPressed: cubit.useMyLocation, child: Text(l10n.usePrecise)),
                        ]),
                    ),
                );
            },
        );
    }
}
