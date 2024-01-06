import 'package:ceal_chronicler_f/utils/readable_uuid.dart';

import '../persistence/json_serializable.dart';

class CharacterId extends JsonSerializable {
  static const String _idFieldName = "id";

  var id = ReadableUuid();

  CharacterId();

  CharacterId.fromJsonString(String jsonString)
      : super.fromJsonString(jsonString);

  CharacterId.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);

  @override
  decodeJson(Map<String, dynamic> jsonMap) {
    id = ReadableUuid.fromJson(jsonMap[_idFieldName]);
  }

  @override
  Map<String, dynamic> toJson() => {
        _idFieldName: id,
      };

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
