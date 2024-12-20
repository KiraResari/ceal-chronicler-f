import 'dart:convert';

import 'package:ceal_chronicler_f/locations/model/location_id.dart';

import '../timeline/model/point_in_time_id.dart';
import 'key_field.dart';

class LocationIdKeyField extends KeyField<LocationId> {
  LocationIdKeyField();

  LocationIdKeyField.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  LocationIdKeyField.fromJson(Map<String, dynamic> json)
      : super.fromDecodedJson(
          _determineLocationIdFromJson(json),
          decodeKeys(json[KeyField.keysKey]),
        );

  static LocationId? _determineLocationIdFromJson(Map<String, dynamic> json) {
    return json[KeyField.initialValueKey] != null
        ? LocationId.fromString(json[KeyField.initialValueKey])
        : null;
  }

  static Map<PointInTimeId, LocationId?> decodeKeys(
      Map<String, dynamic> jsonMap) {
    return jsonMap.map((key, value) => MapEntry(
          PointInTimeId.fromString(key),
          value == null ? null : LocationId.fromString(value),
        ));
  }

  @override
  String initialValueToJson(LocationId? initialValue) =>
      initialValue != null ? initialValue.uuid : "";

  @override
  Map<String, dynamic> keysToJson(Map<PointInTimeId, LocationId?> keys) {
    return keys.map((key, value) {
      return MapEntry(key.uuid, value?.uuid);
    });
  }
}
