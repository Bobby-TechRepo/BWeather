import 'dart:math' as math;

import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/utils/astronomy.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';

/// Sunrise-to-sunset arc with the sun's current position and the day length,
/// plus tonight's moon phase.
class SunMoonCard extends StatelessWidget {
    final Forecast forecast;

    /// The moon looks mirrored south of the equator.
    final double latitude;

    const SunMoonCard({ super.key, required this.forecast, required this.latitude });

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final locale = context.localeName;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final text = theme.textTheme;

        final today = forecast.today();
        final sunrise = today?.sunrise, sunset = today?.sunset;
        final sun = (sunrise != null && sunset != null) ? SunProgress(sunrise: sunrise, sunset: sunset) : null;
        final progress = sun?.at(forecast.localNow());
        final moon = MoonInfo.at(DateTime.now());

        String daylight = "--";
        if (sun != null) {
            final minutes = sun.daylight.inMinutes;
            daylight = l10n.daylightDuration(minutes ~/ 60, minutes % 60);
        }

        return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(l10n.sunAndMoon, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                if (sun != null)
                    Semantics(
                        label: "${l10n.sunrise} ${formatClock(sun.sunrise, locale)}, ${l10n.sunset} ${formatClock(sun.sunset, locale)}, ${l10n.daylight} $daylight",
                        excludeSemantics: true,
                        child: Column(children: [
                            SizedBox(
                                height: 72,
                                child: CustomPaint(
                                    size: Size.infinite,
                                    painter: _SunArcPainter(progress: progress, track: colors.outlineVariant, fill: const Color(0xFFF4B33C), horizon: colors.outline),
                                ),
                            ),
                            const SizedBox(height: 8),
                            Row(children: [
                                Expanded(child: _Label(title: l10n.sunrise, value: formatClock(sun.sunrise, locale), align: CrossAxisAlignment.start)),
                                Expanded(child: _Label(title: l10n.daylight, value: daylight, align: CrossAxisAlignment.center)),
                                Expanded(child: _Label(title: l10n.sunset, value: formatClock(sun.sunset, locale), align: CrossAxisAlignment.end)),
                            ]),
                        ]),
                    ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Divider(color: colors.outlineVariant.withValues(alpha: 0.5))),
                Semantics(
                    label: "${moonPhaseName(l10n, moon.phase)}, ${l10n.moonIllumination((moon.illumination * 100).round())}",
                    excludeSemantics: true,
                    child: Row(children: [
                        SizedBox.square(
                            dimension: 40,
                            child: CustomPaint(painter: MoonPainter(fraction: moon.fraction, southern: latitude < 0, lit: const Color(0xFFF2EBD3), shadow: colors.onSurface.withValues(alpha: 0.18))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(moonPhaseName(l10n, moon.phase), style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                                Text(l10n.moonIllumination((moon.illumination * 100).round()), style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                            ]),
                        ),
                    ]),
                ),
            ]),
        );
    }
}

String moonPhaseName(AppLocalizations l10n, MoonPhase phase) => switch (phase) {
    MoonPhase.newMoon => l10n.moonNew,
    MoonPhase.waxingCrescent => l10n.moonWaxingCrescent,
    MoonPhase.firstQuarter => l10n.moonFirstQuarter,
    MoonPhase.waxingGibbous => l10n.moonWaxingGibbous,
    MoonPhase.fullMoon => l10n.moonFull,
    MoonPhase.waningGibbous => l10n.moonWaningGibbous,
    MoonPhase.lastQuarter => l10n.moonLastQuarter,
    MoonPhase.waningCrescent => l10n.moonWaningCrescent,
};

class _Label extends StatelessWidget {
    final String title, value;
    final CrossAxisAlignment align;

    const _Label({ required this.title, required this.value, required this.align });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final textAlign = switch (align) {
            CrossAxisAlignment.start => TextAlign.start,
            CrossAxisAlignment.end => TextAlign.end,
            _ => TextAlign.center,
        };
        return Column(crossAxisAlignment: align, children: [
            Text(title, textAlign: textAlign, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            Text(value, textAlign: textAlign, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ]);
    }
}

/// A half-ellipse from sunrise (left) to sunset (right); the travelled part is
/// filled and the sun sits at the current position. At night only the track shows.
class _SunArcPainter extends CustomPainter {
    final double? progress;
    final Color track, fill, horizon;

    _SunArcPainter({ required this.progress, required this.track, required this.fill, required this.horizon });

    @override
    void paint(Canvas canvas, Size size) {
        const inset = 10.0;
        final rect = Rect.fromLTRB(inset, inset, size.width - inset, (size.height - 4) * 2 - inset);
        final baseline = rect.center.dy;

        canvas.drawLine(Offset(0, baseline), Offset(size.width, baseline), Paint()..color = horizon.withValues(alpha: 0.5)..strokeWidth = 1);
        canvas.drawArc(rect, math.pi, math.pi, false, Paint()
            ..color = track
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);

        final p = progress;
        if (p == null) return;
        canvas.drawArc(rect, math.pi, math.pi * p, false, Paint()
            ..color = fill
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 3);

        final angle = math.pi + math.pi * p;
        final sun = Offset(rect.center.dx + rect.width / 2 * math.cos(angle), rect.center.dy + rect.height / 2 * math.sin(angle));
        canvas.drawCircle(sun, 12, Paint()..color = fill.withValues(alpha: 0.25));
        canvas.drawCircle(sun, 7, Paint()..color = fill);
    }

    @override
    bool shouldRepaint(_SunArcPainter old) => old.progress != progress || old.track != track || old.fill != fill || old.horizon != horizon;
}

/// The moon's lit shape for a point in the cycle ([fraction]: 0 new, 0.5 full).
class MoonPainter extends CustomPainter {
    final double fraction;
    final bool southern;
    final Color lit, shadow;

    MoonPainter({ required this.fraction, required this.southern, required this.lit, required this.shadow });

    @override
    void paint(Canvas canvas, Size size) {
        final r = size.shortestSide / 2;
        final c = size.center(Offset.zero);
        canvas.drawCircle(c, r, Paint()..color = shadow);

        if (southern) {
            // Seen from the southern hemisphere the lit side is mirrored.
            canvas.translate(size.width, 0);
            canvas.scale(-1, 1);
        }

        final waxing = fraction < 0.5;
        // Half-width of the terminator ellipse; its sign says which way it bulges.
        final k = r * math.cos(2 * math.pi * fraction);
        final top = Offset(c.dx, c.dy - r), bottom = Offset(c.dx, c.dy + r);

        final path = Path()
            ..moveTo(top.dx, top.dy)
            // Lit limb: the right half while waxing, the left half while waning.
            ..arcToPoint(bottom, radius: Radius.circular(r), clockwise: waxing)
            // Terminator back to the top.
            ..arcToPoint(top, radius: Radius.elliptical(k.abs().clamp(0.01, r).toDouble(), r), clockwise: waxing ? k < 0 : k > 0)
            ..close();
        canvas.drawPath(path, Paint()..color = lit);
    }

    @override
    bool shouldRepaint(MoonPainter old) => old.fraction != fraction || old.southern != southern || old.lit != lit || old.shadow != shadow;
}
