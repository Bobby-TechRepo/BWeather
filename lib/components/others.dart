import 'package:bweather/components/daily.dart';
import 'package:bweather/components/hourly.dart';
import 'package:bweather/components/hourly_chart.dart';
import 'package:bweather/components/option_button.dart';
import 'package:bweather/l10n/l10n.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Horizontal strip with the 7-day forecast, the next 24 hours, or a chart of them.
class Others extends StatefulWidget {
    final Forecast forecast;

    const Others({ super.key, required this.forecast });

    @override
    State<Others> createState() => _OthersState();
}

class _OthersState extends State<Others> {
    ForecastRange _range = ForecastRange.daily;

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final breakpoints = ResponsiveBreakpoints.of(context);
        final forecast = widget.forecast;

        final List<Widget> items;
        if (_range != ForecastRange.daily) {
            final hours = forecast.upcomingHours(24);
            items = [
                for (int i = 0; i < hours.length; i++)
                    HourlyView(hourly: hours[i], isNight: forecast.isNight(hours[i]), label: i == 0 ? context.l10n.now : null),
            ];
        } else {
            final today = forecast.today();
            items = [
                for (final day in forecast.daily)
                    DailyView(daily: day, label: identical(day, today) ? context.l10n.today : null),
            ];
        }

        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: breakpoints.isMobile ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
                RangeToggle(value: _range, onChanged: (range) => setState(() => _range = range)),
                const SizedBox(height: 12),
                if (_range == ForecastRange.chart)
                    Align(alignment: Alignment.centerLeft, child: HourlyChart(hours: forecast.upcomingHours(24)))
                else
                    SizedBox(
                        height: 190,
                        child: ListView(
                            padding: breakpoints.isDesktop ? const EdgeInsets.symmetric(horizontal: 20) : null,
                            scrollDirection: Axis.horizontal,
                            children: [
                                for (final item in items)
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DecoratedBox(
                                            decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                                            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), child: item),
                                        ),
                                    ),
                            ],
                        ),
                    ),
            ],
        );
    }
}
