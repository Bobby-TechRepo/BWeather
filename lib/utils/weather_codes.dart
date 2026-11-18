import 'package:bweather/l10n/app_localizations.dart';

const Map<int, String> __dayImages = {
  // Adding more codes for a more complete map
  0: 'meteocons--clear-day-fill.svg',             // clear
  1: 'meteocons--clear-day-fill.svg',             // Mainly clear
  2: 'meteocons--partly-cloudy-day-fill.svg',     // Partly cloudy
  3: 'meteocons--overcast-fill.svg',              // Overcast
  45: 'meteocons--fog-day-fill.svg',                  // Fog
  48: 'meteocons--fog-day-fill.svg', //'Rime fog or depositing rime fog',
  51: 'meteocons--partly-cloudy-day-drizzle-fill.svg',  //'Light drizzle',
  53: 'meteocons--overcast-day-drizzle-fill.svg',   //'Moderate drizzle',
  55: 'meteocons--extreme-day-drizzle-fill.svg',    //'Dense drizzle',
  56: 'meteocons--overcast-drizzle-fill.svg',  //'Freezing drizzle, light',
  57: 'meteocons--extreme-drizzle-fill.svg',   //'Freezing drizzle, dense',
  61: 'meteocons--partly-cloudy-day-rain-fill.svg',  //'Rain, slight',
  63: 'meteocons--overcast-day-rain-fill.svg', // 'Rain, moderate',
  65: 'meteocons--extreme-day-rain-fill.svg', //'Rain, heavy',
  66: 'meteocons--overcast-rain-fill.svg',   //'Freezing rain, slight',
  67: 'meteocons--extreme-rain-fill.svg',    //'Freezing rain, heavy',
  71: 'meteocons--snow-fill.svg', //'Snow fall, slight',
  73: 'meteocons--extreme-day-snow-fill.svg',   //'Snow fall, moderate',
  75: 'meteocons--extreme-snow-fill.svg',   //'Snow fall, heavy',
  77: 'meteocons--snow-fill.svg',   //'Snow grains',
  80: 'meteocons--drizzle-fill.svg', //'Rain showers, slight',
  81: 'meteocons--overcast-rain-fill.svg',   //'Rain showers, moderate',
  82: 'meteocons--extreme-rain-fill.svg',   //'Rain shower s, violent',
  85: 'meteocons--partly-cloudy-day-snow-fill.svg',       //'Snow showers, slight',
  86: 'meteocons--extreme-snow-fill.svg',  //'Snow showers, heavy',
  95: 'meteocons--thunderstorms-day-fill.svg',   //'Thunderstorm, slight or moderate',
  96: 'meteocons--thunderstorms-day-overcast-fill.svg',  //'Thunderstorm with slight hail',
  99: 'meteocons--thunderstorms-day-extreme-fill.svg',  //'Thunderstorm with heavy hail',
  // ... Add more codes as needed
};

const Map<int, String> __nightImages = {
  // Adding more codes for a more complete map
  0: 'meteocons--clear-night-fill.svg', // clear sky
  1: 'meteocons--clear-night-fill.svg', // Mainly clear
  2: 'meteocons--partly-cloudy-night-fill.svg', //Partly cloudy',
  3: 'meteocons--overcast-night-fill.svg', //'Overcast',
  45: 'meteocons--fog-night-fill.svg',   //'Fog',
  48: 'meteocons--fog-night-fill.svg', //'Rime fog or depositing rime fog',
  51: 'meteocons--drizzle-fill.svg',     //'Light drizzle',
  53: 'meteocons--partly-cloudy-night-drizzle-fill.svg',   //'Moderate drizzle',
  55: 'meteocons--extreme-night-drizzle-fill.svg', //'Dense drizzle',
  56: 'meteocons--overcast-drizzle-fill.svg',  //'Freezing drizzle, light',
  57: 'meteocons--extreme-drizzle-fill.svg',   //'Freezing drizzle, dense',
  61: 'meteocons--partly-cloudy-night-rain-fill.svg',  //'Rain, slight',
  63: 'meteocons--overcast-night-rain-fill.svg', // 'Rain, moderate',
  65: 'meteocons--extreme-night-rain-fill.svg', //'Rain, heavy',
  66: 'meteocons--overcast-rain-fill.svg',   //'Freezing rain, slight',
  67: 'meteocons--extreme-rain-fill.svg',    //'Freezing rain, heavy',
  71: 'meteocons--snow-fill.svg', //'Snow fall, slight',
  73: 'meteocons--extreme-night-snow-fill.svg',   //'Snow fall, moderate',
  75: 'meteocons--extreme-snow-fill.svg',   //'Snow fall, heavy',
  77: 'meteocons--snow-fill.svg',   //'Snow grains',
  80: 'meteocons--drizzle-fill.svg', //'Rain showers, slight',
  81: 'meteocons--overcast-rain-fill.svg',   //'Rain showers, moderate',
  82: 'meteocons--extreme-rain-fill.svg',   //'Rain showers, violent',
  85: 'meteocons--partly-cloudy-night-snow-fill.svg',       //'Snow showers, slight',
  86: 'meteocons--extreme-snow-fill.svg',  //'Snow showers, heavy',
  95: 'meteocons--thunderstorms-night-fill.svg',   //'Thunderstorm, slight or moderate',
  96: 'meteocons--thunderstorms-night-overcast-fill.svg',  //'Thunderstorm with slight hail',
  99: 'meteocons--thunderstorms-night-extreme-fill.svg',  //'Thunderstorm with heavy hail',
  // ... Add more codes as needed
};

class WeatherCode {
    /// Shown for codes the maps don't cover, so an unknown code never breaks the UI.
    static const fallbackImage = 'meteocons--overcast-fill.svg';

    final int code;
    final String image;

    const WeatherCode({ required this.code, required this.image });

    factory WeatherCode.decode({ required int code, required bool isNight }) {
        final image = (isNight ? __nightImages[code] : __dayImages[code]) ?? __dayImages[code] ?? fallbackImage;
        return WeatherCode(code: code, image: "files/icons/$image");
    }

    /// Localized WMO weather description, e.g. "Light rain" / "Pluie faible".
    String describe(AppLocalizations l10n) => switch (code) {
        0 => l10n.wmo0,
        1 => l10n.wmo1,
        2 => l10n.wmo2,
        3 => l10n.wmo3,
        45 => l10n.wmo45,
        48 => l10n.wmo48,
        51 => l10n.wmo51,
        53 => l10n.wmo53,
        55 => l10n.wmo55,
        56 => l10n.wmo56,
        57 => l10n.wmo57,
        61 => l10n.wmo61,
        63 => l10n.wmo63,
        65 => l10n.wmo65,
        66 => l10n.wmo66,
        67 => l10n.wmo67,
        71 => l10n.wmo71,
        73 => l10n.wmo73,
        75 => l10n.wmo75,
        77 => l10n.wmo77,
        80 => l10n.wmo80,
        81 => l10n.wmo81,
        82 => l10n.wmo82,
        85 => l10n.wmo85,
        86 => l10n.wmo86,
        95 => l10n.wmo95,
        96 => l10n.wmo96,
        99 => l10n.wmo99,
        _ => l10n.wmoUnknown,
    };
}
