# BWeather

Forecasts for your location and the places you care about, built with Flutter
and powered by [Open-Meteo](https://open-meteo.com). Android app (desktop
builds are kept for development); free, with no ads or payments.

## Project layout

```
lib/
  app.dart                 App root: repository + cubits + routing
  main.dart                Bootstrap (persistent storage, debug bloc observer)
  services/                Platform wrappers (GPS) behind testable interfaces
  states/                  Cubits: weather (places + forecasts), cities search, settings, navigation
  screens/ pages/          Full screens and main-screen tabs
  components/              Reusable widgets
packages/
  bweather_open_meteo_api/ HTTP client: Open-Meteo (forecast, archive, air quality, geocoding), Nominatim, ipapi, RainViewer
  bweather_repository/     Maps API responses into app models (City, Forecast, ...)
plugins/
  liquid_pull_refresh/     Pull-to-refresh widget
```

Places (your location and saved cities) are identified by a stable key, never
by list position. Forecasts are cached with `hydrated_bloc`, so the app opens
instantly with the last data and refreshes anything older than 15 minutes on
launch, resume and reconnect.

## Translations

UI strings live in `lib/l10n/app_<language>.arb` (English is the template).
`flutter pub get` / `flutter run` regenerate `lib/l10n/app_localizations*.dart`;
you can also run `flutter gen-l10n`. In code, use `context.l10n.someKey`
(`import 'package:bweather/l10n/l10n.dart'`). Cubits never hold display text:
they emit enums (e.g. `LocationIssue`, `ForecastIssue`) that the UI localizes
in `lib/l10n/messages.dart`.

Languages: English, French, Spanish, Chinese (Simplified), Japanese, Hausa,
Yorùbá and Igbo. The Hausa, Yorùbá and Igbo files are drafts that need a
review by native speakers before release.

Flutter has no built-in Material/Cupertino strings for Hausa, Yorùbá or Igbo,
and intl has no date names for them. `lib/l10n/fallback_localizations.dart`
uses English for those framework strings only, and `dateLocale()` in
`lib/utils/utils.dart` formats their dates in English.

To add a language:
1. Copy `app_en.arb` to `app_<code>.arb` and translate it.
2. Add the code to `SettingsState.supportedLanguages` and to the language
   picker in `lib/pages/settings.dart`.
3. Add `android/app/src/main/res/values-<code>/widget.xml`.
4. If intl has no date symbols for it, add it to `languagesWithoutDateSymbols`.

## Units

The app always requests forecasts in metric (°C, km/h, mm). It converts them
on the device to the units chosen in Settings, using `UnitConverter` and
`convertedTo(Units)` in `packages/bweather_repository/lib/conversion.dart`.
Changing units therefore takes effect instantly, works offline and sends no
new requests. The background task is the exception: it still asks Open-Meteo
for the user's units directly.

## Notifications

Opt-in alerts (morning briefing, rain, severe weather) run in the background
about once an hour via `workmanager`. The app writes what the background task
needs to `alert_target.json` in the app-support directory (`AlertScheduler`);
the task (`lib/services/background.dart`) fetches a forecast and asks
`AlertEvaluator` (pure, unit tested) which notifications to post.

## Home-screen widget

`android/app/src/main/kotlin/com/bsoft/bweather/WeatherWidgetProvider.kt`
draws strings that the app (and the hourly background refresh) save with
`home_widget` (`lib/services/home_widget_service.dart`).

## Screen sizes

The layout follows Material window classes:

| Width | Layout |
| --- | --- |
| under 600 px (phones, narrow windows) | bottom navigation bar |
| 600 to 1023 px (tablets, half-screen windows) | navigation rail |
| 1024 px and up (large tablets in landscape, desktop) | rail plus a places panel |

Inside each forecast page, the details column moves beside the main reading
once the page itself is at least 760 px wide. On Windows the window opens at
1280 × 800 and can't be made smaller than 420 × 640
(`windows/runner/win32_window.cpp`). It can still be resized and maximised.

## Release builds

Android: put your upload keystore details in `android/key.properties`
(git-ignored); see the comment at the top of `android/app/build.gradle.kts`.

The app needs Android 8.0 (API 26) or newer (`minSdk = 26` in
`android/app/build.gradle.kts`).

### Crash reporting (optional)

Crash reports go to [Sentry](https://sentry.io), but only if the build is
given a DSN:

```bash
flutter build appbundle --dart-define=SENTRY_DSN=https://<key>@<org>.ingest.sentry.io/<project>
```

Without it, Sentry isn't started and the setting is hidden. Users can turn
reports off in Settings → Privacy. Events carry no user, IP address or
request data (`lib/services/crash_reporting.dart`). In the Sentry project, also
turn on **Prevent storing of IP addresses** (Settings → Security & Privacy).

## Flutter version

The app needs Flutter 3.47 or newer (3.50 stable recommended). Material and Cupertino widgets come from the `material_ui` and `cupertino_ui` packages, not from the SDK. Import `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`; mixing the two in one file causes ambiguous-name errors. To style text with google_fonts, use its `TextStyle` functions (`GoogleFonts.inter(...)`), not its `...TextTheme()` helpers: those still return the SDK's `TextTheme` type.

## Running

The app and its local packages (`packages/*`, `plugins/liquid_pull_refresh`) form a Dart pub workspace: run `flutter pub get` once, at the root.

```bash
flutter pub get
flutter run
```

## Checks

```bash
flutter analyze
flutter test
(cd packages/bweather_open_meteo_api && flutter test)
(cd packages/bweather_repository && flutter test)
```

CI runs the same steps on every push and pull request (`.github/workflows/ci.yml`).

## Data sources

- Weather and geocoding: Open-Meteo (CC BY 4.0). The free API is for
  non-commercial use; a commercial release needs an Open-Meteo API plan.
- Reverse geocoding (place names): OpenStreetMap Nominatim, subject to its
  usage policy (identifying User-Agent, max 1 request/second).
- Air quality, UV and pollen: Open-Meteo Air Quality API (CAMS data).
- Approximate location fallback: ipapi.co (free tier is rate limited).
- Climate averages for "warmer than usual": Open-Meteo Historical Weather API
  (ERA5). This is one request per place, and the result is cached.
- Minute-by-minute rain: Open-Meteo `minutely_15` precipitation. It's off by
  default.
- Rain radar: [RainViewer](https://www.rainviewer.com/api.html) public API.
  The free tier limits:
  - past 2 hours only;
  - zoom 7 at most;
  - 100 requests per minute per IP.

  The "Weather data by RainViewer" credit must stay visible. Before release,
  email support@rainviewer.com to confirm a free public app is fine.
- Trips: Open-Meteo daily forecast (up to 16 days ahead). Days further out use the same climate averages as "warmer than usual".
- Radar base map: OpenStreetMap tiles. Their
  [tile usage policy](https://operations.osmfoundation.org/policies/tiles/)
  requires:
  - visible attribution;
  - an identifying User-Agent;
  - no bulk or offline downloads.

  For heavy use, switch to a commercial tile provider.

See `CHANGELOG.md` for what changed in each phase, and `docs/RELEASE.md` for how to publish a release.
