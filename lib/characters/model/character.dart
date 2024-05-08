import 'dart:convert';

import 'package:ceal_chronicler_f/io/json_serializable.dart';

import 'character_id.dart';

class Character extends JsonSerializable {
  static const String idKey = "id";
  static const String nameKey = "name";
  static const defaultName = "New Character";

  final CharacterId id;
  String name = defaultName;

  Character() : id = CharacterId();

  Character.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Character.fromJson(Map<String, dynamic> json)
      : id = CharacterId.fromString(json[idKey]),
        name = json[nameKey];

  @override
  String toString() => 'Character{id: $id, name: $name}';

  @override
  Map<String, dynamic> toJson() => {
        idKey: id.uuid,
        nameKey: name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
