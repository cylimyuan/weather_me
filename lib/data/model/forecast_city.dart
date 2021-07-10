import 'package:flutter/painting.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forecast_city.g.dart';

enum ForecastCityType {
  @JsonValue('city')
  city,
  @JsonValue('latlng')
  latlng,
  unknown
}

@JsonSerializable()
class ForecastCity {
  final String name;
  final String? state;
  @JsonKey(unknownEnumValue: ForecastCityType.unknown)
  final ForecastCityType type;

  const ForecastCity(this.name,
      {this.state, this.type = ForecastCityType.unknown});
  factory ForecastCity.fromJson(Map<String, dynamic> json) =>
      _$ForecastCityFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastCityToJson(this);

  bool get currentLocationNotLoaded =>
      type == ForecastCityType.latlng && name.isEmpty;

  @override
  bool operator ==(dynamic o) =>
      o is ForecastCity && name == o.name && o.type == type;

  @override
  int get hashCode => hashValues(name, type);
}
