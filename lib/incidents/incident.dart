import 'dart:convert';

import 'package:ceal_chronicler_f/io/json_serializable.dart';

import '../utils/readable_uuid.dart';

class Incident extends JsonSerializable {
  static const String idKey = "id";
  static const String nameKey = "name";

  final ReadableUuid id;
  String name;

  Incident(this.name) : id = ReadableUuid();

  Incident.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Incident.fromJson(Map<String, dynamic> json)
      : id = ReadableUuid.fromString(json[idKey]),
        name = json[nameKey];

  @override
  String toString() => 'Incident{id: $id, name: $name}';

  @override
  Map<String, dynamic> toJson() => {
    idKey: id.uuid,
    nameKey: name,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Incident &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}