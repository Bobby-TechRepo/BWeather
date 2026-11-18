# Changelog

> **Scope decision (Nov 2026):** BWeather is Android-only (desktop builds
> remain for development) and free, with no paywall or payments. iOS-specific
> code and setup steps have been removed from the code and this changelog.

## Instant unit switching (November 2026)

### Changed
- **Units now switch instantly, even offline.**
  - Forecasts are fetched once in metric (°C, km/h, mm) and converted on the phone to the units chosen in Settings.
  - Changing °C/°F, wind speed or precipitation units now converts the forecasts already on screen, for every place and every trip. Before, it re-downloaded all of them.
  - This also means fewer requests to Open-Meteo.
- New `UnitConverter`, with `convertedTo(Units)` on `Forecast`, `Current`, `Hourly`, `Daily`, `MinutelyPrecipitation` and `City` (`packages/bweather_repository/lib/conversion.dart`).
  - Values are recognised by Open-Meteo's own unit labels.
  - Anything that isn't a temperature, speed or amount (%, °, hPa, AQI) is left untouched.
  - Results are rounded to 4 decimals, so switching back and forth doesn't drift.
- A unit change while a request is running is handled: the result is converted when it arrives, instead of being fetched again.
- Toggling minute-by-minute rain still refreshes, because it changes what is downloaded.
- The background job (alerts and widget) still asks for the user's units directly.

### Build
- Android Gradle Plugin bumped from 9.1.0 to 9.1.1, the minimum the current Flutter accepts.

### Tests
- `packages/bweather_repository/test/conversion_test.dart`: every unit pair, untouched units, round trips.
- `test/weather_test.dart`:
  - forecasts are requested in metric and shown in the user's units;
  - changing units converts without any new request.

## Trip planner (November 2026)

### Added
- **Trips tab**, with a luggage icon, between Locations and Settings. On desktop it sits between Forecast and Settings.
- **Multi-stop trips.** Each stop has a city and arrival/departure dates. You can leave one place and arrive at the next on the same day: that day shows as a travel day.
  - Trips are stored on the device (`TripsCubit`, hydrated).
  - Rules: a trip needs at least one stop, stops are in order, and a trip is at most 90 days long.
  - The city picker searches without adding the city to Locations.
- **Day-by-day weather** for each stop, with condition, high/low and rain chance:
  - The forecast covers days up to 16 days ahead (`ForecastRepository.dailyForecast`, a new daily-only Open-Meteo request clamped to the forecast window).
  - Days further out show **typical weather** for the date: the 20-year average, from the climate normals the app already uses. They're clearly labelled and switch to the real forecast automatically as the trip gets closer.
  - Forecasts are cached per stop for 3 hours, and refetched when units change. Past trips aren't refreshed.
- **Trip cards** show:
  - the date range;
  - a countdown ("Starts in 12 days" / "Happening now" / "Ended");
  - the temperature range and how many days are likely rainy;
  - a tint from the most common forecast sky.
- **Packing list** suggested from the weather, with tick boxes that are saved: umbrella, rain jacket, sunscreen, sunglasses, sun hat, light clothes, water bottle, warm layer, winter coat, gloves, windbreaker and insect repellent.
- **Share** a plain-text summary through the Android share sheet: each day's weather plus the packing list. Uses `share_plus`.
- **Pre-trip reminder** (Android), turned on per trip:
  - The hourly background job posts a notification between 17:00 the day before departure and 10:00 on the day, with the first stop's forecast.
  - Each reminder is sent once.
  - Moving the trip's dates re-arms it.
- **Undo** after deleting a trip.
- Privacy policy: a new "Trips" section, in the app and in `docs/privacy-policy.md`.
- Strings in all 8 languages. The Hausa, Yorùbá and Igbo ones need the same native review as the rest.

### Changed
- The background job only fetches the saved place's forecast when the widget or weather alerts need it. A trip reminder alone doesn't trigger that fetch.
- The API client's daily variables are shared between the main forecast and the new daily range request.

### Steps on your side
1. Run `flutter pub get` (new package: `share_plus`), then `flutter analyze` and `flutter test`. The new tests are in `test/trips_test.dart`.
2. Try it:
   - Plan a trip with two stops: one within the next two weeks, one a month away.
   - Check the forecast and typical days, the packing list and sharing.
   - Turn on the reminder for a trip starting tomorrow and wait until after 17:00 (the background job runs about hourly).

## Flutter 3.50: Material and Cupertino packages (November 2026)

Flutter 3.50 deprecates the SDK's `package:flutter/material.dart` and `cupertino.dart` in favour of the standalone `material_ui` and `cupertino_ui` packages.

### Changed
- Added `material_ui: ^1.4.0` and `cupertino_ui: ^1.1.1`. Versions 1.3.0 and 1.1.0 were retracted, so the constraints start above them.
- The app and the local `liquid_pull_refresh` package now need Flutter 3.47 or newer.
- Every `package:flutter/material.dart` import is now `package:material_ui/material_ui.dart`. This is the same as `dart fix --apply --code=migrate_design_widgets`.
- **Localizations:**
  - `MaterialApp` now uses `AppLocalizations.delegate` plus `GlobalMaterialLocalizations.delegates` from material_ui, which also brings the Cupertino and Widgets delegates.
  - The generated `AppLocalizations.localizationsDelegates` still lists the deprecated SDK delegates, so it's no longer used.
  - The generated files are excluded from analysis.
  - `fallback_localizations.dart` takes the Material and Cupertino pieces from the new packages, and only the widgets pieces from `flutter_localizations`.
- **Fonts:** google_fonts (8.2.1) still returns the SDK's `TextTheme`, which isn't the same type as material_ui's.
  - `createTextTheme` now applies Inter and Outfit style by style (`GoogleFonts.inter` / `GoogleFonts.outfit` return a `TextStyle`, which both libraries share).
  - The fonts look the same as before.
- **Pub workspace:** the root `pubspec.yaml` now lists the three local packages under `workspace:`, and each of them has `resolution: workspace`.
  - One `flutter pub get` at the root resolves everything together.
  - The real cause of the `Listenable` errors was a stale `.dart_tool` inside `plugins/liquid_pull_refresh`. It was resolved before the Flutter upgrade, which now pulls `Listenable` from the new `listen` package. That folder never got its own `pub get`, so the analyzer saw 300+ errors there while the app itself was fine.
- Removed the temporary `MaterialUiCompatibilityBridge`. It's deprecated, and no package in the widget tree needs it: flutter_map only uses SDK Material in debug tile builders the app doesn't use.

### Steps on your side
1. Run `flutter --version` and check you're on Flutter 3.47 or newer (3.50 stable recommended).
2. Run `flutter pub get` **at the project root** (the only `pub get` needed now), then `flutter analyze` and the tests.
3. If the analyzer still reports missing packages inside `plugins/` or `packages/`, delete these leftovers from before the workspace and run `flutter pub get` again:
   - the `.dart_tool` folders and `pubspec.lock` files inside `plugins/liquid_pull_refresh`;
   - the same inside the two `packages/` folders.

## Phase 5: Sun & moon, accessibility and release prep (November 2026)

### Added
- **Sun & moon card** (`components/sun_moon_card.dart`):
  - a sunrise-to-sunset arc with the sun at its current position;
  - day length;
  - tonight's moon phase with a drawing of the lit part (mirrored south of the equator) and how much of it is lit.

  It's all computed offline (`utils/astronomy.dart`, unit tested), and replaces the separate sunrise and sunset tiles.
- **Release docs:**
  - `docs/RELEASE.md`: a step-by-step Play Store checklist with build command, device test list, suggested Data safety answers, content rating and rollout.
  - `docs/privacy-policy.md`: the privacy policy to host at a public URL.
  - `fastlane/metadata/android/`: store listing title and descriptions in English, French, Spanish, Chinese and Japanese.

### Changed
- **Accessibility:**
  - The three quick stats are read out as single items ("Humidity: 72%").
  - The city name is announced as a heading.
  - Place cards no longer read out every hourly temperature.
  - With large system text, unit and theme buttons move onto their own row so they don't get squeezed.
- **Saved data survives obfuscated release builds:** both cubits now use fixed storage keys. The default key was the class name, which obfuscation changes.
- `android.enableJetifier` removed from `gradle.properties` (all dependencies use AndroidX).
- `minSdk` is 26 (Android 8.0), as set during Nobel's test run.
- Fixed the analyzer's `unintended_html_in_doc_comment` infos in `crash_reporting.dart`.

## Design refresh: Locations, Settings and home (November 2026)

### Changed
- **Typography:** Inter for text and Outfit for headings and big numbers
  replace Noto Sans Mono, Acme, Fuzzy Bubbles and ABeeZee. Shared component
  themes cover:
  - app bars, cards, dividers, snackbars and bottom sheets;
  - segmented buttons and chips;
  - navigation bar and rail.

  The navigation highlight is now blue instead of orange.
- **Locations:**
  - A large collapsing title, a "Search for a city" field and an add button
    replace the floating action button.
  - Each place is a card tinted by its current sky (`SkyPalette`). It shows:
    - name and local time;
    - conditions, temperature and today's high/low;
    - the next 6 hours.
  - Saved cities can be removed by swiping left or from their ⋮ menu. A
    snackbar offers **Undo** (`WeatherCubit.restoreCity`), which puts the city
    back in place with its forecast.
  - Long-press to reorder, as before. Cards stay at most 720 px wide on
    tablets.
  - The desktop side panel uses the same cards in a compact size, with a
    header and search field (no more floating button).
- **Settings:** grouped sections with coloured icon tiles (Appearance, Units,
  Forecast, Notifications, Privacy, About).
  - Units and theme use segmented buttons.
  - Language and briefing time open a bottom sheet.
  - The version shows next to "About BWeather".
  - Content is capped at 720 px wide on large screens.
- **Home:**
  - The city name, a single date/time line and a large thin temperature
    replace the playful font.
  - Then come the conditions and "Feels like · H/L" on one line.
  - The three quick stats sit in one rounded card.
  - Details, tips, air quality and hourly tiles share the same softer
    surfaces and rounder corners.

## Phase 4: Living forecast, radar and more languages (November 2026)

### Added
- **Animated weather backgrounds:**
  - A subtle sky behind each forecast: sun glow, stars and moon, drifting
    clouds, rain, snow, fog bands and lightning flashes.
  - Drawn with one `CustomPainter` and no image assets
    (`lib/components/weather_background.dart`).
  - It tints the theme surface, so text stays readable in light and dark mode.
  - On by default. It can be turned off in Settings, and it stays still when
    the device asks for reduced motion.
- **"Warmer/cooler than usual":**
  - A chip under "Feels like" compares today's forecast high with the average
    high for the same date over the last 20 years.
  - The averages come from the Open-Meteo historical archive (ERA5) and are
    smoothed over ±7 days. They're fetched once per place and saved with it.
  - Within ±1.5 °C, the chip shows "About normal". Tap it to see the years used.
- **Minute-by-minute rain:**
  - A card with the next 2 hours in 15-minute bars and a one-line summary,
    such as "Rain starting in about 20 min".
  - Off by default. Turn it on in Settings → Forecast. Changing it
    refreshes every place.
- **Rain radar:**
  - A "Rain radar" chip opens a map centred on the place, with OpenStreetMap
    tiles and RainViewer radar for the past 2 hours.
  - Controls: a time slider, play/pause, zoom buttons for mouse users, and a
    button to re-centre on the place.
  - Linked credits for OpenStreetMap and RainViewer.
  - Needs new dependencies: `flutter_map`, `latlong2`, `url_launcher`.
- **Crash reporting (Sentry):**
  - Off unless the build gets `--dart-define=SENTRY_DSN=...` (see README).
  - When it's on, users can turn it off in Settings.
  - Reports carry no location, place names, user or IP data.
  - New privacy-policy sections cover crash reports and the radar map.
- **Translations:** Spanish, Chinese (Simplified), Japanese, Hausa, Yorùbá
  and Igbo, including the Android widget strings.
  - The Hausa, Yorùbá and Igbo texts are drafts: have a native speaker review
    them before release.
  - Flutter has no framework strings or date names for these three, so
    English is used for those parts only (`fallback_localizations.dart`,
    `dateLocale()`).

### Changed
- **Layout for tablets and Windows:**
  - Breakpoints now follow Material window classes:
    - phones and narrow windows (under 600 px): bottom navigation bar;
    - tablets (600–1023 px): navigation rail;
    - large screens (1024 px and up): rail plus the places panel.
  - The rail shows labels beside its icons from 1440 px.
  - The places panel grows with the window (300–380 px).
  - The forecast page now uses its own width rather than the screen's. The
    details column moves beside the main reading at 760 px.
- **Windows:**
  - The window opens at 1280 × 800 and has a minimum size of 420 × 640
    (DPI-aware).
  - A refresh button appears next to "Updated …" on desktop and wider
    screens, because pull-to-refresh is awkward with a mouse.
- The forecast request can include `minutely_15` precipitation. API package:
  - new `dailyHistory()` and `radarFrames()`;
  - `JsonParser.parseNullableDoubleList`, so missing archive days are
    skipped instead of being counted as 0 °C.

### Steps on your side
1. Run `flutter pub get` (new packages: `flutter_map`, `latlong2`,
   `url_launcher`, `sentry_flutter`). Then run `flutter analyze`,
   `flutter test` and both package test suites.
2. Radar: email support@rainviewer.com to confirm a free public app may use
   the public API, and keep the credit visible. For heavy traffic, move the
   base map to a commercial tile provider.
3. Crash reports (optional):
   - Create a Sentry project (Flutter platform).
   - Build with `--dart-define=SENTRY_DSN=<your DSN>`.
   - In the project's Security & Privacy settings, enable
     "Prevent storing of IP addresses".
4. Have native speakers review `app_ha.arb`, `app_yo.arb` and `app_ig.arb`.
5. Try Windows: resize to the minimum size, then maximise. Try a tablet
   emulator in both orientations.

## Phase 3, part 2: Widget and daily tips (November 2026)

### Added
- **Home-screen widget (Android):**
  - Shows the place, temperature with a condition emoji, today's high and
    low, and when it was last updated. Tapping it opens the app.
  - Follows the system light/dark theme, is resizable, and its system strings
    are translated into French.
  - The app pushes fresh data whenever forecasts update (`home_widget`). The
    hourly background job also refreshes the widget, even when every alert
    is turned off.
  - Files: `WeatherWidgetProvider.kt`, `res/layout/weather_widget.xml`,
    `res/xml/weather_widget_info.xml`, plus a `<receiver>` in the manifest.
- **"Today's tips" card** below the forecast (`TipsEngine`, unit tested). It
  shows up to 5 tips, picked from:
  - an umbrella reminder with the likeliest rain time;
  - what to wear, based on today's feels-like maximum;
  - drinking water in extreme heat;
  - sunscreen when UV is high;
  - poor air quality;
  - the best time to be outdoors;
  - whether laundry will dry outside;
  - mosquitoes on a warm, humid evening;
  - fog or heavy rain for drivers.

### Changed
- Notifications are Android-only. The iOS settings and permission code were removed.
- The background job is now a general refresh: widget plus alerts. It's
  registered when any alert is on **or** a widget is on the home screen.

### Steps on your side
1. Run `flutter pub get` (new package: `home_widget`), then `flutter analyze`
   and `flutter test` (plus the package tests).
2. Run the app once, then long-press the home screen → Widgets → BWeather.
   The widget fills in right away. If you add it while the app is closed,
   open the app once so the hourly refresh starts.

### Ideas for later
- Animated weather backgrounds, "compared to normal" insights (Open-Meteo
  climate API), minute-by-minute rain (`minutely_15`), and a rain radar map.
- Hausa, Yoruba and Igbo translations.

## Phase 3, part 1: Premium features (November 2026)

### Fixed
- `ReorderableListView.onReorder` is deprecated in Flutter 3.41+; the list now
  uses `onReorderItem`, which passes the city's final index.

### Added
- **Air quality card:**
  - US AQI with its EPA category and colour, PM2.5, PM10 and **dust**.
    A mask hint appears above 150 µg/m³, which is common during Harmattan.
  - **UV index** with its WHO level, and **pollen** where it's modelled (Europe).
  - Data comes from the Open-Meteo Air Quality API, fetched alongside the
    forecast. If it fails, the forecast still loads.
- **Hourly chart:** a third "Chart" tab next to Daily and Hourly. It shows a
  24-hour temperature curve with rain-chance bars and is drawn with a
  `CustomPainter`, so no chart package is needed.
- **Notifications** (Settings → Notifications; all opt-in, Android):
  - **Morning briefing** at a time you choose (5–10 am): today's conditions,
    minimum and maximum, and rain chance.
  - **Rain alerts** when rain is likely in the next 2 hours and it isn't
    already raining. At most one every 3 hours.
  - **Severe weather:** thunderstorms in the next 3 hours, gusts of 75 km/h
    or more, or a feels-like temperature of 41 °C or more. At most one every 6 hours.
  - A background check runs about once an hour (`workmanager`), fetches a
    fresh forecast for your location (or your first saved city), and posts
    alerts with `flutter_local_notifications` in the app's language. The
    decision logic is a pure, unit-tested function (`AlertEvaluator`).
- Tests for the alert rules, air quality parsing and the AQI/UV levels.

### Android build changes (required by flutter_local_notifications 23)
- `compileSdk` is at least 37; core library desugaring is enabled (`desugar_jdk_libs`).
- `POST_NOTIFICATIONS` permission. The app asks for it the first time you turn on an alert.

### Steps on your side
1. Run `flutter pub get`. This also regenerates the translations for the new
   strings. Then run `flutter analyze` and `flutter test`.
2. Android: if Gradle reports that SDK platform 37 is missing, install
   "Android API 37" in Android Studio → SDK Manager.
3. Testing alerts on a device: turn an alert on in Settings, then wait up to
   an hour, or trigger the job from Android Studio's App Inspection →
   Background Task Inspector.

## Phase 2: Finish the core (November 2026)

### Fixes from the Phase 1 check
- **Failing repository test:** `getWeather` returned the API's grid-cell
  coordinates instead of the requested ones. That also changed a saved
  place's id after its first refresh. It now keeps the requested coordinates.
- **Analyzer issues:**
  - Model fields are renamed to camelCase (`temperature_2m` → `temperature2m`,
    `is_day` → `isDay`, `temp_unit` → `tempUnit`, ...). JSON keys are
    unchanged, so saved data and API parsing still work.
  - Settings uses `RadioGroup` instead of the deprecated `groupValue`/`onChanged`.
  - Fixed null-aware elements, initializing formals, the HTML in a doc comment,
    and removed the unnecessary library names.
- **`liquid_pull_refresh` is now a pure Dart package.** It had no platform
  code to speak of; its broken example caused the one analyzer *error*.
  Deprecated colour APIs and old-style `key` parameters are fixed.

### Added
- **About screen** with the real installed version (`package_info_plus`), data
  sources and attributions, open-source licences, and **Privacy policy** and
  **Terms of use** screens. Settings links to all three.
- **Reorder saved cities** with long-press and drag (drag handles on desktop). Your
  location stays pinned on top.
- **Localization** (English and French) for every screen, including weather
  descriptions, dates and times in the locale's format, and compass points.
  There is a new **Language** setting (System / English / Français).
- **Android release signing** from `android/key.properties`, falling back to
  the debug key when the file is missing.

### Changed
- Cubits no longer hold display text. They emit `LocationIssue`,
  `ForecastIssue` and search status, and the UI turns these into localized
  messages (`lib/l10n/messages.dart`).

### Steps on your side
1. **Delete the leftovers of the old plugin:**
   ```
   plugins/liquid_pull_refresh/android/
   plugins/liquid_pull_refresh/ios/
   plugins/liquid_pull_refresh/example/
   plugins/liquid_pull_refresh/test/
   plugins/liquid_pull_refresh/lib/liquid_pull_refresh_method_channel.dart
   plugins/liquid_pull_refresh/lib/liquid_pull_refresh_platform_interface.dart
   ```
2. Run `flutter pub get`. With `generate: true` it creates
   `lib/l10n/app_localizations*.dart`; if your IDE still shows missing imports,
   run `flutter gen-l10n`. Then run `flutter analyze` and `flutter test`.
3. **Release keystore:** create an upload keystore and `android/key.properties`
   (see the comment in `android/app/build.gradle.kts`).
4. **Legal text:** have the Privacy policy and Terms reviewed, and host the
   privacy policy at a public URL. Google Play asks for one.

### Not in this phase
- Hausa, Yoruba and Igbo. Flutter's Material localizations don't include them,
  so they need a fallback delegate plus a native-speaker translation.
- Converting units on the device instead of refetching.

## Phase 1: Stabilise (November 2026)

This phase fixes the bugs found in the code review (`claude/bweather-code-review.md`
in the Bweather Flutter project), removes dead code, and adds lints and CI. The
numbers in brackets refer to sections of that review.

### Breaking / behaviour changes
- **First launch now shows a welcome screen** instead of immediately asking for
  location. It offers three options: "Use my location", "Continue with
  <approximate place>" (from the network, fetched in the background), and
  "Search for a city". The app **no longer closes** when permission is denied (2.3).
- Saved data moved from the temp/cache directory to the application support
  directory, so the OS can no longer delete it. Existing data is copied over
  once on first launch (2.4).
- Default wind unit for *new* installs is km/h (was m/s). Existing users keep
  their saved choice.
- Saved places are identified by coordinates, so same-named cities in
  different countries (Paris, FR and Paris, TX) can both be saved (2.11).
- The tablet and desktop sidebar is now a Material `NavigationRail`, and the vendored
  `packages/sidebarx` package is no longer used (1.4).

### Fixed
- City search sent only the first typed character. It is now debounced
  (350 ms), searches the full text, needs at least 2 characters, and shows
  loading, empty and error states. Results show the region, e.g. "Ikorodu,
  Lagos, Nigeria" (2.1, 1.11).
- "My location" could resolve to a different town with the same name. The
  forecast is now always requested for the exact GPS coordinates; reverse
  geocoding only provides the display name (2.2).
- One unreadable field (e.g. a null `elevation`) wiped all saved data. Parsing
  is now defensive per field and per city, and old cached forecasts are dropped
  without losing the city (2.5).
- The forecast pager jumped back to the first page whenever any forecast
  updated. It now has a single `PageController` (2.6).
- Location cards showed 00:00–04:00 instead of the next 5 hours (2.7).
- Time zones with half-hour offsets (India, Newfoundland) were rounded. The
  date, time and "rain now" values now use the *place's* local time instead of
  the device's (2.8).
- Day and night icons now use the API's per-hour `is_day` and sunrise/sunset
  instead of a fixed 18:00 cut-off (2.9).
- Weather code 56 at night (and any unknown code) no longer crashes the icon (2.10).
- `WeatherCubit` logic errors: the `&&`/`||` mix-ups, the crash on force-reload
  with no location, the `late` listener crash, and results written to the wrong
  city after adding or removing one. All updates are now done by key (2.11).
- Picking a city from the built-in list used to search by name; it now uses the
  list's coordinates (2.12).
- On desktop, choosing a search result popped the app's only route. The panel
  now closes itself (2.13).
- Connectivity listeners leaked and fired twice. There is now one listener,
  cancelled on close (2.14).
- Wrong labels: "meter per hour" is now "Miles per hour", "Wind Guts" is now
  "Wind gusts", "Match" is now "March", and "Rain Sum" (which showed the last
  15 minutes) is now "Rain chance". Wind direction shows a compass point (2.15).
- Temperatures are rounded instead of rounded up, and "Feels like" is rounded too (2.16).
- If a refresh fails, cached forecasts stay on screen with a "Couldn't refresh ·
  Retry" note instead of a full-screen error (2.17).
- Settings is now reachable on tablet and desktop (1.4).

### Added
- "Updated x min ago" on every forecast. Stale forecasts (older than 15 min) refresh on
  launch, when the app returns to the foreground, and on reconnect.
- Knots wind unit option (1.8).
- Rain chance per hour and per day, plus dew point, sunrise, sunset and "rain
  today" tiles. This data was already downloaded but never shown (1.7).
- A banner when the location is approximate, with "Use precise" / "Settings".
- Accessibility labels on temperature, daily, hourly and detail tiles.
- HTTP timeouts (15 s) and typed failures for every request. Nominatim requests
  now send an identifying User-Agent, as its usage policy requires.
- Tests for search debounce, onboarding fallbacks, key-based updates, unit
  changes, time zone helpers, reverse geocoding and defensive parsing.
- `.github/workflows/ci.yml`: analyze and test the app and both packages.

### Removed
- Unused dependencies: `provider`, `uno`, `card_swiper`, `geocoding`,
  `elegant_notification`, `shared_preferences`, `device_info_plus`,
  `flutter_timezone`, `flutter_spinkit`, `json_annotation`,
  `pull_to_refresh_notification`, `after_layout`, `loading_indicator`,
  `sidebarx`, and `nominatim_flutter` (replaced by a direct, testable call).
- Dead code: sample apps, method-channel stubs without native code, and unused widgets.
- Android permissions that weren't needed: `CHANGE_WIFI_STATE` and
  `ACCESS_WIFI_STATE`, the duplicate `ACCESS_FINE_LOCATION`, and
  `<uses-feature wifi>`, which hid the app from devices without Wi-Fi.
  `POST_NOTIFICATIONS` returns with the notifications feature.

### Delete these files and folders (they are no longer used)
The files below were removed or renamed in this phase. Delete them from your
project; until you do, `flutter analyze` reports errors in them, because some
import packages that were removed.

```
lib/example.dart
lib/test.dart
lib/screens/splash.dart
lib/screens/test.dart
lib/pages/forcast.dart                       (replaced by lib/pages/forecast.dart)
lib/components/forcast.dart                  (replaced by lib/components/forecast_view.dart)
lib/components/locatiions.dart               (replaced by lib/components/location_list.dart)
lib/components/option-button.dart            (replaced by lib/components/option_button.dart)
lib/components/shimmering/forcast.dart       (replaced by lib/components/shimmering/forecast.dart)
lib/components/shimmering/shimmer_wraper.dart (replaced by lib/components/shimmering/shimmer_wrapper.dart)
lib/components/clickable.dart
lib/components/loading.dart
lib/components/placeholders.dart
lib/components/refresh.dart
lib/services/bridge.dart
lib/services/notifications.dart
lib/utils/notifications.dart
lib/utils/objectio.dart
packages/sidebarx/                           (whole folder)
```

### Not in this phase (next up)
- Phase 2: Info, Privacy and Terms pages; app version from `package_info_plus`;
  release signing; reordering saved cities; localization;
  renaming the snake_case model fields; converting `liquid_pull_refresh` from a
  platform plugin into a pure Dart package.
