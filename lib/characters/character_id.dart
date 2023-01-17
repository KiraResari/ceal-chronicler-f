import 'dart:convert';

import 'package:ceal_chronicler_f/utils/readable_uuid.dart';

class CharacterId {
  static const String _idFieldName = "id";

  var id = ReadableUuid();

  CharacterId();

  CharacterId.fromJson(Map<String, dynamic> json)
      : id = ReadableUuid.fromJson(json[_idFieldName]);

  CharacterId.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Map<String, dynamic> toJson() => {
    _idFieldName: id,
  };

  String toJsonString() => jsonEncode(toJson());

  CharacterId copy() {
    var copy = CharacterId();
    copy.id = id.copy();
    return copy;
  }

  @override
  String toString() {
    return id.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CharacterId && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
