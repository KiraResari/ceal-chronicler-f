import 'dart:convert';

import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import 'character_id.dart';

class Character extends IdHolder<CharacterId> {
  static const String nameKey = "name";
  static const String firstApperanceKey = "firstAppearance";
  static const defaultName = "New Character";

  String name = defaultName;
  PointInTimeId firstAppearance;

  Character(this.firstAppearance) : super(CharacterId());

  Character.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Character.fromJson(Map<String, dynamic> json)
      : name = json[nameKey],
        firstAppearance = PointInTimeId.fromJson(json[firstApperanceKey]),
        super(CharacterId.fromString(json[IdHolder.idKey]));

  @override
  String get identifier => name;

  @override
  String get identifierDescription => nameKey;

  @override
  String toString() =>
      'Character{id: $id, name: $name, firstAppearance: $firstAppearance}';

  @override
  Map<String, dynamic> toJson() => {
        IdHolder.idKey: id.uuid,
        nameKey: name,
        firstApperanceKey: firstAppearance,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
