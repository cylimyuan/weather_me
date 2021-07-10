// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastCity _$ForecastCityFromJson(Map<String, dynamic> json) {
  return ForecastCity(
    json['name'] as String,
    state: json['state'] as String?,
    type: _$enumDecode(_$ForecastCityTypeEnumMap, json['type'],
        unknownValue: ForecastCityType.unknown),
  );
}

Map<String, dynamic> _$ForecastCityToJson(ForecastCity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'state': instance.state,
      'type': _$ForecastCityTypeEnumMap[instance.type],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ForecastCityTypeEnumMap = {
  ForecastCityType.city: 'city',
  ForecastCityType.latlng: 'latlng',
  ForecastCityType.unknown: 'unknown',
};
