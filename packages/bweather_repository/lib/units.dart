import 'dart:convert';

import 'package:equatable/equatable.dart';

enum TempUnit{ fahrenheit, celsius }
extension TempUnitExtension on TempUnit{
    String get serialize{
        switch(this){
            case TempUnit.fahrenheit:
                return "fahrenheit";
            case TempUnit.celsius:
                return "celsius";
        }
    }
}
extension TempUnitFromStringExtension on String{
    TempUnit get tempUnit{
        switch(this){
            case "fahrenheit":
                return TempUnit.fahrenheit;
            case "celsius":
                return TempUnit.celsius;
            default:
                throw Exception("$this is not a Temperature Unit");
        }
    }
}

enum WindSpeedUnit { ms, mph, kmh, kn }
extension WindSpeedUnitExtension on WindSpeedUnit{
    String get serialize{
        switch(this){
            case WindSpeedUnit.ms:
                return "ms";
            case WindSpeedUnit.mph:
                return "mph";
            case WindSpeedUnit.kmh:
                return "kmh";
            case WindSpeedUnit.kn:
                return "kn";
        }
    }
}
extension WindSpeedUnitFromStringExtension on String{
    WindSpeedUnit get windSpeedUnit{
        switch(this){
            case "ms":
                return WindSpeedUnit.ms;
            case "mph":
                return WindSpeedUnit.mph;
            case "kn":
                return WindSpeedUnit.kn;
            case "kmh":
                return WindSpeedUnit.kmh;
            default:
                throw Exception("$this is not a Wind Speed Unit");
        }
    }
}

enum PrecipitationUnit{ inch, mm }
extension PrecipitationUnitExtension on PrecipitationUnit{
    String get serialize{
        switch(this){
            case PrecipitationUnit.inch:
                return "inch";
            case PrecipitationUnit.mm:
                return "mm";
        }
    }
}

extension PrecipitationUnitParseExtension on String{
  PrecipitationUnit get precipitationUnit{
      switch(this){
        case "inch":
            return PrecipitationUnit.inch;
        case "mm":
            return PrecipitationUnit.mm;
        default:
            throw Exception("$this is not a Precipitation Unit");
    }
  }
}

class Units extends Equatable{
    final TempUnit tempUnit;
    final WindSpeedUnit windSpeedUnit;
    final PrecipitationUnit precipitationUnit;

    const Units({
        this.tempUnit = TempUnit.celsius, this.windSpeedUnit = WindSpeedUnit.ms,
        this.precipitationUnit = PrecipitationUnit.mm,
    });

    const Units.defaults() : tempUnit = TempUnit.celsius, windSpeedUnit = WindSpeedUnit.ms, precipitationUnit = PrecipitationUnit.mm;

    /// What the app fetches in; the user's units are applied on the device.
    static const metric = Units(tempUnit: TempUnit.celsius, windSpeedUnit: WindSpeedUnit.kmh, precipitationUnit: PrecipitationUnit.mm);

    factory Units.fromJson(dynamic json) {
        return Units(
            tempUnit: json["temp_unit"].toString().tempUnit,
            windSpeedUnit: json["wind_speed_unit"].toString().windSpeedUnit,
            precipitationUnit: json["precipitation_unit"].toString().precipitationUnit);
    }

    Units copy({ TempUnit? tempUnit, WindSpeedUnit? windSpeedUnit, PrecipitationUnit? precipitationUnit }){
        return Units(
            tempUnit: tempUnit ?? this.tempUnit,
            precipitationUnit: precipitationUnit ?? this.precipitationUnit,
            windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit
        );
    }

    Map<String, dynamic> toJson() => {
        "temp_unit" : tempUnit.serialize, "wind_speed_unit": windSpeedUnit.serialize,
        "precipitation_unit": precipitationUnit.serialize,
    };

    String serialize() => jsonEncode(toJson());

    @override
    List<Object?> get props => [ tempUnit.serialize, precipitationUnit.serialize, windSpeedUnit.serialize ];
}