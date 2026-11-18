import 'package:bweather/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

/// A Google Fonts style function, e.g. the tear-off `GoogleFonts.inter`.
typedef FontStyler = TextStyle Function({ TextStyle? textStyle });

/// The app's text theme: [display] for headings and big numbers, [body] for
/// body text and labels.
///
/// Fonts are applied style by style rather than with `GoogleFonts.xxxTextTheme()`:
/// google_fonts still returns the Flutter SDK's `TextTheme`, which is a different
/// type from material_ui's. `TextStyle` is shared by both, so this works either way.
TextTheme createTextTheme(BuildContext context, { required FontStyler body, required FontStyler display }) {
    final base = Theme.of(context).textTheme;
    TextStyle? apply(FontStyler font, TextStyle? style) => style == null ? null : font(textStyle: style);

    return base.copyWith(
        displayLarge: apply(display, base.displayLarge),
        displayMedium: apply(display, base.displayMedium),
        displaySmall: apply(display, base.displaySmall),
        headlineLarge: apply(display, base.headlineLarge),
        headlineMedium: apply(display, base.headlineMedium),
        headlineSmall: apply(display, base.headlineSmall),
        titleLarge: apply(display, base.titleLarge),
        titleMedium: apply(display, base.titleMedium),
        titleSmall: apply(display, base.titleSmall),
        bodyLarge: apply(body, base.bodyLarge),
        bodyMedium: apply(body, base.bodyMedium),
        bodySmall: apply(body, base.bodySmall),
        labelLarge: apply(body, base.labelLarge),
        labelMedium: apply(body, base.labelMedium),
        labelSmall: apply(body, base.labelSmall),
    );
}

// Date/time formatting uses intl with the app's locale. The date symbols for
// supported locales are loaded by GlobalMaterialLocalizations.

/// Languages the app is translated into but intl has no date names for.
/// Their dates use English names (common in Nigeria) until symbols exist.
const languagesWithoutDateSymbols = {"ha", "yo", "ig"};

/// The locale to pass to intl's DateFormat for an app [locale].
String dateLocale(String locale) =>
    languagesWithoutDateSymbols.contains(locale.split(RegExp("[_-]")).first) ? "en" : locale;

/// "Thursday, November 12" / "jeudi 12 novembre"
String formatDate(DateTime time, String locale) => DateFormat.MMMMEEEEd(dateLocale(locale)).format(time);

/// "Thu" / "jeu."
String shortDay(DateTime time, String locale) => DateFormat.E(dateLocale(locale)).format(time);

/// "3:05 PM" / "15:05"
String formatClock(DateTime time, String locale) => DateFormat.jm(dateLocale(locale)).format(time);

/// "Dec 3" / "3 déc."
String formatShortDate(DateTime time, String locale) => DateFormat.MMMd(dateLocale(locale)).format(time);

/// "Thu, Dec 3" / "jeu. 3 déc."
String formatDayDate(DateTime time, String locale) => DateFormat.MMMEd(dateLocale(locale)).format(time);

/// "Dec 3 – 8" style range; repeats the month only when it changes.
String formatDateRange(DateTime start, DateTime end, String locale) {
    if (start.year == end.year && start.month == end.month && start.day == end.day) return formatShortDate(start, locale);
    return "${formatShortDate(start, locale)} – ${formatShortDate(end, locale)}";
}

/// "3 PM" / "15 h"
String formatHour(DateTime time, String locale) => DateFormat.j(dateLocale(locale)).format(time);

/// "UTC+1", "UTC+5:30", "UTC−3:30"
String formatUtcOffset(Duration offset) {
    final sign = offset.isNegative ? "−" : "+";
    final minutes = offset.inMinutes.abs();
    final hours = minutes ~/ 60, rest = minutes % 60;
    return "UTC$sign$hours${rest == 0 ? "" : ":${rest.toString().padLeft(2, "0")}"}";
}

/// "just now", "5 min ago", "2 h ago", "3 days ago" (localized)
String formatAge(AppLocalizations l10n, DateTime time, [DateTime? now]) {
    final age = (now ?? DateTime.now()).difference(time);
    if (age.inMinutes < 1) return l10n.ageJustNow;
    if (age.inHours < 1) return l10n.ageMinutes(age.inMinutes);
    if (age.inDays < 1) return l10n.ageHours(age.inHours);
    return l10n.ageDays(age.inDays);
}

/// Temperatures are shown as whole degrees, rounded (not ceiled: 20.1° is 20°).
int roundTemp(num value) => value.round();

/// Index 0..15 of the 16-point compass for a wind direction in degrees.
int compassIndex(num degrees) => ((degrees % 360) / 22.5).round() % 16;

/// Localized 16-point compass name ("SW", "SO", ...).
String compassPoint(AppLocalizations l10n, num degrees) => l10n.compassPoints.split(",")[compassIndex(degrees)];
