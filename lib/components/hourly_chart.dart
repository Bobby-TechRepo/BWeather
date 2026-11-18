import 'dart:math' as math;

import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';

/// Next-24-hours chart: temperature line on top, rain-chance bars below.
/// Drawn with a CustomPainter (no chart dependency); scrolls horizontally.
class HourlyChart extends StatelessWidget {
    final List<Hourly> hours;

    static const double slotWidth = 52;
    static const double height = 190;

    const HourlyChart({ super.key, required this.hours });

    @override
    Widget build(BuildContext context) {
        if (hours.isEmpty) return const SizedBox(height: height);

        final colors = Theme.of(context).colorScheme;
        final l10n = context.l10n;
        final locale = context.localeName;
        final textStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 12);

        final labels = [for (final hour in hours) formatHour(hour.time, locale)];
        final temperatures = [for (final hour in hours) "${roundTemp(hour.temperature.value)}°"];

        return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(spacing: 16, children: [
                    _Legend(color: colors.primary, label: l10n.chartLegendTemperature),
                    _Legend(color: colors.tertiary.withValues(alpha: 0.6), label: l10n.chartLegendRain),
                ]),
            ),
            SizedBox(
                height: height,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Semantics(
                        // The chart repeats the hourly list; screen readers get that list instead.
                        excludeSemantics: true,
                        child: CustomPaint(
                            size: Size(hours.length * slotWidth, height),
                            painter: _HourlyChartPainter(
                                temperatures: [for (final hour in hours) hour.temperature.value],
                                rainChances: [for (final hour in hours) hour.precipitationProbability.value],
                                temperatureLabels: temperatures,
                                hourLabels: labels,
                                lineColor: colors.primary,
                                barColor: colors.tertiary.withValues(alpha: 0.45),
                                textColor: colors.onSurface,
                                mutedTextColor: colors.onSurfaceVariant,
                                textStyle: textStyle,
                            ),
                        ),
                    ),
                ),
            ),
        ]);
    }
}

class _Legend extends StatelessWidget {
    final Color color;
    final String label;

    const _Legend({ required this.color, required this.label });

    @override
    Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
}

class _HourlyChartPainter extends CustomPainter {
    final List<double> temperatures;
    final List<int> rainChances;
    final List<String> temperatureLabels, hourLabels;
    final Color lineColor, barColor, textColor, mutedTextColor;
    final TextStyle textStyle;

    _HourlyChartPainter({
        required this.temperatures, required this.rainChances, required this.temperatureLabels, required this.hourLabels,
        required this.lineColor, required this.barColor, required this.textColor, required this.mutedTextColor, required this.textStyle,
    });

    static const double _top = 22, _lineArea = 70, _barArea = 50, _labelArea = 22;

    @override
    void paint(Canvas canvas, Size size) {
        final count = temperatures.length;
        final slot = size.width / count;
        final minT = temperatures.reduce(math.min), maxT = temperatures.reduce(math.max);
        final span = math.max(maxT - minT, 1.0);

        double xAt(int i) => slot * i + slot / 2;
        double yAt(double t) => _top + _lineArea - (t - minT) / span * _lineArea;

        // Rain-chance bars.
        const barBottom = _top + _lineArea + 8 + _barArea;
        final barPaint = Paint()..color = barColor;
        for (int i = 0; i < count; i++) {
            final barHeight = rainChances[i].clamp(0, 100) / 100 * _barArea;
            if (barHeight <= 0) continue;
            final rect = Rect.fromLTWH(xAt(i) - slot * 0.3, barBottom - barHeight, slot * 0.6, barHeight);
            canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(3)), barPaint);
            if (rainChances[i] >= 20) {
                _text(canvas, "${rainChances[i]}%", Offset(xAt(i), barBottom - barHeight - 2), mutedTextColor, alignBottom: true, scale: 0.85);
            }
        }

        // Temperature line.
        final path = Path()..moveTo(xAt(0), yAt(temperatures[0]));
        for (int i = 1; i < count; i++) {
            final previous = Offset(xAt(i - 1), yAt(temperatures[i - 1]));
            final current = Offset(xAt(i), yAt(temperatures[i]));
            final controlX = (previous.dx + current.dx) / 2;
            path.cubicTo(controlX, previous.dy, controlX, current.dy, current.dx, current.dy);
        }
        canvas.drawPath(path, Paint()
            ..color = lineColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..strokeCap = StrokeCap.round);

        final dotPaint = Paint()..color = lineColor;
        for (int i = 0; i < count; i++) {
            final point = Offset(xAt(i), yAt(temperatures[i]));
            canvas.drawCircle(point, 3, dotPaint);
            _text(canvas, temperatureLabels[i], point.translate(0, -6), textColor, alignBottom: true);
        }

        // Hour labels.
        for (int i = 0; i < count; i++) {
            _text(canvas, hourLabels[i], Offset(xAt(i), barBottom + _labelArea - 4), mutedTextColor, alignBottom: true);
        }
    }

    void _text(Canvas canvas, String text, Offset anchor, Color color, { bool alignBottom = false, double scale = 1 }) {
        final painter = TextPainter(
            text: TextSpan(text: text, style: textStyle.copyWith(color: color, fontSize: (textStyle.fontSize ?? 12) * scale)),
            textDirection: TextDirection.ltr,
        )..layout();
        final dy = alignBottom ? anchor.dy - painter.height : anchor.dy;
        painter.paint(canvas, Offset(anchor.dx - painter.width / 2, dy));
        painter.dispose();
    }

    @override
    bool shouldRepaint(covariant _HourlyChartPainter old) =>
        old.temperatures != temperatures || old.rainChances != rainChances || old.lineColor != lineColor || old.textColor != textColor;
}
