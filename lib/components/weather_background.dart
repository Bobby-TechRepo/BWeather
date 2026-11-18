import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/scheduler.dart';

/// What the animated sky shows, derived from a WMO weather code.
enum SkyKind { clear, partlyCloudy, overcast, fog, drizzle, rain, heavyRain, snow, thunder }

class SkyScene {
    final SkyKind kind;
    final bool night;

    const SkyScene(this.kind, { required this.night });

    factory SkyScene.from({ required int weatherCode, required bool isDay }) {
        final kind = switch (weatherCode) {
            0 || 1 => SkyKind.clear,
            2 => SkyKind.partlyCloudy,
            3 => SkyKind.overcast,
            45 || 48 => SkyKind.fog,
            51 || 53 || 55 || 56 || 57 => SkyKind.drizzle,
            61 || 63 || 66 || 80 || 81 => SkyKind.rain,
            65 || 67 || 82 => SkyKind.heavyRain,
            71 || 73 || 75 || 77 || 85 || 86 => SkyKind.snow,
            95 || 96 || 99 => SkyKind.thunder,
            _ => SkyKind.overcast,
        };
        return SkyScene(kind, night: !isDay);
    }

    bool get hasSun => !night && (kind == SkyKind.clear || kind == SkyKind.partlyCloudy);
    bool get hasStars => night && (kind == SkyKind.clear || kind == SkyKind.partlyCloudy);
    bool get hasLightning => kind == SkyKind.thunder;

    int get cloudCount => switch (kind) {
        SkyKind.clear => 0,
        SkyKind.partlyCloudy => 3,
        SkyKind.fog => 0,
        SkyKind.drizzle || SkyKind.snow => 4,
        _ => 6,
    };

    int get rainDrops => switch (kind) {
        SkyKind.drizzle => 40,
        SkyKind.rain => 80,
        SkyKind.heavyRain || SkyKind.thunder => 140,
        _ => 0,
    };

    int get snowFlakes => kind == SkyKind.snow ? 70 : 0;

    @override
    bool operator ==(Object other) => other is SkyScene && other.kind == kind && other.night == night;

    @override
    int get hashCode => Object.hash(kind, night);
}

/// A subtle animated sky drawn behind the forecast. It only tints the theme's
/// surface, so text stays readable in light and dark mode.
///
/// Static (a single frame) when [animate] is false or the system asks for
/// reduced motion; paused automatically when the page is off screen.
class WeatherBackground extends StatefulWidget {
    final SkyScene scene;
    final bool animate;

    const WeatherBackground({ super.key, required this.scene, this.animate = true });

    @override
    State<WeatherBackground> createState() => _WeatherBackgroundState();
}

class _WeatherBackgroundState extends State<WeatherBackground> with SingleTickerProviderStateMixin {
    late final Ticker _ticker;
    final ValueNotifier<double> _seconds = ValueNotifier(0);

    @override
    void initState() {
        super.initState();
        _ticker = createTicker((elapsed) => _seconds.value = elapsed.inMicroseconds / 1e6);
    }

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        _syncTicker();
    }

    @override
    void didUpdateWidget(WeatherBackground oldWidget) {
        super.didUpdateWidget(oldWidget);
        _syncTicker();
    }

    void _syncTicker() {
        final run = widget.animate && !MediaQuery.disableAnimationsOf(context);
        if (run && !_ticker.isActive) {
            _ticker.start();
        } else if (!run && _ticker.isActive) {
            _ticker.stop();
        }
    }

    @override
    void dispose() {
        _ticker.dispose();
        _seconds.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        return RepaintBoundary(
            child: CustomPaint(
                painter: SkyPainter(
                    scene: widget.scene, seconds: _seconds,
                    dark: theme.brightness == Brightness.dark, ink: theme.colorScheme.onSurface,
                ),
                child: const SizedBox.expand(),
            ),
        );
    }
}

class _Particle {
    final double x, y, size, speed, phase;

    const _Particle(this.x, this.y, this.size, this.speed, this.phase);
}

class SkyPainter extends CustomPainter {
    final SkyScene scene;
    final ValueNotifier<double> seconds;
    final bool dark;
    final Color ink;

    // Same particles every time, so the sky doesn't "jump" on rebuilds.
    static final List<_Particle> _particles = () {
        final random = math.Random(7);
        return List.generate(160, (_) => _Particle(random.nextDouble(), random.nextDouble(), random.nextDouble(), 0.6 + random.nextDouble() * 0.8, random.nextDouble() * math.pi * 2));
    }();

    SkyPainter({ required this.scene, required this.seconds, required this.dark, required this.ink }) : super(repaint: seconds);

    @override
    void paint(Canvas canvas, Size size) {
        if (size.isEmpty) return;
        final t = seconds.value;
        _paintTint(canvas, size);
        if (scene.hasSun) _paintSun(canvas, size, t);
        if (scene.hasStars) _paintStars(canvas, size, t);
        if (scene.kind == SkyKind.fog) _paintFog(canvas, size, t);
        if (scene.cloudCount > 0) _paintClouds(canvas, size, t);
        if (scene.rainDrops > 0) _paintRain(canvas, size, t);
        if (scene.snowFlakes > 0) _paintSnow(canvas, size, t);
        if (scene.hasLightning) _paintLightning(canvas, size, t);
    }

    Color get _tint => switch (scene.kind) {
        SkyKind.clear || SkyKind.partlyCloudy => scene.night ? const Color(0xFF1B2A6B) : const Color(0xFF3D8BFD),
        SkyKind.fog => const Color(0xFF9AA5B1),
        SkyKind.snow => const Color(0xFFB8D4F0),
        SkyKind.thunder => const Color(0xFF4B3F72),
        SkyKind.drizzle || SkyKind.rain || SkyKind.heavyRain => const Color(0xFF4F6D8A),
        SkyKind.overcast => const Color(0xFF7D8B99),
    };

    void _paintTint(Canvas canvas, Size size) {
        final strength = dark ? 0.35 : 0.18;
        final rect = Offset.zero & size;
        canvas.drawRect(rect, Paint()..shader = LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [_tint.withValues(alpha: strength), _tint.withValues(alpha: 0)],
            stops: const [0, 0.7],
        ).createShader(rect));
    }

    void _paintSun(Canvas canvas, Size size, double t) {
        final center = Offset(size.width * 0.85, size.height * 0.08);
        final radius = math.min(size.width, 600.0) * (0.45 + 0.03 * math.sin(t * 0.6));
        canvas.drawCircle(center, radius, Paint()..shader = RadialGradient(colors: [
            const Color(0xFFFFC94D).withValues(alpha: dark ? 0.22 : 0.35),
            const Color(0xFFFFC94D).withValues(alpha: 0),
        ]).createShader(Rect.fromCircle(center: center, radius: radius)));
    }

    void _paintStars(Canvas canvas, Size size, double t) {
        final paint = Paint();
        final color = dark ? Colors.white : ink;
        for (final p in _particles.take(60)) {
            final twinkle = 0.5 + 0.5 * math.sin(t * p.speed * 1.5 + p.phase);
            paint.color = color.withValues(alpha: (dark ? 0.55 : 0.25) * twinkle);
            canvas.drawCircle(Offset(p.x * size.width, p.y * size.height * 0.6), 0.6 + p.size * 1.2, paint);
        }
        // Moon glow, top right.
        final moon = Offset(size.width * 0.84, size.height * 0.09);
        canvas.drawCircle(moon, 60, Paint()..shader = RadialGradient(colors: [
            color.withValues(alpha: dark ? 0.18 : 0.10), color.withValues(alpha: 0),
        ]).createShader(Rect.fromCircle(center: moon, radius: 60)));
        canvas.drawCircle(moon, 16, Paint()..color = color.withValues(alpha: dark ? 0.5 : 0.2));
    }

    void _paintClouds(Canvas canvas, Size size, double t) {
        final base = dark ? Colors.white : ink;
        final alpha = switch (scene.kind) {
            SkyKind.partlyCloudy => dark ? 0.05 : 0.04,
            _ => dark ? 0.07 : 0.06,
        };
        final paint = Paint()
            ..color = base.withValues(alpha: alpha)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
        final span = size.width + 400;
        for (int i = 0; i < scene.cloudCount; i++) {
            final p = _particles[100 + i];
            final x = (p.x * span + t * 6 * p.speed) % span - 200;
            final y = size.height * (0.04 + p.y * 0.35);
            final w = 140 + p.size * 160;
            // A cloud is three overlapping blurred ovals.
            canvas.drawOval(Rect.fromCenter(center: Offset(x, y), width: w, height: w * 0.42), paint);
            canvas.drawOval(Rect.fromCenter(center: Offset(x - w * 0.25, y + w * 0.08), width: w * 0.6, height: w * 0.3), paint);
            canvas.drawOval(Rect.fromCenter(center: Offset(x + w * 0.22, y - w * 0.06), width: w * 0.55, height: w * 0.32), paint);
        }
    }

    void _paintRain(Canvas canvas, Size size, double t) {
        final heavy = scene.rainDrops > 100;
        final paint = Paint()
            ..color = (dark ? const Color(0xFFB3D4FF) : const Color(0xFF2F5D8A)).withValues(alpha: heavy ? 0.28 : 0.2)
            ..strokeWidth = heavy ? 1.6 : 1.2
            ..strokeCap = StrokeCap.round;
        final length = scene.kind == SkyKind.drizzle ? 8.0 : 16.0 + (heavy ? 8 : 0);
        final fall = scene.kind == SkyKind.drizzle ? 260.0 : 620.0;
        const slant = 0.18;
        final height = size.height + length;
        for (final p in _particles.take(scene.rainDrops)) {
            final y = (p.y * height + t * fall * p.speed) % height - length;
            final x = (p.x * (size.width + 40) + y * slant) % (size.width + 40) - 20;
            canvas.drawLine(Offset(x, y), Offset(x - length * slant, y - length), paint);
        }
    }

    void _paintSnow(Canvas canvas, Size size, double t) {
        final paint = Paint()..color = (dark ? Colors.white : const Color(0xFF6B8BB0)).withValues(alpha: dark ? 0.6 : 0.45);
        final height = size.height + 10;
        for (final p in _particles.take(scene.snowFlakes)) {
            final y = (p.y * height + t * 40 * p.speed) % height - 5;
            final x = p.x * size.width + math.sin(t * 0.8 * p.speed + p.phase) * 18;
            canvas.drawCircle(Offset(x, y), 1.2 + p.size * 2.2, paint);
        }
    }

    void _paintFog(Canvas canvas, Size size, double t) {
        final paint = Paint()
            ..color = (dark ? Colors.white : ink).withValues(alpha: dark ? 0.06 : 0.05)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
        for (int i = 0; i < 5; i++) {
            final p = _particles[120 + i];
            final y = size.height * (0.1 + i * 0.18);
            final dx = math.sin(t * 0.15 * p.speed + p.phase) * size.width * 0.15;
            canvas.drawRRect(
                RRect.fromRectAndRadius(Rect.fromLTWH(-size.width * 0.2 + dx, y, size.width * 1.4, 50 + p.size * 40), const Radius.circular(40)),
                paint,
            );
        }
    }

    void _paintLightning(Canvas canvas, Size size, double t) {
        // A double flash roughly every 7 seconds.
        final phase = t % 7.0;
        final flash = phase < 0.08 ? 1.0 : (phase > 0.18 && phase < 0.26 ? 0.6 : 0.0);
        if (flash == 0) return;
        canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white.withValues(alpha: (dark ? 0.14 : 0.22) * flash));
    }

    @override
    bool shouldRepaint(SkyPainter oldDelegate) =>
        oldDelegate.scene != scene || oldDelegate.dark != dark || oldDelegate.ink != ink || oldDelegate.seconds != seconds;
}
