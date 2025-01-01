import 'dart:convert';

import '../../key_fields/location_id_key_field.dart';
import '../../key_fields/party_id_key_field.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../../utils/model/temporal_entity.dart';
import 'character_id.dart';

class Character extends TemporalEntity<CharacterId> {
  static const defaultName = "New Character";
  static const String _presentLocationKey = "presentLocation";
  static const String _partyKey = "party";

  final LocationIdKeyField presentLocation;
  final PartyIdKeyField party;

  Character(PointInTimeId firstAppearance)
      : presentLocation = LocationIdKeyField(),
        party = PartyIdKeyField(),
        super(defaultName, CharacterId(), firstAppearance);

  Character.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Character.fromJson(Map<String, dynamic> json)
      : presentLocation = _locationIdKeyFieldFromJson(json),
        party = _partyIdKeyFieldFromJson(json),
        super.fromJson(json, CharacterId.fromString(json[IdHolder.idKey]));

  static LocationIdKeyField _locationIdKeyFieldFromJson(
    Map<String, dynamic> json,
  ) {
    var jsonMap = json[_presentLocationKey];
    return jsonMap == null
        ? LocationIdKeyField()
        : LocationIdKeyField.fromJson(jsonMap);
  }

  static PartyIdKeyField _partyIdKeyFieldFromJson(
    Map<String, dynamic> json,
  ) {
    var jsonMap = json[_partyKey];
    return jsonMap == null
        ? PartyIdKeyField()
        : PartyIdKeyField.fromJson(jsonMap);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = super.toJson();
    jsonMap[_presentLocationKey] = presentLocation;
    jsonMap[_partyKey] = party;
    return jsonMap;
  }

  @override
  String toString() => 'Character{id: $id}';
}
