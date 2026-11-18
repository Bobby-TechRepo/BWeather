import 'dart:developer';

import 'package:bweather/services/alerts.dart';
import 'package:bweather/services/crash_reporting.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SettingsState extends Equatable {
    final TempUnit tempUnit;
    final WindSpeedUnit windSpeedUnit;
    final PrecipitationUnit precipitationUnit;

    /// "auto", "light" or "dark".
    final String themeMode;

    /// App language code ("en", "fr"), or "" to follow the device.
    final String languageCode;

    /// Notification preferences.
    final AlertPrefs alerts;

    /// Minute-by-minute (15-minute) rain for the next 2 hours. Off by default
    /// because it makes every forecast request a little larger.
    final bool minuteRain;

    /// Animated sky behind the forecast. Also off when the system asks for reduced motion.
    final bool animatedBackground;

    /// Send anonymous crash reports (only when the build has a Sentry DSN).
    final bool crashReports;

    /// Locale override for MaterialApp; null follows the device.
    Locale? get locale => languageCode.isEmpty ? null : Locale(languageCode);

    /// "light" and "dark" are fixed; "auto" follows the time of day ([isDay]).
    ThemeMode themeModeFor({ required bool isDay }) {
        switch (themeMode) {
            case "light":
                return ThemeMode.light;
            case "dark":
                return ThemeMode.dark;
        }
        return isDay ? ThemeMode.light : ThemeMode.dark;
    }

    Units get units => Units(tempUnit: tempUnit, windSpeedUnit: windSpeedUnit, precipitationUnit: precipitationUnit);

    const SettingsState({
        this.tempUnit = TempUnit.celsius, this.windSpeedUnit = WindSpeedUnit.kmh,
        this.precipitationUnit = PrecipitationUnit.mm, this.themeMode = "auto", this.languageCode = "",
        this.alerts = const AlertPrefs(), this.minuteRain = false, this.animatedBackground = true, this.crashReports = true,
    });

    SettingsState copy({ TempUnit? tempUnit, WindSpeedUnit? windSpeedUnit, PrecipitationUnit? precipitationUnit, String? themeMode, String? languageCode, AlertPrefs? alerts, bool? minuteRain, bool? animatedBackground, bool? crashReports }) {
        return SettingsState(
            tempUnit: tempUnit ?? this.tempUnit,
            windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
            precipitationUnit: precipitationUnit ?? this.precipitationUnit,
            themeMode: themeMode ?? this.themeMode,
            languageCode: languageCode ?? this.languageCode,
            alerts: alerts ?? this.alerts,
            minuteRain: minuteRain ?? this.minuteRain,
            animatedBackground: animatedBackground ?? this.animatedBackground,
            crashReports: crashReports ?? this.crashReports,
        );
    }

    factory SettingsState.fromJson(Map<String, dynamic> json) {
        const defaults = SettingsState();
        T read<T>(String key, T Function(String value) parse, T fallback) {
            try {
                return json[key] == null ? fallback : parse(json[key].toString());
            } catch (_) {
                return fallback;
            }
        }

        return SettingsState(
            tempUnit: read("temp_unit", (value) => value.tempUnit, defaults.tempUnit),
            windSpeedUnit: read("wind_speed_unit", (value) => value.windSpeedUnit, defaults.windSpeedUnit),
            precipitationUnit: read("precipitation_unit", (value) => value.precipitationUnit, defaults.precipitationUnit),
            themeMode: read("themeMode", (value) => const ["auto", "light", "dark"].contains(value) ? value : "auto", defaults.themeMode),
            languageCode: read("language", (value) => supportedLanguages.contains(value) ? value : "", defaults.languageCode),
            alerts: AlertPrefs.fromJson(json["alerts"]),
            minuteRain: read("minute_rain", (value) => value == "true", defaults.minuteRain),
            animatedBackground: read("animated_background", (value) => value == "true", defaults.animatedBackground),
            crashReports: read(crashReportsKey, (value) => value == "true", defaults.crashReports),
        );
    }

    Map<String, dynamic> toJson() => {
        "temp_unit" : tempUnit.serialize, "wind_speed_unit": windSpeedUnit.serialize,
        "precipitation_unit": precipitationUnit.serialize, "themeMode" : themeMode, "language": languageCode,
        "alerts": alerts.toJson(), "minute_rain": minuteRain, "animated_background": animatedBackground,
        crashReportsKey: crashReports,
    };

    /// Also read directly from storage in main(), before the cubits exist.
    static const crashReportsKey = "crash_reports";

    /// Languages with translations (keep in sync with lib/l10n/app_*.arb).
    static const supportedLanguages = ["en", "fr", "es", "zh", "ja", "ha", "yo", "ig"];

    @override
    List<Object?> get props => [tempUnit, windSpeedUnit, precipitationUnit, themeMode, languageCode, alerts, minuteRain, animatedBackground, crashReports];
}

/// User preferences. Other cubits react to changes by listening to [stream];
/// this cubit knows nothing about them.
class SettingsCubit extends HydratedCubit<SettingsState> {
    SettingsCubit(): super(const SettingsState()) {
        CrashReporting.enabled = state.crashReports;
    }

    /// Fixed storage key. The default is the class name, which changes in
    /// obfuscated release builds and would lose saved settings on update.
    static const storageKey = 'SettingsCubit';

    @override
    String get storagePrefix => storageKey;

    String get themeMode => state.themeMode;
    set themeMode(String mode) => emit(state.copy(themeMode: mode));

    set languageCode(String code) => emit(state.copy(languageCode: code));

    set alerts(AlertPrefs alerts) => emit(state.copy(alerts: alerts));

    set minuteRain(bool enabled) => emit(state.copy(minuteRain: enabled));

    set animatedBackground(bool enabled) => emit(state.copy(animatedBackground: enabled));

    set crashReports(bool enabled) {
        CrashReporting.enabled = enabled;
        emit(state.copy(crashReports: enabled));
    }

    set tempUnit(TempUnit unit) => emit(state.copy(tempUnit: unit));

    set windSpeedUnit(WindSpeedUnit unit) => emit(state.copy(windSpeedUnit: unit));

    set precipitationUnit(PrecipitationUnit unit) => emit(state.copy(precipitationUnit: unit));

    @override
    SettingsState? fromJson(Map<String, dynamic> json) {
        try {
            return SettingsState.fromJson(json);
        } catch (err) {
            log("Settings State deserialization error", error: err);
        }
        return null;
    }

    @override
    Map<String, dynamic>? toJson(SettingsState state) => state.toJson();
}
