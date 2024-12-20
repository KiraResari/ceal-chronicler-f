import 'dart:convert';

import '../../key_fields/location_id_key_field.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../../utils/model/temporal_entity.dart';
import 'character_id.dart';

class Character extends TemporalEntity<CharacterId> {
  static const defaultName = "New Character";
  static const String _presentLocationKey = "presentLocation";

  final LocationIdKeyField presentLocation;

  Character(PointInTimeId firstAppearance)
      : presentLocation = LocationIdKeyField(),
        super(defaultName, CharacterId(), firstAppearance);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = super.toJson();
    jsonMap[_presentLocationKey] = presentLocation;
    return jsonMap;
  }

  Character.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Character.fromJson(Map<String, dynamic> json)
      : presentLocation =
            LocationIdKeyField.fromJson(json[_presentLocationKey]),
        super.fromJson(json, CharacterId.fromString(json[IdHolder.idKey]));

  @override
  String toString() =>
      'Character{id: $id, name: $name, firstAppearance: $firstAppearance, lastAppearance: $lastAppearance}';
}
