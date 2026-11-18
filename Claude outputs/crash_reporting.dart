import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Optional crash reporting through Sentry.
///
/// Nothing is sent unless the build was given a DSN (from your Sentry project's
/// Client Keys page):
///
/// ```sh
/// flutter build apk --dart-define=SENTRY_DSN=https://KEY@ORG.ingest.sentry.io/PROJECT
/// ```
///
/// Users can turn reports off in Settings; [enabled] is checked for every event.
/// No personal data is attached (no IP address, no location, no city names).
class CrashReporting {
    static const dsn = String.fromEnvironment('SENTRY_DSN');

    /// Whether this build can send crash reports at all.
    static bool get available => dsn.isNotEmpty;

    /// The user's choice (Settings → Send crash reports). Updated by SettingsCubit.
    static bool enabled = true;

    /// Starts Sentry (when available and allowed) and then runs [app].
    ///
    /// If the user has turned reports off, Sentry isn't started at all, so
    /// native (Java/NDK) crash handlers aren't installed either. Turning it
    /// back on takes effect from the next launch; turning it off applies at
    /// once to Dart errors via [enabled].
    static Future<void> run(FutureOr<void> Function() app) async {
        if (!available || !enabled) {
            await app();
            return;
        }

        await SentryFlutter.init(
            (options) {
                options.dsn = dsn;
                options.environment = kReleaseMode ? 'production' : 'debug';
                options.sendDefaultPii = false;
                options.tracesSampleRate = 0;
                options.attachScreenshot = false;
                options.attachViewHierarchy = false;
                options.beforeSend = (event, hint) => enabled ? _scrub(event) : null;
                options.beforeBreadcrumb = (breadcrumb, hint) => enabled && breadcrumb?.category != 'http' ? breadcrumb : null;
            },
            appRunner: app,
        );
    }

    /// Drops request details that could contain coordinates.
    static SentryEvent _scrub(SentryEvent event) {
        event.request = null;
        event.user = null;
        return event;
    }
}
