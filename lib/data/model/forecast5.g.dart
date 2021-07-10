// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast5.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Forecast5 _$Forecast5FromJson(Map<String, dynamic> json) {
  return Forecast5(
    (json['list'] as List<dynamic>?)
            ?.map((e) => Forecast.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$Forecast5ToJson(Forecast5 instance) => <String, dynamic>{
      'list': instance.list,
    };
