import 'package:json_annotation/json_annotation.dart';

part 'forecast_main.g.dart';

@JsonSerializable()
class ForecastMain {
  final double temp;
  final double pressure;
  final double humidity;

  ForecastMain(this.temp, this.pressure, this.humidity);

  factory ForecastMain.fromJson(Map<String, dynamic> json) =>
      _$ForecastMainFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastMainToJson(this);
}
