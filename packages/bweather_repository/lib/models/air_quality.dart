import 'package:bweather_open_meteo_api/util.dart';
import 'package:equatable/equatable.dart';

/// US EPA AQI bands.
enum AqiLevel { good, moderate, sensitive, unhealthy, veryUnhealthy, hazardous }

/// WHO UV index bands.
enum UvLevel { low, moderate, high, veryHigh, extreme }

/// Air quality, UV and pollen at a place. Values are null when unavailable.
class AirQuality extends Equatable {
    final int? usAqi, europeanAqi;

    /// µg/m³
    final double? pm25, pm10, dust;
    final double? uvIndex;

    /// Pollen in grains/m³ by API key (e.g. "grass_pollen"). Europe only.
    final Map<String, double> pollen;

    const AirQuality({ this.usAqi, this.europeanAqi, this.pm25, this.pm10, this.dust, this.uvIndex, this.pollen = const {} });

    bool get isEmpty => usAqi == null && europeanAqi == null && pm25 == null && pm10 == null && dust == null && uvIndex == null && pollen.isEmpty;

    AqiLevel? get aqiLevel {
        final aqi = usAqi;
        if (aqi == null) return null;
        if (aqi <= 50) return AqiLevel.good;
        if (aqi <= 100) return AqiLevel.moderate;
        if (aqi <= 150) return AqiLevel.sensitive;
        if (aqi <= 200) return AqiLevel.unhealthy;
        if (aqi <= 300) return AqiLevel.veryUnhealthy;
        return AqiLevel.hazardous;
    }

    UvLevel? get uvLevel {
        final uv = uvIndex;
        if (uv == null) return null;
        final rounded = uv.round();
        if (rounded <= 2) return UvLevel.low;
        if (rounded <= 5) return UvLevel.moderate;
        if (rounded <= 7) return UvLevel.high;
        if (rounded <= 10) return UvLevel.veryHigh;
        return UvLevel.extreme;
    }

    factory AirQuality.fromJson(dynamic json) {
        final pollenJson = (json["pollen"] as Map?) ?? const {};
        return AirQuality(
            usAqi: JsonParser.parseIntOrNull(json, "us_aqi"),
            europeanAqi: JsonParser.parseIntOrNull(json, "european_aqi"),
            pm25: JsonParser.parseDoubleOrNull(json, "pm2_5"),
            pm10: JsonParser.parseDoubleOrNull(json, "pm10"),
            dust: JsonParser.parseDoubleOrNull(json, "dust"),
            uvIndex: JsonParser.parseDoubleOrNull(json, "uv_index"),
            pollen: {
                for (final entry in pollenJson.entries)
                    if (double.tryParse(entry.value.toString()) != null) entry.key.toString(): double.parse(entry.value.toString()),
            },
        );
    }

    Map<String, dynamic> toJson() => {
        "us_aqi": usAqi, "european_aqi": europeanAqi, "pm2_5": pm25, "pm10": pm10, "dust": dust, "uv_index": uvIndex, "pollen": pollen,
    };

    @override
    List<Object?> get props => [usAqi, europeanAqi, pm25, pm10, dust, uvIndex, pollen];
}
