import 'dart:convert';

import '../parties/model/party_id.dart';
import '../timeline/model/point_in_time_id.dart';
import 'key_field.dart';

class PartyIdKeyField extends KeyField<PartyId> {
  PartyIdKeyField();

  PartyIdKeyField.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  PartyIdKeyField.fromJson(Map<String, dynamic> json)
      : super.fromDecodedJson(
          _determinePartyIdFromJson(json),
          decodeKeys(json[KeyField.keysKey]),
        );

  static PartyId? _determinePartyIdFromJson(Map<String, dynamic> json) {
    return json[KeyField.initialValueKey] != null
        ? PartyId.fromString(json[KeyField.initialValueKey])
        : null;
  }

  static Map<PointInTimeId, PartyId?> decodeKeys(Map<String, dynamic> jsonMap) {
    return jsonMap.map((key, value) => MapEntry(
          PointInTimeId.fromString(key),
          value == null ? null : PartyId.fromString(value),
        ));
  }

  @override
  String initialValueToJson(PartyId? initialValue) =>
      initialValue != null ? initialValue.uuid : "";

  @override
  Map<String, dynamic> keysToJson(Map<PointInTimeId, PartyId?> keys) {
    return keys.map((key, value) {
      return MapEntry(key.uuid, value?.uuid);
    });
  }
}
