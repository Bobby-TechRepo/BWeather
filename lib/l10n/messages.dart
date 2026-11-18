import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/states/forecast/city_state.dart';
import 'package:bweather/states/forecast/weather_state.dart';

/// User-facing text for state enums. Cubits emit enums; the UI localizes them.
extension StateMessages on AppLocalizations {
    String locationIssue(LocationIssue issue) => switch (issue) {
        LocationIssue.serviceDisabled => locationServiceDisabled,
        LocationIssue.permissionDenied => locationPermissionDenied,
        LocationIssue.permissionDeniedForever => locationPermissionBlocked,
        LocationIssue.unavailable => locationUnavailable,
        LocationIssue.none => "",
    };

    /// Message for a failed forecast; [city] is used when the reason is unknown.
    String forecastIssue(ForecastIssue issue, String city) => switch (issue) {
        ForecastIssue.network => forecastErrorNetwork,
        ForecastIssue.data => forecastErrorData,
        ForecastIssue.unknown || ForecastIssue.none => forecastLoadFailed(city),
    };
}
