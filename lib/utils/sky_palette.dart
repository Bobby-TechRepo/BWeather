import 'package:bweather/components/weather_background.dart';
import 'package:material_ui/material_ui.dart';

/// Gradients for cards that show a place's current sky. All are dark enough
/// for white text (contrast is checked against the lighter end).
class SkyPalette {
    const SkyPalette._();

    static LinearGradient of(SkyScene scene) {
        final (start, end) = _colors(scene);
        return LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [start, end]);
    }

    static (Color, Color) _colors(SkyScene scene) {
        if (scene.night) {
            return switch (scene.kind) {
                SkyKind.clear || SkyKind.partlyCloudy => (const Color(0xFF0E1A3C), const Color(0xFF2A3D70)),
                SkyKind.thunder => (const Color(0xFF1C1733), const Color(0xFF3B3463)),
                SkyKind.snow => (const Color(0xFF23324A), const Color(0xFF475C7A)),
                _ => (const Color(0xFF1A222E), const Color(0xFF384456)),
            };
        }
        return switch (scene.kind) {
            SkyKind.clear => (const Color(0xFF1F6FBF), const Color(0xFF3482C8)),
            SkyKind.partlyCloudy => (const Color(0xFF2E6BA6), const Color(0xFF4E80B2)),
            SkyKind.overcast => (const Color(0xFF4F6275), const Color(0xFF64788B)),
            SkyKind.fog => (const Color(0xFF5B6773), const Color(0xFF6E7B88)),
            SkyKind.drizzle || SkyKind.rain => (const Color(0xFF34506D), const Color(0xFF587592)),
            SkyKind.heavyRain => (const Color(0xFF253A52), const Color(0xFF44607E)),
            SkyKind.snow => (const Color(0xFF4A6C93), const Color(0xFF5F80A6)),
            SkyKind.thunder => (const Color(0xFF2B2648), const Color(0xFF4F4878)),
        };
    }
}
