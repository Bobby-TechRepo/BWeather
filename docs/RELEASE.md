# Releasing BWeather on Google Play

A checklist for each release. Items marked **once** only need doing the first time.

## 1. Before you build

- [ ] `flutter analyze` is clean, and every test suite passes:
  ```bash
  flutter test
  (cd packages/bweather_open_meteo_api && flutter test)
  (cd packages/bweather_repository && flutter test)
  ```
- [ ] Bump `version:` in `pubspec.yaml`, for example `1.0.1+2`. The number after `+` must go up on every upload.
- [ ] Add a `CHANGELOG.md` entry.
- [ ] **once** Create an upload key and `android/key.properties` (see the comment at the top of `android/app/build.gradle.kts`). Back up the keystore and passwords. Losing them means you can't update the app.
- [ ] **once** Have native speakers review `app_ha.arb`, `app_yo.arb` and `app_ig.arb`.
- [ ] **once** Email support@rainviewer.com to confirm that a free public app may use the public radar API.
- [ ] **once** Check that Open-Meteo's free tier covers your use. It's for non-commercial use; a company publishing an app may need an API plan.

## 2. Build

```bash
flutter build appbundle --release \
  --obfuscate --split-debug-info=build/symbols \
  --dart-define=SENTRY_DSN=https://KEY@ORG.ingest.sentry.io/PROJECT
```

- Leave out `--dart-define=SENTRY_DSN=...` to ship without crash reporting.
- `--obfuscate` makes the app harder to reverse-engineer. Keep `build/symbols` for each release: Sentry needs those files to turn obfuscated stack traces back into readable ones. The [`sentry_dart_plugin`](https://pub.dev/packages/sentry_dart_plugin) can upload them for you.
- Saved settings and places use fixed storage keys (`storagePrefix`), so obfuscation doesn't wipe them on update.
- The bundle is at `build/app/outputs/bundle/release/app-release.aab`.

## 3. Test the release build on a real phone

```bash
flutter install --release
```

- [ ] First launch: allow location, then deny it and use city search instead.
- [ ] Add, reorder and remove cities. Check that Undo works.
- [ ] Turn on the morning briefing and add the home-screen widget. Leave the phone for an hour and check that both update.
- [ ] Open the radar and play it. Check that the credits open in the browser.
- [ ] Plan a two-stop trip, check the forecast and typical days, tick a packing item, share the trip, and turn on its reminder.
- [ ] Switch languages and dark mode.
- [ ] Turn on large text (Settings → Display → Font size), then look at the forecast, Locations and Settings.
- [ ] Watch `flutter logs` for errors. If the "Impeller opt-out deprecated" message only shows on an emulator, ignore it there.

## 4. Play Console

**once** Store listing:
- Texts are in `fastlane/metadata/android/<locale>/` (title, short and full description). Paste them in, or upload them with fastlane `supply`.
- Graphics: a 512 × 512 icon, a 1024 × 500 feature graphic, and at least 2 phone screenshots. Add 7- and 10-inch tablet screenshots too, since the app has a tablet layout.
- Category: Weather. Contact email: your support address.

**once** Privacy policy: host `docs/privacy-policy.md` at a public URL (for example GitHub Pages) and enter it under App content → Privacy policy.

**once** App content → Data safety. Suggested answers (check them against Google's current definitions):

| Data type | Collected | Shared | Optional | Why |
| --- | --- | --- | --- | --- |
| Approximate location | Yes, processed ephemerally | No | Yes (city search works without it) | App functionality |
| Precise location | Yes, processed ephemerally | No | Yes | App functionality |
| Crash logs, diagnostics | Yes, only in builds with a Sentry DSN | No | Yes (Settings → Privacy) | App functionality, analytics |

- Data is encrypted in transit (HTTPS only).
- There's no account, so there's nothing to delete on a server. Uninstalling removes everything stored on the device.
- Sending data to Open-Meteo, OpenStreetMap, RainViewer, ipapi.co and Sentry to provide the service counts as using service providers, not as "sharing".

**once** Other App content items:
- Content rating questionnaire: a utility app with no user-generated content.
- Target audience: choose 13 and over. Including children brings extra Families policy rules.
- Ads: none.
- Permissions: foreground location only. There's no background location: the hourly background job uses the saved place, not GPS. Notifications are requested when the user turns an alert on.

## 5. Roll out

- [ ] Upload the `.aab` to Internal testing first and try it from the Play Store on a couple of devices.
- [ ] If the developer account is a *personal* one created after November 2023, Google requires a closed test with at least 12 testers for 14 days before you can publish to Production. An organisation account (for example Bsoft Limited) doesn't have this rule.
- [ ] Promote to Closed testing, then to Production with a staged rollout (for example 20%).
- [ ] Watch Sentry and the Play Console "Android vitals" for crashes and ANRs during the first days.
