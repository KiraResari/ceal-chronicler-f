import 'dart:convert';

import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';

import '../../io/json_serializable.dart';

class PointInTime extends JsonSerializable {
  static const String idKey = "id";
  static const String nameKey = "name";

  final PointInTimeId id;
  String name;

  PointInTime(this.name) : id = PointInTimeId();

  PointInTime.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  PointInTime.fromJson(Map<String, dynamic> json)
      : id = PointInTimeId.fromString(json[idKey]),
        name = json[nameKey];

  @override
  String toString() => 'PointInTime{id: $id, name: $name}';

  @override
  Map<String, dynamic> toJson() => {
        idKey: id.uuid,
        nameKey: name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointInTime &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
