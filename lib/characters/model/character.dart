import 'dart:convert';

import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../../utils/model/temporal_entity.dart';
import 'character_id.dart';

class Character extends TemporalEntity<CharacterId> {
  static const defaultName = "New Character";

  Character(PointInTimeId firstAppearance)
      : super(defaultName, CharacterId(), firstAppearance);

  Character.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Character.fromJson(Map<String, dynamic> json)
      : super.fromJson(json, CharacterId.fromString(json[IdHolder.idKey]));

  @override
  String toString() =>
      'Character{id: $id, name: $name, firstAppearance: $firstAppearance, lastAppearance: $lastAppearance}';
}
