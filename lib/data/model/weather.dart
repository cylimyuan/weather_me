import 'package:json_annotation/json_annotation.dart';
import 'package:sprintf/sprintf.dart';
import 'package:weather_me/config/open_weather_map_util.dart';

part 'weather.g.dart';

enum WeatherType {
  @JsonValue('Rain')
  rain,
  @JsonValue('Clouds')
  clouds,
  unknown
}

@JsonSerializable()
class Weather {
  @JsonKey(name: 'id')
  final int id;
  // @JsonKey(unknownEnumValue: WeatherType.unknown)
  final String main;
  final String description;
  final String icon;
  Weather(this.id, this.main, this.description, this.icon);

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  String get iconUrl => sprintf(openWeatherMapiconEndpoint, [icon]);
}
