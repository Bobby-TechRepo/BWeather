import 'package:bweather/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum ForecastRange { daily, hourly, chart }

/// Daily / Hourly / Chart switch.
class RangeToggle extends StatelessWidget {
    final ForecastRange value;
    final ValueChanged<ForecastRange> onChanged;

    const RangeToggle({ super.key, required this.value, required this.onChanged });

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveBreakpoints.of(context).isDesktop ? 20 : 10),
            child: SegmentedButton<ForecastRange>(
                showSelectedIcon: false,
                segments: [
                    ButtonSegment(value: ForecastRange.daily, label: Text(context.l10n.daily)),
                    ButtonSegment(value: ForecastRange.hourly, label: Text(context.l10n.hourly)),
                    ButtonSegment(value: ForecastRange.chart, label: Text(context.l10n.chart)),
                ],
                selected: {value},
                onSelectionChanged: (selection) => onChanged(selection.first),
            ),
        );
    }
}
