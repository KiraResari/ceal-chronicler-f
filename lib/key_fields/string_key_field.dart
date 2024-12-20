import 'dart:convert';

import '../timeline/model/point_in_time_id.dart';
import 'key_field.dart';

class StringKeyField extends KeyField<String> {
  StringKeyField(String initialValue) : super(initialValue: initialValue);

  StringKeyField.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  StringKeyField.fromJson(Map<String, dynamic> json)
      : super.fromDecodedJson(
          json[KeyField.initialValueKey],
          decodeKeys(json[KeyField.keysKey]),
        );

  static Map<PointInTimeId, String?> decodeKeys(Map<String, dynamic> jsonMap) {
    return jsonMap
        .map((key, value) => MapEntry(PointInTimeId.fromString(key), value));
  }

  @override
  String initialValueToJson(String? initialValue) => initialValue ?? "";

  @override
  Map<String, dynamic> keysToJson(Map<PointInTimeId, String?> keys) {
    return keys.map((key, value) => MapEntry(key.uuid, value));
  }
}
