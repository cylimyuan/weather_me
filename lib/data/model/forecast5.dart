import 'package:json_annotation/json_annotation.dart';
import 'package:weather_me/data/model/forecast.dart';

part 'forecast5.g.dart';

@JsonSerializable()
class Forecast5 {
  @JsonKey(defaultValue: [])
  final List<Forecast> list;
  @JsonKey(ignore: true)
  DateTime? createdAt;

  Forecast5(this.list);
  factory Forecast5.fromJson(Map<String, dynamic> json) =>
      _$Forecast5FromJson(json);
  Map<String, dynamic> toJson() => _$Forecast5ToJson(this);
}
