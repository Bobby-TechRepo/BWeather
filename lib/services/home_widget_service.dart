import 'dart:developer';

import 'package:bweather/l10n/app_localizations.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather/utils/weather_codes.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Everything the Android home-screen widget shows, as plain strings.
class WeatherWidgetData extends Equatable {
    final String place, temperature, condition, emoji, range, updated;

    const WeatherWidgetData({
        required this.place, required this.temperature, required this.condition,
        required this.emoji, required this.range, required this.updated,
    });

    /// Builds the widget text for [city]'s forecast. Pure, for tests.
    static WeatherWidgetData from({
        required City city,
        required Forecast forecast,
        required AppLocalizations l10n,
        required String locale,
        required DateTime updatedAt,
    }) {
        final current = forecast.current;
        final today = forecast.today(updatedAt);
        final unit = current.temperature.unit;
        return WeatherWidgetData(
            place: city.name,
            temperature: "${roundTemp(current.temperature.value)}°",
            condition: WeatherCode.decode(code: current.weatherCode, isNight: !current.isDay).describe(l10n),
            emoji: emojiFor(current.weatherCode, isNight: !current.isDay),
            range: today == null
                ? ""
                : l10n.widgetRange("${roundTemp(today.temperatureMax.value)}$unit", "${roundTemp(today.temperatureMin.value)}$unit"),
            updated: l10n.widgetUpdated(formatClock(updatedAt, locale)),
        );
    }

    /// Emoji for a WMO weather code. RemoteViews can't draw our SVG icons,
    /// and emoji keep the widget dependency-free.
    static String emojiFor(int code, { bool isNight = false }) => switch (code) {
        0 || 1 => isNight ? "🌙" : "☀️",
        2 => isNight ? "☁️" : "⛅",
        3 => "☁️",
        45 || 48 => "🌫️",
        >= 51 && <= 57 => "🌦️",
        >= 61 && <= 67 => "🌧️",
        >= 71 && <= 77 => "❄️",
        >= 80 && <= 82 => "🌧️",
        85 || 86 => "🌨️",
        >= 95 && <= 99 => "⛈️",
        _ => "🌡️",
    };

    Map<String, String> toMap() => {
        "place": place, "temperature": temperature, "condition": condition,
        "emoji": emoji, "range": range, "updated": updated,
    };

    @override
    List<Object?> get props => [place, temperature, condition, emoji, range, updated];
}

/// Pushes weather data to the Android home-screen widget
/// (`android/app/src/main/kotlin/com/bsoft/bweather/WeatherWidgetProvider.kt`).
class HomeWidgetService {
    static const androidProvider = "com.bsoft.bweather.WeatherWidgetProvider";

    static bool get isSupported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    WeatherWidgetData? _last;

    /// Whether the user has at least one BWeather widget on their home screen.
    Future<bool> hasWidgets() async {
        if (!isSupported) return false;
        try {
            return (await HomeWidget.getInstalledWidgets()).isNotEmpty;
        } catch (error) {
            log("Couldn't list home-screen widgets", error: error);
            return false;
        }
    }

    Future<void> update(WeatherWidgetData data) async {
        if (!isSupported || data == _last) return;
        try {
            for (final entry in data.toMap().entries) {
                await HomeWidget.saveWidgetData<String>(entry.key, entry.value);
            }
            await HomeWidget.updateWidget(qualifiedAndroidName: androidProvider);
            _last = data;
        } catch (error) {
            log("Couldn't update the home-screen widget", error: error);
        }
    }
}
