// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastMain _$ForecastMainFromJson(Map<String, dynamic> json) {
  return ForecastMain(
    (json['temp'] as num).toDouble(),
    (json['pressure'] as num).toDouble(),
    (json['humidity'] as num).toDouble(),
  );
}

Map<String, dynamic> _$ForecastMainToJson(ForecastMain instance) =>
    <String, dynamic>{
      'temp': instance.temp,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
    };
