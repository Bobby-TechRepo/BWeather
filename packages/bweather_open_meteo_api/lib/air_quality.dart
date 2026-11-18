import 'package:bweather_open_meteo_api/util.dart';
import 'package:equatable/equatable.dart';

/// Current air quality from the Open-Meteo Air Quality API.
///
/// Every value can be null: pollen is only modelled for Europe, and any
/// variable may be missing for a location.
class AirQualityResult extends Equatable {
    /// Pollen variables requested from the API (grains/m³).
    static const pollenKeys = ["alder_pollen", "birch_pollen", "grass_pollen", "mugwort_pollen", "olive_pollen", "ragweed_pollen"];

    final DateTime? time;
    final int? europeanAqi, usAqi;
    final double? pm10, pm25, dust, uvIndex;

    /// e.g. {"grass_pollen": 12.0}; only non-null values are kept.
    final Map<String, double> pollen;

    const AirQualityResult({ this.time, this.europeanAqi, this.usAqi, this.pm10, this.pm25, this.dust, this.uvIndex, this.pollen = const {} });

    factory AirQualityResult.fromJson(Map<String, dynamic> json) {
        final current = (json["current"] as Map?) ?? const {};
        final pollen = <String, double>{
            for (final key in pollenKeys)
                if (JsonParser.parseDoubleOrNull(current, key) != null) key: JsonParser.parseDoubleOrNull(current, key)!,
        };
        return AirQualityResult(
            time: JsonParser.parseDateOrNull(current, "time"),
            europeanAqi: JsonParser.parseIntOrNull(current, "european_aqi"),
            usAqi: JsonParser.parseIntOrNull(current, "us_aqi"),
            pm10: JsonParser.parseDoubleOrNull(current, "pm10"),
            pm25: JsonParser.parseDoubleOrNull(current, "pm2_5"),
            dust: JsonParser.parseDoubleOrNull(current, "dust"),
            uvIndex: JsonParser.parseDoubleOrNull(current, "uv_index"),
            pollen: pollen,
        );
    }

    @override
    List<Object?> get props => [time, europeanAqi, usAqi, pm10, pm25, dust, uvIndex, pollen];
}
