import 'dart:convert';

import '../io/json_serializable.dart';
import '../utils/readable_uuid.dart';

class PointInTime extends JsonSerializable {
  static const String idKey = "idKey";
  static const String nameKey = "nameKey";

  final ReadableUuid id;
  String name;

  PointInTime(this.name) : id = ReadableUuid();

  PointInTime.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  PointInTime.fromJson(Map<String, dynamic> json)
      : id = ReadableUuid.fromJson(json[idKey]),
        name = json[nameKey];

  @override
  String toString() => 'PointInTime{id: $id, name: $name}';

  @override
  Map<String, dynamic> toJson() => {
        idKey: id,
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
