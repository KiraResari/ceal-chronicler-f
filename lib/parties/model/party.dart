import 'dart:convert';

import '../../key_fields/location_id_key_field.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../../utils/model/temporal_entity.dart';
import 'party_id.dart';

class Party extends TemporalEntity<PartyId> {
  static const defaultName = "New Character";
  static const String _presentLocationKey = "presentLocation";

  final LocationIdKeyField presentLocation;

  Party(PointInTimeId firstAppearance)
      : presentLocation = LocationIdKeyField(),
        super(defaultName, PartyId(), firstAppearance);

  Party.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Party.fromJson(Map<String, dynamic> json)
      : presentLocation =
  LocationIdKeyField.fromJson(json[_presentLocationKey]),
        super.fromJson(json, PartyId.fromString(json[IdHolder.idKey]));

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = super.toJson();
    jsonMap[_presentLocationKey] = presentLocation;
    return jsonMap;
  }

  @override
  String toString() => 'Party{id: $id}';
}
