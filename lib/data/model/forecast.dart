import 'package:json_annotation/json_annotation.dart';
import 'package:weather_me/data/model/forecast_main.dart';
import 'package:weather_me/data/model/weather.dart';
import 'package:weather_me/util/date_formatter.dart';

part 'forecast.g.dart';

@JsonSerializable()
class Forecast {
  @JsonKey(name: 'dt_txt')
  final String dateText;
  final List<Weather> weather;
  final ForecastMain main;

  Forecast(this.dateText, this.weather, this.main);

  factory Forecast.fromJson(Map<String, dynamic> json) =>
      _$ForecastFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastToJson(this);

  @JsonKey(ignore: true)
  late DateTime dateTime = _getDateTime();
  DateTime _getDateTime() {
    return stdServerDateTimeFormat.parse(dateText);
  }
}
